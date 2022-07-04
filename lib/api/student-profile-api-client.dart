import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'student-profile-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class StudentProfileApiClient {
  factory StudentProfileApiClient(Dio dio, {String baseUrl}) =
      _StudentProfileApiClient;

  @GET("/student/studentwithparent?school_id={id}")
  Future<String> getStudentProfile(
      @Path() String schoolId, String classId, String sectionId,int page,int limit,String searchText);


  @GET("/group")
  Future<String> getGroups(Map<String, dynamic> data);

  @DELETE("/group/{group_id}/student/{studentId}")
  Future<String> removeStudentGroup(@Path() String groupId, String studentId);

  @PUT("/group/{group_id}/student/{studentId}")
  Future<String> addStudentGroup(
      @Body() String groupId, @Path() String studentId);

  @PUT("/group/{group_id}")
  Future<String> updateGroup(
      @Body() Map<String, dynamic> data, @Path() String studentId);

  @POST("/group")
  Future<String> createGroup(@Body() Map<String, dynamic> data);

  @DELETE("/group/{group_id}")
  Future<String> deleteGroup(String groupId);

  @POST("/reward/create")
  Future<String> rewardStudent(@Body() Map<String, dynamic> data);

  @POST("/reward")
  Future<String> totalRewardStudent(@Body() String studentId);

// @GET("/student/profile/{id}")
// Future<String> updateStudentProfile(
//     @Path() String id, @Body() String aboutMe, @Body() String hobbies);
}
