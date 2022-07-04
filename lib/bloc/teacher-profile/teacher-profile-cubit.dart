import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import '/api/teacher-profile-api-client.dart';
import '/bloc/teacher-profile/teacher-profile-states.dart';
import '/model/activity.dart';
import '/model/teacher-profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeacherAchievementsCubit extends Cubit<TeacherAchievementStates> {
  TeacherAchievementsCubit() : super(TeacherAchievementLoading());
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();
  SharedPreferences sharedPreferences;

  void getAchievements({String teacherId}) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    String _teacherId = sharedPreferences.get('user-id');
    final client = TeacherProfileApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    final x = TeacherProfileApiClient(dio);
    await client
        .getTeacherAchievements(teacherId ?? _teacherId)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-getting-achievements : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            TeacherAchievementsResponse response =
                TeacherAchievementsResponse.fromJson(jsonDecode(value));
            emit(TeacherAchievementLoaded(response.data));
          }
        });
  }

  Future<void> createAchievements(String title, String description) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    String classId = sharedPreferences.get('class-id');
    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.get('user-id');
    final client = TeacherProfileApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    TeacherAchievements achievements = TeacherAchievements(
      classId: classId,
      teacherId: teacherId,
      title: title,
      description: description,
    );
    await client
        .createTeacherAchievements(achievements.toJson())
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-creating-achievements : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }

  Future<void> updateAchievements(TeacherAchievements achievements) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TeacherProfileApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateTeacherAchievements(achievements.id, achievements.toJson())
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-updating-achievements : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }
}

class TeacherSkillsCubit extends Cubit<TeacherSkillStates> {
  TeacherSkillsCubit() : super(TeacherSkillsLoading());
  final Dio dio = Dio();
  final storage = FlutterSecureStorage();
  SharedPreferences sharedPreferences;

  Future<void> getSkills({String teacherId}) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    sharedPreferences = await SharedPreferences.getInstance();
    String _teacherId = sharedPreferences.get('user-id');
    final client = TeacherProfileApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .getTeacherSkills(teacherId ?? _teacherId)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-getting-skills : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            TeacherSkillsResponse response =
                TeacherSkillsResponse.fromJson(jsonDecode(value));
            emit(TeacherSkillsLoaded(response.data));
          }
        });
  }

  Future<void> createSkill(String skill) async {
    String token = await storage.read(key: 'token');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String classId = sharedPreferences.get('class-id');
    String userId = sharedPreferences.get('user-id');
    final client = TeacherProfileApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    TeacherSkills skills =
        TeacherSkills(skills: [skill], classId: classId, teacherId: userId);
    await client
        .createTeacherSkills(skills.toJson())
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-creating-skill : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }

  Future<void> updateAboutMe(String about) async {
    String token = await storage.read(key: 'token');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TeacherProfileApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateAboutMe(about, teacherId)
        .catchError((error) {
          if (error is DioError) {
            print('Dio-error-message : ${error.response}');
          }
          print('Error-while-updating-about-me : $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
          }
        });
  }
}

class RewardTeacherCubit extends Cubit<RewardTeacherStates> {

  RewardTeacherCubit() : super(RewardTeacherLoading());
  final dio = Dio();
  final storage =  FlutterSecureStorage();
  SharedPreferences sharedPreferences;
  loadRewardTeacher({String teacherId}) async {
    log('true 01');
    String token = await storage.read(key: "token");
    sharedPreferences = await SharedPreferences.getInstance();
    String _teacherId = sharedPreferences.get('user-id');
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    final client = TeacherProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));
    await client
        .totalRewardTeacher(teacherId ?? _teacherId)
        .catchError((error) {
          print('error-while-loading-reward: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print('response-from-reward: $value');
            // print('response-loading-groups: $value');
            List<TotalRewardDetails> rewardsStudent =
                List<TotalRewardDetails>.from(
              jsonDecode(value)['data'].map(
                (e) => TotalRewardDetails.fromJson(e),
              ),
            );
            // print(group.group[0].groupPersons[0].name);
            emit(RewardTeacherLoaded(rewardsStudent));
          }
        });
  }

  rewardTeacher(Reward body, {bool innovation = false}) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = TeacherProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));
    log("Response-teacher: ${body.toJson(forTeacher: true).toString()}");
    await client
        .rewardTeacher(body.toJson(innovation: innovation, forTeacher: true))
        .catchError((error) {
          print('error-while-rewarding: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(body.teachers[0].teacherId + ' teacher id while rewarding');
            print('response-rewarding-teacher: $value');
          }
        });
  }

  rewardParent(Reward body, {bool innovation = false}) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    final client = TeacherProfileApiClient(dio,
        baseUrl: GlobalConfiguration().get("baseURL"));
    log('Parent- ${body.toJson(innovation: innovation, forParent: true)}');
    await client
        .rewardTeacher(body.toJson(innovation: innovation, forParent: true))
        .catchError((error) {
          if (error is DioError) {
            print('error-while-rewarding: ${error.response}');
          }
          print('error-while-rewarding: $error');
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            // print(body.teachers[0].teacherId + ' teacher id while rewarding');
            print('response-rewarding-parent: $value');
          }
        });
  }
}
