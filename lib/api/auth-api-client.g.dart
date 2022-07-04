// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _AuthApiClient implements AuthApiClient {
  _AuthApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> findUsers(username) async {
    ArgumentError.checkNotNull(username, 'username');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = username;
    String url = baseUrl +
        '/SignUp/user/dashboard '+
        username.toString() ;
    final _result = await _dio.request<String>(
      baseUrl + '/SignUp/user/dashboard',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    log(url);
    final value = _result.data;
    return value;
  }

  @override
  Future<String> login(username, password) async {
    ArgumentError.checkNotNull(username, 'username');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      'username': username,
      "pincode": password,
    };
    log(baseUrl+'/SignUp/mobileLogin   '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/SignUp/mobileLogin',
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
  Future<String> updatePinNumber(id, password) async {
    ArgumentError.checkNotNull(id, 'id');
    ArgumentError.checkNotNull(password, 'password');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "id": id,
      "pincode": password,
    };
    log(_dio.options.headers.toString());
    log(baseUrl+'/SignUp/updatePinCode   '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/SignUp/updatePinCode',
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
  Future<String> sendOTP(mobile, username, type) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    ArgumentError.checkNotNull(username, 'username');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "mobile": mobile,
      "username": "$username",
      "type": "send",
      "profile_type": "$type"
    };
    log(baseUrl+'/otp  '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/otp',
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
  Future<String> updateDeviceToken(token, teacherId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "device_token": "$token",
    };
    final _result = await _dio.request<String>(
      baseUrl + '/teacher/updateDeviceToken/$teacherId',
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
  Future<String> verifyOTP(mobile, username, otp) async {
    ArgumentError.checkNotNull(mobile, 'mobile');
    ArgumentError.checkNotNull(username, 'username');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "mobile": mobile,
      "username": "$username",
      "type": "verify",
      "otp": "$otp"
    };
    final _result = await _dio.request<String>(
      baseUrl + '/otp',
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
}
