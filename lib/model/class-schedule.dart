// To parse this JSON data, do
//
//     final classScheduleResponse = classScheduleResponseFromJson(jsonString);


import 'package:intl/intl.dart';

import '../model/activity.dart';
import '../model/user.dart' show UserInfo, StudentInfo;

// ClassScheduleResponse classScheduleResponseFromJson(String str) =>
//     ClassScheduleResponse.fromJson(json.decode(str));

// String classScheduleResponseToJson(ClassScheduleResponse data) =>
//     json.encode(data.toJson());

// class ClassScheduleResponse {
//   ClassScheduleResponse({
//     this.result,
//     this.data,
//   });

//   int result;
//   List<ClassSchedule> data;

//   factory ClassScheduleResponse.fromJson(Map<String, dynamic> json) =>
//       ClassScheduleResponse(
//         result: json["result"],
//         data: List<ClassSchedule>.from(
//             json["data"].map((x) => ClassSchedule.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "result": result,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//       };
// }

// class ClassSchedule {
//   ClassSchedule({
//     // this.assignTo,
//     this.studentJoinClass,
//     this.createdAt,
//     this.updatedAt,
//     this.id,
//     this.classDate,
//     this.classDetails,
//     this.repository,
//     this.createdBy,
//     this.updatedBy,
//   });

//   // List<AssignTo> assignTo;
//   List<dynamic> studentJoinClass;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String id;
//   DateTime classDate;
//   List<ClassScheduleDetail> classDetails;
//   List<Repository> repository;
//   String createdBy;
//   String updatedBy;

//   factory ClassSchedule.fromJson(Map<String, dynamic> json) => ClassSchedule(
//         // assignTo: List<AssignTo>.from(
//         //     json["assign_To"].map((x) => AssignTo.fromJson(x))),
//         studentJoinClass:
//             List<dynamic>.from(json["student_join_class"].map((x) => x)),
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         id: json["_id"],
//         classDate: DateTime.parse(json["class_Date"]),
//         classDetails: List<ClassScheduleDetail>.from(
//             json["class_details"].map((x) => ClassScheduleDetail.fromJson(x))),
//         repository: List<Repository>.from(
//             json["repository"].map((x) => Repository.fromJson(x))),
//         createdBy: json["createdBy"],
//         updatedBy: json["updatedBy"],
//       );

//   Map<String, dynamic> toJson() => {
//         // "assign_To": List<dynamic>.from(assignTo.map((x) => x.toJson())),
//         "student_join_class":
//             List<dynamic>.from(studentJoinClass.map((x) => x)),
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "_id": id,
//         "class_Date": classDate.toIso8601String(),
//         "class_details":
//             List<dynamic>.from(classDetails.map((x) => x.toJson())),
//         "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
//         "createdBy": createdBy,
//         "updatedBy": updatedBy,
//       };
// }

// class AssignTo {
//   AssignTo({
//     this.subject,
//     this.repository,
//     this.createdAt,
//     this.updatedAt,
//     this.id,
//     this.username,
//     this.password,
//     this.schoolId,
//     this.branchId,
//     this.name,
//     this.contactNumber,
//     this.dob,
//     this.email,
//     this.address,
//     this.aadhar,
//     this.stsNo,
//     this.rteStudent,
//     this.caste,
//     this.motherTongue,
//     this.bloodGr,
//     this.modeOfTransp,
//     this.medicalCond,
//     this.wearGlasses,
//     this.assignToClass,
//     this.section,
//     this.vehicleId,
//     this.v,
//   });

//   List<dynamic> subject;
//   List<dynamic> repository;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String id;
//   String username;
//   String password;
//   String schoolId;
//   String branchId;
//   String name;
//   dynamic contactNumber;
//   String dob;
//   String email;
//   String address;
//   String aadhar;
//   String stsNo;
//   String rteStudent;
//   String caste;
//   String motherTongue;
//   String bloodGr;
//   String modeOfTransp;
//   String medicalCond;
//   String wearGlasses;
//   String assignToClass;
//   String section;
//   String vehicleId;
//   int v;

