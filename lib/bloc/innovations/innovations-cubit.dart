import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:global_configuration/global_configuration.dart';
import '/api/innovations-api-client.dart';
import '/bloc/innovations/innovations-states.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/model/innovations.dart';

class InnovationCubit extends Cubit<InnovationStates> {
  InnovationCubit() : super(InnovationsLoading());
  SharedPreferences sharedPreferences;
  final dio = Dio();
  final storage =  FlutterSecureStorage();

  loadInnovations() async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client = InnovationsApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .getInnovations({
          "teacher_id": "$teacherId",
          // "page": 1,
          // "limit": 5,
        })
        .catchError((error) {
          print('error-while-loading-innovations: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            processInnovation(
                InnovationList.fromJson(jsonDecode(value)), teacherId, true);
          }
        });
  }

  Future<void> loadMoreInnovations(InnovationsLoaded state, int page) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client = InnovationsApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .getInnovations({"teacher_id": "$teacherId", "page": page, "limit": 5})
        .catchError((error) {
          print('error-while-loading-innovations: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            bool hasMore = false;
            var innovation = InnovationList.fromJson(jsonDecode(value));
            log('innovation-extra: ${innovation.innovations.isNotEmpty}');
            hasMore = innovation.innovations.isNotEmpty;
            var extra = innovation;
            extra.innovations.addAll(state.innovations);
            log('Length: ${extra.innovations.length}');
            processInnovation(extra, teacherId, hasMore);
          }
        });
  }

  processInnovation(
      InnovationList innovations, String teacherId, bool hasMore) {
    List<Innovation> innovation = [];
    for (var i in innovations.innovations) {
      if (i.likeBy.contains(teacherId)) {
        i.liked = true;
      } else {
        i.liked = false;
      }
      innovation.add(i);
    }
    innovation = innovation.reversed.toList();
    log('Innovations has more: $hasMore');
    emit(InnovationsLoaded(innovation, hasMore));
  }

  publishInnovations(Innovation innovation, int coin) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();
    innovation.coin = coin;
    print('coin innovation : $coin');
    sharedPreferences = await SharedPreferences.getInstance();
    // String teacherId = sharedPreferences.getString('user-id');
    final client = InnovationsApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .updateInnovations(innovation.toJson(), innovation.id)
        .catchError((error) {
          print('error-while-publish-innovation: $error');
          if (error is DioError) {
            print('dio-error: $error');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            // InnovationList innovations =
            //     InnovationList.fromJson(jsonDecode(value));
            // emit(InnovationsLoaded(innovations.innovations));
          }
        });
  }

  likeInnovation(String innovationId) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client = InnovationsApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .likeInnovation(teacherId, innovationId)
        .catchError((error) {
          print('error-while-liking-innovation: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            // InnovationList innovations =
            //     InnovationList.fromJson(jsonDecode(value));
            // emit(InnovationsLoaded(innovations.innovations));
          }
        });
  }

  dislikeInnovation(String innovationId) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client = InnovationsApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    await client
        .dislikeInnovation(teacherId, innovationId)
        .catchError((error) {
          print('error-while-disliking-innovation: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            // InnovationList innovations =
            //     InnovationList.fromJson(jsonDecode(value));
            // emit(InnovationsLoaded(innovations.innovations));
          }
        });
  }

  addViewInnovation(Innovation innovation) async {
    String token = await storage.read(key: "token");
    dio.options.headers["Authorization"] = "Bearer "+token.toString();

    sharedPreferences = await SharedPreferences.getInstance();
    String teacherId = sharedPreferences.getString('user-id');
    final client = InnovationsApiClient(
      dio,
      baseUrl: GlobalConfiguration().get('baseURL'),
    );
    // if(innovation.viewBy)
    await client
        .addViewInnovation(teacherId, innovation.id)
        .catchError((error) {
          print('error-while-adding-view-innovation: $error');
          if (error is DioError) {
            print('dio-error: ${error.response}');
          }
        })
        .whenComplete(() {})
        .then((value) {
          if (value != null) {
            print(value);
            // InnovationList innovations =
            //     InnovationList.fromJson(jsonDecode(value));
            // emit(InnovationsLoaded(innovations.innovations));
          }
        });
  }
}

class CurrentInnovationCubit extends Cubit<InnovationCurrentState> {
  CurrentInnovationCubit() : super(CurrentInnovationNotLoaded());
  loadCurrentInnovation(Innovation innovation, bool seeInnovation) {
    emit(CurrentInnovationLoaded(innovation, seeInnovation));
  }
}
