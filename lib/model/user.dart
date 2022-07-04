import 'dart:convert';

import 'package:growonplus_teacher/export.dart';

import '/model/class-schedule.dart';
import '../model/activity.dart';

User userFromJson(String str) => User.fromJson(jsonDecode(str));

String userToJson(UserInfo data) => json.encode(data.toJson());

class User {
  User({
    this.userInfo,
  });

  List<UserInfo> userInfo;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userInfo:
            List<UserInfo>.from(json["data"].map((x) => UserInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "user_info": List<dynamic>.from(userInfo.map((x) => x.toJson())),
      };
}

class UserSubject {
  String id;
  String name;

  UserSubject({
    this.id,
    this.name,
  });

  factory UserSubject.fromJson(Map<String, dynamic> data) {
    return UserSubject(
      id: data['_id'],
      name: data['name'],
    );
  }
}

class SecondaryClass {
  String classId;
  String sectionId;
  String sectionName;
  String className;

  SecondaryClass({
    this.classId,
    this.className,
    this.sectionId,
    this.sectionName,
  });

  factory SecondaryClass.fromJson(Map<String, dynamic> data) {
    return SecondaryClass(
      classId: data['classId'],
      className: data['className'],
      sectionId: data['sectionId'],
      sectionName: data['sectionName'],
    );
  }
}

class UserInfo {
  UserInfo(
      {this.secondaryProfileType,
      this.secondaryClass,
      this.subject,
      this.otherDegrees,
      this.certifications,
      this.extraAchievement,
      this.repository,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.username,
      this.name,
      this.mobile,
      this.profileType,
      this.schoolId,
      this.branchId,
      this.gender,
      this.password,
      this.qualification,
      this.dob,
      this.email,
      this.address,
      this.aadhar,
      this.bloodGrp,
      this.religion,
      this.caste,
      this.motherTongue,
      this.graduationDetails,
      this.leadershipExp,
      this.level,
      this.maritalStatus,
      this.cv,
      this.mastersDetails,
      this.pincode,
      this.tenDetails,
      this.twelveDetails,
      this.v,
      this.about,
      this.classId,
      this.profileImage,
      this.pin,
        this.isAuthorized,
      });

  List<dynamic> secondaryProfileType;
  List<SecondaryClass> secondaryClass;
  List<UserSubject> subject;
  List<dynamic> otherDegrees;
  List<dynamic> certifications;
  List<dynamic> extraAchievement;
  List<dynamic> repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String username;
  String name;
  int mobile;
  UserProfileType profileType;
  SchoolId schoolId;
  String branchId;
  String gender;
  String password;
  String qualification;
  String dob;
  String email;
  String address;
  int aadhar;
  String bloodGrp;
  String religion;
  String caste;
  String motherTongue;
  String maritalStatus;
  String level;
  String leadershipExp;
  String cv;
  Details tenDetails;
  Details twelveDetails;
  Details graduationDetails;
  Details mastersDetails;
  String about;
  dynamic v;
  String pincode;
  SchoolClassDetails classId;
  String profileImage;
  String pin;
  bool isAuthorized;

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    // try {
    return UserInfo(
        subject: json['subject'] == null
            ? null
            : List<UserSubject>.from(
                json["subject"].map((e) => UserSubject.fromJson(e))),
        repository:
            List<dynamic>.from((json["repository"] ?? []).map((x) => x)),
        certifications:
            List<dynamic>.from((json["certifications"] ?? []).map((x) => x)),
        extraAchievement:
            List<dynamic>.from((json["extra_achievement"] ?? []).map((x) => x)),
        secondaryClass: json['secondary_class'] == null
            ? []
            : List<SecondaryClass>.from(
                json["secondary_class"].map((x) => SecondaryClass.fromJson(x)),
              ),
        isAuthorized: json['authorized'],
        otherDegrees:
            List<dynamic>.from((json["other_degrees"] ?? []).map((x) => x)),
        secondaryProfileType: List<dynamic>.from(
            (json["secondary_profile_type"] ?? []).map((x) => x)),
        leadershipExp: json['leaderShip_Exp'],
        cv: json["cv"],
        level: json["level"],
        gender: json["gender"],
        maritalStatus: json["marital_status"],
        pincode: json["pin"].toString(),
        qualification: json["qualification"],
        religion: json["religion"],
        about: json['about_me'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        id: json["_id"],
        username: json["username"],
        password: '${json["password"]}',
        pin: '${json['pin']}',
        schoolId: json['school_id'] != null ? json['school_id'] is Map<String,dynamic> ? SchoolId.fromJson(json['school_id']):null:json['school_id'],
        branchId: json["branch_id"],
        name: json["name"],
        mobile: json["mobile"],
        dob: json["dob"],
        profileType: json['profile_type'] != null
            ? json['profile_type'] is String
                ? null
                : UserProfileType.fromJson(json['profile_type'])
            : UserProfileType(),
        email: json["email"],
        address: json["address"],
        aadhar: json["aadhar_card"],
        caste: json["caste"],
        motherTongue: json["mother_tounge"],
        bloodGrp: json["blood_gr"],
        v: json["__v"],
        classId: SchoolClassDetails(
          classId: json['primary_class'] == null
              ? null
              : json['primary_class'] is String
                  ? json['primary_class']
                  : json['primary_class']['_id'],
          className: json['primaryClassName'] == null
              ? null
              : json['primaryClassName'],
          sections: [
            ClassSection(
              id: json['primary_section'],
              name: json['primarySectionName'],
            ),
          ],
        ),
        profileImage: json['profile_image'],

    );
    // } catch (e) {
    //   log(e.toString() + e.runtimeType.toString());
    // }
  }

