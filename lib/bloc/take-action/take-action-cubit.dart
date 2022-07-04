import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';
import '/api/take-action-api-client.dart';
import '/bloc/take-action/take-action-states.dart';
import '/model/activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class TakeActionCubit extends Cubit<TakeActionStates> {
  TakeActionCubit() : super(Loading());
  SharedPreferences sharedPreferences;
  FlutterSecureStorage storage;
  final dio = Dio();

  Future<void> updateAnnouncement(String activityId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TakeActionApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateAnnouncement(activityId, teacherId)
        .catchError((error) {
          if (error is DioError)
            print('dio-error-update-announcement : ${error.response}');
          print('error-while-updating-announcement: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-updating-announcement: $value');
          }
        });
  }

  void updateEventGoing(String activityId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TakeActionApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateEventGoing(activityId, teacherId)
        .catchError((error) {
          if (error is DioError)
            print('dio-error-update-event : ${error.response}');
          print('error-while-updating-event: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-updating-event: $value');
          }
        });
  }

  void updateEventNotGoing(String activityId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TakeActionApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateEventNotGoing(activityId, teacherId)
        .catchError((error) {
          if (error is DioError)
            print('dio-error-update-event : ${error.response}');
          print('error-while-updating-event: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-updating-event: $value');
          }
        });
  }

  void updateLivePoll(String activityId, SelectedOptions option) async {
    sharedPreferences = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    option.selectedBy = teacherId;
    final client = TakeActionApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateLivePoll(activityId, option.toJson())
        .catchError((error) {
          if (error is DioError)
            print('dio-error-update-event : ${error.response}');
          print('error-while-updating-event: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-updating-event: $value');
          }
        });
  }

  void updateCheckList(String activityId, SelectedOptions option) async {
    sharedPreferences = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    option.selectedBy = teacherId;
    final client = TakeActionApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateCheckList(activityId, option.toJson())
        .catchError((error) {
          if (error is DioError)
            print('dio-error-update-event : ${error.response}');
          print('error-while-updating-event: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-updating-event: $value');
          }
        });
  }

  initializeTakeAction(ReceivedSession session) {
    emit(TakeActionInitialized(session));
  }


}
