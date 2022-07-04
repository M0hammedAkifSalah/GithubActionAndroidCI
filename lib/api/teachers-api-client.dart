import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'teachers-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class TeachersListApiClient {
  factory TeachersListApiClient(Dio dio, {String baseUrl}) =
      _TeachersListApiClient;

  @POST("/SignUp/user/")
  Future<String> getAllTeachers(@Body() String schoolId,int page,int limit);

  @POST("/activity/forwarded/{activity_id}")
  Future<String> forwardActivity(
      @Path() String activityId, @Body() Map<String, dynamic> data);

  @PUT('/activity/')
  Future<String> getAssignToYou(@Body() Map<String,dynamic> data);

  @GET('/signup/{id}')
  Future<String> getUser(String teacherId);
}
