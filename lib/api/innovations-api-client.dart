import 'package:dio/dio.dart';

import 'package:retrofit/http.dart';

part 'innovations-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class InnovationsApiClient {
  factory InnovationsApiClient(Dio dio, {String baseUrl}) =
      _InnovationsApiClient;

  @POST("/innovation/")
  Future<String> createInnovations(@Body() Map<String, dynamic> data);

  @POST("/innovation/get")
  Future<String> getInnovations(@Body() Map<String, dynamic> data);
  @POST("/innovation/Like/{innovation_id}")
  Future<String> likeInnovation(@Body() String teacherId, String innovationId);
  @POST("/innovation/viewed/{innovation_id}")
  Future<String> addViewInnovation(
      @Body() String teacherId, String innovationId);
  @POST("/innovation/Dislike/{innovation_id}")
  Future<String> dislikeInnovation(
      @Body() String teacherId, String innovationId);

  @PUT("/innovation/update/{id}")
  Future<String> updateInnovations(
      @Body() Map<String, dynamic> data, String id);

  // @GET("/student/profile/{id}")
  // Future<String> updateStudentProfile(
  //     @Path() String id, @Body() String aboutMe, @Body() String hobbies);
}
