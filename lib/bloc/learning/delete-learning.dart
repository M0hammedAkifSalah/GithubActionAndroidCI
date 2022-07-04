import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:global_configuration/global_configuration.dart';
import 'package:dio/dio.dart';

class DeleteLearing {
  String baseUrl = GlobalConfiguration().get('baseURL');
  FlutterSecureStorage storage = FlutterSecureStorage();
  Dio dio = Dio();

  Future<bool> deleteChapterContent(Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');
    var url = baseUrl + '/chapter/deleteContent';
    try {
      Response response = await dio.request(url,
          options: Options(method: 'POST', headers: {'Authorization': "Bearer "+token}),
          data: data);
      if (response != null) {
        log(response.data.toString());
        return true;
      }
      return false;
    } catch (error) {
      if (error is DioError) {
        log('Dio Error in Delete Content: ${error.response} ');
        return false;
      } else {
        log('Error in delete content: $error ');
        return false;
      }
    }
  }

  Future<bool> deleteTopicContent(Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');
    var url = baseUrl + '/topic/deleteContent';
    try {
      Response response = await dio.request(url,
          options: Options(method: 'POST', headers: {'Authorization': "Bearer "+token}),
          data: data);
      if (response != null) {
        log(response.data.toString());
        return true;
      }
      return false;
    } catch (error) {
      if (error is DioError) {
        log('Dio Error in delete Topic Content: ${error.response}  ');
        return false;
      } else {
        log('Error in delete topic content: $error ');
        return false;
      }
    }
  }
}
