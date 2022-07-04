import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:global_configuration/global_configuration.dart';
import 'package:growonplus_teacher/model/Test%20Models/TestChapterModel.dart';
import 'package:growonplus_teacher/model/Test%20Models/TestTopicModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/api/test-module-api-client.dart';
import '/bloc/test-module/test-module-states.dart';
import '/model/class-schedule.dart';
import '/model/test-model.dart';

class QuestionPaperCubit extends Cubit<QuestionPaperStates> {
  QuestionPaperCubit() : super(QuestionPaperLoading());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();


  Future<List<QuestionPaper>> loadAllQuestionPapers(
      {int page , int limit,bool isEvaluate,String classId,String subject,String searchText}) async {
    List<QuestionPaper> questionPaper = [];
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String userId = prefs.getString('user-id');
    String schoolId = prefs.getString('school-id');
    String token = await storage.read(key: 'token');
    Map<String,dynamic> data = {
      'page':page,
      'limit':limit,
      'school_id':schoolId,
      'class_id':classId,
      'detail_question_paper.subject':subject,
      "searchValue": searchText,
      "filterKeysArray": ["question_title", "question_id"],
    };
    if(isEvaluate)
      data.addAll({'user_id':userId});
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    data.removeWhere((key, value) => value == null);
    await client
        .getAllQuestionPapers(data)
        .catchError((error) {
          if (error is DioError) {
            print('DIO error');
            print('Error-while-loading-question-paper: ${error.response}');
          }
          print(error);
          emit(QuestionPaperNotLoaded());
        })
        .whenComplete(() {})
        .then((value) {

          if (value != null) {
            var result = jsonDecode(value)['result'];
            var data = jsonDecode(value)['data'];
            if (result == 0) {

              emit(QuestionPaperNotLoaded());
            }
          }

          if (value != null) {
            double marks = 0;
            var data = jsonDecode(value)['data'];
            if (data != null) {
              questionPaper = List<QuestionPaper>.from(
                jsonDecode(value)['data'].map((e) {
                  if (e['detail_question_paper'] != null) {
                    return QuestionPaper.fromJson(e);
                  }
                }),
              );
              questionPaper.removeWhere((element) => element == null);
              questionPaper.forEach((element) {
                element.status = 'Evaluate';
                marks = element.section[0].section.fold(0,
                    (previousValue, element) {
                  return previousValue + element.totalMarks;
                });
                var temp = element.assignTo.where((e) => e.status != null
                    ? e.status.toLowerCase() == 'evaluated'
                    : false);
                if (temp.length == element.assignTo.length) {
                  element.status = 'Evaluated';
                }
                element.totalMarks = marks;
                marks = 0;
              });

              questionPaper.isNotEmpty
                  ? emit(QuestionPaperLoaded(questionPaper))
                  : emit(QuestionPaperNotLoaded());
            }
          } else {
            emit(QuestionPaperNotLoaded());
          }
        });
    return questionPaper;
  }

