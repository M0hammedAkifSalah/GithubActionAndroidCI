import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/api/activity-api-client.dart';
import '/api/learning-api-client.dart';
import '/bloc/learning/learning-states.dart';
import '/model/learning.dart';
import '/model/user.dart';

class LearningClassCubit extends Cubit<LearningClassesStates> {
  LearningClassCubit() : super(LearningClassLoading());
  SharedPreferences sharedPreferences;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  Future<void> getClasses() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final teacherId = sharedPreferences.getString('user-id');

    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .getClassesForTeacher(teacherId)
        .catchError((error) {
          emit(LearningStudentsFailed());
          if (error is DioError) {
            log(error.stackTrace.toString());
          }
          print('Error-while-getting-learning-classes : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            LearningClassResponse response =
                LearningClassResponse.fromJson(jsonDecode(value));

            emit(LearningClassLoaded(response.classData));
          }
        });
  }

  Future<List<StudentInfo>> getStudents(
      {String classId, String sectionId,int page,int limit}) async {
    List<StudentInfo> students = <StudentInfo>[];
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    log(dio.options.headers.toString());
    final schoolId = sharedPreferences.getString('school-id');
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .getAllStudents(classId, schoolId, sectionId,page,limit)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : $error');
          }
          print('Error-while-getting-learning-students : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            LearningStudentResponse response =
                LearningStudentResponse.fromJson(jsonDecode(value));

            for (var i in response.students) {
              if (!students.map((e) => e.id).contains(i.id)) {
                // log(i.name);
                students.add(i);
              }
            }
            // students = response.students;
            emit(LearningStudentsLoaded(students));
          }
        });
    return students;
  }

  // Future<void> getAllStudents({String classId, String sectionId,int page,int limit}) async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   final token = await storage.read(key: "token");
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //   final schoolId = sharedPreferences.getString('school-id');
  //   final client = LearningApiClient(
  //     dio,
  //     baseUrl: GlobalConfiguration().get("baseURL"),
  //   );
  //   await client
  //       .getAllStudents(classId, schoolId, sectionId,page,limit)
  //       .catchError((error) {
  //         if (error is DioError) {
  //           print('Dio-error-message : $error');
  //         }
  //         print('Error-while-getting-learning-students : $error');
  //       })
  //       .whenComplete(() {})
  //       .then((value) {
  //         if (value != null) {
  //           LearningStudentResponse response =
  //               LearningStudentResponse.fromJson(jsonDecode(value));
  //           var students = <StudentInfo>[];
  //           for (var i in response.students) {
  //             if (!students.map((e) => e.id).contains(i.id)) {
  //               students.add(i);
  //             }
  //           }
  //           emit(LearningStudentsLoaded(students));
  //         }
  //       });
  // }

  // Future<void> loadMoreStudents(String classId, String sectionId,
  //     LearningStudentsLoaded state, int page) async {
  //   String token = await storage.read(key: "token");
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //
  //   sharedPreferences = await SharedPreferences.getInstance();
  //
  //   String schoolId = sharedPreferences.getString("school-id");
  //   print('Student-profile-cubit: school-id == $schoolId');
  //
  //   final client = LearningApiClient(
  //     dio,
  //     baseUrl: GlobalConfiguration().get("baseURL"),
  //   );
  //   await client
  //       .getMoreStudentsOfClass(classId, schoolId, sectionId, page)
  //       .catchError((error) {
  //         print("get-more-student-error: $error");
  //         if (error is DioError) {
  //           DioError err = error;
  //           print("get-student-error-message: ${err.response}");
  //         }
  //       })
  //       .whenComplete(() {})
  //       .then(
  //         (value) {
  //           if (value != null) {
  //             var student = Students.fromJson(json.decode(value));
  //             state.students.addAll(student.students);
  //             emit(LearningStudentsLoaded(state.students,
  //                 hasMoreData: student.students.isNotEmpty));
  //           }
  //           return value;
  //         },
  //       );
  // }
}

