
import 'package:growonplus_teacher/export.dart';
/*
AttendanceResponse attendanceResponseFromJson(String str) =>
    AttendanceResponse.fromJson(json.decode(str));

String attendanceResponseToJson(AttendanceResponse data) =>
    json.encode(data.toJson());

class AttendanceResponse {
  AttendanceResponse({
    this.error,
    this.statusCode,
    this.message,
    this.data,
  });

  bool error;
  int statusCode;
  String message;
  List<Attendance> data;

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) =>
      AttendanceResponse(
        error: json["error"],
        statusCode: json["statusCode"],
        message: json["message"],
        data: List<Attendance>.from(
            json["data"].map((x) => Attendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "statusCode": statusCode,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
class Attendance {
  Attendance({
    this.id,
    this.sections,
    this.date,
    this.teacherId,
    this.classId,
    this.schoolId,
    this.assignTo,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  List<Section> sections;
  DateTime date;
  Teacher teacherId;
  Class classId;
  String schoolId;
  List<AssignTo> assignTo;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        id: json["_id"],
        assignTo: List<AssignTo>.from(
            json["assignTo"].map((x) => AssignTo.fromJson(x))),
        date: DateTime.parse(json["class_Date"]),
        sections: List<Section>.from(
            json["sections"].map((x) => Section.fromJson(x))),
        teacherId: Teacher.fromJson(json["teacher_id"]),
        classId: Class.fromJson(json["class_id"]),
        schoolId: json["school_id"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "date": date,
        "assign_To": List<dynamic>.from(assignTo.map((x) => x.toJson())),
        "class_Date": date.toIso8601String(),
        "sections": List<dynamic>.from(sections.map((x) => x.toJson())),
        "teacher_id": teacherId.toJson(),
        "class_id": classId.toJson(),
        "school_id": schoolId,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class AssignTo {
  AssignTo({
    this.id,
    this.status,
    this.schoolId,
    this.studentId,
    this.sectionId,
  });

  String id;
  String status;
  String schoolId;
  Student studentId;
  String sectionId;

  factory AssignTo.fromJson(Map<String, dynamic> json) => AssignTo(
        id: json["_id"],
        status: json["status"],
        schoolId: json["school_id"],
        studentId: Student.fromJson(json["student_id"]),
        sectionId: json["section_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "school_id": schoolId,
        "student_id": studentId.toJson(),
        "section_id": sectionId,
      };
}

class Class {
  String id;
  String name;

  Class({
    this.id,
    this.name,
  });

  factory Class.fromJson(Map<String, dynamic> data) => Class(
        id: data['_id'],
        name: data['name'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };
}

class Section {
  String id;
  String name;

  Section({
    this.id,
    this.name,
  });

  factory Section.fromJson(Map<String, dynamic> data) => Section(
        id: data['_id'],
        name: data['name'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Section && id == other.id;
}

class Teacher {
  String id;
  String name;
  String profileImage;

  Teacher({
    this.id,
    this.name,
    this.profileImage,
  });

  factory Teacher.fromJson(Map<String, dynamic> data) => Teacher(
        id: data['_id'],
        name: data['name'],
        profileImage: data['profile_image'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'profile_image': profileImage,
      };
}

class Student {
  String id;
  String name;
  String profileImage;

  Student({
    this.id,
    this.name,
    this.profileImage,
  });

  factory Student.fromJson(Map<String, dynamic> data) => Student(
        id: data['_id'],
        name: data['name'],
        profileImage: data['profile_image'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'profile_image': profileImage,
      };
}*/

class AttendanceModel {
  AttendanceModel({
    this.classTeacher,
    this.attendanceTakenByTeacher,
    this.schoolId,
    this.classId,
    this.sectionId,
    this.date,
    this.attendanceDetails,
    this.createdBy,
    this.updatedBy,
  });

  String classTeacher;
  String attendanceTakenByTeacher;
  String schoolId;
  String classId;
  String sectionId;
  DateTime date;
  List<StudentsAttendanceDetail> attendanceDetails;
  String createdBy;
  String updatedBy;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        classTeacher: json["class_teacher"],
        attendanceTakenByTeacher: json["attendance_takenBy_teacher"],
        schoolId: json["school_id"],
        classId: json["class_id"],
        sectionId: json["section_id"],
        date: DateTime.parse(json["date"]).toLocal(),
        attendanceDetails: List<StudentsAttendanceDetail>.from(
            json["attendanceDetails"]
                .map((x) => StudentsAttendanceDetail.fromJson(x))),
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
      );

  Map<String, dynamic> toJson() => {
        "class_teacher": classTeacher,
        "attendance_takenBy_teacher": attendanceTakenByTeacher,
        "school_id": schoolId,
        "class_id": classId,
        "section_id": sectionId,
        "date": date.toUtc().toIso8601String(),
        "attendanceDetails":attendanceDetails != null ?
            List<dynamic>.from( attendanceDetails.map((x) => x.toJson()) ): null ,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
      };
}

