import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:global_configuration/global_configuration.dart';
import '/model/user.dart';
import '/api/teachers-api-client.dart';
import '/bloc/teacher-school/teacher-school-states.dart';
import '/model/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignedActivitiesCubit extends Cubit<AssignToYouStates> {
  AssignedActivitiesCubit() : super(AssignedActivitiesLoading());
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();
  SharedPreferences sharedPreference;

  Future<void> getAssignedActivities(String status) async {
    emit(AssignActivityFilterLoading());
    String token = await storage.read(key: 'token');
    sharedPreference = await SharedPreferences.getInstance();
    String teacherId = sharedPreference.get('user-id');
    String teacherName = sharedPreference.get('user-name');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    Map<String, dynamic> body = {};
    if (status.toLowerCase() != 'evaluated')
      body.addAll({
        "assignTo_you": {
          "teacher_id": teacherId,
          "status": status,
        }
      });
    else {
      body.addAll({
        "status": status,
        "assignTo_you": {
          "teacher_id": teacherId,
        }
      });
    }
    final client = TeachersListApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    client
        .getAssignToYou(body)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-getting-assigned-activities : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            ActivityFeedResponse response =
                ActivityFeedResponse.fromJson(jsonDecode(value), teacherId);
            processActivities(response, teacherName, teacherId, true, status);
          }
        });
  }

  Future<void> loadMoreAssignedActivities(
      AssignedActivitiesLoaded state, String status, int page) async {
    emit(AssignActivityFilterLoading());
    String token = await storage.read(key: 'token');
    sharedPreference = await SharedPreferences.getInstance();
    String teacherId = sharedPreference.get('user-id');
    String teacherName = sharedPreference.get('user-name');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    Map<String, dynamic> body = {};
    body.addAll({
      "page": page,
      "limit": 5,
      "assignTo_you": {
        "teacher_id": teacherId,
        "status": status,
      }
    });
    log('Request-body: $body');
    final client = TeachersListApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    client
        .getAssignToYou(body)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-getting-assigned-activities : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            ActivityFeedResponse response =
                ActivityFeedResponse.fromJson(jsonDecode(value), teacherId);
            response.data.addAll(state.activities);
            processActivities(response, teacherName, teacherId,
                response.data.isNotEmpty, status);
          }
        });
  }

  processActivities(
      ActivityFeedResponse activityFeedResponse,
      String teacherName,
      String teacherId,
      bool hasMoreData,
      String status) async {
    List<Activity> allActivities = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> savedActivities =
        sharedPreferences.getStringList('saved-activities') ?? [];
    if (sharedPreferences.getStringList('saved-activities') == null) {
      sharedPreferences.setStringList('saved-activities', []);
    }
    for (final activity in activityFeedResponse.data) {
      activity.teacherName = teacherName;
      activity.timeLeft = activity.endDateTime.compareTo(DateTime.now()) <= 0
          ? 0
          : DateTime.parse(activity.dueDate).day - DateTime.now().day;
      // if (activity.timeLeft == 0) {
      //   activity.status = 'Evaluate';
      // }
      if (checkReactedActivity(activity, teacherId) &&
          activity.teacherProfile.id != teacherId &&
          activity.status.toLowerCase() != 'evaluated') {
        activity.userReacted = checkReactedActivity(activity, teacherId);
        activity.status = activity.assignToYou.firstWhere((element) {
          return element.teacherId == teacherId;
        }).status;
      } else if (activity.status.toLowerCase() == 'evaluated' &&
          'evaluated' != status.toLowerCase()) {
        continue;
      }

      if (activity.assignTo.isNotEmpty)
        activity.assigned = Assigned.student;
      else if (activity.assignToYou.isNotEmpty &&
          activity.teacherProfile.id != teacherId)
        activity.assigned = Assigned.teacher;
      else if (activity.assignToYou.isNotEmpty) {
        activity.assigned = Assigned.faculty;
      } else
        activity.assigned = Assigned.parent;
      // print(savedActivities.contains(activity.id));
      if (savedActivities.contains(activity.id)) {
        activity.saved = true;
      }
      if (activity.likeBy.contains(teacherId)) activity.liked = true;
      allActivities.add(activity);
    }
    emit(AssignedActivitiesLoaded(allActivities, hasMoreData));
  }

  bool checkReactedActivity(Activity activity, String teacherId) {
    switch (activity.activityType) {
      case 'Announcement':
        return activity.acknowledgeByTeacher
            .map((e) => e.acknowledgeByTeacher)
            .contains(teacherId);
      case 'Event':
        return (activity.goingByTeacher.contains(teacherId) ||
            activity.notGoingByTeacher.contains(teacherId));
      case 'LivePoll':
        for (var i in activity.selectedLivePoll) {
          if (i.selectedByTeacher == teacherId) {
            activity.selectedLivePollByTeacher = i;
            return true;
          }
        }
        return false;
      case 'Check List':
        for (var i in activity.selectedCheckList) {
          if (i.selectedByTeacher == teacherId) {
            activity.selectedCheckListByTeacher = i;
            return true;
          }
        }
        return false;
      default:
        return false;
    }
  }
}