//   factory AssignTo.fromJson(Map<String, dynamic> json) => AssignTo(
//         subject: List<dynamic>.from(json["subject"].map((x) => x)),
//         repository: List<dynamic>.from(json["repository"].map((x) => x)),
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         id: json["_id"],
//         username: json["username"],
//         password: json["password"],
//         schoolId: json["school_id"],
//         branchId: json["branch_id"],
//         name: json["name"],
//         contactNumber: json["contact_number"],
//         dob: json["dob"],
//         email: json["email"],
//         address: json["address"],
//         aadhar: json["aadhar"],
//         stsNo: json["sts_no"],
//         rteStudent: json["rte_student"],
//         caste: json["caste"],
//         motherTongue: json["mother_tongue"],
//         bloodGr: json["blood_gr"],
//         modeOfTransp: json["mode_of_transp"],
//         medicalCond: json["medical_cond"],
//         wearGlasses: json["wear_glasses"],
//         assignToClass: json["class"],
//         section: json["section"],
//         vehicleId: json["vehicle_id"],
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "subject": List<dynamic>.from(subject.map((x) => x)),
//         "repository": List<dynamic>.from(repository.map((x) => x)),
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "_id": id,
//         "username": username,
//         "password": password,
//         "school_id": schoolId,
//         "branch_id": branchId,
//         "name": name,
//         "contact_number": contactNumber,
//         "dob": dob,
//         "email": email,
//         "address": address,
//         "aadhar": aadhar,
//         "sts_no": stsNo,
//         "rte_student": rteStudent,
//         "caste": caste,
//         "mother_tongue": motherTongue,
//         "blood_gr": bloodGr,
//         "mode_of_transp": modeOfTransp,
//         "medical_cond": medicalCond,
//         "wear_glasses": wearGlasses,
//         "class": assignToClass,
//         "section": section,
//         "vehicle_id": vehicleId,
//         "__v": v,
//       };
// }

class ClassScheduleDetail {
  ClassScheduleDetail({
    this.id,
    this.startTime,
    this.endTime,
    this.subject,
    this.chapterName,
    // this.teacherId,
    this.meetingLink,
    this.meetingName,
  });

  String id;
  String startTime;
  String endTime;
  String subject;
  String chapterName;

  // Teacher teacherId;
  String meetingLink;
  String meetingName;

