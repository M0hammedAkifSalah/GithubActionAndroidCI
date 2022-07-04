import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'test-module-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class TestModuleApiClient {
  factory TestModuleApiClient(Dio dio, {String baseUrl}) = _TestModuleApiClient;

  @POST("/actualQuestions/mobile?repository.id=600ff15a82cedf0ed49a1489")
  Future<String> getAllQuestionPapers(Map<String, dynamic> data);

  @GET("/school/{school_id}")
  Future<String> getClasses(@Path() String schoolId);

  @GET(
      "/subject?repository.id={schoolId}&repository.mapDetails.classId={classId}")
  Future<String> getSubjects(@Path() String schoolId, @Path() String classId);

  @GET('/chapter/get')
  Future<String> getChapters(String schoolId, String classId, String subjectId);

  @GET('/exam_type?repository.id={{school_id}}')
  Future<String> getExamType(@Path() String schoolId);

  @GET('/question_category')
  Future<String> getQuestionCategory(String schoolId);

  @GET(
      '/objectiveQuestion?repository.id={{schoolId}}&class={{class}}&subject={{subject}}&examType={{exam_type}}')
  Future<String> getQuestionTypeObjective({
    @Body() String className,
    String schoolId,
    String subject,
    String examType,
  });

  @POST('/actualQuestions/')
  Future<String> createQuestionPaper(Map<String, dynamic> body);

  @POST('/actualQuestions/assign')
  Future<String> assignQuestionPaper(Map<String, dynamic> body, String qpId);

  @GET('/learnOutcome')
  Future<String> getAllLearningOutcome(String schoolId);

  @GET('/answer/get')
  Future<String> getAllSubmittedAnswer(String questionId,String teacherId,int page,int limit);

  @POST('/feedback')
  Future<String> feedbackStudent(String studentId, String questionId);

  @POST('/answer/freetextmark')
  Future<String> freeTextMarksSubmit({@Body() Map<String, dynamic> body});

  @POST(
      'topic?repository.id={id}&class_id={id}&board_id={id}&syllabus_id={id}&subject_id={id}&chapter_id={id}')
  Future<String> getTopics(
      String schoolId, String classId, String subjectId, String chapterId);
}
// Map<String,dynamic> data
//{"studentId":"","questionId":""}
