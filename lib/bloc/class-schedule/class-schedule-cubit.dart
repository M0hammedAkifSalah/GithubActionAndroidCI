import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/export.dart';
import '../../model/class-schedule.dart';

class ClassDetailsCubit extends Cubit<ClassDetailsState> {
  ClassDetailsCubit() : super(ClassDetailsLoading());

  SharedPreferences sharedPreferences;
  final storage = FlutterSecureStorage();
  final dio = Dio();

  Future<void> loadClassDetails({bool removeCheck = true}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.getString('school-id');
    String token = await storage.read(key: "token");
    List<String> classes = sharedPreferences.getStringList('classes');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getClassDetails(schoolId)
        .catchError((error) {
          print('error-while-loading-classes: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {

          if (value != null) {
            SchoolDetailsResponse response =
                SchoolDetailsResponse.fromJson(jsonDecode(value));
            List<SchoolClassDetails> classDetails =
                response.data[0].classDetails;
            // if (!removeCheck) {
            var mapped = classDetails.where((element) {
              if (classes.isEmpty) return true;
              return classes.contains(element.classId);
            }).toList();

            // classDetails.removeWhere((element) {
            //   if (mapped.map((e) => e.classId).contains(element.classId))
            //     return true;
            //   return false;
            // });

            if (classes.isEmpty) classDetails = mapped;

            // }
            emit(
              ClassDetailsLoaded(classDetails, mapped),
            );
          }
        });
  }
}

class SubjectDetailsCubit extends Cubit<SubjectDetails> {
  SubjectDetailsCubit() : super(SubjectDetailsLoading());

  SharedPreferences sharedPreferences;
  final storage = FlutterSecureStorage();
  final dio = Dio();

  Future<void> loadAssignmentSubjectDetails() async {
    print('getting subjects');
    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.getString('school-id');
    ArgumentError.checkNotNull(schoolId, 'class-id');
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    print('getting subjects');
    await client
        .getAssignmentSubjectDetails(schoolId)
        .catchError((error) {
          print('error-while-loading-subjects: $error');
          if (error is DioError) {
            print('dio-error: $error');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            SubjectDetailsResponse response =
                SubjectDetailsResponse.fromJson(jsonDecode(value));
            emit(SubjectDetailsLoaded(response.data));
          }
        });
  }
}

class ScheduleClassCubit extends Cubit<ClassScheduleStates> {
  ScheduleClassCubit() : super(ClassScheduleLoading());
  SharedPreferences sharedPreferences;
  final storage = FlutterSecureStorage();
  final dio = Dio();

  createClass(ScheduledClassTask classSchedule,
      {List<StudentInfo> assignedStudents,
      List<String> teacher,
      List<PlatformFile> files,
      List<String> assignedTeachers}) async {
    if (classSchedule.files == null) {
      classSchedule.files = [];
    }
    log('inside cubit ${classSchedule.files}');
    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.getString('school-id');
    String teacherId = sharedPreferences.getString('user-id');
    String teacherName = sharedPreferences.getString('user-name');
    String token = await storage.read(key: "token");
    List<String> paths = await ActivityCubit().uploadFile(files);
    classSchedule.files.addAll(paths);
    classSchedule.repository = [
      Repository(
        schoolId: schoolId,
        classId: assignedStudents.isNotEmpty
            ? assignedStudents[0].userInfoClass
            : '',
      ),
    ];
    classSchedule.createdAt = DateTime.now();
    classSchedule.updatedAt = DateTime.now();
    classSchedule.teacherId = teacherId;
    classSchedule.createdBy = teacherName;
    // if (assignedStudents != null) {
    classSchedule.assignTo = assignedStudents.map((e) {
      return AssignTo(
        branch: e.branchId,
        classId: e.userInfoClass,
        sectionId: e.section,
        schoolId: schoolId,
        studentId: e,
      );
    }).toList();

    classSchedule.assignTo_you = teacher.map((e) {
      return AssignToYou(teacherId: e);
    }).toList();

    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    log('Schedule Class Request Body ' + classSchedule.toJson().toString());
    await client
        .createScheduleClass(classSchedule.toJson())
        .catchError((error) {
          print('error-while-creating-classes: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            if (kDebugMode) {
              print(value);
            }
          }
        });
  }

