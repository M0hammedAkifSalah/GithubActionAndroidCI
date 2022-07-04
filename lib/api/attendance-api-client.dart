import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'attendance-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class AttendanceApiClient {
  factory AttendanceApiClient(Dio dio, {String baseUrl}) = _AttendanceApiClient;

  @POST("/attendance/getbydate")
  Future<String> getAttendanceByDate(@Body() Map<String, dynamic> data);

  @GET("/subject?repository.id={schoolId}")
  Future<String> getAssignmentSubjectDetails(@Path() String schoolId);

  @POST("/learning/getsubject")
  Future<String> getSubjectDetails(@Body() Map<String, dynamic> data);

  @POST("/learning/getchapter")
  Future<String> getChapterDetails(@Body() Map<String, dynamic> data);

  @GET("/scheduleClass/delete/{id}")
  Future<String> deleteClass(String id, Map<String, dynamic> data);

  @GET("/scheduleClass/linkedId/delete")
  Future<String> deleteClassLinked(Map<String, dynamic> body);

  @POST("/learning/topic")
  Future<String> getTopicDetails(@Body() Map<String, dynamic> data);

  @POST('/scheduleClass/add')
  Future<String> createScheduleClass(@Body() Map<String, dynamic> data);

  @POST('/scheduleClass')
  Future<String> getScheduleClass(@Body() Map<String, dynamic> data);

  @POST('/scheduleClass/limited')
  Future<String> getScheduleClassLimit(@Body() Map<String, dynamic> data);

  @POST('/scheduleClass/update/:{Scheduled Class id}')
  Future<String> updateClass(data, id);

  @POST('/scheduleClass/joinClassTeacher/:id')
  Future<String> joinClassForTeacher(@Body() data, id);

  @POST('/attendance/create')
  Future<String> createAttendance(@Body() data);

  @POST('/attendance/getbydate')
  Future<String> attendanceByDate(@Body() data);

  @POST('/attendance/update')
  Future<String> editAttendance(@Body() data);

  @POST('/attendance/reportbyschool')
  Future<String> reportBySchool(@Body() data);

  @POST('attendance/reportbystudent')
  Future<String> reportByStudent(@Body() Map<String,dynamic> body);
}