  // Future<void> loadMoreQuestionPapers(
  //     QuestionPaperLoaded state, int page) async {
  //   prefs = await SharedPreferences.getInstance();
  //   storage = FlutterSecureStorage();
  //   String userId = prefs.getString('user-id');
  //   String schoolId = prefs.getString('school-id');
  //   String token = await storage.read(key: 'token');
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //   final client =
  //       TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
  //   await client
  //       .getMoreQuestionPapers(schoolId, page,userId)
  //       .catchError((error) {
  //         if (error is DioError) {
  //           print('DIO error');
  //           print('Error-while-loading-question-paper: ${error.response}');
  //         }
  //         print(error);
  //       })
  //       .whenComplete(() {})
  //       .then((value) {
  //         if (value != null) {
  //           double marks = 0;
  //           // print(value);
  //           List<QuestionPaper> newquestionPaper = List<QuestionPaper>.from(
  //             jsonDecode(value)['data'].map((e) {
  //               if (e['detail_question_paper'] != null) {
  //                 return QuestionPaper.fromJson(e);
  //               }
  //             }),
  //           );
  //           // List<QuestionPaper> questionPaper = [];
  //           // questionPaper.addAll(state.questionPaper);
  //           // questionPaper.addAll(newquestionPaper);
  //           // questionPaper.removeWhere((element) => element == null);
  //           // questionPaper.forEach((element) {
  //           //   element.status = 'Evaluate';
  //           //   marks =
  //           //       element.section[0].section.fold(0, (previousValue, element) {
  //           //     return previousValue + element.totalMarks;
  //           //   });
  //           //   var temp = element.assignTo
  //           //       .where((e) => e.status.toLowerCase() == 'evaluated');
  //           //   if (temp.length == element.assignTo.length) {
  //           //     element.status = 'Evaluated';
  //           //   }
  //           //   element.totalMarks = marks;
  //           //   marks = 0;
  //           // });
  //           state.questionPaper.addAll(newquestionPaper);
  //           emit(QuestionPaperLoaded(state.questionPaper));
  //
  //         }
  //       });
  // }

  Future<void> giveFeedback(String studentId, String questionId) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String schoolId = prefs.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .feedbackStudent(studentId, questionId)
        .catchError((error) {
          if (error is DioError) {
            print('DIO error');
            print('Error-while-loading-question-paper: ${error.response}');
          }
          print(error);
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {}
        });
  }

  Future<void> createQuestionPaper(
      QuestionPaper questionPaper, String duration) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    UserId userId = UserId();
    userId.id = prefs.get('user-id');
    String schoolId = prefs.get('school-id');
    String userName = prefs.get('user-name');
    questionPaper.duration = duration;

    String token = await storage.read(key: 'token');
    questionPaper.userId = userId;
    questionPaper.schoolId = schoolId;
    questionPaper.createdBy = userName;
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    log('01');
    log('        paper         ${questionPaper.toJson()}');
    log('02');
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .createQuestionPaper(questionPaper.toJson())
        .catchError((error) {
          if (error is DioError) {
            print('Dio-Error-while-creating-question-paper: ${error.response}');
            log(error.message.toString());
            log(error.response.toString());
          }
          log(error.toString());
          print("Error-while-creating-question-paper: $error");
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
          }
        });
  }

  //Method to send the comments from the teacher when student submits the test
  Future<bool> sendRewards(String comment, String feedbacktype) async {
    String baseUrl = GlobalConfiguration().get('baseURL');
    prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    storage = FlutterSecureStorage();
    String teacherId = prefs.getString('user-id');
    String token = await storage.read(key: 'token');

    var url = baseUrl + '/answer/teacherFeedback/' + teacherId;
    try {
      Response response = await dio.request(url,
          options: Options(
            headers: {'token': token},
            method: 'POST',
          ),
          data: {
            'teacher_id': teacherId,
            'feedback_type': feedbacktype,
            'comment': comment
          });
      if (response.data != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      if (error is DioError) {
        log('${error.response}');
        return false;
      } else {
        log('$error');
        return false;
      }
    }
  }

  //to assign already Created question paper
  // Future<void> assignQuestionPaper(TestAssign assign, String qpId) async {
  //   prefs = await SharedPreferences.getInstance();
  //   storage = FlutterSecureStorage();
  //   String token = await storage.read(key: 'token');
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //   String teacherId = prefs.getString('user-id');
  //   assign.teacherId = teacherId;
  //   assign.assignDate = DateTime.now().toString();
  //   log(token.toString());
  //   log('question paper api request body ');
  //   final client =
  //       TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
  //   await client
  //       .assignQuestionPaper(assign.toJson(), qpId)
  //       .catchError((error) {
  //         if (error is DioError) {
  //           print(
  //               'Dio-Error-while-Assigning-question-paper: ${error.response}');
  //           log(error.message.toString());
  //           log(error.response.toString());
  //         }
  //         log(error.toString());
  //         print("Error-while-assigning-question-paper: $error");
  //       })
  //       .whenComplete(() {})
  //       .then((value) {
  //         if (value != null) {
  //           print('Question Paper assigned');
  //           print(value);
  //         }
  //       });
  // }
}