  Future<void> joinClassForTeacher({String scheduleClassId}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    Map<String, dynamic> data = {'teacher_join_class': teacherId};
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));

    client
        .joinClassForTeacher(data, scheduleClassId)
        .catchError((error) {
          if (kDebugMode) {
            print('error-while-creating-classes: $error');
          }
          if (error is DioError) {
            if (kDebugMode) {
              print('dio-error: ${error.response}');
            }
          }
        })
        .whenComplete(() {})
        .then((value) {
          log(value.toString());
          if (value != null) {}
        });
  }

  Future<void> updateClass(ScheduleClassUpdate classSchedule, String id,
      {List<File> files}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = await storage.read(key: "token");
    List<String> paths = await ActivityCubit().uploadFile(files ?? []);
    classSchedule.files.addAll(paths);
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    log(classSchedule.toJson().toString());
    client
        .updateClass(classSchedule.toJson(), id)
        .catchError((error) {
          if (kDebugMode) {
            print('error-while-creating-classes: $error');
          }
          if (error is DioError) {
            if (kDebugMode) {
              print('dio-error: ${error.response}');
            }
          }
        })
        .whenComplete(() {})
        .then((value) {
          log(value.toString());
          if (value != null) {}
        });
  }

  Future getAllClass(String date, BuildContext context) async {
    log("Get-all-class : called");
    emit(ClassScheduleLoading());
    sharedPreferences = await SharedPreferences.getInstance();
    String token = await storage.read(key: "token");
    String name = sharedPreferences.getString('user-name');
    String teacherId = sharedPreferences.getString('user-id');
    String profileType = sharedPreferences.getString('profile_type');
    String schoolId = sharedPreferences.getString('school-id');
    bool check = profileType.toLowerCase() == 'teacher';
    log('check: $check');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    Map<String, dynamic> data = {
      "class_start_Date": date,
      "repository.school_id": schoolId,
      "page": 1,
      "limit": 5,
    };
    if (check) {
      data.addAll({
        "teacher_id": "$teacherId",
      });
    }
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getScheduleClass(data)
        .catchError((error) {
          print('error-while-getting-classes: $error');
          if (error is DioError) {
            log('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            List<ScheduledClassTask> classesToday =
                List<ScheduledClassTask>.from(
              jsonDecode(value)['data']
                  .map((e) => ScheduledClassTask.fromJson(e)),
            );

            processClass(classesToday, teacherId, date, check, hasMore: true);
          }
        });
  }

  Future getMoreClass(String date, int page, ClassScheduleLoaded state) async {
    log("Get-more-class : called");
    sharedPreferences = await SharedPreferences.getInstance();
    String token = await storage.read(key: "token");
    String name = sharedPreferences.getString('user-name');
    String teacherId = sharedPreferences.getString('user-id');
    String profileType = sharedPreferences.getString('profile_type');
    String schoolId = sharedPreferences.getString('school-id');
    bool check = profileType.toLowerCase() == 'teacher';
    log('check: $check');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    Map<String, dynamic> data = {
      "repository.school_id": schoolId,
      "class_start_Date": date,
      "page": page,
      "limit": 4,
    };
    if (check) {
      data.addAll({
        "teacher_id": "$teacherId",
      });
    }
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getScheduleClass(data)
        .catchError((error) {
          print('error-while-getting-classes: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            List<ScheduledClassTask> classesToday =
                List<ScheduledClassTask>.from(
              jsonDecode(value)['data']
                  .map((e) => ScheduledClassTask.fromJson(e)),
            );
            List<ScheduledClassTask> list2 = [];
            log('response-length: ${classesToday.length}');
            log('state-length: ${state.allClassSchedules.length}');
            classesToday.forEach((element) {
              if (!list2.map((e) => e.id).contains(element.id)) {
                log('Adding');
                list2.add(element);
              }
            });
            state.allClassSchedules.addAll(list2);
            processClass(state.allClassSchedules, teacherId, date, check,
                hasMore: classesToday.isNotEmpty);
          }
        });
  }

  Future deleteClass(String classId, Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .deleteClass(classId, data)
        .catchError((error) {
          print('error-while-deleting-classes: $error');
          if (error is DioError) {
            print('dio-error: $error');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print("Response-delete-class: " + value);
          }
        });
  }

  Future deleteClassLinked(String linkedId, String date) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .deleteClassLinked({
          "linked_id": linkedId,
          "fromDate": date,
        })
        .catchError((error) {
          print('error-while-deleting-classes: $error');
          if (error is DioError) {
            print('dio-error: $error');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print("Response-delete-class-linked: " + value);
          }
        });
  }

  void processClass(List<ScheduledClassTask> classes, String teacherId,
      String date, bool check,
      {bool hasMore = true}) {
    List<ScheduledClassTask> extras = [];
    // for (var cls in classes) {
    //   if (cls.startDate.length > 1) {
    //     for (int i = 1; i < cls.startDate.length; i++) {
    //       ScheduledClassTask _class = ScheduledClassTask(
    //         activityType: cls.activityType,
    //         assignTo: cls.assignTo,
    //         chapterName: cls.chapterName,
    //         classRepeat: cls.classRepeat,
    //         createdAt: cls.createdAt,
    //         createdBy: cls.createdBy,
    //         description: cls.description,
    //         endDate: cls.endDate,
    //         endTime: cls.endTime,
    //         files: cls.files,
    //         id: cls.id,
    //         meetingLink: cls.meetingLink,
    //         onGoing: cls.onGoing,
    //         publishedWith: cls.publishedWith,
    //         repository: cls.repository,
    //         startDate: cls.startDate,
    //         startTime: cls.startTime,
    //         studentJoin: cls.studentJoin,
    //         subjectName: cls.subjectName,
    //         teacherId: cls.teacherId,
    //         teacherName: cls.teacherName,
    //         updatedAt: cls.updatedAt,
    //       );
    //       _class.startTime = DateTime(
    //         cls.startDate[i].year,
    //         cls.startDate[i].month,
    //         cls.startDate[i].day,
    //         cls.startTime.hour,
    //         cls.startTime.minute,
    //       );
    //       extras.add(_class);
    //     }
    //   }
    // }
    // classes.addAll(extras);
    for (var cls in classes) {
      var _now = DateTime.now();
      cls.editable = cls.teacherId == teacherId;
      var _classDay = cls.startTime;
      if (_classDay.day == _now.day &&
          _classDay.month == _now.month &&
          _classDay.year == _now.year) {
        // print(cls.endTime);
        if (cls.endTime != null) if (DateTime.now().compareTo(cls.endTime) !=
            1) {
          cls.onGoing = true;
        }
      }
    }
    emit(
      ClassScheduleLoaded(
        allClassSchedules: classes,
        teacherId: teacherId,
        hasMore: hasMore,
        dateSpecificClassSchedules: [],
      ),
    );
  }
}