  Map<String, dynamic> toJson() => {
        "secondary_profile_type": secondaryClass,
        "secondary_class": secondaryClass,
        "subject": subject,
        "other_degrees": otherDegrees,
        "certifications": certifications,
        "extra_achievement": extraAchievement,
        "repository": repository,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "_id": id,
        "username": username,
        "name": name,
        "mobile": mobile,
        "school_id": schoolId,
        "branch_id": branchId,
        "gender": gender,
        "password": password,
        "qualification": qualification,
        "dob": dob,
        "email": email,
        "address": address,
        "aadhar_card": aadhar,
        "blood_gr": bloodGrp,
        "religion": religion,
        "caste": caste,
        "mother_tounge": motherTongue,
        "marital_status": maritalStatus,
        "level": level,
        "leaderShip_Exp": leadershipExp,
        "cv": cv,
        "__v": v,
        "pincode": pincode,
        "primary_class": classId.toJson(),
      };
}

class UserProfileType {
  List<Repository> repository;
  String id;
  String roleName;
  String displayName;
  String description;
  String type;
  UserPrivilege privilege;
  DateTime createdAt;
  DateTime updatedAt;

  UserProfileType({
    this.createdAt,
    this.description,
    this.displayName,
    this.id,
    this.privilege,
    this.repository,
    this.roleName,
    this.type,
    this.updatedAt,
  });

  factory UserProfileType.fromJson(Map<String, dynamic> data) {
    return UserProfileType(
      // repository: List<Repository>.from(
      //   data['repository'].map((e) => Repository.fromJson(e)),
      // ),
      id: data['_id'],
      roleName: data['role_name'],
      displayName: data['display_name'],
      // createdAt: DateTime.parse(data['createdAt']),
      // updatedAt: DateTime.parse(data['updatedAt']),
      privilege: data['privilege'] == null
          ? null
          : UserPrivilege.fromJson(data['privilege']),
      description: data['description'],
      type: data['type'],
    );
  }
}

class UserPrivilege {
  final bool addClass;
  final bool addBoard;
  final bool createQuestion;
  final bool createQuestionPaper;
  final bool viewQuestionPaper;
  final bool addSyllabus;
  final bool addSubject;
  final bool addChapter;
  final bool addTopic;
  final bool addLearningOutcome;
  final bool addQuestionCategory;
  final bool addExamTypes;
  final bool addQa;
  final bool addAssessment;
  final bool createSchool;
  final bool createStudent;
  final bool createTeacher;
  final bool createPrinciple;
  final bool createManagement;

