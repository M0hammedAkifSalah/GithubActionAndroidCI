import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/http.dart';

part 'activity-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class ActivityApiClient {
  factory ActivityApiClient(Dio dio, {String baseUrl}) = _ActivityApiClient;

  @POST("/activity")
  Future<String> getActivities(@Body() Map<String, dynamic> data);

  @POST("/activity/reassign")
  Future<String> reassignAssignment(@Body() String studentId, String activityId,
      String comment, List<String> files);

  @POST("/activity/submitEvaluated")
  Future<String> submitEvaluated(@Body() String studentId, String activityId,
      String comment, List<String> files);

  @POST("/activity/offlineAssignment/{activity_id}")
  Future<String> submitOfflineAssignment(
      List<Map<String, dynamic>> studentIds, String activityId);

  @POST("/activity/addAnouncement")
  Future<String> addAcknowledgement(@Body() Map<String, dynamic> announcement);

  @POST("/activity/createAssignment")
  Future<String> addAssignment(@Body() Map<String, dynamic> assignment);

  @POST("/activity/addlivePool")
  Future<String> addLivePool(@Body() Map<String, dynamic> livePool);

  @POST("/activity/addEventCreact")
  Future<String> addEvent(@Body() Map<String, dynamic> event);

  @POST("/activity/Checklist/add")
  Future<String> addCheckList(@Body() Map<String, dynamic> checkList);

  @POST("/file/upload")
  Future<String> uploadFile(@Body() PlatformFile file);

  @POST("/file/upload")
  Future<String> uploadBytes(@Body() Uint8List bytes, @Body() String filename);

  @PUT("/activity/updateAssignmentStatus/{activity_id}")
  Future<String> updateAssignmentStatus(String activityId);

  @PUT("/activity/updateStatusToEvaluate/{activity_id}")
  Future<String> updateActivityStatus(String activityId);

  @POST('/SignUp/profile/image/{teacher_id}')
  Future<String> updateProfile(
      @Path() String teacherId, @Body() String fileName);

  @POST('/activity/Like/{activity_id}')
  Future<String> likeActivity(
      @Body() String teacherId, @Path() String activityId);

  @POST('/activity/DisLike/{activity_id}')
  Future<String> disLikeActivity(
      @Body() String teacherId, @Path() String activityId);

  @POST('/activity/viewed/{activity_id}')
  Future<String> viewActivity(
      @Body() String teacherId, @Path() String activityId);

  @POST('/activity/delete/{{activity_id}}')
  Future<String> deleteActivity(String activityId);

  @POST('/bookmarks/delete/{{student_id}}')
  Future<String> deleteBookmark(String activityId, String teacherId);

  @POST('/bookmarks/create')
  Future<String> addBookmark(String activityId, String teacherId);

  @POST('/bookmarks')
  Future<String> getAllBookmark(String teacherId);

  @POST('/dashboard/stats/progress/{schoolId}')
  Future<String> getTotalProgress(
      @Body() Map<String, dynamic> data, String schoolId);

  //method to get test average in progress
  @POST('/test/pendingCount')
  Future<String> getTestProgress(@Body() Map<String, dynamic> data);

  @GET('/dashboard/stats/attendance/:id')
  Future<String> getJoinedClassProgress(String studentId);

  @GET('/dashboard/stats/{{key}}/{{userId}}')
  Future<String> activityProgress(@Path() String key, @Path() String userId);

  @POST('/school/sectionWiseProgress')
  Future<String> sectionProgress(String schoolId);

  @GET('/dashboard/stats/lateSubmission/{studentId}')
  Future<String> lateSubmissionProgress(String studentId);
}
