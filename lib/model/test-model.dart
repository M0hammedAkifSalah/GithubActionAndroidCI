import 'dart:developer';

import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import '../model/activity.dart';
import '../model/class-schedule.dart';
import '../model/learning.dart';

enum QuestionTypeEnum {
  Mcq,
  TwoColMatching,
  Objective,
  FillInTheBlanks,
  ThreeColMatching,
  SequencingQuestion,
  SentenceSequencing,
  TrueFalse,
  Sorting,
  FreeText,
  NumericalRange,
}

class TestChapter {
  String chapter;
  String chapterName;
  TestChapter({
    this.chapter,
    this.chapterName,
  });

  factory TestChapter.fromJson(Map<String, dynamic> data) {
    log(data.toString());
    return TestChapter(
      chapter: data['_id'],
      chapterName: data['name'],
    );
  }

  Map<String, dynamic> toJson() {
    log('27/12 001 ' + chapter + ' ' + chapterName);
    return {
      '_id': chapter,
      'name': chapterName,
    };
  }
}

class TestTopic {
  String topicId;
  String topicName;

  TestTopic({
    this.topicId,
    this.topicName,
  });
  factory TestTopic.fromJson(Map<String, dynamic> data) {
    return TestTopic(
      topicId: data['_id'],
      topicName: data['name'],
    );
  }
  Map<String, dynamic> toJson() {
   return {
        '_id': topicId,
        'name': topicName,
      };

  }
}

class ChapterLearningOutcome {
  List<Repository> repository;
  String id;
  String name;
  List<LearningFiles> filesUpload;
  String classId;
  String boardId;
  String subjectId;
  String syllabusId;
  String chapterImage;
  String description;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ChapterLearningOutcome({
    this.boardId,
    this.chapterImage,
    this.classId,
    this.createdAt,
    this.createdBy,
    this.description,
    this.filesUpload,
    this.id,
    this.name,
    this.repository,
    this.subjectId,
    this.syllabusId,
    this.updatedAt,
    this.updatedBy,
    this.v,
  });

  @override
  String toString() {
    return '$name';
  }

