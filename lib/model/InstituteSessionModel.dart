
class Session {
  Session(
      {this.sessionStartDate,
      this.sessionEndDate,
      this.sessionStartTime,
      this.sessionEndTime,
      this.subjectName,
      this.doesSessionRepeat,
      this.instituteId,
      this.meetingLink,
      this.schools,
      this.description,
      this.files,
      this.createdBy,
      this.id,
      this.studentJoinSession,
      this.teacherJoinSession,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.isDaily,
      this.isForStudent,
      });

  DateTime sessionStartDate;
  DateTime sessionEndDate;
  bool isForStudent;
  DateTime sessionStartTime;
  DateTime sessionEndTime;
  String subjectName;
  String doesSessionRepeat;
  String instituteId;
  String meetingLink;
  String id;
  List<dynamic> studentJoinSession;
  List<dynamic> teacherJoinSession;
  List<String> schools;
  String description;
  List<String> files;
  String createdBy;
  String createdAt;
  String updatedAt;
  String status;
  String isDaily;

  factory Session.fromJson(Map<String, dynamic> json) {
    // log('fromjson '+json.toString());
    // try {
    return Session(
        sessionStartDate: json["session_start_Date"] != null
            ? DateTime.parse(json["session_start_Date"])
            : null,
        sessionEndDate: json["session_end_Date"] != null
            ? DateTime.parse(json["session_end_Date"])
            : null,
        sessionStartTime: json["session_start_time"] != null
            ? DateTime.parse(json["session_start_time"])
            : null,
        sessionEndTime: json["session_end_time"] != null
            ? DateTime.parse(json["session_end_time"])
            : null,
        subjectName: json["subject_name"],
        doesSessionRepeat: json["does_session_repeat"],
        instituteId: json["institute_id"],
        meetingLink: json["meeting_link"],
        schools: json["schools"] != null
            ? List<String>.from(json["schools"].map((x) => x))
            : null,
        description: json["description"],
        files: List<String>.from(json["files"].map((x) => x)),
        createdBy: json["createdBy"],
        id: json["_id"],
        studentJoinSession: json["student_join_session"] != []
            ? json["student_join_session"]
            : [],
        teacherJoinSession: json["teacher_join_session"] != []
            ? json["teacher_join_session"]
            : [],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        status: json['status'].toString(),
        isDaily: json['isDaily'],
        isForStudent: json['isForStudent'],);
    // }
    // catch (e) {
    //   log(e.toString());
    //   if(e is TypeError)
    //     {
    //       log(e.stackTrace.toString());
    //     }
    // }
  }

  Map<String, dynamic> toJson() {
    // try {
    return {
      "session_start_Date": sessionStartDate.toUtc().toIso8601String(),
      "session_end_Date": sessionEndDate != null
          ? sessionEndDate.toUtc().toIso8601String()
          : null,
      "session_start_time": sessionStartTime.toUtc().toIso8601String(),
      "session_end_time": sessionEndTime.toUtc().toIso8601String(),
      "subject_name": subjectName,
      "does_session_repeat": doesSessionRepeat,
      "institute_id": instituteId,
      "meeting_link": meetingLink.toLowerCase(),
      "schools": List<dynamic>.from(schools.map((x) => x)),
      "description": description,
      "files": List<dynamic>.from(files.map((x) => x)),
      "createdBy": createdBy,
      'status': 'Pending',
      'isDaily': isDaily,
      'isForStudent': isForStudent
    };
    // }  catch (e) {
    //   // TODO
    //   log(e.toString()+e.runtimeType.toString());
    // }
  }
}

class ReceivedSession {
  ReceivedSession(
      {this.sessionStartDate,
      this.sessionEndDate,
      this.sessionStartTime,
      this.sessionEndTime,
      this.subjectName,
      this.doesSessionRepeat,
      this.instituteId,
      this.meetingLink,
      this.schools,
      this.description,
      this.files,
      this.createdBy,
      this.id,
      this.studentJoinSession,
      this.teacherJoinSession,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.isDaily,
      this.isForStudent});

  DateTime sessionStartDate;

  bool isForStudent;
  DateTime sessionEndDate;
  DateTime sessionStartTime;
  DateTime sessionEndTime;
  String subjectName;
  String doesSessionRepeat;
  String instituteId;
  String meetingLink;
  String id;
  List<dynamic> studentJoinSession;
  List<TeacherJoinedSession> teacherJoinSession;
  List<SessionSchool> schools;
  String description;
  List<String> files;
  CreatedBy createdBy;
  String createdAt;
  String updatedAt;
  String status;
  String isDaily;
  bool isTeacherJoined;

