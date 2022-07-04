import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'teacher-profile-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class TeacherProfileApiClient {
  factory TeacherProfileApiClient(Dio dio, {String baseUrl}) =
      _TeacherProfileApiClient;

  @GET("/achievements?teacher_id={{Id}}")
  Future<String> getTeacherAchievements(@Path() String teacherId);

  @GET("/teacher/skill?teacher_id={{Id}}")
  Future<String> getTeacherSkills(@Path() String teacherId);

  @POST("/teacher/skill")
  Future<String> createTeacherSkills(Map<String, dynamic> data);
  @POST("/SignUp/profile/{teacher_id}")
  Future<String> updateAboutMe(String about, String teacherId);

  @POST("/achievements")
  Future<String> createTeacherAchievements(@Body() Map<String, dynamic> data);

  @PUT('/achievements/{teacher_id}')
  Future<String> updateTeacherAchievements(
      @Path() String achievementId, @Body() Map<String, dynamic> data);

  @POST("/reward/create")
  Future<String> rewardTeacher(@Body() Map<String, dynamic> data);
  @POST("/reward")
  Future<String> totalRewardTeacher(@Body() String studentId);
}
