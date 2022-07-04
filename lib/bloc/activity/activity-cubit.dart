import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:open_file/open_file.dart' as open;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/api/activity-api-client.dart';
import '/bloc/activity/activity-states.dart';
import '/model/activity.dart';
import '/model/create_task.dart';
import '/model/task-progress.dart';
import '/model/user.dart' as user;

class ActivityCubit extends Cubit<ActivityStates> {
  ActivityCubit() : super(ActivityLoading());
  SharedPreferences sharedPreferences;
  final dio = Dio();
  final storage = FlutterSecureStorage();

  Future<void> openFile(String fileName, {bool openFile = true}) async {
    // String path = await ExtStorage.getExternalStorageDirectory();
    String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    print('downloading: $path');
    await Permission.storage.request();
    Permission.storage.isGranted.then((value) async {
      if (value) {
        Response response =
            await dio.download(fileName, path + '/${fileName.split('/').last}');

        print(response.data);
        if (openFile) {
          open.OpenFile.open(path + '/${fileName.split('/').last}');
        }
      }
    });
  }

  Future<bool> downloadFile(
      {String fileUrl,
      String filename,
      CancelToken cancelToken,
      Function(int, int) onReceiveProgress,
      Function(dynamic) onError}) async {
    print("downloading files");

    final dio = Dio();
    String path = '';
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          try {
            path = await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);
          } on PlatformException {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
      return await dio
          .download(
            fileUrl,
            path + "/$filename",
            deleteOnError: true,
            onReceiveProgress: onReceiveProgress,
            cancelToken: cancelToken,
          )
          .catchError((error) {
            print("download-file-error: $error");
            if (error is DioError) {
              DioError err = error;
              print("download-file-error-message: ${err.error}");
            }
            onError(error);
          })
          .whenComplete(() {})
          .then((_) {
            showNotification(filename, "$path/$filename");
            return true;
          });
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> showNotification(String fileName, String filePath) async {
    var _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'download', // id
      'Download', //title
      description: 'Download files',
      // description
      importance: Importance.max,
    );
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidNotificationDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      icon: '@drawable/growonlogo',
      playSound: true,
      largeIcon: DrawableResourceAndroidBitmap("growonlogo"),
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
      channelShowBadge: true,
      onlyAlertOnce: true,
    );
    var notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      math.Random().nextInt(1000),
      "Downloaded",
      fileName,
      notificationDetails,
      payload: "download==,==$filePath",
    );
  }

  List<AssignTo> assigned(List<user.StudentInfo> assignedStudents) {
    return List<AssignTo>.from(
      assignedStudents.map(
        (student) => AssignTo(
          branch: student.branchId,
          sectionId: student.section,
          classId: student.userInfoClass,
          schoolId: student.schoolId,
          studentId: student,
        ),
      ),
    );
  }

  Future<void> likeActivity(String activityId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .likeActivity(teacherId, activityId)
        .catchError((error) {
          print("like-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("like-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
          return value;
        });
  }

  Future<void> disLikeActivity(String activityId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .disLikeActivity(teacherId, activityId)
        .catchError((error) {
          print("dislike-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("dislike-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
          return value;
        });
  }

  Future<void> viewActivity(String activityId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .viewActivity(teacherId, activityId)
        .catchError((error) {
          print("view-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("view-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
          return value;
        });
  }

  Future<void> loadActivities(String source, Map<String, dynamic> body,
      {int limit}) async {
    emit(ActivityFilterLoading());
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    dio.options.headers["Connection"] = "keep-alive";
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString("user-id");
    String teacherName = sharedPreferences.get('user-name');
    ArgumentError.checkNotNull('teacher id', teacherId);
    Map<String, dynamic> data = {
      "teacher_id": teacherId,
    };
    data.addAll(body);
    log(dio.options.headers.toString());
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .getActivities(data)
        .catchError((error) {
          print("get-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("get-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            processActivities(activityFeedResponseFromJson(value, teacherId),
                teacherId, true);
          }
          return value;
        });
  }

  Future<void> loadAdminActivities(String source, Map<String, dynamic> body,
      {int limit}) async {
    emit(ActivityFilterLoading());
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.getString("school-id");
    String teacherId = sharedPreferences.getString("user-id");
    // String teacherName = sharedPreferences.get('user-name');
    ArgumentError.checkNotNull('teacher id', schoolId);
    Map<String, dynamic> data = {
      "repository.id": schoolId,
      "page": 1,
      "limit": 5,
    };
    data.addAll(body);
    print(GlobalConfiguration().get('baseURL'));
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .getActivities(data)
        .catchError((error) {
          print("get-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("get-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            processActivities(
                activityFeedResponseFromJson(value, teacherId), teacherId, true,
                forAdmin: true);
          }
          return value;
        });
  }

  Future<void> loadMoreActivities(
      ActivityLoaded state, Map<String, dynamic> body, int page) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString("user-id");
    String schoolId = sharedPreferences.getString("school-id");
    // String teacherName = sharedPreferences.get('user-name');
    ArgumentError.checkNotNull('teacher id', teacherId);
    Map<String, dynamic> data = {
      "repository.id": schoolId,
      "page": page,
      "limit": 5
    };
    data.addAll(body);
    log("Request-body-activity: $data");
    print(GlobalConfiguration().get('baseURL'));

    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .getActivities(data)
        .catchError((error) {
          print("get-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("get-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            var feed = activityFeedResponseFromJson(value, teacherId);
            log("Got-data: ${state.allActivities}");
            state.allActivities.addAll(feed.data);
            log("Got-data: ${state.allActivities.length}");
            processActivities(ActivityFeedResponse(data: state.allActivities),
                teacherId, feed.data.isNotEmpty,
                forAdmin: true);
          }
          return value;
        });
  }

  Future<void> reassignAssignment(String studentId, String activityId,
      String comment, List<PlatformFile> files) async {
    // emit(ActivityLoading());
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    // String teacherId = sharedPreferences.getString("user-id");
    // String teacherName = sharedPreferences.get('user-name');
    // Map<String, dynamic> data = {"teacher_id": teacherId};
    // List<String> _files = await uploadFile(files);
    List<String> _files = await uploadBytes(files);

    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .reassignAssignment(studentId, activityId, comment, _files)
        .catchError((error) {
          print("reassign-assignment-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("reassign-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            // processActivities(activityFeedResponseFromJson(value), teacherName);
          }
          return value;
        });
  }

  Future<void> submitEvaluated(String studentId, String activityId,
      String comment, List<PlatformFile> files) async {
    // emit(ActivityLoading());
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    List<String> _files = await uploadBytes(files);

    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .submitEvaluated(studentId, activityId, comment, _files)
        .catchError((error) {
          print("submitEvaluated-assignment-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("submitEvaluated-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
      log('assignment submitEvaluated $value');
          if (value != null) {
            print(value);
            // processActivities(activityFeedResponseFromJson(value), teacherName);
          }
          return value;
        });
  }

  Future<void> submitOfflineAssignment(
      List<Map<String, dynamic>> studentIds, String activityId) async {
    // emit(ActivityLoading());
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();

    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .submitOfflineAssignment(studentIds, activityId)
        .catchError((error) {
          print("submitOfflineAssignment-assignment-error: $error");
          if (error is DioError) {
            DioError err = error;
            print(
                "submitOfflineAssignment-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            // processActivities(activityFeedResponseFromJson(value), teacherName);
          }
          return value;
        });
  }

  Future<void> updateAssignmentStatus(String activityId) async {
    // emit(ActivityLoading());
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    // String teacherId = sharedPreferences.getString("user-id");
    // String teacherName = sharedPreferences.get('user-name');
    // Map<String, dynamic> data = {"teacher_id": teacherId};

    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .updateAssignmentStatus(activityId)
        .catchError((error) {
          print("update-status-assignment-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("update-status-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
      log('assignment updateAssignmentStatus $value');
          if (value != null) {
            print(value);
            // processActivities(activityFeedResponseFromJson(value), teacherName);
          }
          return value;
        });
  }

  Future<void> updateActivityStatus(String activityId) async {
    // emit(ActivityLoading());
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    // String teacherId = sharedPreferences.getString("user-id");
    // String teacherName = sharedPreferences.get('user-name');
    // Map<String, dynamic> data = {"teacher_id": teacherId};

    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .updateActivityStatus(activityId)
        .catchError((error) {
          print("update-status-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("update-status-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            // processActivities(activityFeedResponseFromJson(value), teacherName);
          }
          return value;
        });
  }

  processActivities(
      ActivityFeedResponse activityFeedResponse, String teacherId, bool hasMore,
      {bool forAdmin = false}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    List<Activity> allActivities = [];
    List<String> savedActivities =
        sharedPreferences.getStringList('saved-activities') ?? [];
    if (sharedPreferences.getStringList('saved-activities') == null) {
      sharedPreferences.setStringList('saved-activities', []);
    }
    for (final activity in activityFeedResponse.data) {
      // if (activity != null) {
      if (activity.likeBy.contains(teacherId)) {
        activity.liked = true;
      }
      activity.editable = activity.teacherProfile.id == teacherId;
      // print(activity.endDateTime.toIso8601String());
      // if (activity.activityType == 'Announcement') {
      //   print(activity.endDateTime.compareTo(DateTime.now()));
      //   print(activity.description);
      // }
      // print(activity.description);
      activity.teacherName = activity.teacherProfile.name;
      activity.timeLeft =
          activity.endDateTime.compareTo(DateTime.now()) <= 0 ? 0 : 1;
      if (activity.timeLeft == 0 &&
          !['evaluate', 'evaluated'].contains(activity.status.toLowerCase())) {
        updateActivityStatus(activity.id);
      }
      // print('${savedActivities.contains(activity.id)} inside load activity');
      if (savedActivities.contains(activity.id)) {
        activity.saved = true;
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

      // if (activity.timeLeft == 0 || checkActivityCompletion(activity)) {
      //   if (activity.status != 'Evaluated' &&
      //       activity.assigned != Assigned.teacher) activity.status = 'Evaluate';
      // }
      if (activity.activityType == 'Assignment') {
        if (activity.activityReward.length != activity.assignTo.length &&
            activity.status.toLowerCase() == 'evaluated') {
          activity.status = 'Evaluate';
          activity.partiallyEvaluated = true;
        }
        if (activity.activityReward.length - 1 == activity.assignTo.length) {
          activity.updateAssignmentStatus = true;
        }
        // } else if (activity.timeLeft == 0 ||
        //     checkActivityCompletion(activity)) {
        //   activity.status = 'Evaluate';
        // } else {
        //   activity.status = 'Pending';
        // }

        for (var i in activity.activityReward) {
          activity.assignTo.forEach((element) {

            if (element.studentId.id == i.studentId) {
              element.coins = i.coin + i.extraCoin;
              element.status = i.status ?? 'Evaluated';
            }
          });
          activity.submitedBy.forEach((element) {
            if (element.studentId == i.studentId) {
              element.coins = i.coin + i.extraCoin;
            }
          });
        }
      }
      if (activity.forwarded) {
        activity.status = 'Forwarded';
      }
      activity.assignTo.sort((comp1, comp2) {
        if (comp1.status == 'Evaluated') {
          return -1;
        }
        return (comp1.status == 'Submitted') ? 0 : 1;
      });

      allActivities.add(activity);
      // allActivities.sort((comp1, comp2) {
      //   if (comp1.partiallyEvaluated) return -1;
      //   return 1;
      // });
    }
    // allActivities.sort((act1, act2) {
    //   if (act1.status.toLowerCase() == 'pending')
    //     return -1;
    //   else if (act1.status.toLowerCase() == 'evaluated') return 1;
    //   return 0;
    // });

    if (forAdmin) {
      emit(
        AdminActivityLoaded(
          allActivities: allActivities,
          hasMoreData: hasMore,
        ),
      );
    } else {
      emit(
        ActivityLoaded(
          allActivities: allActivities,
          hasMoreData: hasMore,
        ),
      );
    }
  }

  bool checkActivityCompletion(Activity activity) {
    switch (activity.activityType) {
      case 'Assignment':
        return (activity.assignTo.length == activity.submitedBy.length);
      case 'LivePoll':
        if (activity.assigned == Assigned.student)
          return (activity.assignTo.length == activity.selectedLivePoll.length);
        else if (activity.assigned == Assigned.parent)
          return (activity.assignToParent.length ==
              activity.selectedLivePoll.length);
        else if (activity.assigned == Assigned.faculty)
          return (activity.assignToYou.length ==
              activity.selectedLivePoll.length);
        return false;

      case 'Check List':
        if (activity.assigned == Assigned.student)
          return (activity.assignTo.length ==
              activity.selectedCheckList.length);
        else if (activity.assigned == Assigned.parent)
          return (activity.assignToParent.length ==
              activity.selectedCheckList.length);
        else if (activity.assigned == Assigned.faculty)
          return (activity.assignToYou.length ==
              activity.selectedCheckList.length);
        return false;

      case 'Announcement':
        if (activity.assigned == Assigned.student)
          return (activity.assignTo.length == activity.acknowledgeBy.length);
        else if (activity.assigned == Assigned.parent)
          return (activity.assignToParent.length ==
              activity.acknowledgeByParent.length);
        else if (activity.assigned == Assigned.faculty)
          return (activity.assignToYou.length ==
              activity.acknowledgeByTeacher.length);
        return false;
      case 'Event':
        if (activity.assigned == Assigned.student)
          return (activity.assignTo.length ==
              (activity.going.length + activity.notGoing.length));
        else if (activity.assigned == Assigned.faculty)
          return (activity.assignToYou.length ==
              (activity.goingByTeacher.length +
                  activity.notGoingByTeacher.length));
        else if (activity.assigned == Assigned.parent)
          return (activity.assignToParent.length ==
              (activity.goingByParent.length +
                  activity.notGoingByParent.length));
        return false;

      //   break;
      default:
        return false;
    }
  }

  createAssignment({
    AssignmentTask assignmentTask,
    File image,
    List<PlatformFile> attachments,
    List<user.StudentInfo> students,
    List<AssignToParent> parents,
    List<String> teacher,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherName = sharedPreferences.get('user-name');
    String teacherId = sharedPreferences.get('user-id');
    String schoolId = sharedPreferences.get('school-id');
    assignmentTask.teacherId = teacherId;
    assignmentTask.createdBy = teacherName;
    assignmentTask.updateBy = teacherName;
    assignmentTask.teachers = teacher;
    assignmentTask.parents = parents;
    assignmentTask.repository = [];
    assignmentTask.assignTo = assigned(students);
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    assignmentTask.files = await uploadFile(attachments);
    assignmentTask.repository = [
      Repository(
        id: schoolId,
        repositoryType: 'School',
      )
    ];
    emit(TaskUploading());
    log('createAssignment ' + assignmentTask.toJson().toString());
    await client
        .addAssignment(assignmentTask.toJson())
        .catchError((error) {
          print('error-adding-assignment: $error');
          if (error is DioError) print('dio-error: ${error.response}');
        })
        .whenComplete(() {})
        .then((value) {
          log(value.toString());
          if (value != null) {
            print('assignment-uploaded: ${jsonDecode(value)}');
            emit(TaskUploaded());
          }
        });
  }

  createAnnouncement({
    AnnouncementTask assignmentTask,
    // File image,
    List<PlatformFile> attachments,
    List<user.StudentInfo> students,
    List<String> teacher,
    List<AssignToParent> parents,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherName = sharedPreferences.get('user-name');
    String teacherId = sharedPreferences.get('user-id');
    String schoolId = sharedPreferences.get('school-id');
    assignmentTask.createdBy = teacherName;
    assignmentTask.updateBy = teacherName;
    assignmentTask.teacherId = teacherId;
    assignmentTask.teachers = teacher;
    assignmentTask.assignTo = assigned(students);
    assignmentTask.parents = parents;
    assignmentTask.repository = [
      Repository(
        id: schoolId,
        repositoryType: 'School',
      )
    ];
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    assignmentTask.files = await uploadFile(attachments);
    log('announcement task : ' + assignmentTask.toJson().toString());
    emit(TaskUploading());
    await client
        .addAcknowledgement(assignmentTask.toJson())
        .catchError((error) {
          if (error is DioError) print('dio-error: ${error.response}');
        })
        .whenComplete(() {})
        .then((value) {
          log('announcement return value ' + value.toString());
          if (value != null) {
            emit(TaskUploaded());
          }
        });
  }

  createLivePoll({
    LivePollTask assignmentTask,
    // File image,
    List<PlatformFile> attachments,
    List<user.StudentInfo> students,
    List<String> teacher,
    List<AssignToParent> parents,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherName = sharedPreferences.get('user-name');
    String teacherId = sharedPreferences.get('user-id');
    String schoolId = sharedPreferences.get('school-id');
    assignmentTask.createdBy = teacherName;
    assignmentTask.updateBy = teacherName;
    assignmentTask.assignTo = assigned(students);
    assignmentTask.teacherId = teacherId;
    assignmentTask.teachers = teacher;
    assignmentTask.parents = parents;
    assignmentTask.repository = [
      Repository(
        id: schoolId,
        repositoryType: 'School',
      )
    ];
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    emit(TaskUploading());
    await client
        .addLivePool(assignmentTask.toJson())
        .catchError((error) {
          print('error-adding-livePoll: $error');
          if (error is DioError) print('dio-error: ${error.response}');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('livePoll-uploaded: ${jsonDecode(value)}');
            emit(TaskUploaded());
          }
        });
  }

  createCheckList({
    CheckListTask assignmentTask,
    // File image,
    List<PlatformFile> attachments,
    List<user.StudentInfo> students,
    List<String> teacher,
    List<AssignToParent> parents,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherName = sharedPreferences.get('user-name');
    String teacherId = sharedPreferences.get('user-id');
    String schoolId = sharedPreferences.get('school-id');
    assignmentTask.teacherId = teacherId;
    assignmentTask.createdBy = teacherName;
    assignmentTask.updateBy = teacherName;
    assignmentTask.assignTo = assigned(students);
    assignmentTask.teachers = teacher;
    assignmentTask.parents = parents;
    // assignmentTask.image = (await uploadFile([image]))[0];
    assignmentTask.repository = [
      Repository(
        id: schoolId,
        repositoryType: 'School',
      )
    ];
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    emit(TaskUploading());
    await client
        .addCheckList(assignmentTask.toJson())
        .catchError((error) {
          print('error-adding-checklist: $error');
          if (error is DioError) print('dio-error: ${error.response}');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('checklist-uploaded: ${jsonDecode(value)}');
            emit(TaskUploaded());
          }
        });
  }

  createEvent({
    EventTask assignmentTask,
    // File image,
    List<PlatformFile> attachments,
    List<user.StudentInfo> students,
    List<String> teacher,
    List<AssignToParent> parents,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherName = sharedPreferences.get('user-name');
    String teacherId = sharedPreferences.get('user-id');
    String schoolId = sharedPreferences.get('school-id');
    assignmentTask.teacherId = teacherId;
    assignmentTask.createdBy = teacherName;
    assignmentTask.updateBy = teacherName;
    assignmentTask.assignTo = assigned(students);
    assignmentTask.teachers = teacher;
    assignmentTask.parents = parents;
    // assignmentTask.acknowledgedBy = [assigned(students)[0].studentId];
    assignmentTask.repository = [
      Repository(
        id: schoolId,
        repositoryType: 'School',
      )
    ];
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    emit(TaskUploading());
    await client
        .addEvent(assignmentTask.toJson())
        .catchError((error) {
          print('error-adding-event: $error');
          if (error is DioError) print('dio-error: ${error.response}');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('event-uploaded: ${jsonDecode(value)}');
            emit(TaskUploaded());
          }
        });
  }

  void saveActivity(String activityId, {bool remove = false}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getStringList('saved-activities') == null) {
      sharedPreferences.setStringList('saved-activities', []);
    }
    List<String> savedActivities =
        sharedPreferences.getStringList('saved-activities');
    if (!remove) {
      savedActivities.add(activityId);
    } else {
      savedActivities.remove(activityId);
    }
    sharedPreferences.setStringList('saved-activities', savedActivities);
    print(sharedPreferences.getStringList('saved-activities'));
  }

  Future<List<String>> uploadFile(List<PlatformFile> files) async {
    emit(TaskUploading());
    String token = await storage.read(key: "token");
    if (files == null) return [null];
    log('UPLOADING FILEs $files');
    List<String> _file = [];
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));

    for (var file in files) {
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
    }

    return _file;
  }

  Future<List<String>> uploadBytes(List<PlatformFile> files) async {
    emit(TaskUploading());
    String token = await storage.read(key: "token");
    List<String> _file = [];
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));

    for (var file in files) {
      await client
          .uploadBytes(file.bytes, file.name)
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
    }

    return _file;
  }

  Future<bool> updateProfile(PlatformFile file) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    String token = await storage.read(key: 'token');
    // log("TOKEN FOR UPLOAD PROFILE  " + token);
    String fileName = (await uploadFile([file]))[0];
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    String fileUrl = GlobalConfiguration().get('fileURL');
    final client = ActivityApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    client
        .updateProfile(teacherId, '$fileName')
        .catchError((e) {
          print('error-while-updating-profile: $e');
          if (e is DioError) print('response = ${e.response}');
        })
        .whenComplete(() {})
        .then(
          (value) {
            if (value != null) {
              return true;
              print('file-updated: ${jsonDecode(value)}');
            }
          },
        );
    return false;
  }

  Future<void> deleteActivity(String activityId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .deleteActivity(activityId)
        .catchError((error) {
          print("delete-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("delete-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
          return value;
        });
  }

  Future<void> deleteBookmark(String activityId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .deleteActivity(activityId)
        .catchError((error) {
          print("delete-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("delete-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            emit(TaskDeleted());
          }
          return value;
        });
  }

  Future<TotalActivityProgress> userTotalProgress(
    String userId, {
    bool student = false,
    bool teacher = false,
    bool classes = false,
  }) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    String schoolId;

    schoolId = sharedPreferences.get('school-id');

    Map<String, String> forClass = {"assignTo.class_id": userId};
    Map<String, String> forStudent = {"assignTo.student_id": userId};
    Map<String, String> forTeacher = {"assignTo_you.teacher_id": userId};
    Map<String, String> data;
    TotalActivityProgress progress = TotalActivityProgress();
    if (student) {
      data = forStudent;
    } else if (teacher) {
      data = forTeacher;
    } else if (classes) {
      data = forClass;
    }

    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getTotalProgress(data, schoolId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          var data = jsonDecode(value);
          progress = TotalActivityProgress(
              status: data['status'],
              activity: data['actvivity'],
              average: data['avgData'] ?? 0.0,
              pendingData: data['pending']);
          // progress = TotalActivityProgress.fromJson(jsonDecode(value));
          // print(progress);

          // print('Total-progress-value-null: $value');
        });
    return progress ?? TotalActivityProgress();
  }

  Future<AttendanceDetails> joinedClassProgress(String studentId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    AttendanceDetails progress = AttendanceDetails();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getJoinedClassProgress(studentId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            var data = jsonDecode(value)['attendance_details'];
            progress = AttendanceDetails.fromJson(data);

            return progress;
          }
        });
    return progress;
  }

  //test average in progress
  Future<ActivityProgress> testProgress(String studentId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    log("test progress token " + token);
    Map<String, dynamic> data = {};
    data = TestAvgProgress(assignToStudentId: studentId).toJson();
    ActivityProgress progress = ActivityProgress();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getTestProgress(data)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            progress = ActivityProgress.fromJson(jsonDecode(value)['Test']);
            return progress;
          }
        });
    return progress;
  }

  Future<ActivityProgress> announcementProgress(
    String userId, {
    String extra = '',
  }) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    ActivityProgress progress = ActivityProgress();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .activityProgress('Announcement$extra', userId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('Announcement');
            var data = jsonDecode(value)['Announcement'];
            // print('${data['completed']} ' + key);
            // progress = ActivityProgress(
            //   completed: data['completed'],
            //   average: data['average'],
            //   pending: data['total'] - data['completed'],
            //   total: data['total'],
            // );
            progress = ActivityProgress.fromJson(data);

            return progress;
          }
        });
    return progress;
  }

  Future<ActivityProgress> assignmentProgress(
    String userId,
  ) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    ActivityProgress progress = ActivityProgress();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .activityProgress('assignment', userId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('Assignment');
            var data = jsonDecode(value)['Assignment'];
            // print('${data['completed']} ' + key);
            // progress = ActivityProgress(
            //   completed: data['completed'],
            //   average: data['average'],
            //   pending: data['total'] - data['completed'],
            //   total: data['total'],
            // );
            progress = ActivityProgress.fromJson(data);

            return progress;
          }
        });
    return progress;
  }

  Future<ActivityProgress> checkListActivityProgress(
    String userId, {
    String extra = '',
  }) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    ActivityProgress progress = ActivityProgress();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .activityProgress('checkListStats$extra', userId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response} CheckList");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            var data = jsonDecode(value)['CheckList'];
            print('checkList');
            print(data);
            // print('${data['completed']} ' + key);
            // progress = ActivityProgress(
            //   completed: data['completed'],
            //   average: data['average'],
            //   pending: data['total'] - data['completed'],
            //   total: data['total'],
            // );
            progress = ActivityProgress.fromJson(data);

            return progress;
          }
        });
    return progress;
  }

  Future<ActivityProgress> livePollActivityProgress(
    String userId, {
    String extra = '',
  }) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    ActivityProgress progress = ActivityProgress();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .activityProgress('livepool$extra', userId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response} livepool");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            var data = jsonDecode(value)['livepool'];
            progress = ActivityProgress.fromJson(data);

            return progress;
          }
        });
    return progress;
  }

  Future<ActivityProgress> eventActivityProgress(
    String userId, {
    String extra = '',
  }) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    ActivityProgress progress = ActivityProgress();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .activityProgress('Event$extra', userId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response} Event");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            var data = jsonDecode(value)['Event'];
            print('Event');
            print(data);
            // print('${data['completed']} ' + key);
            // progress = ActivityProgress(
            //   completed: data['completed'],
            //   average: data['average'],
            //   pending: data['total'] - data['completed'],
            //   total: data['total'],
            // );
            progress = ActivityProgress.fromJson(data);

            return progress;
          }
        });
    return progress;
  }

  Future<ActivityProgress> lateSubmissionProgress(
    String userId, {
    String extra = '',
  }) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    ActivityProgress progress = ActivityProgress();
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .lateSubmissionProgress(userId)
        .catchError((error) {
          print("progress-activity-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-activity-error-message: ${err.response} Event");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            var data = jsonDecode(value);
            progress = ActivityProgress.fromJson(data);

            return progress;
          }
        });
    return progress;
  }
}

class SectionProgressCubit extends Cubit<SectionProgressStates> {
  SectionProgressCubit() : super(SectionProgressLoading());
  Dio dio = Dio();
  SharedPreferences sharedPreferences;
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<SectionProgress>> sectionProgress() async {
    List<SectionProgress> progress = [];
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer " + token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    String schoolId = sharedPreferences.getString('school-id');
    final client =
        ActivityApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .sectionProgress(schoolId)
        .catchError((error) {
          print("progress-section-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("progress-section-error-message: ${err.response} Event");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            // print('${data['completed']} ' + key);
            // progress = ActivityProgress(
            //   completed: data['completed'],
            //   average: data['average'],
            //   pending: data['total'] - data['completed'],
            //   total: data['total'],
            // );
            progress = List<SectionProgress>.from(
              jsonDecode(value)['data'].map((e) {
                log('section-progress: $e');
                return SectionProgress.fromJson(e);
              }),
            );
            log('Section progress loaded ${progress.length}');
            emit(SectionProgressLoaded(progress));
          }
        });
    return progress;
  }
}
