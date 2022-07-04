import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:growonplus_teacher/api/institute-api-client.dart';
import 'package:growonplus_teacher/bloc/Institute/institute-states.dart';
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../activity/activity-cubit.dart';

class InstituteCubit extends Cubit<InstituteStates> {
  InstituteCubit() : super(InstituteLoading());

  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();

  Future<void> getInstitute(String instituteId) async {
    log('true');
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getInstitute(instituteId)
        .catchError((error) {
          if (error is DioError) {
            log('DIO error');
            log('Error-while-loading-Institute: ${error.response}');
          }
          log(error.toString());
        })
        .whenComplete(() {})
        .then((value) {
          log(value.toString());
          if (value != null) {
            InstituteModel instituteModel =
                InstituteModel.fromJson(jsonDecode(value)['data']);
            if (instituteModel != null) {
              emit(InstituteLoaded(instituteModel));
            }
          }
        });
  }

  Future<void> postSession(Session session, List<PlatformFile> files) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    // String teacherName = prefs.getString('user-name');
    String userId = prefs.getString('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    List<String> paths = await ActivityCubit().uploadFile(files);
    session.files = [];
    session.files.addAll(paths);

    session.createdBy = userId;
    log(session.toJson().toString());
    final client =
        InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .postSession(session.toJson())
        .catchError((error) {
          if (error is DioError) {
            log('Error-while-loading-Institute: ${error.response}');
          }
          log(error.toString());
        })
        .whenComplete(() {})
        .then((value) {
          log(value.toString());
          // if (value != null) {
          //   InstituteModel instituteModel =
          //       InstituteModel.fromJson(jsonDecode(value)['data']);
          //   if (instituteModel != null) {
          //     emit(InstituteLoaded(instituteModel));
          //   }
          // }
        });
  }

  Future<void> updateSession(Session session, String id) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    // String teacherName = prefs.getString('user-name');
    String userId = prefs.getString('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    // List<String> paths = await ActivityCubit().uploadFile(files);
    session.files = [];
    // session.files.addAll(paths);

    session.createdBy = userId;
    log(session.toJson().toString());
    final client =
    InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .updateSession(session.toJson(),id)
        .catchError((error) {
      if (error is DioError) {
        log('Error-while-loading-Institute: ${error.response}');
      }
      log(error.toString());
    })
        .whenComplete(() {})
        .then((value) {
      log(value.toString());
      // if (value != null) {
      //   InstituteModel instituteModel =
      //       InstituteModel.fromJson(jsonDecode(value)['data']);
      //   if (instituteModel != null) {
      //     emit(InstituteLoaded(instituteModel));
      //   }
      // }
    });
  }
}

class SessionCubit extends Cubit<DisplaySessionStates> {
  SessionCubit() : super(SessionLoading());

  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();

  Future<List<ReceivedSession>> displaySessionForToday(
      {String schoolId, String instituteId}) async {
    // emit(SessionLoading());
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    String teacherId = prefs.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    DateTime date = DateTime.now().toUtc();
    Map<String, dynamic> body = {
      "institute_id": instituteId,
      "schools": schoolId,
      "session_start_Date":
          DateTime(date.year, date.month, date.day).toUtc().toString(),
    };
    List<ReceivedSession> instituteSession;
    final client =
        InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .displaySessionForToday(body)
        .catchError((error) {
          emit(SessionFailed());
          if (error is DioError) {
            log('DIO error');
            log('Error-while-loading-Institute: ${error.response}');
          }
          log(error.toString());
        })
        .whenComplete(() {})
        .then((value) {
          log('01 ' + value.toString());
          if (value != null) {
            instituteSession =
                List<ReceivedSession>.from(jsonDecode(value)["data"].map((e) {
              return ReceivedSession.fromJson(e);
            }));
            // log(instituteSession.toString());
            for (final session in instituteSession) {
              session.isTeacherJoined = session.teacherJoinSession
                  .where((element) => element.teacherId.id == teacherId)
                  .isNotEmpty;
            }

            emit(SessionLoaded(instituteSession));
          }
        });
    return instituteSession;
  }

  Future<List<ReceivedSession>> displaySessionForFuture(
      {
        String searchKey,
        String schoolId,
      String instituteId,
      int pageKey,
      int pageSize,
      String teacherId,
      bool isFuture,
      String isDaily,
      String isWeekly}) async {
    log(isDaily+' '+isWeekly);
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    var date = DateTime.now();
    Map<String, dynamic> body = {
      "institute_id": instituteId,
      "schools": schoolId,
      "session_start_Date":
          DateTime(date.year, date.month, date.day).toUtc().toString(),
      "page": pageKey,
      "limit": pageSize,
      "isDaily": isDaily,
      "does_session_repeat":isWeekly,
    };
    if (searchKey != null && searchKey.isNotEmpty) {
      body["searchValue"] = searchKey;
      body["filterKeysArray"] = ["subject_name"];
    }
    if(isDaily.toLowerCase() != 'yes'){
      body.removeWhere((key, value) => key == 'isDaily');
    }
    if(isWeekly.toLowerCase() != 'yes'){
      body.removeWhere((key, value) => key == 'does_session_repeat');
    }
    if(!isFuture)
      {
        body.removeWhere((key, value) => key=='session_start_Date');
      }
    final client =
        InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    return await client
        .displaySessionForFuture(body,isFuture)
        .catchError((error) {
          if (error is DioError) {
            log('DIO error');
            log('Error-while-loading-Institute: ${error.response}');
          }
          log(error.toString());
        })
        .whenComplete(() {})
        .then((value) {
          // log('01 ' + value.toString());
          if (value != null) {
            var instituteSession =
                List<ReceivedSession>.from(jsonDecode(value)["data"].map((e) {
              return ReceivedSession.fromJson(e);
            }));
            // log(instituteSession.toString());
            for (final session in instituteSession) {
              session.isTeacherJoined = session.teacherJoinSession
                  .where((element) => element.teacherId.id == teacherId)
                  .isNotEmpty;
            }

            return instituteSession;
          }
          throw Exception();
        });
  }

  Future<String> joinSessionForTeacher(
      ReceivedSession session, String schoolId) async {

    prefs = await SharedPreferences.getInstance();
    String teacherId = prefs.getString('user-id');
    // String schoolId = prefs.getString('user-id');
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    Map<String, dynamic> data = {
      'teacher_join_session': [
        {
          'teacher_id': teacherId,
          'school_id': schoolId,
        }
      ]
    };
    final client =
        InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    String status = '';

    await client
        .joinSessionForTeacher(data, session.id)
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
          if (value != null) {
            status = 'success';
            session.isTeacherJoined = true;
          }
        });
    return status;
  }

  Future<String> deleteSession(String sessionId)
  async {
    log('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    emit(SessionLoading());
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    var val;
    final client =
    InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .deleteSession(sessionId)
        .catchError((error) {
      emit(SessionFailed());
      if (error is DioError) {
        log('DIO error');
        log('Error-while-loading-Institute: ${error.response}');
      }
      log(error.toString());
      return 'Something Went Wrong!!! Please Try again after sometime';
    })
        .whenComplete(() {})
        .then((value) {
      if (value != null) {
        val = json.decode(value)['message'];
       return value;
      }
    });
    return val;
  }
}
