// import 'package:dio/dio.dart';
// import 'package:global_configuration/global_configuration.dart';
// import 'package:retrofit/http.dart';

// part 'class-schedule-api-client.g.dart';

// abstract class ClassScheduleApiClient {
//   factory ClassScheduleApiClient(Dio dio, {String baseUrl}) = _ClassScheduleApiClient;

//   @POST("/scheduleClass")
//   Future<String> getClassSchedules(@Body() String schoolId, @Body() String classId);

// }

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'class-schedule-api-client.g.dart';

abstract class SchoolDetailsClient {
  factory SchoolDetailsClient(Dio dio, {String baseUrl}) = _SchoolDetailsClient;

  @GET("/school/{school_id}")
  Future<String> getClassDetails(@Path() String schoolId);

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

  // @POST('/scheduleClass/update/60dd94e2361e1166d198d87a')
  // Future<String> updateScheduleClass(@Body() Map<String, dynamic> data);

  // @POST("/SignUp/updatePinCode")
  // Future<String> updatePinNumber(@Body() String id, @Body() String password);
}