  UserPrivilege({
    this.addClass,
    this.addBoard,
    this.createQuestion,
    this.createQuestionPaper,
    this.viewQuestionPaper,
    this.addSyllabus,
    this.addSubject,
    this.addChapter,
    this.addTopic,
    this.addLearningOutcome,
    this.addQuestionCategory,
    this.addExamTypes,
    this.addQa,
    this.addAssessment,
    this.createSchool,
    this.createStudent,
    this.createTeacher,
    this.createPrinciple,
    this.createManagement,
  });

  factory UserPrivilege.fromJson(Map<String, dynamic> data) {
    return UserPrivilege(
      addClass: data['add_class'],
      addBoard: data['add_board'],
      createQuestion: data['create_question'],
      createQuestionPaper: data['create_question_paper'],
      viewQuestionPaper: data['view_question_paper'],
      addSyllabus: data["add_syllubus"],
      addSubject: data['add_subject'],
      addChapter: data['add_chapter'],
      addTopic: data['add_topic'],
      addLearningOutcome: data['add_learning_outcome'],
      addQuestionCategory: data['add_question_category'],
      addExamTypes: data['add_exam_types'],
      addQa: data['add_qa'],
      addAssessment: data['add_assessment'],
      createSchool: data['create_school'],
      createStudent: data['create_student'],
      createManagement: data['create_management'],
      createPrinciple: data['create_principle'],
      createTeacher: data['create_teacher'],
    );
  }
}

class ParentInfo {
  List<dynamic> languageProficiency;
  dynamic mLanguageProficiency;
  dynamic gLanguageProficiency;
  List<Repository> repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String username;
  String password;
  String profileType;
  String guardian;
  String fatherName;
  String fContactNumber;
  String mobileToRegStudent;
  String fMail;
  String fQualification;
  String fAadhar;
  String motherName;
  String mContactNumber;
  String mMobileToRegStudent;
  String mMail;
  String mQualification;
  String mAadhar;
  String guardianName;
  String gContactNumber;
  String gMobileToRegStudent;
  String gMail;
  String gQualification;
  String gAadhar;
  String profileImage;

  ParentInfo({
    this.createdAt,
    this.fAadhar,
    this.fContactNumber,
    this.fMail,
    this.fQualification,
    this.fatherName,
    this.profileImage,
    this.gAadhar,
    this.gContactNumber,
    this.gLanguageProficiency,
    this.gMail,
    this.gMobileToRegStudent,
    this.gQualification,
    this.guardian,
    this.guardianName,
    this.id,
    this.languageProficiency,
    this.mAadhar,
    this.mContactNumber,
    this.mLanguageProficiency,
    this.mMail,
    this.mMobileToRegStudent,
    this.mQualification,
    this.mobileToRegStudent,
    this.motherName,
    this.password,
    this.profileType,
    this.repository,
    this.updatedAt,
    this.username,
  });

  factory ParentInfo.fromJson(Map<String, dynamic> data) {
    return ParentInfo(
      id: data['_id'],
      username: data['username'],
      password: data['password'],
      profileType: data['profile_type'],
      guardian: data['guardian'],
      fatherName: data['father_name.'],
      fContactNumber: data['f_contact_number'],
      mobileToRegStudent: data['mobile_to_reg_student'],
      fMail: data['f_email'],
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      updatedAt:
          data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : null,
      motherName: data['mother_name'],
      gLanguageProficiency: data['g_language_proficiency'],
      languageProficiency: data['language_proficiency'],
      mLanguageProficiency: data['m_language_proficiency'],
      profileImage: data['profile_image'],
    );
  }
}

class Details {
  Details({
    this.board,
    this.docs,
    this.percentage,
    this.school,
    this.yearOfPassing,
  });