  factory ClassScheduleDetail.fromJson(Map<String, dynamic> json) =>
      ClassScheduleDetail(
        id: json["_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        subject: json["subject"],
        chapterName: json["chapter_name"],
        // teacherId: Teacher.fromJson(json["teacher_id"]),
        meetingLink: json["meeting_link"],
        meetingName: json["meeting_name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "start_time": startTime,
        "end_time": endTime,
        "subject": subject,
        "chapter_name": chapterName,
        // "teacher_id": teacherId.toJson(),
        "meeting_link": meetingLink,
        "meeting_name": meetingName,
      };
}

// class Teacher {
//   Teacher(
//       {this.secondaryProfileType,
//       this.teacherIdClass,
//       this.subject,
//       this.otherDegrees,
//       this.certifications,
//       this.extraAchievement,
//       this.repository,
//       this.createdAt,
//       this.updatedAt,
//       this.id,
//       this.username,
//       this.name,
//       this.mobile,
//       this.profileType,
//       this.schoolId,
//       this.branchId,
//       this.gender,
//       this.password,
//       this.qualification,
//       this.dob,
//       this.email,
//       this.address,
//       this.aadharCard,
//       this.bloodGr,
//       this.religion,
//       this.caste,
//       this.motherTounge,
//       this.maritalStatus,
//       this.level,
//       this.leaderShipExp,
//       this.cv,
//       this.tenDetails,
//       this.twelveDetails,
//       this.graduationDetails,
//       this.mastersDetails,
//       this.v,
//       this.profileImage});

//   List<dynamic> secondaryProfileType;
//   List<dynamic> teacherIdClass;
//   List<dynamic> subject;
//   List<Certification> otherDegrees;
//   List<Certification> certifications;
//   List<Certification> extraAchievement;
//   List<dynamic> repository;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String id;
//   String username;
//   String name;
//   int mobile;
//   String profileType;
//   String schoolId;
//   String branchId;
//   String gender;
//   String password;
//   String qualification;
//   String dob;
//   String email;
//   String address;
//   int aadharCard;
//   String bloodGr;
//   String religion;
//   String caste;
//   String motherTounge;
//   String maritalStatus;
//   String level;
//   String leaderShipExp;
//   String cv;
//   Details tenDetails;
//   Details twelveDetails;
//   Details graduationDetails;
//   Details mastersDetails;
//   int v;
//   String profileImage;

//   factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
//         secondaryProfileType:
//             List<dynamic>.from(json["secondary_profile_type"].map((x) => x)),
//         teacherIdClass: List<dynamic>.from(json["class"].map((x) => x)),
//         subject: List<dynamic>.from(json["subject"].map((x) => x)),
//         otherDegrees: List<Certification>.from(
//             json["other_degrees"].map((x) => Certification.fromJson(x))),
//         certifications: List<Certification>.from(
//             json["certifications"].map((x) => Certification.fromJson(x))),
//         extraAchievement: List<Certification>.from(
//             json["extra_achievement"].map((x) => Certification.fromJson(x))),
//         repository: List<dynamic>.from(json["repository"].map((x) => x)),
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         id: json["_id"],
//         username: json["username"],
//         name: json["name"],
//         mobile: json["mobile"],
//         profileType: json["profile_type"],
//         schoolId: json["school_id"],
//         branchId: json["branch_id"],
//         gender: json["gender"],
//         password: json["password"],
//         qualification: json["qualification"],
//         dob: json["dob"],
//         email: json["email"],
//         address: json["address"],
//         aadharCard: json["aadhar_card"],
//         bloodGr: json["blood_gr"],
//         religion: json["religion"],
//         caste: json["caste"],
//         profileImage: json["profile_image"],
//         motherTounge: json["mother_tounge"],
//         maritalStatus: json["marital_status"],
//         level: json["level"],
//         leaderShipExp: json["leaderShip_Exp"],
//         cv: json["cv"],
//         tenDetails: Details.fromJson(json["ten_details"]),
//         twelveDetails: Details.fromJson(json["twelve_details"]),
//         graduationDetails: Details.fromJson(json["graduation_details"]),
//         mastersDetails: Details.fromJson(json["masters_details"]),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "secondary_profile_type":
//             List<dynamic>.from(secondaryProfileType.map((x) => x)),
//         "class": List<dynamic>.from(teacherIdClass.map((x) => x)),
//         "subject": List<dynamic>.from(subject.map((x) => x)),
//         "other_degrees":
//             List<dynamic>.from(otherDegrees.map((x) => x.toJson())),
//         "certifications":
//             List<dynamic>.from(certifications.map((x) => x.toJson())),
//         "extra_achievement":
//             List<dynamic>.from(extraAchievement.map((x) => x.toJson())),
//         "repository": List<dynamic>.from(repository.map((x) => x)),
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "_id": id,
//         "username": username,
//         "name": name,
//         "profile_image": profileImage,
//         "mobile": mobile,
//         "profile_type": profileType,
//         "school_id": schoolId,
//         "branch_id": branchId,
//         "gender": gender,
//         "password": password,
//         "qualification": qualification,
//         "dob": dob,
//         "email": email,
//         "address": address,
//         "aadhar_card": aadharCard,
//         "blood_gr": bloodGr,
//         "religion": religion,
//         "caste": caste,
//         "mother_tounge": motherTounge,
//         "marital_status": maritalStatus,
//         "level": level,
//         "leaderShip_Exp": leaderShipExp,
//         "cv": cv,
//         "ten_details": tenDetails.toJson(),
//         "twelve_details": twelveDetails.toJson(),
//         "graduation_details": graduationDetails.toJson(),
//         "masters_details": mastersDetails.toJson(),
//         "__v": v,
//       };
// }

class Certification {
  Certification();

  factory Certification.fromJson(Map<String, dynamic> json) => Certification();

  Map<String, dynamic> toJson() => {};
}

class Details {
  Details({
    this.school,
    this.board,
    this.percentage,
    this.yearOfPassing,
    this.attachDoc,
  });

  String school;
  String board;
  int percentage;
  int yearOfPassing;
  String attachDoc;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        school: json["school"],
        board: json["Board"],
        percentage: json["percentage"],
        yearOfPassing: json["year_of_passing"],
        attachDoc: json["Attach_doc"],
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "Board": board,
        "percentage": percentage,
        "year_of_passing": yearOfPassing,
        "Attach_doc": attachDoc,
      };
}

class ClassRepository {
  ClassRepository({
    this.id,
    this.schoolId,
    this.classId,
  });

