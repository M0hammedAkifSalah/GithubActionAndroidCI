// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import '../model/user.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.message,
    this.token,
    this.userInfo,
  });

  String message;
  String token;
  List<UserInfo> userInfo;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        message: json["message"],

        token: json["token"].toString(),
        // userInfo: List<UserInfo>.from(
        //     json["user_info"].map((x) => UserInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "token": token,
        "user_info": List<dynamic>.from(userInfo.map((x) => x.toJson())),
      };
}
