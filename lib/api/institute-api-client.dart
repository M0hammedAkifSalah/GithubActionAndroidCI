import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'institute-api-client-g.dart';

abstract class InstituteApiClient {
  factory InstituteApiClient(Dio dio, {String baseUrl}) = _InstituteApiClient;

  @GET('/institute/{instituteId}')
  Future<String> getInstitute(String instituteId);

  @POST('/session/add')
  Future<String> postSession(Map<String, dynamic> data);

  @POST('/session/updateCompleteSession/:id')
  Future<String> updateSession(Map<String, dynamic> data, id);

  @DELETE('/session/delete/{id}')
  Future<String> deleteSession(String sessionId);

  @POST('/session')
  Future<String> displaySessionForToday(Map<String, dynamic> data);

  @POST('/session/future')
  Future<String> displaySessionForFuture(Map<String, dynamic> data,bool isFuture);

  @POST('/session/joinSessionTeacher/:id')
  Future<String> joinSessionForTeacher(@Body() data, id);

  @GET('/session/report/school/{schoolId}/teachers?page=0&limit=10')
  Future<String> getSessionTeachers(String schoolId,int page,int limit,bool isStudent);

  @GET('/session/report/institute/{instituteId}')
  Future<String> getSessionSchools(String instituteId);

  @GET('/student/{studentId}')
  Future<String> getStudentInfo(String studentId);
}