  String id;
  String schoolId;
  String classId;

  factory ClassRepository.fromJson(Map<String, dynamic> json) =>
      ClassRepository(
        id: json["_id"],
        schoolId: json["school_id"],
        classId: json["class_id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "school_id": schoolId,
        "class_id": classId,
      };
}

class SchoolDetailsResponse {
  int status;
  int results;
  List<SchoolDetails> data;

  SchoolDetailsResponse({this.data, this.results, this.status});

  factory SchoolDetailsResponse.fromJson(Map<String, dynamic> response) =>
      SchoolDetailsResponse(
        data: response['data'] != null && response['data'] != []
            ? List<SchoolDetails>.from(
                response['data'].map((e) => SchoolDetails.fromJson(e)),
              )
            : [],
        results: response['results'],
        status: response['status'],
      );
}

class SubjectDetailsResponse {
  int status;
  int results;
  List<Subjects> data;

  SubjectDetailsResponse({this.data, this.results, this.status});

  factory SubjectDetailsResponse.fromJson(Map<String, dynamic> response) =>
      SubjectDetailsResponse(
        data: List<Subjects>.from(
          response['data'].map((e) => Subjects.fromJson(e)),
        ),
        results: response['results'],
        status: response['status'],
      );
}

class SchoolClassDetails {
  String classId;
  String className;
  String createdBy;
  List<ClassSection> sections;

  SchoolClassDetails({
    this.classId,
    this.className,
    this.createdBy,
    this.sections,
  });

  @override
  String toString() {
    return 'School-class-details: $classId, $className';
  }

  factory SchoolClassDetails.fromJson(Map<String, dynamic> data) {
    // try {
      return SchoolClassDetails(
        classId: data['classId'],
        className: data['className'],
        createdBy: data['createdBy'],
        sections: data['section'] == null
            ? []
            : List<ClassSection>.from(
                data['section'].map((e) => ClassSection.fromJson(e)),
              ),
      );
    // }  catch (e) {
    //   // TODO
    //   log(e.runtimeType.toString());
    // }
  }

  Map<String, dynamic> toJson() {
    return {
      "classId": classId,
      "className": className,
      "createdBy": createdBy,
    };
  }

  @override
  int get hashCode => classId.hashCode;

  @override
  bool operator ==(Object other) =>
      other is SchoolClassDetails && classId == other.classId;
}

class ClassSection {
  String id;
  String name;
  double progress;
  int studentCount;

  ClassSection({
    this.id,
    this.name,
    this.progress = 0,
    this.studentCount,
  });

  factory ClassSection.fromJson(Map<String, dynamic> data) {
    return ClassSection(
        id: data['id'], name: data['name'], studentCount: data['studentCount']);
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is ClassSection && id == other.id;
}

class SchoolBranch {
  String name;
  String address;
  String city;
  String state;
  int contact;
  String pincode;

  SchoolBranch({
    this.address,
    this.city,
    this.contact,
    this.name,
    this.pincode,
    this.state,
  });

