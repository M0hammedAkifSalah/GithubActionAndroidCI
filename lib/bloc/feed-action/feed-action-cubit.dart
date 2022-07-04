// import 'dart:convert';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:global_configuration/global_configuration.dart';
// import ' /api/activity-api-client.dart';
// import ' /bloc/feed-action/feed-action-states.dart';
// import ' /model/activity.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import '/api/feed-api-client.dart';
import '/bloc/feed-action/feed-action-states.dart';
import '/model/activity.dart';
import '/model/feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class ThreadPostCubit extends Cubit<FeedActionStates> {
  ThreadPostCubit() : super(PostingThreadState());
  SharedPreferences sharedPreferences;
  final dio = Dio();
  final storage = FlutterSecureStorage();

  void postThread(ThreadComments comment, String activityId) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String teacherId = preferences.getString('user-id');
    comment.teacherId.id = teacherId;
    comment.userId = teacherId;
    final client =
        FeedApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .createThread(comment.toJson(), activityId)
        .catchError((error) {
          if (error is DioError) print('Dio-error-while-posting: $error');
          print('error-while-posting : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }
}

class FeedBackCubit extends Cubit<FeedBackStates> {
  FeedBackCubit() : super(FeedBacksLoading());
  SharedPreferences sharedPreferences;
  final dio = Dio();
  final storage = FlutterSecureStorage();
  Future postFeedback(FeedBackStudent feedback) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.get('user-id');
    feedback.teacherIdString = teacherId;
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        FeedApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .postFeedbacks(feedback.toJson())
        .catchError((error) {
          if (error is DioError)
            print('Dio-error-while-posting-feedback: $error');
          print('error-while-posting-feedback : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }

  void getFeedback(String studentId) async {
    emit(FeedBacksLoading());
    sharedPreferences = await SharedPreferences.getInstance();
    // String classId = sharedPreferences.get('class-id');
    // String schoolId = sharedPreferences.get('school-id');
    // feedback.repository = [Repository(classId: classId,schoolId: schoolId)];
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        FeedApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getFeedbacks(studentId)
        .catchError((error) {
          if (error is DioError)
            print('Dio-error-while-getting-feedback: $error');
          print('error-while-getting-feedback : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            // print(value);
            List<FeedBackStudent> feedbackList = List<FeedBackStudent>.from(
              jsonDecode(value)['data'].map((e) => FeedBackStudent.fromJson(e)),
            );
            emit(FeedBacksLoaded(feedbackList));
          }
        });
  }
}
// class FeedActionCubit extends Cubit<FeedActionStates> {
//   FeedActionCubit() : super(FeedActionLoading());
//   SharedPreferences sharedPreferences;
//   final dio = Dio();
//   final storage =  FlutterSecureStorage();

//   // updateFeedPanelContent(String type, Activity activity) async {
//   //   emit(FeedActionLoading());
//   //   String token = await storage.read(key: "token");
//   //   dio.options.headers["token"] = token;

//   //   final client =
//   //       ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
//   //   await client
//   //       .getAnActivity(activity.id)
//   //       .catchError((error) {
//   //         print("get-an-activity-error: $error");
//   //         if (error is DioError) {
//   //           DioError err = error;
//   //           print("get-an-activity-error-message: ${err.response}");
//   //         }
//   //       })
//   //       .whenComplete(() {})
//   //       .then((value) {
//   //         if (value != null) {
//   //           print("get-an-activity-response: $value");
//   //           SingleActivity singleActivity = singleActivityFromJson(value);
//   //           dispatchStateChanges(type, singleActivity.activity);
//   //         }
//   //         return value;
//   //       });
//   // }

//   submitEventGoing(String activityId) async {
//     sharedPreferences = await SharedPreferences.getInstance();

//     String userId = sharedPreferences.getString("user-id");
//     String token = await storage.read(key: "token");
//     dio.options.headers["token"] = token;

//     final client =
//         ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
//     await client
//         .submitEventGoing({})
//         .catchError((error) {
//           print("submit-event-going-error: $error");
//           if (error is DioError) {
//             DioError err = error;
//             print("submit-event-going-error-message: ${err.response}");
//           }
//         })
//         .whenComplete(() {})
//         .then((value) {
//           if (value != null) {
//             print("submit-event-going-response: $value");
//           }
//           return value;
//         });
//   }

//   submitEventNotGoing(String activityId) async {
//     sharedPreferences = await SharedPreferences.getInstance();

//     String userId = sharedPreferences.getString("user-id");
//     String token = await storage.read(key: "token");
//     dio.options.headers["token"] = token;

//     final client =
//         ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
//     await client
//         .submitEventGoing({})
//         .catchError((error) {
//           print("submit-event-not-going-error: $error");
//           if (error is DioError) {
//             DioError err = error;
//             print("submit-event-not-going-error-message: ${err.response}");
//           }
//         })
//         .whenComplete(() {})
//         .then((value) {
//           if (value != null) {
//             print("submit-event-not-going-response: $value");
//           }
//           return value;
//         });
//   }

//   submitCheckList(String activityId, List<String> options) async {
//     sharedPreferences = await SharedPreferences.getInstance();

//     String userId = sharedPreferences.getString("user-id");
//     String token = await storage.read(key: "token");
//     dio.options.headers["token"] = token;

//     final client =
//         ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
//     await client
//         .submitChecklist({})
//         .catchError((error) {
//           print("submit-checklist-error: $error");
//           if (error is DioError) {
//             DioError err = error;
//             print("submit-checklist-error-message: ${err.response}");
//           }
//         })
//         .whenComplete(() {})
//         .then((value) {
//           if (value != null) {
//             print("submit-checklist-response: $value");
//           }
//           return value;
//         });
//   }

//   submitLivePoll(String activityId, List<String> options) async {
//     sharedPreferences = await SharedPreferences.getInstance();

//     String userId = sharedPreferences.getString("user-id");
//     String token = await storage.read(key: "token");
//     dio.options.headers["token"] = token;

//     final client =
//         ActivityApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
//     await client
//         .submitLivePool({})
//         .catchError((error) {
//           print("submit-assignment-error: $error");
//           if (error is DioError) {
//             DioError err = error;
//             print("submit-assignment-error-message: ${err.response}");
//           }
//         })
//         .whenComplete(() {})
//         .then((value) {
//           if (value != null) {
//             print("submit-assignment-response: $value");
//           }
//           return value;
//         });
//   }

//   dispatchStateChanges(String type, Activity activity) async {
//     sharedPreferences = await SharedPreferences.getInstance();

//     String userId = sharedPreferences.getString("user-id");

//     if (activity.activityType == "LivePoll") {
//       for (final selectedOption in activity.selectedOptions) {
//         if (selectedOption.selectedBy == userId) {
//           activity.userReacted = true;
//           activity.livePollSelection = selectedOption.options[0];
//           break;
//         }
//       }
//       if (activity.userReacted == null) activity.userReacted = false;
//     }

//     if (activity.activityType == "Check List") {
//       for (final selectedOption in activity.selectedOptions) {
//         if (selectedOption.selectedBy == userId) {
//           activity.userReacted = true;
//           for (final selectedOption in selectedOption.options) {
//             for (final option in activity.options)
//               if (option.text == selectedOption) {
//                 option.checked = "YES";
//               }
//           }
//           break;
//         }
//       }
//       if (activity.userReacted == null) activity.userReacted = false;
//     }

//     if (activity.activityType == "Event") {
//       if (activity.going.contains(userId)) {
//         activity.userReacted = true;
//         activity.eventAction = "going";
//       } else if (activity.notGoing.contains(userId)) {
//         activity.userReacted = true;
//         activity.eventAction = "not-going";
//       }
//       if (activity.userReacted == null) activity.userReacted = false;
//     }
//     switch (type) {
//       case "Announcement":
//         emit(LoadAnnouncementFeed(activity));
//         break;
//       case "Assignment":
//         emit(LoadAssignmentFeed(activity));
//         break;
//       case "Event":
//         emit(LoadEventFeed(activity));
//         break;
//       case "CheckList":
//         emit(LoadCheckListFeed(activity));
//         break;
//       case "LivePoll":
//         emit(LoadLivePollFeed(activity));
//         break;
//     }
//   }
// }
