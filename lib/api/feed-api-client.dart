import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:retrofit/http.dart';

part 'feed-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class FeedApiClient {
  factory FeedApiClient(Dio dio, {String baseUrl}) = _FeedApiClient;

  @POST("activity/feed/{activityId}")
  Future<String> createThread(
      @Body() Map<String, dynamic> data, @Path() String activityId);
  @GET('/performances/')
  Future<String> getFeedbacks(String studentId);
  @POST('/performances/create')
  Future<String> postFeedbacks(@Body() Map<String, dynamic> feedback);
  // @GET("/student/profile/{id}")
  // Future<String> updateStudentProfile(
  //     @Path() String id, @Body() String aboutMe, @Body() String hobbies);
}
