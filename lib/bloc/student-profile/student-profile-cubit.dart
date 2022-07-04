import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';

// import ' /bloc/feed-action/feed-action-cubit.dart';
import 'package:dio/dio.dart';
import '/bloc/student-profile/student-profile-states.dart';
import '/api/student-profile-api-client.dart';
import '/model/activity.dart';
import '/model/test-model.dart';
import '/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentProfileCubit extends Cubit<StudentProfileStates> {
  StudentProfileCubit() : super(StudentProfileLoading());
  SharedPreferences sharedPreferences;
  final dio = Dio();
  final storage = FlutterSecureStorage();

  // List<StudentInfo> assignedStudents = [];
  // List<AssignTo> get assigned {
  //   return List<AssignTo>.from(
  //     assignedStudents.map(
  //       (student) => AssignTo(
  //         branch: student.branchId,
  //         classId: student.userInfoClass,
  //         schoolId: student.schoolId,
  //         studentId: student.id,
  //       ),
  //     ),
  //   );
  // }

  // addStudent(StudentInfo student) {
  //   assignedStudents.add(student);
  //   emit(StudentProfileLoaded(this.studentInfo, assignedStudents: assigned));
  // }

  // removeStudent(StudentInfo student) {
  //   assignedStudents.remove(student);
  //   emit(StudentProfileLoaded(this.studentInfo, assignedStudents: assigned));
  // }

  Future<List<StudentInfo>> loadStudentProfile(
      {String classId, String sectionId,int page,int limit,String searchText}) async {
    Students students;
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    sharedPreferences = await SharedPreferences.getInstance();

    String schoolId = sharedPreferences.getString("school-id");

    final client = StudentProfileApiClient(
      dio,
      baseUrl: GlobalConfiguration().get("baseURL"),
    );
    await client
        .getStudentProfile(schoolId, classId, sectionId,page,limit,searchText)
        .catchError((error) {
          print("get-student-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("get-student-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then(
          (value) {
            if (value != null) {

              students = Students.fromJson(jsonDecode(value));
            }
            emit(StudentProfileLoaded(students.students));


          },
        );
    return students.students;
  }

  // Future<void> loadMoreStudents(StudentProfileLoaded state, int page,
  //     {String searchText = "", String classId, String sectionId}) async {
  //   String token = await storage.read(key: "token");
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //
  //   sharedPreferences = await SharedPreferences.getInstance();
  //
  //   String schoolId = sharedPreferences.getString("school-id");
  //   print('Student-profile-cubit: school-id == $schoolId');
  //
  //   final client = StudentProfileApiClient(
  //     dio,
  //     baseUrl: GlobalConfiguration().get("baseURL"),
  //   );
  //   await client
  //       .loadMoreStudentProfile(
  //           schoolId, searchText, classId, sectionId, page.toString())
  //       .catchError((error) {
  //         print("get-student-error: $error");
  //         if (error is DioError) {
  //           DioError err = error;
  //           print("get-student-error-message: ${err.response}");
  //         }
  //       })
  //       .whenComplete(() {})
  //       .then(
  //         (value) {
  //           if (value != null) {
  //             print("load-more-student-response: $value");
  //             var student = Students.fromJson(json.decode(value));
  //             studentInfo.students.addAll(student.students);
  //             emit(StudentProfileLoaded(studentInfo,
  //                 hasMoreData: student.students.isNotEmpty));
  //           }
  //           return value;
  //         },
  //       );
  // }
}

class GroupCubit extends Cubit<GroupStates> {
  GroupCubit() : super(StudentGroupsLoading());
  final dio = Dio();
  final storage = FlutterSecureStorage();
  SharedPreferences preferences;

  Future loadGroups() async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    preferences = await SharedPreferences.getInstance();
    String schoolId = preferences.getString('school-id');
    String userId = preferences.getString('user-id');
    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .getGroups({
          "school_id": schoolId,
        })
        .catchError((error) {
          if (error is DioError) {
            print("error-while-loading-groups: ${error.response}");
          }
          print('error-while-loading-groups: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            Groups group = Groups.fromJson(jsonDecode(value)["data"]);
            // print(group.group[0].groupPersons[0].name);
            emit(StudentGroupsLoaded(group));
          }
        });
  }

  Future<void> createGroup({List<String> students,List<String> users,String groupName}) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    preferences = await SharedPreferences.getInstance();
    String schoolId = preferences.getString('school-id');
    String userId = preferences.getString('user-id');
    Map<String,dynamic> data ={
      'students':students,
      'users':users,
      'group_name':groupName,
      'school_id':schoolId,
      'teacher_id':userId
    };

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .createGroup(data)
        .catchError((error) {
          print('error-while-creating-group: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-creating-group: $value');
          }
        });
  }

  rewardStudents(Reward body, {bool innovation = false}) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .rewardStudent(body.toJson(innovation: innovation))
        .catchError((error) {
          if (error is DioError) print('dio-error-reward : ${error.response}');
          print('error-while-rewarding: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-rewarding-student: $value');
          }
        });
  }
}