class TestModuleClassCubit extends Cubit<TestModuleClassStates> {
  TestModuleClassCubit() : super(TestClassesLoading());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();

  Future<void> loadAllClasses() async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String schoolId = prefs.getString('school-id');
    List<String> classes = prefs.getStringList('classes');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getClasses(schoolId)
        .catchError((error) {
          if (error is DioError) {
            print('DIO error');
            print('Error-while-loading-test-classes: ${error.response}');
          }
          print(error);
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            SchoolDetailsResponse response =
                SchoolDetailsResponse.fromJson(jsonDecode(value));
            List<SchoolClassDetails> classDetails =
                response.data != null && response.data.isNotEmpty
                    ? response.data[0].classDetails
                    : [];
            var temp = classDetails.where((element) {
              if (classes.isEmpty) {
                return true;
              }
              return classes.contains(element.classId);
            }).toList();
            if (temp.isNotEmpty) {
              temp = classDetails;
            }
            emit(TestClassesLoaded(classDetails));
          }
        });
  }
}

class TestModuleSubjectCubit extends Cubit<TestModuleSubjectStates> {
  TestModuleSubjectCubit() : super(TestModuleSubjectLoading());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();

  Future<String> loadAllSubjects(String classId) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String schoolId = prefs.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getSubjects(schoolId, classId)
        .catchError((error) {
          if (error is DioError) {
            print('DIO error');
            print('Error-while-loading-test-subjects: ${error.response}');
          }
          print(error);
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            List<Subjects> subjects = List<Subjects>.from(
              jsonDecode(value)['data'].map((e) {
                return Subjects.fromJson(e);
              }),
            );
            emit(TestModuleSubjectLoaded(subjects));
          } else {
            emit(TestModuleNoSubjects());
          }
          return value;
        });
  }
}

class TestModuleChapterCubit extends Cubit<TestModuleChapterStates> {
  TestModuleChapterCubit() : super(TestModuleChapterLoading());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();

  Future<void> loadAllChapters(String classId, String subjectId) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String schoolId = prefs.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client.getChapters(schoolId, classId, subjectId).catchError((error) {
      if (error is DioError) {
        log(error.message.toString());
        log(error.stackTrace.toString());
      }
    }).then((value) {
      if (value != null) {
        List<TestChapterModel> testChapterModel = List<TestChapterModel>.from(
            jsonDecode(value)['data'].map((e) => TestChapterModel.fromJson(e)));
        emit(TestModuleChapterLoaded(testChapterModel));
      }
    });
  }
}

class TestModuleTopicCubit extends Cubit<TestModuleTopicStates> {
  TestModuleTopicCubit() : super(TestModuleTopicLoading());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();

  Future<void> loadAllTopics(
      String classId, String subjectId, String chapterId) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String schoolId = prefs.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getTopics(schoolId, classId, subjectId, chapterId)
        .catchError((error) {
      log(error.toString());
      if (error is DioError) {
        log(error.message.toString());
        log(error.stackTrace.toString());
      }
    }).then((value) {
      if (value != null) {
        List<TestTopicModel> testTopicModel = List<TestTopicModel>.from(
            jsonDecode(value)['data'].map((e) => TestTopicModel.fromJson(e)));
        emit(TestModuleTopicLoaded(testTopicModel));
      }
    });
  }
}

class ExamTypeCubit extends Cubit<ExamTypeStates> {
  ExamTypeCubit() : super(ExamTypeLoading());
  SharedPreferences sharedPreferences;
  FlutterSecureStorage storage;
  Dio dio = Dio();

