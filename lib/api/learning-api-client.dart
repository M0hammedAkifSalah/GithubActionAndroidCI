import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'learning-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class LearningApiClient {
  factory LearningApiClient(Dio dio, {String baseUrl}) = _LearningApiClient;

  @POST('/learning/data')
  Future<String> getLearningData(
      @Body() Map<String, dynamic> data, @Path() String urlEnd);

  @POST('/SignUp/teacher/class')
  Future<String> getClassesForTeacher(@Body() String teacherId);

  @GET(
      '/student?school_id=600ff15a82cedf0ed49a1489&class=600ff34d82cedf0ed49a1493')
  Future<String> getAllStudents(
      @Path() String classId, String schoolId, String sectionId,int page,int limit);

  @POST('/student/getBySectionId')
  Future<String> getStudentIdOfSection(
      @Path() String mode, @Body() Map<String, dynamic> data);

  @POST('/student/getBySectionId')
  Future<String> getTeacherIdOfSchool(String schoolId);

  @PUT('/learning/data/{learning_id}')
  Future<String> updateLearnings(
      @Path() String learningId, @Body() Map<String, dynamic> data);

  @PUT('/learning/chapter/addImage/{chapter_id}')
  Future<String> updateChapterLearnings(
      @Path() String chapterId, @Body() Map<String, dynamic> data);

  @PUT('/learning/subject/files/{subject}')
  Future<String> updateSubjectLearnings(
      @Path() String subjectId, @Body() Map<String, dynamic> data);

  @POST('/learning/recentfile')
  Future<String> getRecentFiles(@Body() String classId);
}
