import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '/api/auth-api-client.dart';
import '/bloc/auth/auth-states.dart';
import '/model/login-response.dart';
import '/model/user.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthStateLoading());
  SharedPreferences prefs;
  final storage =  FlutterSecureStorage();
  final dio = Dio();


  void logout() async {
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    storage.deleteAll();
    print(prefs.get('user-id'));
  }

  Future<void> checkAuthStatus() async {
    prefs = await SharedPreferences.getInstance();
    String token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      emit(AccountsNotLoaded());
      return;
    } else if (!prefs.containsKey("username"))
      emit(AccountsNotLoaded());
    else if (prefs.containsKey('user-id')) {

      getUsers(prefs.getString('user-id'), true);
    } else {
      getUsers(prefs.getString('username'));
    }
  }

  Future<void> setupPinAndLogin(String pinNumber, UserInfo userInfo) async {
    prefs = await SharedPreferences.getInstance();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client =
        AuthApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .updatePinNumber(userInfo.id, pinNumber)
        .catchError((error) {
          print("update-pin-error: $error");
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print("update-pin-response: $value");
          }
          if (json.decode(value)['status'] == "success")
            login(userInfo, pinNumber);
          return value;
        });
  }

  Future<void> login(UserInfo userInfo, String pinNumber) async {
    prefs = await SharedPreferences.getInstance();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        AuthApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .login(userInfo.mobile.toString(), pinNumber)
        .catchError((error) {
          print("login-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("login-error-message: ${err.response}");
            emit(LoginFailed());
          }
        })
        .whenComplete(() {})
        .then((value) async {
          if (value != null) {

            prefs = await SharedPreferences.getInstance();
            LoginResponse loginResponse = loginResponseFromJson(value);
            List<String> classes = [];
            if (userInfo.secondaryClass.isNotEmpty)
              classes = userInfo.secondaryClass.map((e) => e.classId).toList();
            if (userInfo.classId.classId != null)
              classes.add(userInfo.classId.classId);
            prefs.setStringList('classes', classes);
            await storage.write(key: "token", value: loginResponse.token);
            prefs.setString("school-id", userInfo.schoolId.id);
            prefs.setString("profile_type", userInfo.profileType.roleName);
            prefs.setString("branch", userInfo.branchId ?? 'admin');
            prefs.setString("class-id", userInfo.classId.classId ?? 'admin');
            prefs.setString("user-id", userInfo.id);
            prefs.setString("user-name", userInfo.name);
            prefs.setString('mobile', userInfo.mobile.toString());

            emit(LoginSuccess(loginResponse));
          }
          return value;
        });
  }

  Future<UserInfo> getUsers(String username, [bool id = false]) async {
    prefs = await SharedPreferences.getInstance();
    String token = await storage.read(key: 'token');
    dio.options.headers['Authorization'] = "Bearer "+token.toString();
    UserInfo userInfo;
    final client =
        AuthApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));
    Map<String, dynamic> data =
        !id ? {"username": username} : {"_id": username};
    await client
        .findUsers(data)
        .catchError((error) {
          print("find-user-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("find-user-error-message: ${err.response}");
          }
          emit(AccountsNotLoaded());
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            if (!id)
              prefs.setString('username', username);
            else
              prefs.setString('user-id', username);

            User user = userFromJson(value);

            // print('username after response === ' +
            //     user.userInfo[0].mobile.toString());
            if (user.userInfo.isEmpty) {
              emit(AccountsNotLoaded());
              return 'No Account Exist';
            }
            prefs.setString('user-id', user.userInfo[0].id);
            var selectedUser = user.userInfo[0];
            // if (selectedUser.pin == "" ||
            //     selectedUser.pin == null ||
            //     selectedUser.pin == "null") {
            //   emit(AccountsNotLoaded());
            // }
            userInfo = user.userInfo[0];
            emit(
              AccountsLoaded(
                user: user.userInfo.firstWhere((act) =>
                    act.mobile.toString() == username || act.id == username),
                users: user.userInfo,
              ),
            );
            Future.delayed(Duration(seconds: 2)).then((d) {
              if(!kIsWeb)
              FirebaseMessaging.instance.getToken().then((value) {
                if (value != null) {
                  AuthCubit().updateDeviceToken(value);
                }
              });
            });
          }
          return value;
        });
    return userInfo;
  }

  Future<void> sendOTP(UserInfo userInfo) async {
    prefs = await SharedPreferences.getInstance();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        AuthApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .sendOTP(userInfo.mobile, userInfo.username, 'teacher')
        .catchError((error) {
          print("send-otp-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("send-otp-message: ${err.response}");
          }
          emit(OtpNotVerified());
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
          return value;
        });
  }

  Future<void> updateDeviceToken(String deviceToken) async {
    prefs = await SharedPreferences.getInstance();
    String teacherId = prefs.getString('user-id');
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client =
        AuthApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .updateDeviceToken(deviceToken, teacherId)
        .catchError((error) {
          // print("update-token-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("update-token-message: ${err.response}");
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
          }
          return value;
        });
  }

  Future<void> verifyOTP(UserInfo userInfo, String otp) async {
    prefs = await SharedPreferences.getInstance();
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client =
        AuthApiClient(dio, baseUrl: GlobalConfiguration().get("baseURL"));

    await client
        .verifyOTP(userInfo.mobile, userInfo.username, otp)
        .catchError((error) {
          print("verify-otp-error: $error");
          if (error is DioError) {
            DioError err = error;
            print("verify-error-message: ${err.response}");
          }
          emit(OtpNotVerified());
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            if (jsonDecode(value)['error'] != null) {
              emit(OtpNotVerified());
              return ('Otp Not Verified');
            }
            print(value);
            emit(OtpVerified());
          }
          return value;
        });
  }
}