class ScheduleClassIdCubit extends Cubit<ClassScheduleIdStates> {
  ScheduleClassIdCubit() : super(ClassScheduleIdLoading());
  SharedPreferences sharedPreferences;
  final storage = FlutterSecureStorage();
  final dio = Dio();

  Future getAllClassId() async {
    log("Get-all-class-id : called");
    sharedPreferences = await SharedPreferences.getInstance();
    log("Get-all-class-id : called 1");
    String token = await storage.read(key: "token");
    log("Get-all-class-id : called 2");
    String teacherId = sharedPreferences.getString('user-id');
    String profileType = sharedPreferences.getString('profile_type');
    String schoolId = sharedPreferences.getString('school-id');
    bool check = profileType.toLowerCase() == 'teacher';
    log('check: $check');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    Map<String, dynamic> data = {
      "repository.school_id": schoolId,
    };
    if (check) {
      data.addAll({
        "teacher_id": "$teacherId",
      });
    }
    final client =
        SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getScheduleClassLimit(data)
        .catchError((error) {
          print('error-while-getting-classes: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            List<ScheduledClassTask> classes = List<ScheduledClassTask>.from(
              jsonDecode(value)['data']
                  .map((e) => ScheduledClassTask.fromJson(e)),
            );

            emit(ClassScheduleIdLoaded(allClassSchedules: classes));
          }
        });
  }
}
// https://us05web.zoom.us/j/84187279910?pwd=VVpVRmF6NmVWZERYdnJNZk1SNDczQT09
// class ChapterDetailsCubit extends Cubit<ChapterDetailsStates> {
//   ChapterDetailsCubit() : super(ChapterDetailsLoading());
//   SharedPreferences sharedPreferences;
//   final storage =  FlutterSecureStorage();
//   final dio = Dio();

//   loadChapters(String subjectId) async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     String classId = sharedPreferences.getString('class-id');
//     String token = await storage.read(key: "token");
//     dio.options.headers["Authorization"] = "Bearer "+token.toString();
//     final client =
//         SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
//     await client
//         .getChapterDetails({
//           "class_id": classId,
//           "subject_id": subjectId,
//         })
//         .catchError((error) {
//           print('error-while-loading-chapters: $error');
//           if (error is DioError) {
//             print('dio-error: $error');
//           }
//         })
//         .whenComplete(() {})
//         .then((value) {
//           if (value != null) {
//             print(value);
//             List<Chapters> chapters = List<Chapters>.from(
//               jsonDecode(value)['data'].map((e) => Chapters.fromJson(e)),
//             );
//             emit(ChapterDetailsLoaded(chapters));
//           }
//         });
//   }
// }

// class TopicDetailsCubit extends Cubit<TopicDetailsStates> {
//   TopicDetailsCubit() : super(TopicDetailsLoading());
//   SharedPreferences sharedPreferences;
//   final storage =  FlutterSecureStorage();
//   final dio = Dio();

//   loadChapters(String subjectId, String chapterId) async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     String classId = sharedPreferences.getString('class-id');
//     String token = await storage.read(key: "token");
//     dio.options.headers["Authorization"] = "Bearer "+token.toString();
//     final client =
//         SchoolDetailsClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
//     await client
//         .getTopicDetails({
//           "class_id": classId,
//           "subject_id": subjectId,
//           "chapter_id": chapterId,
//         })
//         .catchError((error) {
//           print('error-while-loading-topics: $error');
//           if (error is DioError) {
//             print('dio-error: $error');
//           }
//         })
//         .whenComplete(() {})
//         .then((value) {
//           if (value != null) {
//             print(value);
//             List<Topics> chapters = List<Topics>.from(
//               jsonDecode(value)['data'].map((e) => Topics.fromJson(e)),
//             );
//             emit(TopicDetailsLoaded(chapters));
//           }
//         });
//   }
// }
