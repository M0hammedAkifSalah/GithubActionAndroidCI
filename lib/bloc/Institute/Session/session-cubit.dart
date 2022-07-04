
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:growonplus_teacher/bloc/Institute/Session/session-states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../../../api/institute-api-client.dart';
import '../../../model/session-report.dart';
import '../../../model/user.dart';

class SessionReportCubit extends Cubit<SessionReportStates>{
  SessionReportCubit() : super(SessionReportLoading());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();

  Future<void> getSchoolSessionReport(String instituteId) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    var val;
    final client = InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getSessionSchools(instituteId)
        .catchError((error) {
      emit(SessionReportFailed());
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
        val =  List<SessionSchoolReport>.from(jsonDecode(value)['data'].map((e)=>SessionSchoolReport.fromJson(e)));
       emit(SessionReportLoaded(val));
      }
    });
  }


 }

class SessionReportStudentCubit extends Cubit<SessionReportStudentStates>{
  SessionReportStudentCubit() : super(SessionReportLoadingStudent());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();


  Future<List<SessionReportStudent>> getSessionReportStudents({String schoolId,int page,int limit,bool isStudent}) async {
    log(isStudent.toString());
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    List<SessionReportStudent> val;
    final client = InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getSessionTeachers(schoolId,page,limit,isStudent)
        .catchError((error) {

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
        val = List<SessionReportStudent>.from(jsonDecode(value)['data'].map((e)=>SessionReportStudent.fromJson(e)));

        emit(SessionReportLoadedStudent(val));

      }
    });
    return val;
  }
  Future<void> getMoreSessionReportStudents({SessionReportLoadedStudent state,String schoolId,int page,int limit,bool isStudent}) async {
    log(isStudent.toString());
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    List<SessionReportStudent> val;
    final client = InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getSessionTeachers(schoolId,page,limit,isStudent)
        .catchError((error) {

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
        val = List<SessionReportStudent>.from(jsonDecode(value)['data'].map((e)=>SessionReportStudent.fromJson(e)));
        state.studentsReport.addAll(val);
        emit(SessionReportLoadedStudent(state.studentsReport,hasMore: val.isNotEmpty));

      }
    });
  }


}

class SessionReportTeacherCubit extends Cubit<SessionReportTeacherStates>{
  SessionReportTeacherCubit() : super(SessionReportLoadingTeacher());
  FlutterSecureStorage storage;
  SharedPreferences prefs;
  Dio dio = Dio();




  Future<List<SessionReportStudent>> getSessionReportTeachers({String schoolId,int page,int limit,bool isStudent}) async {

    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    List<SessionReportStudent> val;
    final client = InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getSessionTeachers(schoolId,page,limit,isStudent)
        .catchError((error) {

      if (error is DioError) {
        log('DIO error');
        log('Error-while-loading-Institute: ${error.response}');
      }
      log(error.toString());
      return 'Something Went Wrong!!! Please Try again after sometime';
    })
        .whenComplete(() {})
        .then((value) {
          // log(value.toString());
      if (value != null) {
        val = List<SessionReportStudent>.from(jsonDecode(value)['data'].map((e)=>SessionReportStudent.fromJson(e)));

        emit(SessionReportLoadedTeacher(val));

      }
    });
    return val;
  }

  Future<void> getMoreSessionReportTeachers({SessionReportLoadedTeacher state,String schoolId,int page,int limit,bool isStudent}) async {

    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    List<SessionReportStudent> val;
    final client = InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getSessionTeachers(schoolId,page,limit,isStudent)
        .catchError((error) {
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
        val = List<SessionReportStudent>.from(jsonDecode(value)['data'].map((e)=>SessionReportStudent.fromJson(e)));
        state.teacherReport.addAll(val);
        emit(SessionReportLoadedTeacher(state.teacherReport,hasMore: val.isNotEmpty));
      }
    });
  }

  Future<List<StudentInfo>> getStudentDetailes({String studentId}) async {
    prefs = await SharedPreferences.getInstance();
    storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    List<StudentInfo> studentInfo;
    final client = InstituteApiClient(dio, baseUrl: GlobalConfiguration().get('baseURL'));
    await client
        .getStudentInfo(studentId)
        .catchError((error) {
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
        studentInfo = List<StudentInfo>.from(jsonDecode(value)['data'].map((e)=>StudentInfo.fromJson(e)));
      }
    });
    return studentInfo;
  }




}