  String school;
  String board;
  String percentage;
  String yearOfPassing;
  String docs;

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        board: json["Board"],
        docs: json["Attach_doc"],
        percentage: json["percentage"].toString(),
        school: json["school"],
        yearOfPassing: json["year_of_passing"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "school": school,
        "Board": board,
        "percentage": percentage,
        "year_of_passing": yearOfPassing,
        "Attach_doc": docs,
      };
}

// class Repository {
//   Repository({
//     this.id,
//     this.branchName,
//     this.repositoryType,
//   });

//   String id;
//   String branchName;
//   String repositoryType;

//   factory Repository.fromJson(Map<String, dynamic> json) => Repository(
//         id: json["id"],
//         branchName: json["branch_name"],
//         repositoryType: json["repository_type"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "branch_name": branchName,
//         "repository_type": repositoryType,
//       };
// }

class LanguageProficiency {
  LanguageProficiency({
    this.languageOne,
    this.languageTwo,
    this.languageThree,
    this.languageFour,
  });

  Language languageOne;
  Language languageTwo;
  Language languageThree;
  Language languageFour;

  factory LanguageProficiency.fromJson(Map<String, dynamic> json) =>
      LanguageProficiency(
        languageOne: Language.fromJson(json["languageOne"]),
        languageTwo: Language.fromJson(json["languageTwo"]),
        languageThree: Language.fromJson(json["languageThree"]),
        languageFour: Language.fromJson(json["languageFour"]),
      );

  Map<String, dynamic> toJson() => {
        "languageOne": languageOne.toJson(),
        "languageTwo": languageTwo.toJson(),
        "languageThree": languageThree.toJson(),
        "languageFour": languageFour.toJson(),
      };
}

class Language {
  Language({
    this.languageName,
    this.read,
    this.write,
    this.speak,
  });

  String languageName;
  String read;
  String write;
  String speak;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        languageName: json["languageName"],
        read: json["read"],
        write: json["write"],
        speak: json["speak"],
      );

  Map<String, dynamic> toJson() => {
        "languageName": languageName,
        "read": read,
        "write": write,
        "speak": speak,
      };
}

class Students {
  final String result;
  List<StudentInfo> students;

  Students({this.result, this.students});

