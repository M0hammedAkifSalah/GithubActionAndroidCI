import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    hide Options;
import 'package:global_configuration/global_configuration.dart';

class EditActivity {
  String baseUrl = GlobalConfiguration().get('baseURL');
  FlutterSecureStorage storage = FlutterSecureStorage();
  Dio dio = Dio();

  Future<bool> editAnnouncement(
      String activityId, Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');

    var url = baseUrl + '/activity/updateAnouncement/' + activityId;
    log(url.toString());
    try {
      Response response = await dio.request(url,
          options: Options(method: 'PUT', headers: {'Authorization': "Bearer "+token}),
          data: data);
      //TODO add check condition, in response data.
      if (response.data != null) {
        log(response.data.toString());
        if (response.data['message'] == 'Announcement updated successfully') {
          return true;
        }
        return false;
      }
      return false;
    } catch (error) {
      if (error is DioError) {
        log('Dio Error in editAnouncement: ${error.response}');
        return false;
      } else {
        log('Error in editAnouncement: $error');
        return false;
      }
    }
  }

  Future<bool> editEvent(String activityId, Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');
    var url = baseUrl + 'activity/updateEvent/' + activityId;
    log(url + ' ' + data.toString());
    // try {
    Response response = await dio.request(url,
        options: Options(method: 'PUT', headers: {'Authorization': "Bearer "+token}), data: data);
    //TODO add check condition, in response data.
    if (response.data != null) {
      log(response.data.toString());
      if (response.data['message'] == 'Event updated successfully') {
        return true;
      }
      return false;
    }
    return false;
    // } catch (error) {
    //   if (error is DioError) {
    //     log('Dio Error in editEvent: ${error.response}');
    //     return false;
    //   } else {
    //     log('Error in editEvent: $error');
    //     return false;
    //   }
    // }
  }

  Future<bool> editLivePoll(String activiyId, Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');
    var url = baseUrl + 'activity/updateLivepool/' + activiyId;
    log(url + ' ' + data.toString());
    try {
      Response response = await dio.request(url,
          options: Options(method: 'PUT', headers: {'Authorization': "Bearer "+token}),
          data: data);
      //TODO add check condition, in response data.
      if (response.data != null) {
        log(response.data.toString());
        if (response.data['message'] == 'live Pool updated successfully') {
          return true;
        }
        return false;
      }
      return false;
    } catch (error) {
      if (error is DioError) {
        log('Dio Error in editLivePoll: ${error.response}');
        return false;
      } else {
        log('Error in editLivePoll: $error');
        return false;
      }
    }
  }

  Future<bool> editCheckList(
      String activityId, Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');
    var url = baseUrl + 'activity/updateChecklist/' + activityId;
    log(url + ' ' + data.toString());
    try {
      Response response = await dio.request(url,
          options: Options(method: 'PUT', //TODO add method
              headers: {'Authorization': "Bearer "+token}), data: data);
      //TODO add check condition, in response data.
      if (response.data != null) {
        log(response.data.toString());

        if (response.data['message'] == 'Checklist updated successfully') {
          return true;
        }
        return false;
      }
      return false;
    } catch (error) {
      if (error is DioError) {
        log('Dio Error in editCheckList: ${error.response}');
        return false;
      } else {
        log('Error in editCheckList: $error');
        return false;
      }
    }
  }

  Future<bool> editAssignment(
      String activityId, Map<String, dynamic> data) async {
    String token = await storage.read(key: 'token');
    var url = baseUrl + '/activity/updateAssignment/' + activityId;
    log(url + '  ' + data.toString());
    Response response = await dio.request(url,
        options: Options(method: 'PUT', headers: {'Authorization': "Bearer "+token}), data: data);
    //TODO add check condition, in response data.
    if (response.data != null) {
      log('edit response ' + response.data.toString());
      if (response.data['message'] == 'Assignment updated successfully') {
        return true;
      }
      return false;
    }
    return false;
  }
}
