// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student-profile-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _StudentProfileApiClient implements StudentProfileApiClient {
  _StudentProfileApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> getStudentProfile(
      String schoolId, String classId, String sectionId,int page,int limit,searchText) async {
    ArgumentError.checkNotNull(schoolId, 'schoolId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{
      "school_id": schoolId,
      "searchValue": searchText,
      "filterKeysArray": ["name", "username"],
      "page": page,
      "limit": limit,
    };
    if (classId != null && classId.isNotEmpty) {
      _data["class"] = classId;
    }
    if (sectionId != null && sectionId.isNotEmpty) {
      _data["section"] = sectionId;
    }
    log(baseUrl + '/student/getAllStudents  ' + _data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/student/getAllStudents',
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
  Future<String> getGroups(data) async {
    // ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    String url = baseUrl + '/group';
    log('group api ' + url + ' ' + _data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/group',
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
  Future<String> removeStudentGroup(groupId, studentId) async {
    // ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<String>(
      baseUrl + '/group/$groupId/student/$studentId',
      queryParameters: queryParameters,
      options: Options(
        method: 'DELETE',
        // headers: <String, dynamic>{
        //   "studentId": studentId,
        // },
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> addStudentGroup(groupId,studentId) async {
    // ArgumentError.checkNotNull(id, 'id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl + '/group/$groupId/student/$studentId',
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

  @override
  Future<String> updateGroup(Map<String, dynamic> data, String groupId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log(baseUrl + '/group/$groupId  '+data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/group/$groupId',
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

  @override
  Future<String> createGroup(data) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl + '/group',
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
  Future<String> deleteGroup(groupId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl + '/group/$groupId',
      queryParameters: queryParameters,
      options: Options(
        method: 'DELETE',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> rewardStudent(data) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log(baseUrl+'/reward/create  '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/reward/create',
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
  Future<String> totalRewardStudent(studentId) async {
    ArgumentError.checkNotNull(studentId, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"student_details.student_id": studentId};
    log(baseUrl+'/reward '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/reward',
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