  void loadExamType() async {
    sharedPreferences = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String schoolId = sharedPreferences.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getExamType(schoolId)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-while-loading-exam-type: ${error.response}');
          }
          print('Error-while-loading-exam-type: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            ExamTypeResponse response =
                ExamTypeResponse.fromJson(jsonDecode(value));
            emit(ExamTypeLoaded(response.data));
          }
        });
  }
}

class QuestionTypeCubit extends Cubit<QuestionTypeStates> {
  QuestionTypeCubit() : super(QuestionTypeLoading());
  Dio dio = Dio();
  FlutterSecureStorage storage;
  SharedPreferences sharedPreferences;

  Future<void> loadAllQuestionType(
      String className, String subject, String examType) async {
    emit(QuestionTypeLoading());
    sharedPreferences = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    String schoolId = sharedPreferences.getString('school-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getQuestionTypeObjective(
          schoolId: schoolId,
          className: className,
          subject: subject,
          examType: examType,
        )
        .catchError((error) {
          if (error is DioError) {
            print('Error-while-loading-objective-question: ${error.response}');
          }
          print('Error-while-loading-objective-question: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            QuestionTypeResponse response =
                QuestionTypeResponse.fromJson(jsonDecode(value));
            processObjectiveQuestionPaper(response.data);
          }
        });
  }

  void processObjectiveQuestionPaper(List<QuestionType> questions) {
    Map<String, String> questionType = {
      "mcq": "MCQ",
      "twoColMtf": "Two Column Matching",
      "objectives": "Objectives",
      "fillInTheBlanks": "Fill In The Blanks",
      "threeColMtf": "Three Column Matching",
      "trueOrFalse": "True Or False",
      "freeText": "Free Text",
      "comprehension": "Comprehension",
      "NumericalRange": "Numerical Range",
      '3colOptionLevelScoring': 'Three Column Option Level',
      'optionLevelScoring': 'Option Level Scoring'
    };
    List<QuestionTypeSingle> singleQuestionType = [];
    if (questionType != null) {
      for (var ques in questions) {
        ques.questionTypeString = questionType[ques.questionType[0]];
      }
    }
    for (var i in questionType.values) {
      List<QuestionType> type = questions
          .where((element) => element.questionTypeString == i)
          .toList();
      singleQuestionType.add(
        QuestionTypeSingle(
          questionType: type,
          title: i,
          totalQuestions: type.length,
        ),
      );
    }

    emit(QuestionTypeLoaded(questions, singleQuestionType));
  }

  // String questionType(String type) {
  //   switch (type) {
  //     case 'mcq':
  //       return 'MCQ';
  //     case 'twoColMtf':
  //       return 'Two Column Matching';
  //     case 'objectives':
  //       return 'Objectives';
  //     case 'fillInTheBlanks':
  //       return 'Fill In The Blanks';
  //     case 'threeColMtf':
  //       return 'Three Column Matching';
  //     case 'sequencingQuestion':
  //       return 'Sequencing Question';
  //     case 'sentenceSequencing':
  //       return 'Sentence Sequencing';
  //     case 'trueOrFalse':
  //       return 'True Or False';
  //     case 'sorting':
  //       return 'Sorting';
  //     case 'freeText':
  //       return "Free Text";
  //     case 'NumericalRange':
  //       return 'Numerical Range';
  //     default:
  //       return '';
  //   }
  // }
}

class LearningOutcomeCubit extends Cubit<LearningOutcomeStates> {
  LearningOutcomeCubit() : super(LearningOutcomeLoading());
  SharedPreferences prefs;
  FlutterSecureStorage storage;
  Dio dio = Dio();

  void getLearningOutcome() async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String schoolId = prefs.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getAllLearningOutcome(schoolId)
        .catchError((error) {
          if (error is DioError) {
            print(
                'Dio-error-while-getting-learning-outcome: ${error.response}');
          }
          print('Error-while-getting-learning-outcome: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            List<LearningOutcome> learningOutcome = List<LearningOutcome>.from(
              jsonDecode(value)['data'].map((e) => LearningOutcome.fromJson(e)),
            );
            emit(LearningOutcomeLoaded(learningOutcome));
          }
        });
  }
}

