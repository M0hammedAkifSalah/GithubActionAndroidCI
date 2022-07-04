import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'take-action-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class TakeActionApiClient {
  factory TakeActionApiClient(Dio dio, {String baseUrl}) = _TakeActionApiClient;

  @POST('/activity/Anouncement/teacher/{activity_id}')
  Future<String> updateAnnouncement(
      @Path() String activityId, @Body() String teacherId);

  @POST('/activity/event/going/taecher/{activity_id}')
  Future<String> updateEventGoing(
      @Path() String activityId, @Body() String teacherId);

  @POST('/activity/event/notgoing/taecher/{activity_id}')
  Future<String> updateEventNotGoing(
      @Path() String activityId, @Body() String teacherId);

  @POST('/activity/livePool/{activity_id}')
  Future<String> updateLivePoll(
      @Path() String activityId, @Body() Map<String, dynamic> selected);
  
  @POST('/activity/checklist/activityId')
  Future<String> updateCheckList(
      @Path() String activityId, @Body() Map<String, dynamic> selected);

  // @GET("/student/profile/{id}")
  // Future<String> updateStudentProfile(
  //     @Path() String id, @Body() String aboutMe, @Body() String hobbies);
}
