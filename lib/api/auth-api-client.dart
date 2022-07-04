import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

part 'auth-api-client.g.dart';

@RestApi(baseUrl: "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/")
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST("/SignUp/user/dashboard")
  Future<String> findUsers(@Body() Map<String, dynamic> request);

  @POST("/SignUp/mobileLogin")
  Future<String> login(@Body() String username, @Body() String password);

  @POST("/SignUp/updatePinCode")
  Future<String> updatePinNumber(@Body() String id, @Body() String password);
  @POST("//otp")
  Future<String> sendOTP(
      @Body() int mobile, @Body() String username, @Body() profileType);
  
  @POST("/otp")
  Future<String> updateDeviceToken(
      @Body() String token,String teacherId);
  @POST("/otp")
  Future<String> verifyOTP(
      @Body() int mobile, @Body() String username, @Body() String otp);
}