class RewardStudentCubit extends Cubit<RewardStudentStates> {
  RewardStudentCubit() : super(RewardStudentLoading());
  final dio = Dio();
  final storage = FlutterSecureStorage();

  loadRewardStudent(String studentId) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .totalRewardStudent(studentId)
        .catchError((error) {
          print('error-while-loading-reward: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            // print('response-loading-groups: $value');
            List<TotalRewardDetails> rewardsStudent =
                List<TotalRewardDetails>.from(
              jsonDecode(value)['data'].map(
                (e) => TotalRewardDetails.fromJson(e),
              ),
            );
            // print(group.group[0].groupPersons[0].name);
            emit(RewardStudentLoaded(rewardsStudent));
          }
        });
  }

  // createGroup(SingleGroup group) async {
  //   String token = await storage.read(key: "token");
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //
  //   final client = StudentProfileApiClient(dio,
  //       baseUrl: GlobalConfiguration().get("baseURL"));
  //
  //   await client
  //       .createGroup(group.toJson())
  //       .catchError((error) {
  //         print('error-while-creating-group: $error');
  //       })
  //       .whenComplete(() {})
  //       .then((value) {
  //         if (value != null) {
  //           print('response-creating-group: $value');
  //         }
  //       });
  // }

  Future<SingleGroup> updateGroup(
      String groupId, Map<String, dynamic> data) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.getString('school-id');
    String teacherId = sharedPreferences.getString('user-id');
    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));

    return await client
        .updateGroup(data, groupId)
        .catchError((error) {
          if (error is DioError) {
            print('error-while-updating-group: ${error.response}');
          }
          print('error-while-updating-group: $error');
          return null;
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-updating-group: $value');
            return SingleGroup.fromJson(jsonDecode(value)['data']);
          }
          return null;
        });
  }

  Future deleteGroup(String groupId) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .deleteGroup(groupId)
        .catchError((error) {
          if (error is DioError) {
            print('error-while-deleting-group: ${error.response}');
          }
          print('error-while-deleting-group: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-deleting-group: $value');
          }
        });
  }

  Future addStudentGroup(String groupId,String studentId) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .addStudentGroup(groupId,studentId)
        .catchError((error) {
          if (error is DioError) {
            print('error-while-deleting-group: ${error.response}');
          }
          print('error-while-deleting-group: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-deleting-group: $value');
          }
        });
  }

  Future removeStudentGroup(String groupId, String studentId) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .removeStudentGroup(groupId, studentId)
        .catchError((error) {
          if (error is DioError) {
            print('error-while-deleting-group: ${error.response}');
          }
          print('error-while-deleting-group: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-deleting-group: $value');
          }
        });
  }

  rewardStudents(Reward body, {bool innovation = false}) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .rewardStudent(body.toJson(innovation: innovation))
        .catchError((error) {
          print('error-while-rewarding: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-rewarding-student: $value');
          }
        });
  }

  rewardTestStudents(TestDetailsModel body) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = StudentProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .rewardStudent(body.toJson())
        .catchError((error) {
          if (error is DioError) {
            print('error-while-rewarding: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-rewarding-student: $value');
          }
        });
  }
}