  factory ChapterLearningOutcome.fromJson(Map<String, dynamic> data) {
    return ChapterLearningOutcome(
      repository: data['repository'] != null
          ? List<Repository>.from(
              data['repository'].map((e) => Repository.fromJson(e)),
            )
          : [],
      id: data['_id'],
      filesUpload: data['files_upload'] == null
          ? []
          : List<LearningFiles>.from(
              data['files_upload'].map((e) => LearningFiles.fromJson(e)),
            ),
      classId: data['class_id'],
      boardId: data['board_id'],
      name: data['name'],
      subjectId: data['subject_id'],
      syllabusId: data['syllabus_id'],
      chapterImage: data['chapter_image'],
      description: data['description'],
      createdBy: data['created_by'],
      updatedBy: data['updated_by'],
      createdAt:
          DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class BoardLearningOutcome {
  List<Repository> repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String name;
  String classId;
  String createdBy;
  String updatedBy;
  String description;

  BoardLearningOutcome({
    this.repository,
    this.createdAt,
    this.classId,
    this.createdBy,
    this.description,
    this.updatedAt,
    this.updatedBy,
    this.id,
    this.name,
  });

  factory BoardLearningOutcome.fromJson(Map<String, dynamic> data) {
    return BoardLearningOutcome(
      repository: List<Repository>.from(
        data['repository'].map((e) => Repository.fromJson(e)),
      ),
      description: data['description'],
      classId: data['class_id'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      id: data['_id'],
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      name: data['name'],
    );
  }
}

class TopicLearningOutcome {
  List tags;
  List<Repository> repository;
  String id;
  String name;
  List<LearningFiles> filesUpload;
  String classId;
  String boardId;
  String subjectId;
  String syllabusId;
  String chapterId;
  String topicImage;
  String description;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  TopicLearningOutcome({
    this.boardId,
    this.chapterId,
    this.classId,
    this.createdAt,
    this.createdBy,
    this.description,
    this.filesUpload,
    this.id,
    this.name,
    this.repository,
    this.subjectId,
    this.syllabusId,
    this.tags,
    this.topicImage,
    this.updatedAt,
  });

  @override
  String toString() {
    return '$name';
  }

  factory TopicLearningOutcome.fromJson(Map<String, dynamic> data) {
    return TopicLearningOutcome(
      tags: data['tags'],
      repository: List<Repository>.from(
        data['repository'].map((e) => Repository.fromJson(e)),
      ),
      id: data['_id'],
      boardId: data['board_id'],
      chapterId: data['chapter_id'],
      classId: data['class_id'],
      subjectId: data['subject_id'],
      filesUpload: List<LearningFiles>.from(
        data['files_upload'].map((e) => LearningFiles.fromJson(e)),
      ),
      topicImage: data['topic_image'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      createdBy: data['created_by'],
      description: data['description'],
      name: data['name'],
      syllabusId: data['syllabus_id'],
    );
  }
}

class TestDifficultyLevel {
  int veryEasy;
  int easy;
  int intermediate;
  int hard;
  int veryHard;

  TestDifficultyLevel({
    this.veryEasy = 0,
    this.easy = 0,
    this.hard = 0,
    this.intermediate = 0,
    this.veryHard = 0,
  });

  factory TestDifficultyLevel.fromJson(Map<String, dynamic> data) {
    return TestDifficultyLevel(
      easy: data['easy'],
      veryEasy: data['veryEasy'],
      hard: data['hard'],
      intermediate: data['intermediate'],
      veryHard: data['veryHard'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "easy": easy,
      "veryEasy": veryEasy,
      "intermediate": intermediate,
      "hard": hard,
      "veryHard": veryHard,
    };
  }
}

class LearningOutcome {
  String name;
  String description;
  String createdBy;
  List<Repository> repository;
  String id;
  List<LearningFiles> filesUpload;
  BoardLearningOutcome boardId;
  SchoolClassDetails classId;
  Subjects subjectId;
  ChapterLearningOutcome chapterId;
  TopicLearningOutcome topicId;
  DateTime createdAt;
  DateTime updatedAt;
  LearningOutcome({
    this.repository,
    this.id,
    this.filesUpload,
    this.classId,
    this.subjectId,
    this.chapterId,
    this.topicId,
    this.boardId,
    this.createdBy,
    this.createdAt,
    this.description,
    this.name,
    this.updatedAt,
  });

  @override
  String toString() {
    return '$name';
  }

  factory LearningOutcome.fromJson(Map<String, dynamic> data) {
    return LearningOutcome(
      repository: List<Repository>.from(
        data['repository'].map((e) => Repository.fromJson(e)),
      ),
      id: data['_id'],
      boardId: BoardLearningOutcome.fromJson(data['board_id']),
      chapterId: ChapterLearningOutcome.fromJson(data['chapter_id'] ?? {}),
      classId: SchoolClassDetails.fromJson(data['class_id']),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      createdBy: data['created_by'],
      description: data['description'],
      filesUpload: List<LearningFiles>.from(
        data['files_upload'].map((e) => LearningFiles.fromJson(e)),
      ),
      name: data['name'],
      subjectId: Subjects.fromJson(data['subject_id']),
      topicId: TopicLearningOutcome.fromJson(data['topic_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "createdBy": createdBy,
    };
  }
}

class AttemptType {
  int practice;
  int test;
  int practiceTest;

  AttemptType({
    this.practice = 1,
    this.practiceTest = 0,
    this.test = 0,
  });

  factory AttemptType.fromJson(Map<String, dynamic> data) {
    return AttemptType(
      practice: data['practice'] ?? 1,
      test: data['test'] ?? 0,
      practiceTest: data['practiceTest'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "practice": practice,
      "test": test,
      "practiceTest": practiceTest,
    };
  }
}

class QuestionSectionList {
  List<QuestionSection> section;
  String id;
  String sectionName;
  String information;
  QuestionSectionList({
    this.section,
    this.id,
    this.sectionName,
    this.information,
  });

  factory QuestionSectionList.fromJson(Map<String, dynamic> data) {
    return QuestionSectionList(
      section: List<QuestionSection>.from(
        data['question_list'].map((e) => QuestionSection.fromJson(e)),
      ),
      id: data['_id'],
      sectionName: data['section_name'],
      information: data['information'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "question_list": List<dynamic>.from(
        section.map((e) => e.toJson()),
      ),
      "section_name": sectionName,
      "information": information,
    };
  }
}

class LearningOutcomeSection {
  List<String> outcome;
  LearningOutcomeSection(this.outcome);

  factory LearningOutcomeSection.fromJson(Map<String, dynamic> data) {
    return LearningOutcomeSection(data['outcome']!= null ?data['outcome'].map((e) => e):[]);
  }
  Map<String, dynamic> toJson()
  {

          return {
            'outcome':outcome,
          };

  }
}

class QuestionSection {
  List<String> questionType;
  List<String> question;
  List<QuestionSection> questions;
  List<QuestionOptions> options;
  List<QuestionOptions> answer;
  String duration;
  dynamic negativeMarks;
  String negativeScore;
  String optionsType;
  int totalMarks;
  MatchOption matchOptions;
  String id;
  String reason;

  QuestionSection({
    this.answer,
    this.duration,
    this.id,
    this.matchOptions,
    this.negativeMarks,
    this.negativeScore,
    this.options,
    this.optionsType,
    this.question,
    this.questionType,
    this.questions,
    this.totalMarks,
    this.reason,
  });

  factory QuestionSection.fromJson(Map<String, dynamic> data) {


      return QuestionSection(
          id: data['_id'],
          answer: List<QuestionOptions>.from(
            data['answer']
                .map((e) => !(e is String) ? QuestionOptions.fromJson(e) : null),
          ),
          questionType: List<String>.from(data['questionType'].map((e) => e)),
          // question: [data['questionSvg']],
          question: List<String>.from(data['question'].map((e) => e)),
          duration: data['duration'],
          negativeMarks: data['negativeMarks'],
          negativeScore: data['negativeScore'],
          optionsType: data['optionType'],
          totalMarks: data['totalMarks'],
          matchOptions: MatchOption.fromJson(data['matchOptions'] ?? {}),
          options: List<QuestionOptions>.from(
            data['options'].map((e) => QuestionOptions.fromJson(e)),
          ),
          reason: data['reason'],
          questions: List<QuestionSection>.from(
              data['questions'].map((e) => QuestionSection.fromJson(e))));

  }
  Map<String, dynamic> toJson() {
    try {
      return {
        "questionType": List<dynamic>.from(questionType.map((e) => e)),
        // "questionSvg":question.first,
        "question": List<dynamic>.from(question.map((e) => e)),
        "options": List<dynamic>.from(
          options.map((e) => e.toJson()),
        ),
        "answer": List<dynamic>.from(
          answer.map((e) => e.toJson()),
        ),
        "questions":
            questions == null ? [] : questions.map((e) => e.toJson()).toList(),
        "duration": duration,
        "_id": id,
        "negativeMarks": negativeMarks??0,
        "negativeScore": negativeScore ?? "NO",
        "optionsType": optionsType ?? "text",
        "totalMarks": totalMarks,
        "matchOptions": matchOptions.toJson(),
        "reason":reason,
        // "questionSvg":questionSvg
      };
    }  catch (e) {
      // TODO
      log('error   '  +e.toString() );
    }
  }
}

class QuestionPaperAnswer {
  TestStudentDetails studentDetails;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String questionTitle;
  String questionId;
  int attemptQuestion;
  List<TestAnswerDetails> answerDetails;
  String totalTimeTaken;
  int totalMarks;
  int marksObtained;
  String createdBy;
  String status;
  int totalStudents;
  int rank;
  int avg;

  QuestionPaperAnswer({
    this.answerDetails,
    this.attemptQuestion,
    this.createdAt,
    this.createdBy,
    this.id,
    this.questionId,
    this.questionTitle,
    this.studentDetails,
    this.totalMarks,
    this.totalTimeTaken,
    this.updatedAt,
    this.marksObtained,
    this.status,
    this.rank,
    this.totalStudents,
    this.avg,
  });

  factory QuestionPaperAnswer.fromJson(Map<String, dynamic> data) {
    return QuestionPaperAnswer(
        answerDetails: List<TestAnswerDetails>.from(
          data['answer_details'].map((e) => TestAnswerDetails.fromJson(e)),
        ),
        attemptQuestion: data['attempt_question'],
        createdAt: DateTime.parse(data['createdAt']),
        updatedAt: DateTime.parse(data['updatedAt']),
        createdBy: data['createdBy'],
        id: data['_id'],
        questionId: data['question_id'],
        questionTitle: data['question_title'],
        marksObtained: data['marksObtained'],
        studentDetails: TestStudentDetails.fromJson(data['student_details']),
        totalMarks: int.parse(data['totalMarks'].toString()),
        totalTimeTaken: data['totalTimeTaken'].toString(),
        status: data['status'],
      rank: data['rank'],
      totalStudents: data['total_student'],
      avg: data['average']

    );
  }
}

class CorrectedAnswer {
  int questionNo;
  bool correct;
  int marks;
  CorrectedAnswer({
    this.correct,
    this.questionNo,
    this.marks,
  });

  bool operator ==(other) {
    return questionNo == other.questionNo && correct == other.correct;
  }

  @override
  String toString() {
    return 'Corrected-Ans: $correct , $questionNo';
  }

  Map<String, dynamic> toJson() {
    return {
      "question_no": questionNo,
      "correctOrNot": correct ? "correct" : "wrong",
    };
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}

class TestAnswerDetails {
  String id;
  String question;
  List answerByStudent;
  List answer;
  String questionId;
  String timeTaken;
  String correct;
  int marks;
  int negativeMarks;
  bool correctOrNot;
  List<TestAnswerDetails> answers;
  int obtainedMarks;

  TestAnswerDetails({
    this.id,
    this.answer,
    this.answerByStudent,
    this.marks,
    this.negativeMarks,
    this.question,
    this.correct,
    this.timeTaken,
    this.correctOrNot,
    this.answers,
    this.obtainedMarks,
    this.questionId
  });
  factory TestAnswerDetails.fromJson(Map<String, dynamic> data) {
    return TestAnswerDetails(
        id: data['_id'],
        question: data['question'],
        questionId: data['questionId'],
        answerByStudent: data['answerByStudent'],
        answer: data['answer'],
        timeTaken: data['timetaken'],
        correctOrNot: data['correctOrNot'].toString().toLowerCase() == 'yes',
        correct: data['correctOrNot'],
        marks: data['marks'],
        negativeMarks: data['negative_mark'],
        answers: data['answers'] != null ? List<TestAnswerDetails>.from(data['answers'].map((e)=> TestAnswerDetails.fromJson(e))):null,
        obtainedMarks: data['obtainedMarks']);
  }

  Map<String, dynamic> toJSON() {
    return {'_id': id, 'obtainedMarks': obtainedMarks};
  }
}





// class Answers {
//   Answers({
//     this.question,
//     this.questionId,
//     this.answer,
//     this.answerByStudent,
//     this.answers,
//     this.correctOrNot,
//     this.timetaken,
//     this.obtainedMarks,
//     this.marks,
//     this.negativeMark,
//   });
//
//   String question;
//   String questionId;
//   List<String> answer;
//   List<String> answerByStudent;
//   List<dynamic> answers;
//   String correctOrNot;
//   String timetaken;
//   int obtainedMarks;
//   int marks;
//   int negativeMark;
//
//   factory Answers.fromJson(Map<String, dynamic> json) => Answers(
//     question: json["question"],
//     questionId: json["questionId"],
//     answer: List<String>.from(json["answer"].map((x) => x)),
//     answerByStudent: List<String>.from(json["answerByStudent"].map((x) => x)),
//     answers: List<dynamic>.from(json["answers"].map((x) => x)),
//     correctOrNot: json["correctOrNot"],
//     timetaken: json["timetaken"],
//     obtainedMarks: json["obtainedMarks"],
//     marks: json["marks"],
//     negativeMark: json["negative_mark"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "question": question,
//     "questionId": questionId,
//     "answer": List<dynamic>.from(answer.map((x) => x)),
//     "answerByStudent": List<dynamic>.from(answerByStudent.map((x) => x)),
//     "answers": List<dynamic>.from(answers.map((x) => x)),
//     "correctOrNot": correctOrNot,
//     "timetaken": timetaken,
//     "obtainedMarks": obtainedMarks,
//     "marks": marks,
//     "negative_mark": negativeMark,
//   };
// }


class TestStudentDetails {
  String schoolId;
  String teacherId;
  String classId;
  String studentId;

  TestStudentDetails({
    this.classId,
    this.schoolId,
    this.studentId,
    this.teacherId,
  });
  factory TestStudentDetails.fromJson(Map<String, dynamic> data) {
    return TestStudentDetails(
      studentId: data['student_id'],
      teacherId: data['teacher_id'],
      schoolId: data['school_id'],
      classId: data['class_id'],
    );
  }
}

class QuestionOptions {
  String value;
  String fileText;
  String prefix;
  dynamic maxValue;
  dynamic minValue;
  int score;
  bool isDisable;
  // String valueSvg;
  QuestionOptions({
    this.value,
    this.fileText,
    this.maxValue,
    this.minValue,
    this.prefix,
    this.score,
    this.isDisable,
    // this.valueSvg
  });

  factory QuestionOptions.fromJson(Map<String, dynamic> data) {

      return QuestionOptions(
        fileText: data['file_text'],
        maxValue: data['maxValue'],
        minValue: data['minValue'],
        value: data['valueSvg'] != null ? data['valueSvg']:null,
        prefix: data['prefix'],
        score: data['score'] is String ? int.tryParse(data['score']) : data['score'],
        isDisable: data['isDisable'] is String ? false : data['isDisable'],
        // valueSvg: data['valueSvg']
      );

  }

  Map<String, dynamic> toJson() {
   return {
        "valueSvg": value,
        "maxValue": maxValue,
        "minValue": minValue,
        "file_text": fileText,
        "score":score,
        "prefix":prefix,
        "isDisable":isDisable,
        // "valueSvg":valueSvg
      };

  }

}

class ExamTypeResponse {
  int status;
  int result;
  List<ExamType> data;

  ExamTypeResponse({
    this.data,
    this.result,
    this.status,
  });

  factory ExamTypeResponse.fromJson(Map<String, dynamic> data) {
    return ExamTypeResponse(
      data: List<ExamType>.from(
        data['data'].map((e) => ExamType.fromJson(e)),
      ),
      result: data['result'],
      status: data['status'],
    );
  }
}

class ExamType {
  List<Repository> repository;
  String id;
  String name;
  String description;
  DateTime createdAt;
  DateTime updatedAt;

  ExamType({
    this.repository,
    this.createdAt,
    this.description,
    this.id,
    this.updatedAt,
    this.name,
  });

  factory ExamType.fromJson(Map<String, dynamic> data) {
    return ExamType(
      repository: data['repository'] != null && data['repository'] != [] ? List<Repository>.from(
        data['repository'].map((e) => Repository.fromJson(e)),
      ) : [],
      id: data['_id'],
      name: data['name'],
      description: data['description'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
}

class DetailQuestionPaper {
  List<TestChapter> chapters;
  List<Subjects> subject;
  List<TestTopic> topic;
  List<String> studentType;
  List<String> examType;
  List<LearningOutcomeSection> learningOutcome;
  List<String> questionCategory;
  List<TestBoard> board;
  TestClass testClass;
  String className;
  List<TestSyllabus> syllabus;
  String language;
  AttemptType attemptType;
  int totalQuestion;
  TestDifficultyLevel testDifficultyLevel;

  DetailQuestionPaper(
      {this.chapters,
      this.attemptType,
      this.board,
      this.testClass,
      this.totalQuestion,
      this.examType,
      this.language,
      this.learningOutcome,
      this.questionCategory,
      this.studentType,
      this.subject,
      this.syllabus,
      this.testDifficultyLevel,
      this.topic,
      this.className});

  factory DetailQuestionPaper.fromJson(Map<String, dynamic> data) {
   return DetailQuestionPaper(
          chapters: data['chapters'] != null
              ? List<TestChapter>.from(
                  data['chapters'].map((e) {
                    // log(e['name']);
                    return TestChapter.fromJson(e);
                  }),
                )
              : [],
          attemptType: data['attemptType'] == null
              ? AttemptType()
              : AttemptType.fromJson(data['attemptType']),
          board: data['board'] != null
              ? List<TestBoard>.from((data['board'] ?? [])
                  .map((e) => TestBoard(name: e['name'], id: e['_id'])))
              : [],
          testClass: data['class'] != null
              ? TestClass.fromJson(data['class'])
              : data['class'],
          learningOutcome: List<LearningOutcomeSection>.from(
            data['learningOutcome'].map((e) => LearningOutcomeSection.fromJson(e)),
          ),
          examType: data['examType'] != null
              ? List<String>.from(data['examType'].map((e) => e['value']))
              : [],
          language: data['language'] != null ? data['language'] : '',
          questionCategory: data['questionCategory'] == null
              ? []
              : List<String>.from(data['questionCategory']
                  .map((e) => e['questionCategoryName'])),
          studentType: List<String>.from(data['studentType'].map((e) => e)),
          subject: List<Subjects>.from(
            data['subject'].map((e) {
              return Subjects(name: e['name'], id: e['_id']);
            }),
          ),
          syllabus: List<TestSyllabus>.from((data['syllabus'] ?? [])
              .map((e) => TestSyllabus(id: e['_id'], name: e['name']))),
          totalQuestion:
              data['totalQuestion'] != null ? data['totalQuestion'] : 0,
          testDifficultyLevel: data['difficultyLevel'] == null
              ? TestDifficultyLevel()
              : TestDifficultyLevel.fromJson(data['difficultyLevel']),
          topic: data['topic'] != null
              ? List<TestTopic>.from(
                  data['topic'].map((e) {
                    return TestTopic.fromJson(e);
                  }),
                )
              : [],
          className:
              data['class'] != null ? data['class']['name'] : data['class']);

  }
//
  Map<String, dynamic> toJson() {
   return {
        "chapter": chapters != null
            ? List<String>.from(
                chapters.map((e) => e.chapter),
              )
            : [],
        "subject": subject != null
            ? List<String>.from(
                subject.map((e) => e.id),
              )
            : [],
        "topic": topic != null
            ? List<dynamic>.from(topic.map((e) => e.topicId))
            : [],
        "studentType": studentType ?? '',
        "examType": examType ?? '',
         "learningOutcome":
          [],
        "questionCategory": questionCategory ?? '',
        "board": board != null?
        List<dynamic>.from(board.map((e) => e.id))
        :[],
        "class": testClass != null ? testClass.toJson() : '',
         "syllabus": (syllabus != null && syllabus.isNotEmpty) ? syllabus.first.id:[],
        "totalQuestion": totalQuestion ?? 0,
        "language": language ?? '',
        "attemptType": attemptType != null ? attemptType.toJson() : {},
        "difficultyLevel": testDifficultyLevel != null ? testDifficultyLevel.toJson() : {},
      };
  }
}

class TestSyllabus {
  String id;
  String name;

  TestSyllabus({
    this.id,
    this.name,
  });
  factory TestSyllabus.fromJson(Map<String, dynamic> json) {
   return TestSyllabus(id: json['_id'], name: json['name']);

  }

  Map<String, dynamic> toJson() {
   return {
        '_id': id,
        'name': name,
      };

  }
}

class TestBoard {
  String id;
  String name;

  TestBoard({
    this.id,
    this.name,
  });
  factory TestBoard.fromJson(Map<String, dynamic> json) {
   return TestBoard(id: json['_id'], name: json['name']);

  }

  Map<String, dynamic> toJson() {
   return {
        '_id': id,
        'name': name,
      };

  }
}

class TestClass {
  String id;
  String name;

  TestClass({this.id, this.name});

  factory TestClass.fromJson(Map<String, dynamic> json) {
   return  TestClass(id: json['_id'], name: json['name']);

  }

  Map<String, dynamic> toJson() {
   return  {
        '_id': id,
        'name': name,
      };

  }
}

class QuestionCategory {
  List<Repository> repository;
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  QuestionCategory({
    this.repository,
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return name;
  }

  factory QuestionCategory.fromJson(Map<String, dynamic> data) {
    return QuestionCategory(
      repository: List<Repository>.from(
        data['repository'].map((e) => Repository.fromJson(e)),
      ),
      id: data['_id'],
      name: data['name'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
}

class QuestionPaper {
  DetailQuestionPaper detailQuestionPaper;
  DateTime createdAt;
  DateTime updatedAt;
  List<Repository> repository;
  String id;
  String classId;
  String questionTitle;
  List<QuestionSectionList> section;
  String createdBy;
  int coin;
  Assigned assigned;
  int award;
  UserId userId;
  String qid;
  String schoolId;
  DateTime dueDate;
  DateTime startDate;
  String status;
  DateTime assignDate;
  String title;
  String duration;
  double totalMarks;
  String activityType;
  List<TestAssignTo> assignTo;
  String className;
  bool isCreated;
  bool reason;

  QuestionPaper(
      {this.detailQuestionPaper,
      this.createdAt,
      this.createdBy,
      this.id,
      this.activityType = 'Question Paper',
      this.questionTitle,
      this.repository,
      this.classId,
      this.section,
      this.startDate,
      this.dueDate,
      this.coin,
      this.assignTo,
      this.award,
      this.updatedAt,
      this.userId,
      this.title,
      this.qid,
      this.duration,
      this.assigned = Assigned.student,
      this.className,
      this.isCreated,
      this.reason});

  factory QuestionPaper.fromJson(Map<String, dynamic> data) {
     return  QuestionPaper(
            detailQuestionPaper: data['detail_question_paper'] != null
                ? DetailQuestionPaper.fromJson(data['detail_question_paper'])
                : null,
            createdAt: data['createdAt'] != null
                ? DateTime.parse(data['createdAt']).toLocal()
                : null,
            updatedAt: data['updatedAt'] != null
                ? DateTime.parse(data['updatedAt']).toLocal()
                : null,
            createdBy: data['createdBy'] != null ? data['createdBy'] : '',
            id: data['_id'] != null ? data['_id'] : '',
            award: data['award'] != null ? data['award'] : 0,
            coin: data['coin'] != null ? data['coin'] : 0,
            duration: data['duration'] != null ? data['duration'] : '',
            assignTo: data['assignTo'] != null
                ? List<TestAssignTo>.from(
                    data['assignTo'].map((e) => TestAssignTo.fromJson(e)),
                  )
                : [],
            dueDate: data['dueDate'] != null
                ? DateTime.tryParse(data['dueDate']).toLocal()
                : null,
            startDate: data['startDate'] != null
                ? DateTime.tryParse(data['startDate']).toLocal()
                : null,
            userId: data['user_id'] != null
                ? UserId.fromJson(data['user_id'])
                : UserId(),
            classId: data['class_id'] != null ? data['class_id']['_id'] : '',
            className: data['class_id'] != null ? data['class_id']['name'] : '',
            qid: data['question_id'] != null ? data['question_id'] : '',
            questionTitle:
                data['question_title'] != null ? data['question_title'] : '',
            repository: data['repository'] != null
                ? List<Repository>.from(
                    data['repository'].map((e) => Repository.fromJson(e)),
                  )
                : [],
            section: data['section'] != null
                ? List<QuestionSectionList>.from(
                    data['section'].map((e) => QuestionSectionList.fromJson(e)),
                  )
                : [],
            reason: data['show_reason']);


  }

  Map<String, dynamic> toJson() {
   try {
     return  {
          "class_id": classId,
          "question_title": questionTitle,
          "coin": coin,
          "award": award ,
          "user_id": userId != null ? userId.toJson() : null,
          "question_id": qid ,
          "school_id": schoolId ,
          "duration": duration ,
          "dueDate": dueDate != null ? dueDate.toIso8601String() : null,
          "startDate": startDate != null ? startDate.toIso8601String() : null,
          "createdBy": createdBy,
          "AssignDate": DateTime.now().toIso8601String(),
          "assignTo": assignTo != null
              ? List<dynamic>.from(
                  assignTo.map((e) {
                    return e.toJson();
                  }),
                )
              : [],
          "detail_question_paper":
              detailQuestionPaper != null ? detailQuestionPaper.toJson() : null,
          "section": section != null
              ? List<dynamic>.from(
                  section.map((e) => e.toJson()),
                )
              : [],
          "show_reason": true,
        };
   }  catch (e) {
     log(e.toString()+  'error ');
     // TODO
   }

  }
}


class TestAssignTo {
  TestAssignTo({
    this.status,
    this.id,
    this.studentId,
    this.name,
    this.profileImage,
    this.sectionId,
    this.sectionName,
    this.classId,
    this.className,
    this.schoolId,
  });

  String status;
  String id;
  String studentId;
  String name;
  String profileImage;
  String sectionId;
  String sectionName;
  String classId;
  String className;
  String schoolId;

  factory TestAssignTo.fromJson(Map<String, dynamic> json) {

    return TestAssignTo(
    status: json["status"],
    id: json["_id"],
    studentId: json["student_id"] is Map<String,dynamic> ? json["student_id"]['_id']:json["student_id"],
    name:json["student_id"] is Map<String,dynamic> ? json["student_id"]['name']:json["student_id"],
    profileImage:json["student_id"] is Map<String,dynamic> ? json["student_id"]['profile_image']:json["student_id"],
    sectionId:  json["section_id"] is Map<String,dynamic> ? json["section_id"]['_id']:json["section_id"],
    sectionName:json["section_id"] is Map<String,dynamic> ? json["section_id"]["name"]:json["section_id"],
    classId:json['class_id'] is Map<String,dynamic> ? json["class_id"]['_id']:json["class_id"],
    className: json['class_id'] is Map<String,dynamic> ? json["class_id"]['name']:json['class_id'],
  );
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        "status": 'Pending',
        "student_id": studentId,
        "name": name,
        "profile_image": profileImage,
        "section_id": sectionId,
        "sectionName": sectionName,
        "class_id": classId,
        "className": className,
        "schoolId": schoolId,
      };
    }  catch (e) {
      log(e.toString());
      // TODO
    }
  }
}


class QuestionTypeResponse {
  String status;
  int result;
  List<QuestionType> data;
  QuestionTypeResponse({
    this.data,
    this.result,
    this.status,
  });
  factory QuestionTypeResponse.fromJson(Map<String, dynamic> data) {
    return QuestionTypeResponse(
      status: data['status'],
      result: data['result'],
      data: List<QuestionType>.from(
        data['data'].map((e) => QuestionType.fromJson(e)),
      ),
    );
  }
}

class QuestionTypeSingle {
  final List<QuestionType> questionType;
  final int totalQuestions;
  final String title;
  int selectedQuestions = 0;
  QuestionTypeSingle({
    this.questionType,
    this.totalQuestions,
    this.title,
    this.selectedQuestions = 0,
  });
  @override
  String toString() {
    return 'QuestionTypeSingle object : $title title, $totalQuestions totalQuestion';
  }
}

class QuestionType {
  List<TestBoard> board;
  List<TestSyllabus> syllabus;
  List<TestExamType> examTypeString;
  List<String> questionType;
  List<String> practiceAndTestQuestions;
  List<String> studentType;
  List<String> question;
  List<QuestionOptions> options;
  List<QuestionOptions> answer;
  List<Repository> repository;
  List<QuestionType> questions;
  String questionTypeString;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String className;
  String subject;
  List<TestChapter> chapter;
  List<TestTopic> topic;
  String language;
  List<String> learningOutcome;
  List<dynamic> questionCategory;
  String difficultyLevel;
  String questionTitle;
  String optionType;
  MatchOption matchOption;
  int totalMarks;
  String negativeScore;
  String duration;
  String reason;
  bool selected = false;
  int negativeMarks;
  int wrongCount;
  // String questionSvg;

  QuestionType({
    this.answer,
    this.board,
    this.chapter,
    this.className,
    this.createdAt,
    this.difficultyLevel,
    this.duration,
    this.examTypeString,
    this.id,
    this.language,
    this.learningOutcome,
    this.matchOption,
    this.negativeScore,
    this.optionType,
    this.questions,
    this.options,
    this.practiceAndTestQuestions,
    this.question,
    this.questionCategory,
    this.questionTitle,
    this.questionType,
    this.repository,
    this.studentType,
    this.subject,
    this.syllabus,
    this.topic,
    this.totalMarks,
    this.updatedAt,
    this.reason,
    this.negativeMarks,
    this.wrongCount,
    // this.questionSvg,
  });
  factory QuestionType.fromJson(Map<String, dynamic> data) {
    log(data['questionCategory'].toString());
   return  QuestionType(
          questions: data['questions'] == null && data['questions'] == []
              ? []
              : List<QuestionType>.from(
                  data['questions'].map((e) => QuestionType.fromJson(e)),
                ),
          answer: data['answer'] != null && data['answer'] != [] ? List<QuestionOptions>.from(
            data['answer'].map((e) => e is Map<String, dynamic>
                ? QuestionOptions.fromJson(e)
                : QuestionOptions(value: e.toString())),
          ) : [],
          board: data['board'] != null && data['board'] != [] ? List<TestBoard>.from(data['board'].map((e) =>
              e is Map<String, dynamic>
                  ? TestBoard.fromJson(e)
                  : TestBoard(name: e.toString()))) : [],
          syllabus:data['syllabus'] != null && data['syllabus'] != [] ? List<TestSyllabus>.from(data['syllabus']
              .map((e) => e is Map<String, dynamic> ? TestSyllabus.fromJson(e) : TestSyllabus(name: e.toString()))) : [],
          examTypeString: data['examType'] == null
              ? []
              : List<TestExamType>.from(
                  data['examType'].map((e) => e is Map<String,dynamic> ? TestExamType.fromJson(e) : TestExamType(name: e.toString()))),
          questionType:data['questionType'] != null && data['questionType'] != [] ? List<String>.from(data['questionType'].map((e) => e.toString())) : [],
          practiceAndTestQuestions: data['practiceAndTestQuestion'] != null && data['practiceAndTestQuestion'] != [] ?
              List<String>.from(data['practiceAndTestQuestion'].map((e) => e)) : [],
          studentType:data['studentType'] != null && data['studentType'] != [] ?  List<String>.from(data['studentType'].map((e) => e)):[],
          question: data['questionSvg'] != null ? [data['questionSvg']]:[],
     // question: data['question'] != null && data['question'] != [] ? List<String>.from(data['question'].map((e)=>e.toString())):[],
          options: data['options'] != null && data['options'] != [] ? List<QuestionOptions>.from(
            data['options'].map((e) => e is Map<String,dynamic> ? QuestionOptions.fromJson(e) : QuestionOptions(value: e)),
          ) : [],
          repository: data['repository'] != null && data['repository'] != [] ? List<Repository>.from(
            data['repository'].map((e) => Repository.fromJson(e)),
          ) : [],
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
          id: data['_id'],
          className: data['class'] is Map<String, dynamic>
              ? data['class']['name']
              : data['class'],
          subject: data['subject'] is Map<String, dynamic>
              ? data['subject']['name']
              : data['subject'],
          chapter: data['chapter'] != null && data['chapter'] != [] ? List<TestChapter>.from(data['chapter'].map((e) => e is Map<String,dynamic> ? TestChapter.fromJson(e) : TestChapter(chapterName: e.toString()))) : [],
          topic: data['topic']!= null && data['topic'] != [] ? List<TestTopic>.from(data['topic'].map((e) => e is Map<String,dynamic> ? TestTopic.fromJson(e) : TestTopic(topicName: e.toString()))) : [],
          language: data['language'],
          learningOutcome: data['learningOutcome'] != null && data['learningOutcome'] != [] ? List<String>.from(
              data['learningOutcome'].map((e) => e.toString())) : [],
          questionCategory: data['questionCategory'],
          difficultyLevel: data['difficultyLevel'],
          questionTitle: data['questionTitle'],
          optionType: data['optionsType'],
          matchOption: MatchOption.fromJson(data['matchOptions'] ?? {}),
          totalMarks: data['totalMarks'],
          negativeScore: data['negativeScore'],
          negativeMarks: data['negativeMarks'],
          wrongCount: data['wrong_count'],
          duration: data['duration'],
          reason: data['reason'],
          // questionSvg: data['questionSvg'],
   );
  }

  Map<String, dynamic> toJson() {
    return {
      "board": List<dynamic>.from(board.map((e) => e)),
      "syllabus": List<dynamic>.from(syllabus.map((e) => e)),
      "examType": List<dynamic>.from(examTypeString.map((e) => e)),
      "questionType": List<dynamic>.from(questionType.map((e) => e)),
      "practiceAndTestQuestion":
          List<dynamic>.from(practiceAndTestQuestions.map((e) => e)),
      "studentType": List<dynamic>.from(studentType.map((e) => e)),
      // "questionSvg":questionSvg,
      // "question": List<dynamic>.from(question.map((e) => e)),
      "question":question.first,
      "options": List<dynamic>.from(
        options.map((e) => e.toJson()),
      ),
      "answer": List<dynamic>.from(answer.map(
        (e) => e.toJson(),
      )),
      "repository": List<dynamic>.from(repository.map(
        (e) => e.toJson(),
      )),
      "class": className,
      "subject": subject,
      "chapter": chapter,
      "topic": topic,
      "language": language,
      "learningOutcome": learningOutcome,
      "questionCategory": questionCategory,
      "difficultyLevel": difficultyLevel,
      "questionTitle": questionTitle,
      "optionsType": optionType,
      "matchOptions": matchOption.toJson(),
      "totalMarks": totalMarks,
      "negativeScore": negativeScore,
      "duration": duration,
      "reason": reason,
    };
  }
}

class TestExamType {
  String id;
  String name;

  TestExamType({this.id, this.name});

  factory TestExamType.fromJson(Map<String, dynamic> json) {
   return TestExamType(id: json['_id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
   return {
        '_id': id,
        'name': name,
      };
  }

}

class MatchOption {
  List<MatchOptionColumn> column1;
  List<MatchOptionColumn> column2;
  List<MatchOptionColumn> column3;

  MatchOption({
    this.column1,
    this.column2,
    this.column3,
  });

  factory MatchOption.fromJson(Map<String, dynamic> data) {
    return MatchOption(
      column1: data['column1'] == null
          ? []
          : List<MatchOptionColumn>.from(
              data['column1'].map((e) => MatchOptionColumn.fromJson(e)),
            ),
      column2: data['column2'] == null
          ? []
          : List<MatchOptionColumn>.from(
              data['column2'].map((e) => MatchOptionColumn.fromJson(e)),
            ),
      column3: data['column3'] == null
          ? []
          : List<MatchOptionColumn>.from(
              data['column3'].map((e) => MatchOptionColumn.fromJson(e)),
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "column1": List<dynamic>.from(
        column1.map((e) => e.toJson()),
      ),
      "column2": List<dynamic>.from(
        column2.map((e) => e.toJson()),
      ),
      "column3": List<dynamic>.from(
        column3.map((e) => e.toJson()),
      ),
    };
  }
}

class MatchOptionColumn {
  String type;
  String value;
  String fileText;

  MatchOptionColumn({
    this.type,
    this.fileText,
    this.value,
  });

  factory MatchOptionColumn.fromJson(Map<String, dynamic> data) {
    return MatchOptionColumn(
      type: data['type'].toString(),
      value: _parseHtmlString(data['value']),
      fileText: data['file_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "value": value,
      "file_text": fileText,
    };
  }
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);

  List<Element> imgList = document.querySelectorAll("img");

  String parsedString;
  if (imgList.isNotEmpty) {
    for (Element img in imgList) {
      parsedString = img.attributes["src"];
    }
  } else
    parsedString = parse(document.body.text).documentElement.text;

  /// "<figure class=\"image\"><img src=\"https://grow-on.s3.ap-south-1.amazonaws.com/1613024456212Screenshot (1).png\"></figure>"
  return parsedString;
}

class TimePicker with ChangeNotifier {
  int mins = 0;
  int hours = 3;

  int get getMins => mins;
  int get getHours => hours;

  String get getTimeInSeconds => ((hours * 60 + mins) * 60).toString();

  String get getTime => '$hours hrs $mins mins';

  set setMins(int value) {
    mins = value;
    notifyListeners();
  }

  set setHours(int value) {
    hours = value;
    notifyListeners();
  }
}

class TestDetailsModel {
  EvaluateTestModel testDetails;
  List<RewardedStudent> studentDetails;
  String id;

  TestDetailsModel({
    @required this.id,
    this.studentDetails,
    this.testDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      "activity_id": id,
      "test_details": testDetails.toJson(),
      "student_details": List<dynamic>.from(
        studentDetails.map((e) => e.toJson()),
      ),
    };
  }
}

class EvaluateTestModel {
  String questionId;
  List<CorrectedAnswer> answers;

  EvaluateTestModel({
    this.questionId,
    this.answers,
  });

  Map<String, dynamic> toJson() {
    return {
      "test_id": questionId,
      "answer": List<dynamic>.from(
        answers.map((e) => e.toJson()),
      )
    };
  }
}

//model for assigning a question paper which is already created
class TestAssign {
  String assignDate;
  String startDate;
  String dueDate;
  int award;
  String duration;
  List<AssignTo> assignTo;
  String teacherId;

  TestAssign(
      {this.assignDate,
      this.assignTo,
      this.teacherId,
      this.startDate,
      this.dueDate,
      this.duration,
      this.award});

  factory TestAssign.fromJson(Map<String, dynamic> json) {
   return TestAssign(
          assignDate: json['AssignDate'],
          award: json['award'],
          dueDate: json['dueDate'],
          duration: json['duration'],
          startDate: json['startDate'],
          assignTo: List<AssignTo>.from(
              json['assignTo'].map((e) => AssignTo.fromJson(e))),
          teacherId: json['teacher_id']);

  }

  Map<String, dynamic> toJson() {
   return {
        'AssignDate': assignDate,
        'startDate': startDate,
        'dueDate': dueDate,
        'award': award,
        'duration': duration,
        'assignTo': List<dynamic>.from(
          assignTo.map((e) {
            log(e.toString());
            return e.toJson();
          }),
        ),
        'teacher_id': teacherId
      };
  }
}

class UserId {
  UserId({
    this.id,
    this.name,
    this.profileImage,
  });

  String id;
  String name;
  String profileImage;

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        id: json["_id"],
        name: json["name"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() {
    // try {
      return {
        "_id": id,
        "name": name,
        "profile_image": profileImage,
      };
    // }  catch (e) {
    //   log(e.toString());
    //   // TODO
    // }
  }
}

//model for free text answer submission
// class FreeTextAnswer {
//   FreeTextAnswer({
//     this.questionId,
//     this.studentId,
//     this.answerDetails,
//     this.isEvaluated,
//   });
//
//   String questionId;
//   String studentId;
//   List<AnswerDetail> answerDetails;
//   bool isEvaluated;
//
//   factory FreeTextAnswer.fromJson(Map<String, dynamic> json) => FreeTextAnswer(
//         questionId: json["question_id"],
//         studentId: json["studentId"],
//         answerDetails: List<AnswerDetail>.from(
//             json["answer_details"].map((x) => AnswerDetail.fromJson(x))),
//         isEvaluated: json["isEvaluated"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "question_id": questionId,
//         "student_id": studentId,
//         "answer_details":
//             List<dynamic>.from(answerDetails.map((x) => x.toJson())),
//         "isEvaluated": isEvaluated,
//       };
// }
//
// class AnswerDetail {
//   AnswerDetail({
//     this.id,
//     this.obtainedMarks,
//     this.correctOrNot,
//     this.questionId,
//     this.answers,
//   });
//
//   String id;
//   int obtainedMarks;
//   String correctOrNot;
//   String questionId;
//   List<AnswerDetail> answers;
//   factory AnswerDetail.fromJson(Map<String, dynamic> json) => AnswerDetail(
//       id: json["_id"],
//       questionId: json['question_id'],
//       obtainedMarks: json["obtainedMarks"],
//       correctOrNot: json["correctOrNot"],
//       answers: List<AnswerDetail>.from(
//           json["answers"].map((e) => AnswerDetail.fromJson(e))));
//
//   Map<String, dynamic> toJson() {
//     return {
//       "_id": id ?? '',
//       "question_id": questionId,
//       "obtainedMarks": obtainedMarks,
//       "correctOrNot": correctOrNot ?? 'yes',
//       "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
//     };
//   }
// }

class FreeTextAnswer {
  FreeTextAnswer({
    this.questionId,
    this.studentId,
    this.answerDetails,
    this.isEvaluated,
  });

  String questionId;
  String studentId;
  List<AnswerDetail> answerDetails;
  bool isEvaluated;

  factory FreeTextAnswer.fromJson(Map<String, dynamic> json) => FreeTextAnswer(
        questionId: json["question_id"],
        studentId: json["student_id"],
        answerDetails: List<AnswerDetail>.from(
            json["answer_details"].map((x) => AnswerDetail.fromJson(x))),
        isEvaluated: json["isEvaluated"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "student_id": studentId,
        "answer_details":
            List<dynamic>.from(answerDetails.map((x) => x.toJson())),
        "isEvaluated": isEvaluated,
      };
}

class AnswerDetail {
  AnswerDetail({
    this.id,
    this.questionId,
    this.answers,
    this.obtainedMarks,
    this.correctOrNot,
  });

  String id;
  String questionId;
  List<Answer> answers;
  int obtainedMarks;
  String correctOrNot;

  factory AnswerDetail.fromJson(Map<String, dynamic> json) => AnswerDetail(
        id: json["_id"],
        questionId: json["question_id"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        obtainedMarks: json["obtainedMarks"],
        correctOrNot: json["correctOrNot"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "question_id": questionId,
        "answers": answers != null ? List<dynamic>.from(answers.map((x) => x.toJson())):[],
        "obtainedMarks": obtainedMarks,
        "correctOrNot": correctOrNot,
      };
}

class Answer {
  Answer({
    this.questionId,
    this.obtainedMarks,
    this.correctOrNot,
  });

  String questionId;
  int obtainedMarks;
  String correctOrNot;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        questionId: json["question_id"],
        obtainedMarks: json["obtainedMarks"],
        correctOrNot: json["correctOrNot"],
      );

  Map<String, dynamic> toJson() => {
        "question_id": questionId,
        "obtainedMarks": obtainedMarks,
        "correctOrNot": correctOrNot,
      };
}

String parseHtmlString(String htmlString, {double fontSize = 20.0}) {
  final document = parse(htmlString);

  var svg = document.getElementsByTagName("svg");
  String parsedString = document.outerHtml;
  if (svg.isNotEmpty) {
    for (Element p in svg) {
      p.localName;
      var svgHeight = p.attributes["height"];
      var svgWidth = p.attributes["width"];
      var height = parseRawWidthHeight(svgHeight, fontSize);
      var width = parseRawWidthHeight(svgWidth, fontSize);
      var svgString =
      p.outerHtml.replaceFirst('height="$svgHeight"', 'height="$height"');
      svgString = svgString.replaceFirst('width="$svgWidth"', 'width="$width"');
      parsedString = parsedString.replaceFirst(p.outerHtml, svgString);
    }
  }
  return parsedString;
}
double parseRawWidthHeight(String raw, double fontSize) {
  if (raw == '100%' || raw == '') {
    return double.infinity;
  }
  assert(() {
    final RegExp notDigits = RegExp(r'[^\d\.]');
    if (!raw.endsWith('px') &&
        !raw.endsWith('em') &&
        !raw.endsWith('ex') &&
        raw.contains(notDigits)) {
      print(
          'Warning: Flutter SVG only supports the following formats for `width` and `height` on the SVG root:\n'
              '  width="100%"\n'
              '  width="100em"\n'
              '  width="100ex"\n'
              '  width="100px"\n'
              '  width="100" (where the number will be treated as pixels).\n'
              'The supplied value ($raw) will be discarded and treated as if it had not been specified.');
    }
    return true;
  }());
  return parseDoubleWithUnits(raw, fontSize, tryParse: true) ?? double.infinity;
}

double parseDoubleWithUnits(
    String rawDouble,
    double fontSize, {
      bool tryParse = false,
    }) {
  double unit = 1.0;

  // 1 rem unit is equal to the root font size.
  // 1 em unit is equal to the current font size.
  // 1 ex unit is equal to the current x-height.
  if (rawDouble.contains('rem') ?? false) {
    unit = fontSize;
  } else if (rawDouble.contains('em') ?? false) {
    unit = fontSize;
  } else if (rawDouble.contains('ex') ?? false) {
    unit = fontSize / 2;
  }

  final double value = parseDouble(
    rawDouble,
    tryParse: tryParse,
  );

  return value != null ? value * unit : null;
}

double parseDouble(String rawDouble, {bool tryParse = false}) {
  assert(tryParse != null); // ignore: unnecessary_null_comparison
  if (rawDouble == null) {
    return null;
  }

  rawDouble = rawDouble
      .replaceFirst('rem', '')
      .replaceFirst('em', '')
      .replaceFirst('ex', '')
      .replaceFirst('px', '')
      .trim();

  if (tryParse) {
    return double.tryParse(rawDouble);
  }
  return double.parse(rawDouble);
}