  factory SchoolBranch.fromJson(Map<String, dynamic> data) {
    // try {
      return SchoolBranch(
        name: data['name'],
        address: data['address'],
        city:data['city'] != null ? data['city']['city_name']:null,
        state:data['state'] != null ? data['state']['state_name']:null,
        contact: data['contact'],
        pincode: data['pincode'].toString(),
      );
    // }  catch (e) {
    //   // TODO
    //   log(e.runtimeType.toString());
    //   if(e is NoSuchMethodError)
    //     {
    //       log(e.stackTrace.toString());
    //     }
    // }
  }
}

class SchoolDetails {
  SchoolDetails({
    this.classDetails,
    this.subjectList,
    this.syllabusList,
    this.address,
    this.branch,
    this.board,
    this.city,
    this.contactNo,
    this.country,
    this.createdAt,
    this.email,
    this.id,
    this.repository,
    this.sType,
    this.schoolImage,
    this.schoolName,
    this.state,
    this.updatedAt,
  });

  List<SchoolClassDetails> classDetails;
  List<dynamic> subjectList;
  List<String> syllabusList;
  List<SchoolBranch> branch;
  List<Repository> repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String schoolName;
  String schoolImage;
  String board;
  String email;
  int contactNo;
  String sType;
  String address;
  String city;
  String state;
  String country;

  factory SchoolDetails.fromJson(Map<String, dynamic> data) {

    // try {
      return SchoolDetails(
        repository: List<Repository>.from(
          data['repository'].map((e) => Repository.fromJson(e)),
        ),
        createdAt: DateTime.parse(data['createdAt']),
        updatedAt: DateTime.parse(data['updatedAt']),
        id: data['_id'],
        address: data['address'],
        board: data['board'],
        email: data['email'],
        contactNo: data['contact_number'],
        sType: data['sType'] is Map<String,dynamic> ? data['sType']['stype'] : data['sType'],
        branch: List<SchoolBranch>.from(
          data['branch'].map((e) => SchoolBranch.fromJson(e)),
        ),
        city: data['city'].toString(),
        classDetails: List<SchoolClassDetails>.from(
          data['classList'].map((e) => SchoolClassDetails.fromJson(e)),
        ),
        country: data['country'].toString(),
        schoolImage: data['schoolImage'],
        schoolName: data['schoolName'],
        state: data['state'].toString(),
        subjectList: data['subjectList'],
        syllabusList: List<String>.from(data['syllabusList'].map((e) => e)),
      );
    // }  catch (e) {
    //   // TODO
    //   log(e.toString());
    //   if(e is NoSuchMethodError)
    //     {
    //       log(e.stackTrace.toString());
    //     }
    //   if(e is TypeError)
    //   {
    //     log(e.stackTrace.toString());
    //   }
    // }
  }

// Map<String, dynamic> toJson() {
//   return {
//     "repository": List<dynamic>.from(
//       repository.map((e) => e.toJson()),
//     ),
//     "createdAt": createdAt.toIso8601String(),
//     "updatedAt": updatedAt.toIso8601String(),
//     "_id": id,
//     "name": name,
//     "description": description,
//     "createdBy": createdBy,
//   };
// }
}

class Subjects {
  List<Repository> repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String name;
  String description;
  String createdBy;
  String updatedBy;
  List<dynamic> files;

  Subjects({
    this.createdAt,
    this.createdBy,
    this.description,
    this.files,
    this.id,
    this.name,
    this.repository,
    this.updatedAt,
    this.updatedBy,
  });

