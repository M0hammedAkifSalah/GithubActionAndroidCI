// import 'package:dio/dio.dart';
part of 'teachers-api-client.dart';

class _TeachersListApiClient implements TeachersListApiClient {
  _TeachersListApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }
  final Dio _dio;
  String baseUrl;

  @override
  Future<String> forwardActivity(activityId, data) async {
    ArgumentError.checkNotNull(data, 'data');
    ArgumentError.checkNotNull(activityId, 'activityId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl + '/activity/forwarded/$activityId',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getAllTeachers(schoolId,page,limit) async {
    // ArgumentError.checkNotNull(data, 'data');
    ArgumentError.checkNotNull(schoolId, 'school id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"school_id": schoolId};
    final _result = await _dio.request<String>(
      baseUrl + '/SignUp/user/?school_id=$schoolId&page=$page&limit=$limit',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getMoreTeachers(schoolId, page) async {
    // ArgumentError.checkNotNull(data, 'data');
    ArgumentError.checkNotNull(schoolId, 'school id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"school_id": schoolId};
    final _result = await _dio.request<String>(
      baseUrl + '/SignUp/user/?school_id=$schoolId&limit=15&page=$page',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getAssignToYou(body) async {
    ArgumentError.checkNotNull(body, 'teacherId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = body;
    log(baseUrl+'/activity  '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/activity',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getUser(String teacherId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    log(baseUrl+'/signup/'+teacherId);
    final _result = await _dio.request<String>(
      baseUrl + '/signup/$teacherId',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
    );
    final value = _result.data;
    return value;
  }
}
