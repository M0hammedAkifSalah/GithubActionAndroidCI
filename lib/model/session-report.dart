
import 'dart:developer';

class SessionSchoolReport {
  SessionSchoolReport({
    this.schoolImage,
    this.schoolName,
    this.schoolId,
    this.city,
    this.state,
    this.totalSessions,
    this.attendedUsers,
    this.totalUsers,
  });

  String schoolImage;
  String schoolName;
  String schoolId;
  City city;
  SessionReportState state;
  int totalSessions;
  int attendedUsers;
  int totalUsers;

  factory SessionSchoolReport.fromJson(Map<String, dynamic> json) => SessionSchoolReport(
    schoolImage: json["schoolImage"],
    schoolName: json["schoolName"],
    schoolId: json["schoolId"],
    city: City.fromJson(json["city"]),
    state: SessionReportState.fromJson(json["state"]),
    totalSessions: json["totalSessions"],
    attendedUsers: json["attendedUsers"],
    totalUsers: json["totalUsers"],
  );

  Map<String, dynamic> toJson() => {
    "schoolImage": schoolImage,
    "schoolName": schoolName,
    "schoolId": schoolId,
    "city": city.toJson(),
    "state": state.toJson(),
    "totalSessions": totalSessions,
    "attendedUsers": attendedUsers,
    "totalUsers": totalUsers,
  };
}

class City {
  City({
    this.id,
    this.cityName,
  });

  String id;
  String cityName;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["_id"],
    cityName: json["city_name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "city_name": cityName,
  };
}

class SessionReportState {
  SessionReportState({
    this.id,
    this.stateName,
  });

  String id;
  String stateName;

  factory SessionReportState.fromJson(Map<String, dynamic> json) => SessionReportState(
    id: json["_id"],
    stateName: json["state_name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "state_name": stateName,
  };
}


class SessionReportStudent {
  SessionReportStudent({
    this.id,
    this.name,
    this.profileImage,
    // this.session,
    this.total,
    this.attended,
    this.avg
  });

  String id;
  String name;
  dynamic profileImage;
  // Session session;
  int total;
  int attended;
  double avg;


  factory SessionReportStudent.fromJson(Map<String, dynamic> json) {
    // try {
      return SessionReportStudent(
        id: json["_id"],
        name: json["name"],
        profileImage: json["profile_image"],
        // session: json['session'] != null
        //     ? Session.fromJson(json["session"])
        //     : Session(attended: 0, average: 0.0, total: 0),
        total: json["total"],
        attended: json['attended'],
        avg: double.tryParse(json['average'].toString())


      );
    // }  catch (e) {
    //   // TODO
    //   log(e.toString());
    // }
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "profile_image": profileImage,
    // "session": session.toJson(),
  };
}

class Session {
  Session({
    this.total,
    this.attended,
    this.average,
  });

  int total;
  int attended;
  double average;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    total: json["total"]??0,
    attended: json["attended"],
    average: double.tryParse(json["average"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "attended": attended,
    "average": average,
  };
}

