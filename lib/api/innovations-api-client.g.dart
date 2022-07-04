part of 'innovations-api-client.dart';

class _InnovationsApiClient implements InnovationsApiClient {
  _InnovationsApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }
  final Dio _dio;

  String baseUrl;

  @override
  Future<String> createInnovations(Map<String, dynamic> data) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl+'/innovation/',
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
  Future<String> getInnovations(Map<String, dynamic> data) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl+'/innovation/get',
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
  Future<String> likeInnovation(teacherId, innovationId) async {
    ArgumentError.checkNotNull(teacherId, 'teacher id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "action": "Like",
      "like_by": teacherId,
    };
    final _result = await _dio.request<String>(
      baseUrl+'/innovation/Like/$innovationId',
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
  Future<String> addViewInnovation(teacherId, innovationId) async {
    ArgumentError.checkNotNull(teacherId, 'teacher id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "action": "View",
      "view_by": teacherId,
    };
    final _result = await _dio.request<String>(
      baseUrl+'/innovation/Like/$innovationId',
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
  Future<String> dislikeInnovation(teacherId, innovationId) async {
    ArgumentError.checkNotNull(teacherId, 'teacher id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "action": "Dislike",
      "dislike_by": teacherId,
    };
    final _result = await _dio.request<String>(
      baseUrl+'/innovation/Dislike/$innovationId',
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
  Future<String> updateInnovations(
      Map<String, dynamic> data, String innovationId) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl+'/innovation/update/$innovationId',
      queryParameters: queryParameters,
      options: Options(
        method: 'PUT',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }
}