  factory ReceivedSession.fromJson(Map<String, dynamic> json) {
    // log('fromjson '+json.toString());
    // try {

    return ReceivedSession(
        sessionStartDate: DateTime.parse(json["session_start_Date"]).toLocal(),
        sessionEndDate: json["session_end_Date"] != null
            ? DateTime.parse(json["session_end_Date"]).toLocal()
            : DateTime.parse(json["session_start_Date"]).toLocal(),
        sessionStartTime: DateTime.parse(json["session_start_time"]).toLocal(),
        sessionEndTime: DateTime.parse(json["session_end_time"]).toLocal(),
        subjectName: json["subject_name"],
        doesSessionRepeat: json["does_session_repeat"],
        instituteId: json["institute_id"]['_id'],
        meetingLink: json["meeting_link"],
        schools: List<SessionSchool>.from(
            json["schools"].map((x) => SessionSchool.fromJson(x))),
        description: json["description"],
        files: List<String>.from(json["files"].map((x) => x)),
        createdBy: json["createdBy"] != null
            ? CreatedBy.fromJson(json["createdBy"])
            : null,
        id: json["_id"],
        studentJoinSession: json["student_join_session"] != null
            ? json["student_join_session"]
            : [],
        teacherJoinSession: json["teacher_join_session"] != null
            ? List<TeacherJoinedSession>.from(json["teacher_join_session"]
                .map((x) => TeacherJoinedSession.fromJson(x)))
            : [],
        createdAt: DateTime.parse(json["createdAt"]).toLocal().toString(),
        updatedAt: json["updatedAt"],
        status: json['status'].toString(),
        isDaily: json['isDaily'],
        isForStudent: json['isForStudent'],);
    // }
    // catch (e) {
    //   log(e.toString());
    //   if(e is TypeError)
    //     {
    //       log(e.stackTrace.toString());
    //     }
    // }
  }

  Map<String, dynamic> toJson() => {
        "session_start_Date": sessionStartDate.toUtc().toIso8601String(),
        "session_end_Date": sessionEndDate.toUtc().toIso8601String(),
        "session_start_time": sessionStartTime.toUtc().toIso8601String(),
        "session_end_time": sessionEndTime.toUtc().toIso8601String(),
        "subject_name": subjectName,
        "does_session_repeat": doesSessionRepeat,
        "institute_id": instituteId,
        "meeting_link": meetingLink.toLowerCase(),
        "schools": List<dynamic>.from(schools.map((x) => x)),
        "description": description,
        "files": List<dynamic>.from(files.map((x) => x)),
        "createdBy": createdBy,
        'status': 'Pending',
        'isDaily': isDaily,
        'isForStudent': isForStudent
      };
}

class TeacherJoinedSession {
  TeacherJoinedSession({this.joinDate, this.teacherId, this.schoolId});

  DateTime joinDate;
  Teacher teacherId;
  SessionSchool schoolId;

  factory TeacherJoinedSession.fromJson(Map<String, dynamic> data) {
    return TeacherJoinedSession(
      joinDate: DateTime.parse(data['join_date']),
      teacherId: data['teacher_id'] != null
          ? Teacher.fromJson(data['teacher_id'])
          : null,
      schoolId: SessionSchool.fromJson(data['school_id']),
    );
  }
}

class Teacher {
  String id;
  String name;
  String profileImage;

  Teacher({this.id, this.profileImage, this.name});

  factory Teacher.fromJson(Map<String, dynamic> data) {
    return Teacher(
      id: data['_id'],
      profileImage: data['profile_image'],
      name: data['name'],
    );
  }
}

class CreatedBy {
  CreatedBy({
    this.id,
    this.name,
    this.profileType,
    this.profileImage,
  });

  String id;
  String name;
  ProfileType profileType;
  String profileImage;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["_id"],
        name: json["name"],
        profileImage: json['profile_image'],
        profileType: ProfileType.fromJson(
          json["profile_type"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profile_type": profileType.toJson(),
      };
}

class ProfileType {
  ProfileType({
    this.id,
    this.roleName,
  });

  String id;
  String roleName;

  factory ProfileType.fromJson(Map<String, dynamic> json) => ProfileType(
        id: json["_id"],
        roleName: json["role_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "role_name": roleName,
      };
}

class SessionSchool {
  SessionSchool({
    this.schoolImage,
    this.id,
  });

  String schoolImage;
  String id;

  factory SessionSchool.fromJson(Map<String, dynamic> json) => SessionSchool(
        schoolImage: json["schoolImage"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "schoolImage": schoolImage,
        "_id": id,
      };
}

class InstituteModel {
  InstituteModel({
    this.instituteImage,
    this.schoolList,
    this.activeStatus,
    this.id,
    this.instituteCode,
    this.address,
    this.city,
    this.state,
    this.country,
    this.email,
    this.webSite,
    this.contactNumber,
    this.pincode,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.name,
  });

  String instituteImage;
  List<SchoolList> schoolList;
  bool activeStatus;
  String id;
  int instituteCode;
  String address;
  InstituteCity city;
  WelcomeState state;
  InstituteCountry country;
  String email;
  String webSite;
  int contactNumber;
  int pincode;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String name;