class StudentsAttendanceDetail {
  StudentsAttendanceDetail(
      {this.status, this.studentId,this.name,this.profileImage});

  String status;
  String studentId;
  String name;
  String profileImage;

  factory StudentsAttendanceDetail.fromJson(Map<String, dynamic> json) =>
      StudentsAttendanceDetail(
          status: json["status"],
          studentId: json["student_id"],
        name: json['name'],
        profileImage: json['profileImage']
          );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "status": status.toTitleCase(),
      };
}

// ********************** to db ******************************

class AttendanceByDate {
  AttendanceByDate({
    this.date,
    this.classTeacher,
    this.classId,
    this.schoolId,
  });

  DateTime date;
  String classTeacher;
  String classId;
  String schoolId;

  factory AttendanceByDate.fromJson(Map<String, dynamic> json) =>
      AttendanceByDate(
        date: DateTime.parse(json["date"]).toLocal(),
        classTeacher: json["class_teacher"],
        classId: json["class_id"],
        schoolId: json["school_id"],
      );

  Map<String, dynamic> toJson() {
    var data = {
      "date": date.toUtc().toIso8601String(),
      // "class_teacher": classTeacher,
      "school_id": schoolId,
    };
    if (classId != null) data["class_id"] = classId;
    return data;
  }
}

//******************************* from db ****************************

