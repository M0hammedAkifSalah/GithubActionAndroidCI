part of 'feed-api-client.dart';

class _FeedApiClient implements FeedApiClient {
  _FeedApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }
  final Dio _dio;

  String baseUrl;

  @override
  Future<String> createThread(
      Map<String, dynamic> data, String activityId) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl+'/activity/feed/$activityId',
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
  Future<String> getFeedbacks(String studentId) async {
    // ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl+'/performances/?student_id=$studentId',
      queryParameters: queryParameters,
      options: Options(
        method: 'GET',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> postFeedbacks(Map<String, dynamic> data) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log(baseUrl+'/performances/create   '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl+'/performances/create',
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