class LearningDetailsCubit extends Cubit<LearningStates> {
  LearningDetailsCubit() : super(LearningSubjectLoading());
  SharedPreferences sharedPreferences;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  Future<LearningStates> getSubjectDetails({String classId}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final schoolId = sharedPreferences.getString('school-id');
    final data = {
      "repository": {
        "id": schoolId,
        "mapDetails.classId": classId,
      }
    };
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    emit(LearningSubjectLoading());
    await client
        .getLearningData(data, 'getsubject')
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message-learning-subject : ${error.response}');
          }
          print('Error-while-getting-learning-subject : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            LearningDetailsResponse response =
                LearningDetailsResponse.fromJson(jsonDecode(value));
            List<Learnings> learnings = response.details;
            learnings.forEach((element) {
              element.repository = [
                element.repository.firstWhere(
                  (element2) => element2.id == schoolId,
                )
              ];
            });
            if (response.result == 0)
              emit(LearningSubjectEmpty());
            else
              emit(LearningSubjectLoaded(learnings));
            return (LearningSubjectLoaded(learnings));
          } else {
            emit(LearningSubjectEmpty());
          }
        });
    return LearningSubjectLoading();
  }

  Future<List<String>> updateTopics(
      Learnings learnings, String fileName, List<PlatformFile> file) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    var _file = (await uploadFile(file));
    learnings.uploadingFile.files = _file
        .map((e) => LearningFiles(
              fileName: fileName,
              file: e,
            ))
        .toList();
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .updateLearnings(learnings.id, learnings.toJson(false))
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : $error');
          }
          print('Error-while-uploading-learning-topic : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
    return _file;
  }

  Future<void> updateSubject(
      UploadedFiles uploadedFile, List<PlatformFile> file, String subjectId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    var _file = (await uploadFile(file));
    uploadedFile.files = _file
        .map((e) => LearningFiles(
              fileName: 'title',
              file: e,
            ))
        .toList();
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .updateSubjectLearnings(subjectId, uploadedFile.toJson(true))
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : $error');
          }
          print('Error-while-uploading-learning-chapter : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }

  Future<List<String>> updateChapter(UploadedFiles uploadedFile,
      String fileName, List<PlatformFile> file, String chapterId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    var _file = (await uploadFile(file));
    uploadedFile.files = _file
        .map((e) => LearningFiles(
              fileName: fileName,
              file: e,
            ))
        .toList();
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .updateChapterLearnings(chapterId, uploadedFile.toJson(true))
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : $error');
          }
          print('Error-while-uploading-learning-chapter : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
    return _file;
  }

  Future<List<String>> uploadFile(List<PlatformFile> files) async {
    String token = await storage.read(key: "token");
    if (files == null) return [null];
    List<String> _file = [];
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));

    for (var file in files)
      await client
          .uploadFile(file)
          .catchError((e) {
            print('error-while-uploading-file: $e');
            if (e is DioError) print('response = ${e.response}');
          })
          .whenComplete(() {})
          .then(
            (value) {
              if (value != null) {
                print('file-uploaded: ${jsonDecode(value)}');
                _file.add(jsonDecode(value)['message']);
              }
            },
          );
    return _file;
  }
  // Future<void> getTopicDetails(
  //     {String classId, String chapterId, String subjectId}) async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   final token = await storage.read(key: "token");
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //   final _classId = sharedPreferences.getString('class-id');
  //   final client = LearningApiClient(
  //     dio,
  //     baseUrl: GlobalConfiguration().get("baseURL"),
  //   );
  //   await client
  //       .getAllSubjectWithClass({
  //         "class_id": classId ?? _classId,
  //         "subject_id": subjectId,
  //         "chapter_id": chapterId,
  //       })
  //       .catchError((error) {
  //         if (error is DioError) {
  //           print('Dio-error-message : $error');
  //         }
  //         print('Error-while-getting-learning-classes : $error');
  //       })
  //       .whenComplete(() {})
  //       .then((value) {
  //         if (value != null) {
  //           print(value);
  //           LearningDetailsResponse response =
  //               LearningDetailsResponse.fromJson(jsonDecode(value));
  //           emit(LearningDetailsLoaded(response.details));
  //         }
  //       });
  // }
}

class LearningStudentIdCubit extends Cubit<LearningStudentIdStates> {
  LearningStudentIdCubit() : super(LearningStudentIdLoading());
  SharedPreferences sharedPreferences;
  FlutterSecureStorage storage = FlutterSecureStorage();
  Dio dio = Dio();

  Future<List<StudentInfo>> getStudentsId(List<String> sectionId) async {
    emit(LearningStudentIdLoading());
    sharedPreferences = await SharedPreferences.getInstance();
    List<StudentInfo> _students = [];
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .getStudentIdOfSection(
            'student', {"section": sectionId
      // , "page": 1, "limit": 100000
            })
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : $error');
          }
          print('Error-while-getting-student-id : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            _students = List<StudentInfo>.from(
              jsonDecode(value)['data'].map(
                (e) => StudentInfo(
                    id: e['_id'],
                    userInfoClass: e['class'],
                    section: e['section'],
                    parentId: e['parent_id'],
                    schoolId: e['school_id'],
                  profileImage: e['profile_image'],
                  name: e['name'],
                ),
              ),
            );

            emit(LearningStudentIdLoaded(_students));
          }
        });
    return _students;
  }
}

class LearningParentIdCubit extends Cubit<LearningParentIdStates> {
  LearningParentIdCubit() : super(LearningParentIdLoading());
  SharedPreferences sharedPreferences;
  FlutterSecureStorage storage = FlutterSecureStorage();
  Dio dio = Dio();