  factory Subjects.fromJson(Map<String, dynamic> data) {
    return Subjects(
      id: data['_id'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      name: data['name'],
      description: data['description'],
      createdBy: data['createdBy'],
      files: data['files_upload'],
      repository: List<Repository>.from(
        data['repository'].map((e) => Repository.fromJson(e)),
      ),
      updatedBy: data['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Subjects && id == other.id;
}

// class Chapters {
//   List<dynamic> aboutFile;
//   List<Repository> repository;
//   String id;
//   String name;
//   List<UploadedFiles> filesUpload;
//   String classId;
//   String boardId;
//   String subjectId;
//   String syllabusId;
//   String createdBy;
//   String updatedBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   Chapters({
//     this.aboutFile,
//     this.boardId,
//     this.classId,
//     this.createdAt,
//     this.createdBy,
//     this.filesUpload,
//     this.id,
//     this.name,
//     this.repository,
//     this.subjectId,
//     this.syllabusId,
//     this.updatedAt,
//     this.updatedBy,
//   });

//   factory Chapters.fromJson(Map<String, dynamic> data) {
//     return Chapters(
//       aboutFile: data['about_file'] ?? [],
//       boardId: data['board_id'] ?? "",
//       classId: data['class_id'] ?? "",
//       createdAt: DateTime.parse(data['createdAt']),
//       createdBy: data['created_by'] ?? "",
//       filesUpload: List<UploadedFiles>.from(
//         data['files_upload'].map((e) => UploadedFiles.fromJson(e)),
//       ),
//       id: data['_id'],
//       name: data['name'],
//       repository: data['repository'] != null
//           ? List<Repository>.from(
//               data['repository'].map((e) => Repository.fromJson(e)),
//             )
//           : [],
//       subjectId: data['subject_id'] ?? "",
//       syllabusId: data['syllabus_id'] ?? "",
//       updatedAt: DateTime.parse(data['updatedAt']),
//       updatedBy: data['updated_by'] ?? "",
//     );
//   }
// }

// class Topics {
//   String id;
//   String name;
//   List<UploadedFiles> filesUpload;
//   String classId;
//   Subjects subjectId;
//   Chapters chapterId;
//   String createdBy;
//   DateTime createdAt;
//   DateTime updatedAt;
//   Topics({
//     this.classId,
//     this.createdAt,
//     this.createdBy,
//     this.chapterId,
//     this.filesUpload,
//     this.id,
//     this.name,
//     this.subjectId,
//     this.updatedAt,
//   });

//   factory Topics.fromJson(Map<String, dynamic> data) {
//     return Topics(
//       classId: data['class_id'] ?? "",
//       createdAt: DateTime.parse(data['createdAt']),
//       createdBy: data['created_by'] ?? "",
//       chapterId: Chapters.fromJson(data['chapter_id']),
//       filesUpload: List<UploadedFiles>.from(
//         data['files_upload'].map((e) => UploadedFiles.fromJson(e)),
//       ),
//       id: data['_id'],
//       name: data['name'],
//       subjectId: Subjects.fromJson(data['subject_id']),
//       updatedAt: DateTime.parse(data['updatedAt']),
//     );
//   }
// }

class ScheduledClassTask {
  DateTime startDate;
  DateTime endDate;
  List<String> files;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  DateTime startTime;
  DateTime endTime;
  String subjectName;
  String chapterName;
  String classRepeat;
  String teacherName;
  String teacherId;
  bool editable;
  String meetingLink;
  List<StudentJoin> studentJoin;
  String description;
  List<AssignTo> assignTo;
  String activityType;
  List<Repository> repository;
  String publishedWith;
  String createdBy;
  String linkedId;
  bool onGoing;
  List<AssignToYou> assignTo_you;

  ScheduledClassTask(
      {this.assignTo,
      this.chapterName,
      this.classRepeat,
      this.editable = false,
      this.publishedWith,
      this.onGoing = false,
      this.createdAt,
      this.createdBy,
      this.activityType = 'class',
      this.description,
      this.endDate,
      this.endTime,
      this.files,
      this.id,
      this.meetingLink,
      this.repository,
      this.teacherName,
      this.startDate,
      this.startTime,
      this.studentJoin,
      this.subjectName,
      this.teacherId,
      this.updatedAt,
      this.linkedId,
      this.assignTo_you});

  factory ScheduledClassTask.fromJson(Map<String, dynamic> data) {
    // try {
      return ScheduledClassTask(
        assignTo: data['assign_To'] == null
            ? []
            : List<AssignTo>.from(
                data['assign_To'].map((e) => AssignTo.fromJson(e)),
              ),
        chapterName: data["chapter_name"],
        classRepeat: data['does_class_repeat'],
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.tryParse(data['createdAt']),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.tryParse(data['updatedAt']),
        createdBy: data['createdBy'],
        description: data['description'],
        linkedId: data['linked_id'],
        endDate: data['class_end_Date'] != null ?
             DateTime.parse(data['class_end_Date']).toLocal():null,
        startDate:
            data['class_start_Date'] != null ? DateTime.parse(data['class_start_Date']).toLocal():null,
        endTime: DateTime.tryParse(data['class_end_time']).toLocal() ?? DateTime.now(),
        startTime:
            DateTime.tryParse(data['class_start_time']).toLocal() ?? (DateTime.now()),
        teacherName: data['teacher_id'] != null
            ? data['teacher_id'] is String
                ? data['teacher_id']
                : UserInfo.fromJson(data['teacher_id']).name
            : '',
        teacherId: data['teacher_id'] != null
            ? data['teacher_id'] is String
                ? data['teacher_id']
                : UserInfo.fromJson(data['teacher_id']).id
            : '',
        files: data['files'] == null
            ? []
            : List<String>.from(data['files'].map((e) => e)),
        id: data['_id'],
        meetingLink: data['meeting_link'],
        repository: data['repository'] == null
            ? []
            : List<Repository>.from(
                data['repository'].map((e) => Repository.fromJson(e)),
              ),
        studentJoin: List<StudentJoin>.from(
          data['student_join_class'].map((e) => StudentJoin.fromJson(e)),
        ),
        subjectName: data['subject_name'],
        assignTo_you: data['assign_To_you'] != null
            ? List<AssignToYou>.from(
                data['assign_To_you'].map((e) => AssignToYou.fromJson(e)))
            : [],
      );
    // }  catch (e) {
    //   // TODO
    //   log(e.runtimeType.toString());
    //   if(e is NoSuchMethodError)
    //     {
    //       log(e.stackTrace.toString());
    //     }
    // }
  }

  Map<String, dynamic> toJson() {
    return {
      "class_start_Date": [DateFormat('yyyy-MM-dd').format(startTime.toUtc())],
      "class_end_Date": DateFormat('yyyy-MM-dd').format(endDate != null ?endDate.toUtc() : DateTime.now().toUtc()),
      "class_start_time": '${startTime.toIso8601String()}',
      "class_end_time": '${endTime.toIso8601String()}',
      "subject_name": '$subjectName',
      "chapter_name": '$chapterName',
      "does_class_repeat": '$classRepeat',
      "teacher_id": '$teacherId',
      "meeting_link": '$meetingLink',
      "assign_To": assignTo != null
          ? List<dynamic>.from(
              assignTo.map((e) => e.toJson()),
            )
          : [],
      "description": '$description',
      "files": files,
      "createdBy": createdBy,
      "repository": repository != null
          ? List<dynamic>.from(
              repository.map((e) => e.toJson()),
            )
          : [],
      'assign_To_you': assignTo_you != null
          ? List<dynamic>.from(assignTo_you.map((e) => e.toJson()))
          : []
    };
  }
}

class ScheduleClassUpdate {
  String meetingLink;
  String description;
  List<String> files;

  ScheduleClassUpdate({this.meetingLink, this.description, this.files});

  Map<String, dynamic> toJson() {
    return {
      'meeting_link': meetingLink,
      'description': description,
      'files': files
    };
  }
}

class StudentJoin {
  String id;
  String classId;
  StudentInfo student;
  DateTime joinDate;

  StudentJoin({
    this.id,
    this.classId,
    this.student,
    this.joinDate,
  });

  factory StudentJoin.fromJson(Map<String, dynamic> data) {
    return StudentJoin(
      id: data['_id'],
      joinDate: DateTime.parse(data['join_date']).toLocal(),
      classId: data['class_id']['_id'],
      student: data['student_id'] != null
          ? StudentInfo.fromJson(data['student_id'])
          : StudentInfo(),
    );
  }
}
