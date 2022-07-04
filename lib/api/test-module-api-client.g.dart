part of 'test-module-api-client.dart';

class _TestModuleApiClient implements TestModuleApiClient {
  _TestModuleApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }
  final Dio _dio;
  String baseUrl;

  @override
  Future<String> getAllQuestionPapers(data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log('${baseUrl + '/actualQuestions/mobileData'}, body: $data');
    final _result = await _dio.request<String>(
      baseUrl + '/actualQuestions/mobileData',
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
  Future<String> getClasses(schoolId) async {
    ArgumentError.checkNotNull(schoolId, 'school id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log(baseUrl + '/school/$schoolId');
    final _result = await _dio.request<String>(
      baseUrl + '/school/$schoolId',
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
  Future<String> getSubjects(schoolId, classId) async {
    ArgumentError.checkNotNull(schoolId, 'school id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    //
    String url = baseUrl +
        '/subject?repository.id=$schoolId&repository.mapDetails.classId=$classId';
    log(url);
    final _result = await _dio.request<String>(
      baseUrl +
          '/subject?repository.id=$schoolId&repository.mapDetails.classId=$classId',
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
  Future<String> getAllLearningOutcome(schoolId) async {
    ArgumentError.checkNotNull(schoolId, 'school id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log('getAllLearningOutcome ' +
        baseUrl +
        '/learnOutcome?repository.id=$schoolId');
    final _result = await _dio.request<String>(
      baseUrl + '/learnOutcome?repository.id=$schoolId',
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
  Future<String> getAllSubmittedAnswer(String questionId,String teacherId,int page,int limit) async {
    // ArgumentError.checkNotNull(teacherId, 'teacher id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    Map<String,dynamic> _data = {
      "teacher_id":teacherId,
      "question_id":questionId
    };
    String url = baseUrl + '/answer/get?page=$page&limit=$limit';
    log(url + ' ' + _data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/answer/get?page=$page&limit=$limit',
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
  Future<String> getExamType(schoolId) async {
    ArgumentError.checkNotNull(schoolId, 'school id');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl + '/exam_type?repository.id=$schoolId',
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
  Future<String> getQuestionTypeObjective(
      {className, schoolId, subject, examType}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    String url = baseUrl +
        '/objectiveQuestion?repository.id=$schoolId&class=$className&subject=$subject';
    if (examType != null && examType.trim().isNotEmpty) {
      log('adding-exam-type: ${examType.trim().isEmpty}');
      url += '&examType=$examType';
    }
    log("URL: $url");
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
  Future<String> getQuestionCategory(String schoolId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log('questionCategory ' +
        baseUrl +
        '/question_category?repository.id=$schoolId');
    final _result = await _dio.request<String>(
      baseUrl + '/question_category?repository.id=$schoolId',
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
  Future<String> createQuestionPaper(body) async {
    ArgumentError.checkNotNull(body, 'body');

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = body;
    log('api body for create question ' + body.toString());
    log('true');
    final _result = await _dio.request<String>(
      baseUrl + '/actualQuestions/',
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

  //to assign the already created question paper to the students
  @override
  Future<String> assignQuestionPaper(
      Map<String, dynamic> body, String qpId) async {
    ArgumentError.checkNotNull(body, 'body');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = body;
    String endPoint = qpId;
    String url = baseUrl + '/actualQuestions/assign/' + endPoint;
    log('api body for assign question ' + body.toString());
    log('end point ' + endPoint);
    log(url);
    final _result = await _dio.request<String>(
      baseUrl + '/actualQuestions/assign/' + endPoint,
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
  Future<String> feedbackStudent(studentId, questionId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "student_id": studentId,
      "question_id": questionId,
    };
    final _result = await _dio.request<String>(
      baseUrl + '/feedback/',
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

  //to submit the marks for the freetext question
  @override
  Future<String> freeTextMarksSubmit({Map<String, dynamic> body}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = body;
    log(baseUrl+'/answer/freetextmark   '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/answer/freetextmark',
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
  Future<String> getChapters(schoolId, classId, subjectId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "class_id": classId,
      "subject_id": subjectId,
      "repository.id": schoolId
    };
    log(baseUrl + '/chapter/get ' + _data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/chapter/get',
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
  Future<String> getTopics(String schoolId, String classId, String subjectId,
      String chapterId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    String url = baseUrl +
        '/topic?repository.id=$schoolId&class_id=$classId&subject_id=$subjectId&chapter_id=$chapterId';
    log('getTopics ' + url);
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
