// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity-api-client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ActivityApiClient implements ActivityApiClient {
  _ActivityApiClient(this._dio, {this.baseUrl = ''}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    // baseUrl = 'https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<String> getActivities(data) async {
    ArgumentError.checkNotNull(data, 'teacherId');
    log(baseUrl + '/activity/getTeachersData ' + data.toString());
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    final _result = await _dio.request<String>(
      baseUrl + '/activity/getTeachersData',
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
  Future<String> reassignAssignment(
      studentId, activityId, comment, files) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "activity_id": "$activityId",
      "student_id": "$studentId",
      "text": comment,
      "submitted_date": DateTime.now().toIso8601String(),
      "file": files
    };
    final _result = await _dio.request<String>(
      baseUrl + '/activity/reassign',
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
  Future<String> submitEvaluated(studentId, activityId, comment, files) async {
    ArgumentError.checkNotNull(studentId, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "activity_id": "$activityId",
      "student_id": "$studentId",
      "text": comment,
      "file": files
    };
    log(baseUrl+'/activity/submitEvaluated  '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/activity/submitEvaluated',
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
  Future<String> submitOfflineAssignment(
      List<Map<String, dynamic>> studentIds, String activityId) async {
    ArgumentError.checkNotNull(studentIds, 'studentId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "submited_by": studentIds
          .map(
            (e) => {
          "student_id": e["student_id"],
          "message": [
            {
              "text": "",
              "file": [],
              "is_offline": true,
              "submitted_date": e["date"].toUtc().toIso8601String()
            }
          ],
          "submitted_date": e["date"].toUtc().toIso8601String()
        },
      )
          .toList(),
    };
    log(baseUrl+'/activity/offlineAssignment/$activityId  '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/activity/offlineAssignment/$activityId',
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
  Future<String> updateAssignmentStatus(activityId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log(baseUrl+'/activity/updateAssignmentStatus/$activityId  '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/activity/updateAssignmentStatus/$activityId',
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
  Future<String> updateActivityStatus(activityId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl + '/activity/updateStatusToEvaluate/$activityId',
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
  Future<String> likeActivity(teacherId, activityId) async {
    ArgumentError.checkNotNull(teacherId, 'teacherId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "action": "Like",
      "like_by": "$teacherId",
    };
    final _result = await _dio.request<String>(
      baseUrl + '/activity/Like/$activityId',
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
  Future<String> disLikeActivity(teacherId, activityId) async {
    ArgumentError.checkNotNull(teacherId, 'teacherId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "action": "DisLike",
      "dislike_by": "$teacherId",
    };
    final _result = await _dio.request<String>(
      baseUrl + '/activity/DisLike/$activityId',
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
  Future<String> viewActivity(teacherId, activityId) async {
    ArgumentError.checkNotNull(teacherId, 'teacherId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "action": "View",
      "view_by": "$teacherId",
    };
    final _result = await _dio.request<String>(
      baseUrl + '/activity/viewed/$activityId',
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
  Future<String> addAcknowledgement(announcement) async {
    ArgumentError.checkNotNull(announcement, 'announcement');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(announcement ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    log(baseUrl + '/activity/addAnouncement  ' + _data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/activity/addAnouncement',
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
  Future<String> addAssignment(assignment) async {
    ArgumentError.checkNotNull(assignment, 'assignment');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(assignment ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    log(baseUrl + '/activity/createAssignment  ' + _data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/activity/createAssignment',
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
  Future<String> addCheckList(checkList) async {
    print(checkList.isNotEmpty);
    ArgumentError.checkNotNull(checkList, 'checkList');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = checkList;
    final _result = await _dio.request<String>(
      baseUrl + '/activity/Checklist/add',
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
  Future<String> addLivePool(livePool) async {
    ArgumentError.checkNotNull(livePool, 'livePool');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(livePool ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<String>(
      baseUrl + '/activity/addlivePool',
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
  Future<String> addEvent(event) async {
    ArgumentError.checkNotNull(event, 'event');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(event ?? <String, dynamic>{});
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.request<String>(
      baseUrl + '/activity/addEventCreact',
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
  Future<String> uploadFile(PlatformFile file) async {
    ArgumentError.checkNotNull(file, 'file');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    log('upload path '+file.path.toString());
    final formData =
    FormData.fromMap({
      'file': kIsWeb ? MultipartFile(file.readStream, file.size,
          filename: file.name) : await MultipartFile.fromFile(file.path)
    });
    final _data = formData;
    log(baseUrl + '/file/upload '+_data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/file/upload',
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
  Future<String> uploadBytes(Uint8List bytes, String filename) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final formData = FormData.fromMap(
        {"file": MultipartFile.fromBytes(bytes.toList(), filename: filename)});
    final _data = formData;
    log(baseUrl + '/file/upload');
    final _result = await _dio.request<String>(
      baseUrl + '/file/upload',
      queryParameters: queryParameters,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: _extra,
      ),
      data: _data,
    );
    final value = _result.data;
    log(value.toString());
    return value;
  }

  Future<String> updateProfile(teacherId, file) async {
    ArgumentError.checkNotNull(file, 'file');
    ArgumentError.checkNotNull(teacherId, 'teacherId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"profile_image": file};
    final _result = await _dio.request<String>(
      baseUrl + '/SignUp/profile/image/$teacherId',
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
  Future<String> deleteActivity(String activityId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl + '/activity/delete/$activityId',
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
  Future<String> deleteBookmark(String activityId, String teacherId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "activity": activityId,
    };
    final _result = await _dio.request<String>(
      baseUrl + '/bookmarks/delete/$teacherId',
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
  Future<String> addBookmark(String activityId, String teacherId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {
      "teacher_id": teacherId,
      "bookmark_details": [
        {
          "activity": activityId,
        }
      ]
    };
    final _result = await _dio.request<String>(
      baseUrl + '/bookmarks/create',
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
  Future<String> getAllBookmark(String teacherId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    final _result = await _dio.request<String>(
      baseUrl + '/bookmarks',
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
  Future<String> getTotalProgress(data,String schoolId) async {

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log(baseUrl +
        '/dashboard/stats/progress/$schoolId' +
        data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/dashboard/stats/progress/$schoolId',
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
  Future<String> getJoinedClassProgress(String studentId) async {

    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log(baseUrl + '/dashboard/stats/attendance/$studentId');
    final _result = await _dio.request<String>(
      baseUrl + '/dashboard/stats/attendance/$studentId',
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
  Future<String> activityProgress(key, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log('URL PROGRESS ' + baseUrl + '/dashboard/stats/$key/$userId');
    final _result = await _dio.request<String>(
      baseUrl + '/dashboard/stats/$key/$userId',
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
  Future<String> sectionProgress(schoolId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {"school_id": schoolId};
    log('Sectionprogress ' +
        baseUrl +
        '/school/sectionWiseProgress ${"school_id" + schoolId}');
    final _result = await _dio.request<String>(
      baseUrl + '/school/sectionWiseProgress',
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
  Future<String> getTestProgress(Map<String, dynamic> data) async {
    // TODO: implement getTestProgress
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = data;
    log('TEST PROGRESS API ' +
        baseUrl +
        '/test/pendingCount' +
        data.toString());
    final _result = await _dio.request<String>(
      baseUrl + '/test/pendingCount',
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
  Future<String> lateSubmissionProgress(String studentId) async{
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = {};
    log(baseUrl + '/dashboard/stats/lateSubmission/$studentId');
    final _result = await _dio.request<String>(
      baseUrl + '/dashboard/stats/lateSubmission/$studentId',
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