  factory InstituteModel.fromJson(Map<String, dynamic> json) => InstituteModel(
        instituteImage: json["instituteImage"] ?? null,
        schoolList: List<SchoolList>.from(
            json["schoolList"].map((x) => SchoolList.fromJson(x))),
        activeStatus: json["activeStatus"],
        id: json["_id"],
        instituteCode: json["institute_code"],
        address: json["address"],
        city: InstituteCity.fromJson(json["city"]),
        state: WelcomeState.fromJson(json["state"]),
        country: InstituteCountry.fromJson(json["country"]),
        email: json["email"],
        webSite: json["webSite"],
        contactNumber: json["contact_number"],
        pincode: json["pincode"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "instituteImage": instituteImage,
        "schoolList": List<dynamic>.from(schoolList.map((x) => x.toJson())),
        "activeStatus": activeStatus,
        "_id": id,
        "institute_code": instituteCode,
        "address": address,
        "city": city.toJson(),
        "state": state.toJson(),
        "country": country.toJson(),
        "email": email,
        "webSite": webSite,
        "contact_number": contactNumber,
        "pincode": pincode,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "name": name,
      };
}

class InstituteCity {
  InstituteCity({
    this.repository,
    this.id,
    this.stateId,
    this.cityName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<dynamic> repository;
  String id;
  String stateId;
  String cityName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory InstituteCity.fromJson(Map<String, dynamic> json) => InstituteCity(
        repository: List<dynamic>.from(json["repository"].map((x) => x)),
        id: json["_id"],
        stateId: json["state_id"],
        cityName: json["city_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "repository": List<dynamic>.from(repository.map((x) => x)),
        "_id": id,
        "state_id": stateId,
        "city_name": cityName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class InstituteCountry {
  InstituteCountry({
    this.repository,
    this.fileUpload,
    this.id,
    this.countryName,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<Repository> repository;
  List<dynamic> fileUpload;
  String id;
  String countryName;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory InstituteCountry.fromJson(Map<String, dynamic> json) =>
      InstituteCountry(
        repository: List<Repository>.from(
            json["repository"].map((x) => Repository.fromJson(x))),
        fileUpload: List<dynamic>.from(json["file_upload"].map((x) => x)),
        id: json["_id"],
        countryName: json["country_name"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "file_upload": List<dynamic>.from(fileUpload.map((x) => x)),
        "_id": id,
        "country_name": countryName,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Repository {
  Repository({
    this.id,
    this.repositoryType,
  });

  String id;
  String repositoryType;

  factory Repository.fromJson(Map<String, dynamic> json) => Repository(
        id: json["id"],
        repositoryType: json["repository_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "repository_type": repositoryType,
      };
}

class SchoolList {
  SchoolList({
    this.schoolImage,
    this.id,
    this.schoolName,
    this.country,
    this.state,
    this.city,
    this.schoolCode,
  });

  String schoolImage;
  String id;
  String schoolName;
  SchoolListCountry country;
  SchoolListState state;
  SchoolListCity city;
  int schoolCode;

  factory SchoolList.fromJson(Map<String, dynamic> json) => SchoolList(
        schoolImage: json["schoolImage"],
        id: json["_id"],
        schoolName: json["schoolName"],
        country: json['country'] != null
            ? SchoolListCountry.fromJson(json["country"])
            : null,
        state: json['state'] != null
            ? SchoolListState.fromJson(json["state"])
            : null,
        city:
            json['city'] != null ? SchoolListCity.fromJson(json["city"]) : null,
        schoolCode: json["school_code"],
      );

  Map<String, dynamic> toJson() => {
        "schoolImage": schoolImage,
        "_id": id,
        "schoolName": schoolName,
        "country": country.toJson(),
        "state": state.toJson(),
        "city": city.toJson(),
        "school_code": schoolCode,
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is SchoolList && id == other.id;
}

class SchoolListCity {
  SchoolListCity({
    this.id,
    this.cityName,
  });

  String id;
  String cityName;

  factory SchoolListCity.fromJson(Map<String, dynamic> json) => SchoolListCity(
        id: json["_id"],
        cityName: json["city_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "city_name": cityName,
      };
}

class SchoolListCountry {
  SchoolListCountry({
    this.id,
    this.countryName,
  });

  String id;
  String countryName;

  factory SchoolListCountry.fromJson(Map<String, dynamic> json) =>
      SchoolListCountry(
        id: json["_id"],
        countryName: json["country_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "country_name": countryName,
      };
}

class SchoolListState {
  SchoolListState({
    this.id,
    this.stateName,
  });

  String id;
  String stateName;

  factory SchoolListState.fromJson(Map<String, dynamic> json) =>
      SchoolListState(
        id: json["_id"],
        stateName: json["state_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "state_name": stateName,
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is SchoolListState && id == other.id;
}

class WelcomeState {
  WelcomeState({
    this.repository,
    this.id,
    this.countryId,
    this.stateName,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  List<dynamic> repository;
  String id;
  String countryId;
  String stateName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory WelcomeState.fromJson(Map<String, dynamic> json) => WelcomeState(
        repository: List<dynamic>.from(json["repository"].map((x) => x)),
        id: json["_id"],
        countryId: json["country_id"],
        stateName: json["state_name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "repository": List<dynamic>.from(repository.map((x) => x)),
        "_id": id,
        "country_id": countryId,
        "state_name": stateName,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
