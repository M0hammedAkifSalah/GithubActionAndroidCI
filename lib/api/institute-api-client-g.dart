part of 'institute-api-client.dart';

class _InstituteApiClient implements InstituteApiClient {
  _InstituteApiClient(this._dio, {this.baseUrl});
  final Dio _dio;

  String baseUrl;

  @override
  Future<String> getInstitute(String instituteId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    String url = baseUrl + '/institute/$instituteId';
    log(url);
    final _result = await _dio.request<String>(
      url,
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
  Future<String> postSession(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    String url = baseUrl + '/session/add';
    log(url + ' ' + data.toString());
    final _result = await _dio.request<String>(
      url,
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
  Future<String> updateSession(Map<String, dynamic> data, id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    String url = baseUrl + '/session/updateCompleteSession/$id';
    log(url + ' ' + data.toString());
    final _result = await _dio.request<String>(
      url,
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
  Future<String> displaySessionForToday(Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    String url = baseUrl + '/session';
    log(url + data.toString());
    final _result = await _dio.request<String>(
      url,
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
  Future<String> joinSessionForTeacher(data, id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    String url = baseUrl + '/session/joinSessionTeacher/' + data.toString();
    log('class url ' + url);
    final _result = await _dio.request<String>(
      baseUrl + '/session/joinSessionTeacher/$id',
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
  Future<String> displaySessionForFuture(Map<String, dynamic> data,bool isFuture) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    String url1 = baseUrl +  '/session/future';
    String url2 = baseUrl +  '/session/withPagination';
    log(isFuture ? url1 : url2);
    log(data.toString());
    final _result = await _dio.request<String>(
      isFuture ? url1 : url2,
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
  Future<String> deleteSession(String sessionId) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    String url = baseUrl + '/session/delete/' + sessionId;
    log('delete session url ' + url);
    final _result = await _dio.request<String>(
      baseUrl + '/session/delete/$sessionId',
      queryParameters: queryParameters,
      options: Options(
        method: 'DELETE',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
    );
    final value = _result.data;
    return value;
  }

  @override
  Future<String> getSessionTeachers(String schoolId,int page,int limit,bool isStudent) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log(_dio.options.headers.toString());
    String url = baseUrl + '/session/report/school/$schoolId/${isStudent ? 'students' : 'teachers' }?'
        'page=$page&limit=$limit';
    log(url);
    final _result = await _dio.request<String>(
      url,
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

  // @override
  // Future<String> getSessionStudents(String schoolId,int page,int limit) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   final _data = {};
  //   String url = baseUrl + '/session/report/school/{schoolId}/students?page=&limit=10';
  //   log(url);
  //   final _result = await _dio.request<String>(
  //     url,
  //     queryParameters: queryParameters,
  //     options: Options(
  //       method: 'GET',
  //       headers: <String, dynamic>{},
  //       extra: _extra,
  //     ),
  //     data: _data,
  //   );
  //   final value = _result.data;
  //   return value;
  // }

  @override
  Future<String> getSessionSchools(String instituteid) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    String url = baseUrl + '/session/report/institute/$instituteid';
    log(url);
    final _result = await _dio.request<String>(
      url,
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
  Future<String> getStudentInfo(String studentId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    String url = baseUrl + '/student/$studentId';
    log(url);
    final _result = await _dio.request<String>(
      url,
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
}