class SchoolTeacherCubit extends Cubit<SchoolTeacherStates> {
  SchoolTeacherCubit() : super(SchoolTeacherLoading());
  SharedPreferences sharedPreferences;
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();

  Future<List<UserInfo>> getAllTeachers({int page,int limit}) async {
    TeacherListResponse response;
    String token = await storage.read(key: 'token');
    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.get('school-id');
    String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TeachersListApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .getAllTeachers(schoolId,page,limit)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-getting-all-teachers : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            print('');
             response =
                TeacherListResponse.fromJson(jsonDecode(value));
            response.teacherId = teacherId;
            response.data = response.data.where((element) {
              // if (element.schoolId.id == schoolId) print(element.name);
              return element.profileType.displayName != 'school Admin';
            }).toList();
            emit(
              SchoolTeacherLoaded(
                response.data,
                teacherId,
              ),
            );
          }
        });
    return response.data;
  }

  // Future getMoreTeachers(SchoolTeacherLoaded state, String page) async {
  //   String token = await storage.read(key: 'token');
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   String schoolId = sharedPreferences.get('school-id');
  //   String teacherId = sharedPreferences.get('user-id');
  //   dio.options.headers["Authorization"] = "Bearer "+token.toString();
  //   final client = TeachersListApiClient(
  //     dio,
  //     baseUrl: GlobalConfiguration().get('baseURL'),
  //   );
  //   await client
  //       .getMoreTeachers(schoolId, page)
  //       .catchError((error) {
  //         if (error is DioError) {
  //           print('Dio-error-message : ${error.response}');
  //         }
  //         print('Error-while-getting-all-teachers : $error');
  //       })
  //       .whenComplete(() {})
  //       .then((value) {
  //         if (value != null) {
  //           print(value);
  //           print('');
  //           TeacherListResponse response =
  //               TeacherListResponse.fromJson(jsonDecode(value));
  //           log('before-length: ${state.teachers.length}');
  //           response.teacherId = teacherId;
  //           List<UserInfo> list = state.teachers;
  //           list.addAll(response.data);
  //           log('after-length: ${list.length}');
  //           emit(
  //             SchoolTeacherLoaded(
  //               list,
  //               teacherId,
  //             ),
  //           );
  //         }
  //       });
  // }

  Future<UserInfo> getUser(String teacherId)async{
    UserInfo user;
    String token = await storage.read(key: 'token');
    sharedPreferences = await SharedPreferences.getInstance();
    // String schoolId = sharedPreferences.get('school-id');
    // String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TeachersListApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .getUser(teacherId)
        .catchError((error) {
      if (error is DioError) {
        print('Dio-error-message : ${error.response}');
      }
      print('Error-while-getting-all-teachers : $error');
    })
        .whenComplete(() {})
        .then((value) {
      if (value != null) {
        user = UserInfo.fromJson(jsonDecode(value)['data'][0]);
      }
    });
    return user;
  }

  void forwardAssignment(AssignTeacher assignTeacher) async {
    String token = await storage.read(key: 'token');
    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.get('school-id');
    // String teacherName = sharedPreferences.get('user-name');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TeachersListApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .forwardActivity(assignTeacher.activityId, assignTeacher.toJson())
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-forwarding-task : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }
}