class GetByDateAttendanceResponse {
  GetByDateAttendanceResponse({
    this.id,
    this.classTeacher,
    this.attendanceTakenByTeacher,
    this.classId,
    this.sectionId,
    this.schoolId,
    this.date,
    this.attendanceDetails,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String id;
  class_Teacher classTeacher;
  class_Teacher attendanceTakenByTeacher;
  Id classId;
  Id sectionId;
  Id schoolId;
  DateTime date;
  List<AttendanceDetail> attendanceDetails;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory GetByDateAttendanceResponse.fromJson(Map<String, dynamic> json) =>
      GetByDateAttendanceResponse(
        id: json["_id"],
        classTeacher: class_Teacher.fromJson(json["class_teacher"]),
        attendanceTakenByTeacher:
            class_Teacher.fromJson(json["attendance_takenBy_teacher"]),
        classId: Id.fromJson(json["class_id"]),
        sectionId: Id.fromJson(json["section_id"]),
        schoolId: Id.fromJson(json["school_id"]),
        date: DateTime.parse(json["date"]).toLocal(),
        attendanceDetails:json["attendanceDetails"] != null  ? List<AttendanceDetail>.from(
            json["attendanceDetails"].map((x) => AttendanceDetail.fromJson(x))) : null,
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
        updatedAt: DateTime.parse(json["updatedAt"]).toLocal(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "class_teacher": classTeacher.toJson(),
        "attendance_takenBy_teacher": attendanceTakenByTeacher.toJson(),
        "class_id": classId.toJson(),
        "section_id": sectionId.toJson(),
        "school_id": schoolId.toJson(),
        "date": date.toUtc().toIso8601String(),
        "attendanceDetails":
            List<dynamic>.from(attendanceDetails.map((x) => x.toJson())),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt.toUtc().toIso8601String(),
        "updatedAt": updatedAt.toUtc().toIso8601String(),
        "__v": v,
      };
}

class AttendanceDetail {
  AttendanceDetail({
    this.status,
    this.id,
    this.studentId,

  });

  String status;
  String id;
  StudentId studentId;

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) =>
      AttendanceDetail(
        status: json["status"],
        id: json["_id"],
        studentId: json["student_id"] != null ? StudentId.fromJson(json["student_id"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "student_id": studentId.toJson(),
      };
  AttendanceDetail copy(){
    return AttendanceDetail(studentId: studentId,status: status,id: id);
  }
}

class StudentId {
  StudentId({
    this.id,
    this.name,
    this.classId,
    this.sectionId,
    this.profileImage,
  });


  String id;
  String name;
  String classId;
  String sectionId;
  String profileImage;

  factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
        id: json["_id"],
        name: json["name"],
        classId: json["class"],
        sectionId: json["section"],
        profileImage:
            json["profile_image"] == null ? null : json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "class": classId,
        "section": sectionId,
        "profile_image": profileImage == null ? null : profileImage,
      };
}

class class_Teacher {
  class_Teacher({
    this.id,
    this.name,
    this.profileImage,
  });

  String id;
  String name;
  String profileImage;

  factory class_Teacher.fromJson(Map<String, dynamic> json) => class_Teacher(
        id: json["_id"],
        name: json["name"],
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "profile_image": profileImage,
      };
}

class Id {
  Id({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}


class AttendanceReportBySchoolModel {
  AttendanceReportBySchoolModel({
    this.attendanceDetails,
    this.classId,
    this.students,
    this.presentAvg,
    this.absentAvg,
    this.present,
    this.absent
  });

  List<ReportByStudentAttendanceDetail> attendanceDetails;
  Id classId;
  int students;
  double presentAvg;
  double absentAvg;
  int present;
  int absent;

  factory AttendanceReportBySchoolModel.fromJson(Map<String, dynamic> json) => AttendanceReportBySchoolModel(
    attendanceDetails: List<ReportByStudentAttendanceDetail>.from(json["attendanceDetails"].map((x) => ReportByStudentAttendanceDetail.fromJson(x))),
    classId: Id.fromJson(json["class_id"]),
    students: json["students"],
    presentAvg: json["presentAVG"].toDouble(),
    absentAvg: json["absentAVG"].toDouble(),
    absent: json['absent'],
    present: json['present']
  );

  Map<String, dynamic> toJson() => {
    "attendanceDetails": List<dynamic>.from(attendanceDetails.map((x) => x.toJson())),
    "class_id": classId.toJson(),
    "students": students,
    "presentAVG": presentAvg,
    "absentAVG": absentAvg,
    "present":present,
    "absent":absent
  };
}


class StatusAndDate {
  StatusAndDate({
    this.status,
    this.date,
  });

  String status;
  DateTime date;

  factory StatusAndDate.fromJson(Map<String, dynamic> json) => StatusAndDate(
    status:json["status"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "date": date.toIso8601String(),
  };
}


class AttendanceReportByStudentModel {
  AttendanceReportByStudentModel({
    this.id,
    this.attendanceDetails,
    this.students,
    this.present,
    this.absent,
    this.absentAvg,
    this.presentAvg
  });

  IdClass id;
  List<ReportByStudentAttendanceDetail> attendanceDetails;
  int students;
  int present;
  int absent;
  double presentAvg;
  double absentAvg;

  factory AttendanceReportByStudentModel.fromJson(Map<String, dynamic> json) => AttendanceReportByStudentModel(
    id: IdClass.fromJson(json["_id"]),
    attendanceDetails: List<ReportByStudentAttendanceDetail>.from(json["attendanceDetails"].map((x) => ReportByStudentAttendanceDetail.fromJson(x))),
    students: json["students"],
    present: json["present"],
    absent: json["absent"],
    absentAvg: json['absentAVG'].toDouble(),
    presentAvg: json['presentAVG'].toDouble()
  );

  Map<String, dynamic> toJson() => {
    "_id": id.toJson(),
    "attendanceDetails": List<dynamic>.from(attendanceDetails.map((x) => x.toJson())),
    "students": students,
    "present": present,
    "absent": absent,
    "presentAVG":presentAvg,
    "absentAVG":absentAvg
  };
}

class ReportByStudentAttendanceDetail {
  ReportByStudentAttendanceDetail({
    this.studentId,
    this.presentCount,
    this.absentCount,
    this.attendanceDetails,
  });

  ClassIdClass studentId;
  int presentCount;
  int absentCount;
  List<StatusAndDate> attendanceDetails;

  factory ReportByStudentAttendanceDetail.fromJson(Map<String, dynamic> json) => ReportByStudentAttendanceDetail(
    studentId: ClassIdClass.fromJson(json["student_id"]),
    presentCount: json["present_count"],
    absentCount: json["absent_count"],
    attendanceDetails: List<StatusAndDate>.from(json["attendanceDetails"].map((x) => StatusAndDate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "student_id": studentId.toJson(),
    "present_count": presentCount,
    "absent_count": absentCount,
    "attendanceDetails": List<dynamic>.from(attendanceDetails.map((x) => x.toJson())),
  };
}

class ClassIdClass {
  ClassIdClass({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory ClassIdClass.fromJson(Map<String, dynamic> json) => ClassIdClass(
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
  };
}

class IdClass {
  IdClass({
    this.classId,
    this.sectionId,
  });

  ClassIdClass classId;
  ClassIdClass sectionId;

  factory IdClass.fromJson(Map<String, dynamic> json) => IdClass(
    classId: ClassIdClass.fromJson(json["class_id"]),
    sectionId: ClassIdClass.fromJson(json["section_id"]),
  );

  Map<String, dynamic> toJson() => {
    "class_id": classId.toJson(),
    "section_id": sectionId.toJson(),
  };
}


