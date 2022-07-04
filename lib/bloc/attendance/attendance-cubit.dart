import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/attendance-api-client.dart';
import '../../model/attendance.dart';
import 'attendance-state.dart';
SharedPreferences prefs;
final storage = FlutterSecureStorage();
final dio = Dio();
class AttendanceCubit extends Cubit<AttendanceStates> {
  AttendanceCubit() : super(AttendanceLoading());


  // Future<void> getAttendance(DateTime selectedDate) async {
  //   prefs = await SharedPreferences.getInstance();
  //   String schoolId = prefs.getString('school-id');
  //   String teacherId = prefs.getString('user-id');
  //   final client =
  //       AttendanceApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
  //   await client
  //       .getAttendanceByDate({
  //         "date": selectedDate.toIso8601String(),
  //         "teacher_id": "teacherid",
  //         "class_id": "classid",
  //         "school_id": "schoolid"
  //       })
  //       .catchError((error) {
  //         print("get-attendance-error: $error");
  //         if (error is DioError) {
  //           DioError err = error;
  //           print("get-attendance-error-message: ${err.response}");
  //           emit(AttendanceNotLoaded());
  //         }
  //       })
  //       .whenComplete(() {})
  //       .then((value) async {
  //         if (value != null) {
  //           print("attendance-response: $value");
  //           AttendanceResponse attendanceResponse =
  //               attendanceResponseFromJson(value);
  //           emit(AttendanceLoaded(
  //               selectedDate: selectedDate,
  //               attendanceItems: attendanceResponse.data));
  //         }
  //         return value;
  //       });
  // }

  Future<void> createAttendance(AttendanceModel attendanceModel) async {
    prefs = await SharedPreferences.getInstance();
    String schoolId = prefs.getString('school-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    String teacherId = prefs.getString('user-id');
    attendanceModel.schoolId = schoolId;
    attendanceModel.attendanceTakenByTeacher = teacherId;
    attendanceModel.classTeacher = teacherId;
    final client =
        AttendanceApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .createAttendance(attendanceModel.toJson())
        .catchError((error) {
          print("get-attendance-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("get-attendance-error-message: ${err.response}");
            //emit(AttendanceNotLoaded());
          }
        })
        .whenComplete(() {})
        .then((value) async {
          log('attendance $value');
          if (value != null) {}
          return value;
        });
  }

  Future<void> getAttendanceByDate(AttendanceByDate attendanceByDate) async {
    emit(AttendanceLoading());
    prefs = await SharedPreferences.getInstance();
    String schoolId = prefs.getString('school-id');
    String teacherId = prefs.getString('user-id');
    attendanceByDate.schoolId = schoolId;
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    attendanceByDate.classTeacher = teacherId;
    attendanceByDate.date = DateTime(attendanceByDate.date.year,
        attendanceByDate.date.month, attendanceByDate.date.day);
    log(attendanceByDate.toJson().toString());
    log('55555555555555555555555555');
    final client =
        AttendanceApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .getAttendanceByDate(attendanceByDate.toJson())
        .catchError((error) {
          print("get-attendance-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("get-attendance-error-message: ${err.response}");
            emit(AttendanceNotLoaded());
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            var responseData = jsonDecode(value);
            List<GetByDateAttendanceResponse> response =
                List<GetByDateAttendanceResponse>.from(responseData["data"]
                    .map((x) => GetByDateAttendanceResponse.fromJson(x)));
           response.forEach((element) {
             element.attendanceDetails.removeWhere((att) => att.studentId == null);
           });
            emit(AttendanceLoaded(getByDateAttendanceResponse: response));
          }
          return value;
        });
  }

  Future<void> editAttendance(AttendanceModel attendanceModel,String attendanceId) async {
    prefs = await SharedPreferences.getInstance();

    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    List list =attendanceModel.attendanceDetails != null ? attendanceModel.attendanceDetails.map((e) => e.toJson()).toList() : null;
    // list.forEach((element) {
    //   log(element.toString());
    // });
    var body = {
      '_id':attendanceId,
      "attendanceDetails":list
    };
    final client =
    AttendanceApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .editAttendance(body)
        .catchError((error) {
      print("get-attendance-error: $error");
      if (error is DioError) {
        DioError err = error;
        print("get-attendance-error-message: ${err.response}");
        //emit(AttendanceNotLoaded());
      }
    })
        .whenComplete(() {})
        .then((value) async {
      log('attendance $value');
      if (value != null) {}
      return value;
    });
  }
}

class AttendanceReportCubit extends Cubit<AttendanceReport>{
  AttendanceReportCubit():super(AttendanceReportLoading());

  Future<List<AttendanceReportBySchoolModel>> getAttendanceReportBySchool({DateTime startDate,DateTime endDate,bool month}) async {
    emit(AttendanceReportLoading());
    List<AttendanceReportBySchoolModel> list = [];
    prefs = await SharedPreferences.getInstance();
    String schoolId = prefs.getString('school-id');
    // String teacherId = prefs.getString('user-id');
    Map<String,dynamic> data ={
      "school_id":schoolId,
      "start_date":DateTime(startDate.year,startDate.month,month ? 1 : startDate.day).toUtc().toString(),
      "end_date":DateTime(endDate.year,endDate.month,endDate.day).toUtc().toString()
    };
    data.removeWhere((key, value) => value == null);
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
    AttendanceApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .reportBySchool(data)
        .catchError((error) {
      print("get-attendance-error: $error");
      if (error is DioError) {
        DioError err = error;
        print("get-attendance-error-message: ${err.response}");
        log(error.stackTrace.toString());
        emit(AttendanceReportNotLoaded());
      }
    })
        .whenComplete(() {})
        .then((value) {
      if (value != null) {
        var responseData = jsonDecode(value);
        list = List<AttendanceReportBySchoolModel>.from(responseData['data'].map((e)=>AttendanceReportBySchoolModel.fromJson(e)));
        emit(AttendanceReportLoaded(list));
      }
    });
  return list;
  }

}

class AttendanceReportByStudentCubit extends Cubit<AttendanceReportByStudent>{
  AttendanceReportByStudentCubit():super(AttendanceReportByStudentLoading());

  Future<AttendanceReportByStudentModel> getAttendanceReportByStudent({String classId,String sectionId,String studentId,DateTime startDate,DateTime endDate,bool month = false}) async {
    emit(AttendanceReportByStudentLoading());
    List<AttendanceReportByStudentModel> list = [];
    prefs = await SharedPreferences.getInstance();
    String schoolId = prefs.getString('school-id');
    // String teacherId = prefs.getString('user-id');
    Map<String,dynamic> data ={
      "school_id":schoolId,
      "class_id":classId,
      "section_id":sectionId,
      "student_id":studentId,
      "start_date": startDate != null ?DateTime(startDate.year,startDate.month, month ? 1 : startDate.day).toUtc().toString():null,
      "end_date":endDate != null ?DateTime(endDate.year,endDate.month,endDate.day).toUtc().toString():null
    };
    data.removeWhere((key, value) => value == null);
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
    AttendanceApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .reportByStudent(data)
        .catchError((error) {
      print("get-attendance-error: $error");
      if (error is DioError) {
        DioError err = error;
        print("get-attendance-error-message: ${err.response}");
        log(error.stackTrace.toString());
        emit(AttendanceReportByStudentNotLoaded());
      }
    })
        .whenComplete(() {})
        .then((value) {
      if (value != null) {
        list = List<AttendanceReportByStudentModel>.from(jsonDecode(value)['data'].map((e)=>AttendanceReportByStudentModel.fromJson(e)));
      }

    });

    return list.first;
  }

}