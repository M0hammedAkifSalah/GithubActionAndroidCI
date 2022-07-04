  part of 'learning-api-client.dart';

class _LearningApiClient implements LearningApiClient {
  _LearningApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }
  final Dio _dio;
  String baseUrl;

  Future<String> getLearningData(
      Map<String, dynamic> data, String endPoint) async {
    ArgumentError.checkNotNull(data, 'data');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log('Learning-data: $data');
    final _result = await _dio.request<String>(
      baseUrl + '/learning/$endPoint',
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

  Future<String> getClassesForTeacher(teacherId) async {
    ArgumentError.checkNotNull(teacherId, 'teacher id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"_id": teacherId};
    final _result = await _dio.request<String>(
      baseUrl + '/SignUp/teacher/class',
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

  Future<String> getAllStudents(classId, schoolId, sectionId,page,limit) async {
    ArgumentError.checkNotNull(classId, 'class id');
    ArgumentError.checkNotNull(schoolId, 'school id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log(baseUrl +
        '/student/get?school_id=$schoolId&class=$classId&section=$sectionId&page=$page&limit=$limit');
    final _result = await _dio.request<String>(
      baseUrl +
          '/student/get?school_id=$schoolId&class=$classId&section=$sectionId&page=$page&limit=$limit',
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

  Future<String> getStudentIdOfSection(mode, Map<String, dynamic> data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log(
        baseUrl +
        "/$mode/getBySectionId" +
        ' body : ' +
        _data.toString());
    final _result = await _dio.request<String>(
      baseUrl + "/$mode/getBySectionId",
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

  Future<String> getTeacherIdOfSchool(schoolId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl + "/SignUp/userIdByRole?school_id=$schoolId&page=1&limit=100000",
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

  Future<String> updateLearnings(learningId, data) async {
    ArgumentError.checkNotNull(learningId, 'learning id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl + '/learning/data/$learningId',
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

  Future<String> updateChapterLearnings(chapterId, data) async {
    ArgumentError.checkNotNull(chapterId, 'chapter id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl + '/learning/chapter/addImage/$chapterId',
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

  Future<String> updateSubjectLearnings(subjectId, data) async {
    ArgumentError.checkNotNull(subjectId, 'subject id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl + '/learning/subject/files/$subjectId',
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

  Future<String> getRecentFiles(classId) async {
    ArgumentError.checkNotNull(classId, 'classId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"class_id": classId};
    final _result = await _dio.request<String>(
      baseUrl + '/learning/recentfile',
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
