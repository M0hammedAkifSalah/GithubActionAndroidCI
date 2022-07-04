part of 'take-action-api-client.dart';

class _TakeActionApiClient implements TakeActionApiClient {
  _TakeActionApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }
  final Dio _dio;

  String baseUrl;

  @override
  Future<String> updateAnnouncement(activityId, teacherId) async {
    ArgumentError.checkNotNull(teacherId, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "acknowledge_by_teacher": [teacherId]
    };
    final _result = await _dio.request<String>(
      baseUrl+'/activity/Anouncement/teacher/$activityId',
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
  Future<String> updateEventGoing(activityId, teacherId) async {
    ArgumentError.checkNotNull(teacherId, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "teacher": [teacherId]
    };
    final _result = await _dio.request<String>(
      baseUrl+'/activity/event/going/taecher/$activityId',
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
  Future<String> updateEventNotGoing(activityId, teacherId) async {
    ArgumentError.checkNotNull(teacherId, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "teacher": [teacherId]
    };
    final _result = await _dio.request<String>(
      baseUrl+'/activity/event/notgoing/taecher/$activityId',
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
  Future<String> updateLivePoll(activityId, selected) async {
    ArgumentError.checkNotNull(selected, 'selected');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = selected;
    final _result = await _dio.request<String>(
      baseUrl+'/activity/livePool/$activityId',
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
  Future<String> updateCheckList(activityId, selected) async {
    ArgumentError.checkNotNull(selected, 'selected');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = selected;
    final _result = await _dio.request<String>(
      baseUrl+'/activity/checklist/$activityId',
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