class QuestionAnswerCubit extends Cubit<QuestionAnswerStates> {
  QuestionAnswerCubit() : super(QuestionAnswerLoading());
  Dio dio = Dio();
  FlutterSecureStorage storage = FlutterSecureStorage();
  SharedPreferences prefs;

  Future<List<QuestionPaperAnswer>> getAllSubmittedAnswer(String questionId,int page,int limit) async {
    List<QuestionPaperAnswer> questionPaperAnswer = [];
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String teacherId = prefs.getString('user-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getAllSubmittedAnswer(questionId,teacherId,page,limit)
        .catchError((error) {
          if (error is DioError) {
            print(
                'Dio-Error-while-getting-submitted-answer: ${error.response}');
          }
          print('Error-while-loading-answers: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
              questionPaperAnswer =
                List<QuestionPaperAnswer>.from(
              jsonDecode(value)['data']
                  .map((e) => QuestionPaperAnswer.fromJson(e)),
            );
             // questionPaperAnswer =  questionPaperAnswer.where((e) => e.questionId == questionId).toList();
              questionPaperAnswer.forEach((element) {
                log(element.createdBy.toString() + element.marksObtained.toString());
              });
          }
        });
    return questionPaperAnswer;
  }

  //to send the marks for free text answer

  Future<String> submitFreeTextMarks({FreeTextAnswer freeTextAnswer}) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .freeTextMarksSubmit(body: freeTextAnswer.toJson())
        .catchError((error) {
      if (error is DioError) {
        log(error.message);
      }
      log(error);
    }).then((value) {
      return value.toString();
    });
  }


}

class CorrectQuestionCubit extends Cubit<CorrectQuestionState> {
  CorrectQuestionCubit() : super(CorrectQuestionsLoading());

  void addCorrectedQuestions(List<CorrectedAnswer> answer) {
    emit(CorrectQuestionsLoaded(answer));
  }
}

class QuestionCategoryCubit extends Cubit<QuestionCategoryStates> {
  QuestionCategoryCubit() : super(QuestionCategoryLoading());
  SharedPreferences sharedPreferences;
  Dio dio = Dio();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<void> getAllQuestionCategory() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        TestModuleApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getQuestionCategory(schoolId)
        .whenComplete(() {})
        .catchError((error) {
      if (error is DioError) {
        log('Error-while-getting-question-category: ${error.response}');
      }
      log('Error-while-getting-question-category: $error');
    }).then((value) {
      if (value != null) {
        List response = jsonDecode(value)['data'];
        List<QuestionCategory> categories = List<QuestionCategory>.from(
          response.map((e) => QuestionCategory.fromJson(e)),
        );
        // categories = categories
        //     .where((element) => element.repository[0].id == schoolId)
        //     .toList();
        emit(QuestionCategoryLoaded(categories));
      }
    });
  }
}

class SubmitMarksCubit extends Cubit<SubmitMarksStates>{
  SubmitMarksCubit() : super(FreeTextAnswerSubmission([]));
  void initiateFreeTextEvaluation(){

    emit(FreeTextAnswerSubmission([]));
  }

  void updateValues(AnswerDetail answerDetails){

      var x = (state as FreeTextAnswerSubmission);
     var e = x.answerDetails.firstWhere((element) => element.questionId == answerDetails.questionId,orElse: ()=>null);
      if(e == null)
        {
          x.answerDetails.add(answerDetails);
        }
      print(x.answerDetails);
    emit(FreeTextAnswerSubmission(x.answerDetails));
  }

  void submittedMarks(){
    var x = (state as FreeTextAnswerSubmission);
    x.answerDetails.clear();
    emit(FreeTextAnswerSubmission([]));
  }

}