  factory Students.fromJson(Map<String, dynamic> data) => Students(
        result: data["result"].toString(),
        students: List<StudentInfo>.from(
          data["data"].map((x) => StudentInfo.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() {
    return {
      "result": result,
      "data": List<dynamic>.from(
        students.map((e) => e.toJson()),
      ),
    };
  }
}

class StudentInfo {
  StudentInfo(
      {this.subject,
      this.repository,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.username,
      this.password,
      this.schoolId,
      this.branchId,
      this.name,
      this.contactNumber,
      this.dob,
      this.email,
      this.address,
      this.aadhar,
      this.stsNo,
      this.rteStudent,
      this.parent,
      this.caste,
      this.motherTongue,
      this.bloodGr,
      this.userInfoClass,
      this.modeOfTransp,
      this.medicalCond,
      this.wearGlasses,
      this.section,
      this.parentId,
      this.vehicleId,
      this.v,
      this.profileImage,
      this.taskEvaluated,
      this.studentProgress,
      this.className,
      this.sectionName,
      this.totalStudent});

  @override
  String toString() {
    return 'Student-Info: $name';
  }

  List<dynamic> subject;
  List<dynamic> repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String profileImage;
  String username;
  String password;
  String schoolId;
  String branchId;
  String name;
  String userInfoClass;
  ParentInfo parent;
  dynamic contactNumber;
  String dob;
  String email;
  String address;
  String aadhar;
  String stsNo;
  String rteStudent;
  bool taskEvaluated;
  String caste;
  String motherTongue;
  String bloodGr;
  String modeOfTransp;
  String medicalCond;
  String wearGlasses;
  String parentId;
  String section;
  String className;
  String sectionName;
  String vehicleId;
  double studentProgress;
  int totalStudent;
  int v;

  // AttendanceType attendanceType = AttendanceType.present;
  String status = 'present';

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    // try {
    return StudentInfo(
        subject: json["subject"] ?? [],
        repository: json["repository"] ?? [],
        id: json["_id"],
        username: json["username"],
        password: json["password"],
        schoolId: json['school_id'] is Map<String, dynamic>
            ? json["school_id"]['_id']
            : json['school_id'],
        branchId: json["branch_id"],
        sectionName: json['section'] != null
            ? (json['section'] is Map<String, dynamic>
                ? json['section']['name']
                : json['section'])
            : null,
        name: json["name"],
        contactNumber: json["contact_number"],
        dob: json["dob"],
        profileImage: json["profile_image"],
        email: json["email"],
        parent: (json['parent_id'] == null)
            ? null
            : json['parent_id'] is String
                ? ParentInfo(
                    id: json['parent_id'], fatherName: json['parentName'])
                : ParentInfo.fromJson(json['parent_id']),
        address: json["address"],
        aadhar: json["aadhar"],
        stsNo: json["sts_no"],
        rteStudent: json["rte_student"],
        caste: json["caste"],
        motherTongue: json["mother_tongue"],
        bloodGr: json["blood_gr"],
        modeOfTransp: json["mode_of_transp"],
        // medicalCond: json["medical_cond"],
        wearGlasses: json["wear_glasses"],
        userInfoClass: json['class'] != []
            ? json['class'] is Map<String, dynamic>
                ? json["class"]['_id']
                : json['class']
            : null,
        className: json['class'] != []
            ? json['class'] is Map<String, dynamic>
                ? json["class"]['name']
                : json['class']
            : null,
        section: json["section"] != null
            ? (json['section'] is Map<String, dynamic>
                ? json['section']['_id']
                : '')
            : json['section'],
        vehicleId: json["vehicle_id"],
        studentProgress: json['studentProgress'] != null
            ? json['studentProgress'].toDouble()
            : 0,
        v: json["__v"],

        totalStudent: json["totalStudentsInClass"]);
    // } catch (e) {
    //   // TODO
    //   log(e.toString());
    //   if (e is TypeError) {
    //     log(e.stackTrace.toString());
    //   }
    //   if (e is ArgumentError) {
    //     log(e.stackTrace.toString());
    //   }
    // }
  }

  Map<String, dynamic> toJson() => {
        "subject": List<dynamic>.from(subject.map((x) => x)),
        "repository": List<dynamic>.from(repository.map((x) => x)),
        "createdAt": createdAt != null ? createdAt.toIso8601String() : null,
        "updatedAt": updatedAt != null ? updatedAt.toIso8601String() : null,
        "_id": id,
        "username": username,
        "password": password,
        "school_id": schoolId,
        "branch_id": branchId,
        "name": name,
        "contact_number": contactNumber,
        "dob": dob,
        "email": email,
        "address": address,
        "profile_image": profileImage,
        "aadhar": aadhar,
        "sts_no": stsNo,
        "rte_student": rteStudent,
        "caste": caste,
        "mother_tongue": motherTongue,
        "blood_gr": bloodGr,
        "mode_of_transp": modeOfTransp,
        "medical_cond": medicalCond,
        "wear_glasses": wearGlasses,
        "class": userInfoClass,
        "section": section,
        "vehicle_id": vehicleId,
        "__v": v,
      };

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is StudentInfo && id == other.id;
}

class Class {
  Class({
    this.repository,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.v,
  });

  List<Repository> repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  String name;
  String description;
  String createdBy;
  int v;

  factory Class.fromJson(Map<String, dynamic> json) => Class(
        repository: json["repository"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        createdBy: json["createdBy"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "_id": id,
        "name": name,
        "description": description,
        "createdBy": createdBy,
        "__v": v,
      };
}

class Groups {
  List<SingleGroup> group;

  Groups(this.group);

  factory Groups.fromJson(List data) => Groups(
        List<SingleGroup>.from(
          data.map(
            (e) => SingleGroup.fromJson(e),
          ),
        ),
      );
}

class SingleGroup {
  String id;
  String name;
  String schoolId;
  List<GroupStudents> groupStudents;
  String schoolName;
  String createdBy;
  List<GroupUsers> groupUsers;
  String teacherId;

  SingleGroup({
    this.groupStudents,
    this.id,
    this.name,
    this.schoolId,
    this.schoolName,
    this.createdBy,
    this.groupUsers,
    this.teacherId
  });

  factory SingleGroup.fromJson(Map<String, dynamic> data) {
    // try {
      return SingleGroup(
        id: data["_id"],
        name: data["group_name"],
        schoolId: data['school_id']['_id'],
        schoolName: data['school_id']['schoolName'],
        createdBy: data['teacher_id']['name'],
        groupStudents: data["students"] != null ? List<GroupStudents>.from(
          data["students"].map(
                (person) => GroupStudents.fromJson(person),
          ),
        ):[],
        groupUsers:data['users'] != null ? List<GroupUsers>.from(
          data['users'].map((e)=>GroupUsers.fromJson(e))
        ): [],
         teacherId: data['teacher_id']['_id']
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

  Map<String, dynamic> toJson() => {
        "group_name": name,
        "school_id": schoolId,
        "teacher_id": teacherId,
        "gr_person": List<dynamic>.from(
          groupStudents.map(
            (e) => e.toJson(),
          ),
        ),
      };
}


class GroupStudents {
  String id;
  String name;
  String profileImage;
  String parentId;
  String parentName;
  String parentProfileImage;
  String className;
  String sectionName;
  String classId;
  String sectionId;

  GroupStudents({
    this.id,
    this.name,
    this.classId,
    this.sectionId,
    this.className,
    this.sectionName,
    this.parentId,
    this.parentName,
    this.parentProfileImage,
    this.profileImage
  });

  factory GroupStudents.fromJson(Map<String, dynamic> data) {
    // try {
      return GroupStudents(
        parentId:data['parent_id'] != null ? data['parent_id']['_id'] : null,
        parentName:data['parent_id'] != null ? data['parent_id']['father_name'] : null,
        name:data['name'],
        classId:data['class'] != null ? data['class']['_id'] : null,
        sectionId:data['section'] != null ? data['section']['_id']:null,
        className:data['class'] != null ? data['class']['name'] : null,
        sectionName:data['section'] != null ? data['section']['name']:null,
        parentProfileImage:data['parent_id'] != null ? data['parent_id']['profile_image']:null,
        profileImage: data['profile_image'],
        id: data["_id"],
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
      // "student_name": name,
      "student_id": id,
      "class_id": classId,
      "section_id": sectionId,
    };
  }

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is GroupStudents && id == other.id;
}

class GroupUsers{
  String id;
  String name;
  String profileImage;
  String profileType;

  GroupUsers(
  {
    this.id,
    this.profileImage,
    this.name,
    this.profileType
  }
      );

  factory GroupUsers.fromJson(Map<String,dynamic> data){
    return GroupUsers(
      id: data['_id'],
      profileImage: data['profile_image'],
      name: data['name'],
      profileType: data['profile_type']
    );

  }

  Map<String,dynamic> toJson (){
    return {
      '_id':id,
      'profile_image':profileImage,
      'name':name,
      'profile_type':profileType
    };
  }
}



class SchoolId {
  SchoolId({
    this.institute,
    this.id,
    this.schoolName,
    this.schoolCode,
    this.schoolImage
  });

  Institute institute;
  String id;
  String schoolName;
  int schoolCode;
  String schoolImage;

  factory SchoolId.fromJson(Map<String, dynamic> json) => SchoolId(
    institute: json['institute'] != null ? Institute.fromJson(json["institute"]):null,
    id: json["_id"],
    schoolName: json["schoolName"],
    schoolCode: json["school_code"],
    schoolImage: json['schoolImage']
  );

  Map<String, dynamic> toJson() => {
    "institute": institute.toJson(),
    "_id": id,
    "schoolName": schoolName,
    "school_code": schoolCode,
  };
}

class Institute {
  Institute({
    this.profileImage,
    this.id,
    this.name,
  });

  String profileImage;
  String id;
  String name;

  factory Institute.fromJson(Map<String, dynamic> json) => Institute(
    profileImage: json["profile_image"],
    id: json["_id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "profile_image": profileImage,
    "_id": id,
    "name": name,
  };
}