  Future<void> getStudentsId(List<String> sectionId) async {
    emit(LearningParentIdLoading());
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .getStudentIdOfSection(
            'parent', {"section": sectionId, "page": 1, "limit": 100000})
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : $error');
          }
          print('Error-while-getting-student-id : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('parent-response-id: ' + value);
            List<Map<String, dynamic>> data =
                List<Map<String, dynamic>>.from(jsonDecode(value)['data']);
            var students = List<StudentInfo>.from(
              data.map(
                (e) => StudentInfo(
                  id: e['student_id'],
                  parent: ParentInfo(id: e['parent_id']),
                ),
              ),
            );
            log(students.toString());
            emit(LearningParentIdLoaded(students));
          }
        });
  }
}

class LearningTeacherIdCubit extends Cubit<LearningTeacherIdStates> {
  LearningTeacherIdCubit() : super(LearningTeacherIdLoading());
  SharedPreferences sharedPreferences;
  FlutterSecureStorage storage = FlutterSecureStorage();
  Dio dio = Dio();

  Future<void> getTeacherId() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final token = await storage.read(key: "token");
    String schoolId = sharedPreferences.getString('school-id');
    String userId = sharedPreferences.getString('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    log('token 111'+token);
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .getTeacherIdOfSchool(schoolId)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : $error');
          }
          print('Error-while-getting-student-id : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            log('token 111'+token);
            print('teacher-response-id: ' + value);
            List<String> data = List<String>.from(jsonDecode(value)['data']);
            data.remove(userId);
            emit(LearningTeacherIdLoaded(data));
          }
        });
  }
}

class LearningChapterCubit extends Cubit<LearningChapterStates> {
  LearningChapterCubit() : super(LearningChapterLoading());
  SharedPreferences prefs;
  FlutterSecureStorage storage;
  Dio dio = Dio();

  Future<LearningChapterStates> loadChapters(String subjectId) async {
    prefs = await SharedPreferences.getInstance();
    List<Learnings> chapters = [];
    storage = FlutterSecureStorage();
    String schoolId = prefs.get('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final data = {
      "subject_id": subjectId,
      "repository.id": schoolId,
    };
    log('Entered');
    final client =
        LearningApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getLearningData(data, 'getchapter')
        .catchError((error) {
          if (error is DioError) {
            print(
                'Dio-error-while-loading-chapter-learnings: ${error.response}');
          } else {
            print('Error-while-loading-chapter-learnings: $error');
          }
        })
        .whenComplete(() {})
        .then((value) {
          log('LoadChapters $value');
          if (value != null) {
            LearningDetailsResponse response =
                LearningDetailsResponse.fromJson(jsonDecode(value));
            emit(LearningChapterLoaded(response.details));

            chapters = response.details;
          }
        });
    return (LearningChapterLoaded(chapters));
  }
}

class LearningTopicCubit extends Cubit<LearningTopicStates> {
  LearningTopicCubit() : super(LearningTopicLoading());
  SharedPreferences prefs;
  FlutterSecureStorage storage;
  Dio dio = Dio();

  Future<LearningTopicStates> loadTopics(String chapterId) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    List<Learnings> topics = [];
    String schoolId = prefs.get('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final data = {
      "chapter_id": chapterId,
      "repository.id": schoolId,
    };
    final client =
        LearningApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getLearningData(data, 'topic')
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-while-loading-topic-learnings: ${error.response}');
          } else {
            print('Error-while-loading-topic-learnings: $error');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('Response-learning-topics: $value');
            LearningDetailsResponse response =
                LearningDetailsResponse.fromJson(jsonDecode(value));
            emit(LearningTopicLoaded(response.details));
            topics = response.details;
            print(response.details);
          }
        });
    return LearningTopicLoaded(topics);
  }
}

class RecentFilesCubit extends Cubit<RecentFileStates> {
  RecentFilesCubit() : super(RecentFileLoading());
  final dio = Dio();
  final storage = FlutterSecureStorage();
  void getRecentFiles(String classId) async {
    final token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = LearningApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .getRecentFiles(classId)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-getting-recent-files : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            List<LearningFiles> files = List<LearningFiles>.from(
              jsonDecode(value)['data'].map((e) => LearningFiles.fromJson(e)),
            );
            emit(RecentFileLoaded(files));
          }
        });
  }
}

class NewLearningFilesCubit extends Cubit<NewLearningFilesStates> {
  NewLearningFilesCubit() : super(NewLearningFilesLoading());
  void addNewFiles(List<LearningFiles> files, bool forTopic) {
    emit(NewLearningFilesLoaded(files, forTopic));
  }
}
