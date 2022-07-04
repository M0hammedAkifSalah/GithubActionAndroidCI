// To parse this JSON data, do
//
//     final activityFeedResponse = activityFeedResponseFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/user.dart';

SingleActivity singleActivityFromJson(String str) =>
    SingleActivity.fromJson(json.decode(str));

String singleActivityToJson(SingleActivity data) => json.encode(data.toJson());

class SingleActivity {
  SingleActivity({
    this.status,
    this.activity,
  });

  int status;
  Activity activity;

  factory SingleActivity.fromJson(Map<String, dynamic> json) => SingleActivity(
        status: json["status"],
        activity: Activity.fromJson(json["data"], ''),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": activity.toJson(),
      };
}

ActivityFeedResponse activityFeedResponseFromJson(
        String str, String teacherId) =>
    ActivityFeedResponse.fromJson(json.decode(str), teacherId);

String activityFeedResponseToJson(ActivityFeedResponse data) =>
    json.encode(data.toJson());

class ActivityFeedResponse {
  ActivityFeedResponse({
    this.result,
    this.data,
    this.teacherId,
  });

  int result;
  List<Activity> data;
  String teacherId;

  factory ActivityFeedResponse.fromJson(
          Map<String, dynamic> json, String teacherId) =>
      ActivityFeedResponse(
        result: json["result"],
        data: List<Activity>.from(
            json["data"].map((x) => Activity.fromJson(x, teacherId))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AnnouncementSubmission {
  String acknowledgeByStudent;
  String acknowledgeByTeacher;
  String acknowledgeByParent;
  DateTime submittedDate;
  String id;

  AnnouncementSubmission({
    this.acknowledgeByStudent,
    this.acknowledgeByParent,
    this.acknowledgeByTeacher,
    this.submittedDate,
    this.id,
  });

  factory AnnouncementSubmission.fromJson(Map<String, dynamic> data) {
    // try {
    return AnnouncementSubmission(
      acknowledgeByStudent:
          data['acknowledge_by'] == null ? null : data['acknowledge_by'],
      acknowledgeByTeacher: data['acknowledge_by_teacher'] == null
          ? null
          : data['acknowledge_by_teacher'].toString(),
      acknowledgeByParent: data['acknowledge_by_parent'] == null
          ? null
          : data['acknowledge_by_parent'] is List<dynamic>
              ? data['acknowledge_by_parent'].toString()
              : data['acknowledge_by_parent'],
      submittedDate: DateTime.parse(data['submitted_date']).toLocal(),
      id: data['_id'],
    );
    // } catch (e) {
    //   // TODO
    //   log('err 1 '+e.toString());
    // }
  }
}

class RewardData {
  String id;
  String studentId;
  int coin;
  int extraCoin;
  String rewardGiven;
  String reason;
  String status;

  RewardData({
    this.id,
    this.studentId,
    this.coin,
    this.extraCoin,
    this.reason,
    this.rewardGiven,
    this.status,
  });

  factory RewardData.fromJson(Map<String, dynamic> data) {
    if (data == null) return RewardData();
    return RewardData(
      id: data['_id'],
      studentId: data['student_id'],
      coin: data['coin'],
      extraCoin: data['extra_coin'],
      rewardGiven: data['reward_given'],
      reason: data['reason'],
      status: data['status'],
    );
  }
}

class Activity {
  Activity(
      {this.assignmentStarted = const [],
      this.going = const [],
      this.notGoing = const [],
      this.acknowledgeBy = const [],
      this.acknowledgeStartedBy = const [],
      this.createdAt,
      this.updatedAt,
      this.repository = const [],
      this.id,
      this.activityType,
      this.title,
      this.image,
      this.like,
      this.view,
      this.description,
      this.status,
      this.assignTo = const [],
      this.options = const [],
      this.startDate,
      this.endDate,
      this.dueDate,
      this.coin,
      this.files = const [],
      this.submitedBy = const [],
      this.comment = const [],
      this.teacherProfile,
      this.locations,
      this.selectedLivePoll = const [],
      this.teacherName,
      this.saved = false,
      this.className,
      this.selectedCheckList = const [],
      this.learningOutcome,
      this.subject,
      this.assignToYou = const [],
      this.assignToParent = const [],
      this.acknowledgeByTeacher = const [],
      this.goingByTeacher = const [],
      this.notGoingByTeacher = const [],
      this.forwarded,
      this.endTime,
      this.selectedCheckListByTeacher,
      this.selectedLivePollByTeacher,
      this.acknowledgeByParent = const [],
      this.reward,
      @required this.assigned,
      this.goingByParent = const [],
      this.notGoingByParent = const [],
      this.publishedDate,
      this.endDateTime,
      this.userReacted = false,
      this.liked = false,
      this.editable = false,
      this.likeBy = const [],
      this.links = const [],
      this.activityReward = const [],
      this.partiallyEvaluated = false,
      this.updateAssignmentStatus = false,
      teacherId,
      this.isOffline});

  List<dynamic> assignmentStarted;
  bool updateAssignmentStatus;
  bool partiallyEvaluated;
  List<String> going;
  List<String> notGoing;
  List<RewardData> activityReward;
  List<AnnouncementSubmission> acknowledgeBy;
  List<String> links;
  List<String> files = [];
  List<dynamic> acknowledgeStartedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<Repository> repository;
  String id;
  String activityType;
  String title;
  bool saved;
  bool liked;
  String image;
  String className;
  String subject;
  String learningOutcome;
  String teacherName;
  UserInfo teacherProfile;
  List<String> likeBy;
  DateTime publishedDate;
  int like;
  bool editable;
  int view;
  String description;
  String status;
  List<AssignTo> assignTo;
  List<Option> options;
  String startDate;
  int timeLeft;
  String endDate;
  String dueDate;
  int coin;
  int reward;
  List<SubmittedBy> submitedBy;
  List<SelectedOptions> selectedCheckList;
  List<AnnouncementSubmission> acknowledgeByTeacher;
  List<AnnouncementSubmission> acknowledgeByParent;
  List<String> goingByTeacher;
  List<String> goingByParent;
  List<String> notGoingByTeacher;
  List<String> notGoingByParent;
  List<ThreadComments> comment;
  String locations;
  List<AssignToTeacher> assignToYou;
  Assigned assigned;
  DateTime endDateTime;
  bool userReacted;
  List<AssignToParent> assignToParent;
  bool forwarded;
  List<SelectedOptions> selectedLivePoll;
  SelectedOptions selectedCheckListByTeacher;
  SelectedOptions selectedLivePollByTeacher;
  String endTime;
  UserInfo teacherId;
  bool isOffline;

  factory Activity.fromJson(Map<String, dynamic> json, String teacherId) {
    var _time;
    if (json['EndTime'] != null && DateTime.tryParse(json['EndTime']) != null) {
      _time = TimeOfDay.fromDateTime(
          DateTime.parse(json['EndTime'].toString()).toLocal());
    }
    // try {
    return Activity(
      activityReward: json['allRewards'] == null
          ? []
          : List<RewardData>.from(
              json['allRewards'].map((e) => RewardData.fromJson(e)),
            ),
      assignmentStarted:
          List<dynamic>.from(json["assignment_started"].map((x) => x)),
      going: List<String>.from(json["going"].map((x) => x)),
      goingByTeacher: List<String>.from(json["going_by_teacher"].map((x) => x)),
      goingByParent: List<String>.from(json["going_by_parent"].map((x) => x)),
      notGoing: List<String>.from(json["not_going"].map((x) => x)),
      notGoingByTeacher:
          List<String>.from(json["not_going_by_teacher"].map((x) => x)),
      notGoingByParent:
          List<String>.from(json["not_going_by_parent"].map((x) => x)),
      acknowledgeBy: json["acknowledge_by"] != null
          ? List<AnnouncementSubmission>.from(
              json["acknowledge_by"]
                  .map((x) => AnnouncementSubmission.fromJson(x)),
            )
          : [],
      acknowledgeByTeacher: List<AnnouncementSubmission>.from(
        json["acknowledge_by_teacher"]
            .map((x) => AnnouncementSubmission.fromJson(x)),
      ),
      acknowledgeByParent: json['acknowledge_by_parent'] != []
          ? List<AnnouncementSubmission>.from(
              json["acknowledge_by_parent"]
                  .map((x) => AnnouncementSubmission.fromJson(x)),
            )
          : [],
      links: json['links'] == null
          ? []
          : List<String>.from(json['links'].map((e) => e)),
      acknowledgeStartedBy:
          List<String>.from(json["acknowledge_started_by"].map((x) => x)),
      createdAt: DateTime.parse(json["createdAt"]).toLocal(),
      updatedAt: DateTime.parse(json["updatedAt"]).toLocal(),
      repository: json["repository"] != null
          ? List<Repository>.from(
              json["repository"].map((x) => Repository.fromJson(x)))
          : null,
      id: json["_id"],
      teacherProfile: UserInfo.fromJson(json['teacher_id']),
      activityType: json["activity_type"],
      title: json["title"],
      reward: json['reward'],
      image: json["image"],
      publishedDate: json['publish_date'] == null
          ? null
          : DateTime.parse(json['publish_date']).toLocal(),
      likeBy: json['like_by'] != null && json['like_by'] != []
          ? List<String>.from(
              json['like_by'].map((e) => '$e'),
            )
          : [],
      forwarded: json['forward'] == "true",
      like: json["like"] ?? 0,
      files: json['file'] != null
          ? List<String>.from(json["file"].map((e) => e))
          : [],
      view: json["view"],
      className: json["class_name"],
      subject: json['subject'],
      endTime: _time == null ? '' : '${_time.hour}:${_time.minute}',
      endDateTime: json['EndTime'] != null
          ? DateTime.tryParse(json['EndTime']) != null
              ? DateTime.parse(json['EndTime'].toString()).toLocal()
              : DateTime(2021)
          : DateTime(2021),
      learningOutcome: json['learning_Outcome'],
      selectedLivePoll: json['selected_livepool'] == null
          ? []
          : List<SelectedOptions>.from(
              json['selected_livepool'].map((e) => SelectedOptions.fromJson(e)),
            ),
      selectedCheckList: List<SelectedOptions>.from(
        json['selected_checkList'].map((e) => SelectedOptions.fromJson(e)),
      ),
      teacherId: json["teacher_id"] is String
          ? null
          : UserInfo.fromJson(json["teacher_id"]),
      description: json["description"],
      status: json["status"],
      assignTo: List<AssignTo>.from(
        json['assignTo'].map((x) => AssignTo.fromJson(x)),
      ),
      options:
          List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      startDate: json["StartTime"] ?? json['startDate'].toString(),
      endDate: json["EndDate"].toString(),
      dueDate: json["dueDate"].toString(),
      assignToYou: List<AssignToTeacher>.from(
        json['assignTo_you']
            .where((e) => e['teacher_id'] != null)
            .map((e) => AssignToTeacher.fromJson(e)),
      ),
      assignToParent: List<AssignToParent>.from(
        json['assignTo_parent'].map((e) => AssignToParent.fromJson(e)),
      ),
      coin: json["coin"] ?? null,
      submitedBy: json['activity_type'] != 'Assignment'
          ? []
          : json['submited_by'] != null
              ? List<SubmittedBy>.from(json["submited_by"].map((x) =>
                  SubmittedBy.fromJson(
                      x, DateTime.parse(json['EndTime']).toLocal())))
              : [],
      comment: json['comment'] == null
          ? []
          : List<ThreadComments>.from(
              json["comment"].map((x) => ThreadComments.fromJson(x, teacherId)),
            ),
      locations: json["locations"] ?? null,
      assigned: Assigned.student,
      isOffline: json['isOffline'] ?? false,
    );
    // } catch (e) {
    //   log(e.toString());
    //   if (e is NoSuchMethodError) {
    //     log(e.stackTrace.toString());
    //   }
    //   if (e is TypeError) {
    //     log(e.stackTrace.toString());
    //   }
    // }
  }

  Map<String, dynamic> toJson() => {
        "going": List<dynamic>.from(going.map((x) => x)),
        // "teacher_id": teacherId.toJson(),
        "not_going": List<dynamic>.from(notGoing.map((x) => x)),
        "acknowledge_by": List<dynamic>.from(acknowledgeBy.map((x) => x)),
        "acknowledge_started_by":
            List<dynamic>.from(acknowledgeStartedBy.map((x) => x)),
        // "createdAt": createdAt.toIso8601String(),
        // "updatedAt": updatedAt.toIso8601String(),
        "repository": List<dynamic>.from(repository.map((x) => x.toJson())),
        "_id": id,
        "activity_type": activityType,
        "title": title,
        "image": image,
        "like": like,
        "view": view,
        "description": description,
        "status": status,
        "assignTo": List<dynamic>.from(assignTo.map((x) => x.toJson())),
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "startDate": startDate,
        "EndDate": endDate,
        "dueDate": dueDate ?? null,
        "coin": coin ?? null,
        "comment": List<dynamic>.from(comment.map((x) => x)),
        "locations": locations ?? null,
        "assignTo_you": List<dynamic>.from(
          assignToYou.map((e) => {"teacher_id": e}),
        ),
        "assignTo_parent":
            List<dynamic>.from(assignToParent.map((e) => e.toJson())),
        "isOffline": isOffline
      };
}

enum Assigned {
  parent,
  teacher,
  student,
  faculty,
}

class AssignToTeacher {
  String teacherId;
  String name;
  String profileImage;
  String status;
  String activityId;

  AssignToTeacher({
    this.teacherId,
    this.name,
    this.profileImage,
    this.status,
    this.activityId,
  });

  factory AssignToTeacher.fromJson(Map<String, dynamic> data) {
    return AssignToTeacher(
      name: data['teacher_id']['name'],
      teacherId: data['teacher_id']['_id'],
      status: data['status'] ?? 'Pending',
      profileImage: data['teacher_id']['profile_image'],
      activityId: data['activity_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacherId,
    };
  }
}

class AssignToYou {
  AssignToYou({
    this.teacherId,
  });

  String teacherId;

  factory AssignToYou.fromJson(Map<String, dynamic> json) => AssignToYou(
        teacherId: json["teacher_id"],
      );

  Map<String, dynamic> toJson() => {
        "teacher_id": teacherId,
      };
}

class AssignToParent {
  String studentId;
  String parentId;
  String name;
  String status;
  String profileImage;
  String studentName;
  String studentProfileImage;

  AssignToParent({
    this.studentId,
    this.parentId,
    this.name,
    this.profileImage,
    this.studentName,
    this.status,
    this.studentProfileImage,
  });

  @override
  String toString() {
    return '$name';
  }

  factory AssignToParent.fromJson(Map<String, dynamic> data) {
    return AssignToParent(
      parentId: data['parent_id']['_id'],
      studentId: data['student_id'] is Map<String, dynamic>
          ? data['student_id']['_id']
          : data['student_id'],
      name: data['parent_id'] is Map<String, dynamic>
          ? data['parent_id']['father_name']
          : data['parent_id'],
      status: data['status'],
      profileImage: data['student_id'] is Map<String, dynamic>
          ? data['student_id']['profile_image']
          : data['profile_image'],
      studentName: data['student_id'] is Map<String, dynamic>
          ? data['student_id']['name'].toString()
          : ['name'].toString(),
      studentProfileImage: data['student_id'] is Map<String, dynamic>
          ? data['student_id']['profile_image']
          : data['profile_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "parent_id": parentId,
      "status": "Pending",
      "student_id": studentId,
    };
  }
}

class SubmittedBy {
  List<SubmittedMessage> message;
  String studentId;
  DateTime submittedDate;
  bool lateSubmission;
  int coins;
  String id;

  SubmittedBy({
    this.message,
    this.id,
    this.studentId,
    this.lateSubmission,
    this.submittedDate,
  });

  factory SubmittedBy.fromJson(
      Map<String, dynamic> data, DateTime endDateTime) {
    // try {
    return SubmittedBy(
      id: data['_id'],
      submittedDate: DateTime.parse(data['submitted_date']).toLocal(),
      lateSubmission:
          DateTime.parse(data['submitted_date']).isAfter(endDateTime),
      message: List<SubmittedMessage>.from(
        data['message'].map((e) => SubmittedMessage.fromJson(e)),
      ),
      studentId: data['student_id'],
    );
    // } catch (e) {
    //   // TODO
    //   log(e.toString() + e.runtimeType.toString());
    // }
  }
}

class SubmittedMessage {
  final String id;
  final String text;
  final List<String> file;
  final DateTime submittedDate;
  final bool evaluator;
  final bool isOffline;
  final String lateReason;

  SubmittedMessage({
    this.id,
    this.text,
    this.evaluator,
    this.isOffline = false,
    this.submittedDate,
    this.file,
    this.lateReason,
  });

  factory SubmittedMessage.fromJson(Map<String, dynamic> data) =>
      SubmittedMessage(
        id: data['_id'],
        submittedDate: DateTime.parse(data['submitted_date']).toLocal(),
        text: data['text'],
        evaluator: data['evaluator'],
        isOffline: data['is_offline'],
        file: data['file'] != null ? List<String>.from(data['file']) : [],
        lateReason: data['late_reason'] ?? null,
      );

  SubmittedMessage clone() => SubmittedMessage(
        id: this.id,
        submittedDate: this.submittedDate,
        text: this.text,
        evaluator: this.evaluator,
        isOffline: this.isOffline,
        file: this.file.toList(),
      );
}
// class SelectedOption {
//   SelectedOption({
//     this.options,
//     this.id,
//     this.selectedBy,
//   });

//   List<String> options;
//   String id;
//   String selectedBy;

//   factory SelectedOption.fromJson(Map<String, dynamic> json) => SelectedOption(
//         options: List<String>.from(json["options"].map((x) => x)),
//         id: json["_id"],
//         selectedBy: json["selected_by"],
//       );

//   Map<String, dynamic> toJson() => {
//         "options": List<dynamic>.from(options.map((x) => x)),
//         "_id": id,
//         "selected_by": selectedBy,
//       };
// }

class AssignTo {
  AssignTo(
      {this.classId,
      this.schoolId,
      this.branch,
      this.studentId,
      this.classes,
      this.status,
      this.className,
      this.sectionName,
      this.name,
      this.sectionId,
      this.profileImage,
      this.coins,
      this.studId,
      this.comment});

  String classId;
  List<String> classes;
  String schoolId;
  String comment;
  String sectionId;
  String sectionName;
  String branch;
  String status;
  String name;
  String className;
  int coins;
  String profileImage;
  StudentInfo studentId;
  String studId;

  factory AssignTo.fromJson(Map<String, dynamic> json) {
    return AssignTo(
        status: json['status'],
        classId: json['class_id'] != null
            ? json['class_id'] is Map<String, dynamic>
                ? json["class_id"]['_id']
                : json['class_id']
            : null,
        name: json['student_id'] != null
            ? json['student_id'] is Map<String, dynamic>
                ? json['student_id']['name']
                : json['student_id']
            : null,
        profileImage: json['studentProfile'] ?? json['profile_image'],
        studentId: json['student_id'] == null
            ? null
            : json['student_id'] is Map<String, dynamic>
                ? StudentInfo.fromJson(json['student_id'])
                : StudentInfo(id: json['student_id']),
        studId: json['student_id'] != null
            ? json['student_id'] is Map<String, dynamic>
                ? json['student_id']['_id']
                : json['student_id']
            : null,
        classes: json['class_id'] is List
            ? List<String>.from(json['class_id'].map((e) => e))
            : [
                json['class_id'] != null
                    ? json['class_id'] is Map<String, dynamic>
                        ? json['class_id']['name']
                        : json['class_id']
                    : null
              ],
        branch: json["branch"],
        className: json['class_id'] != null
            ? json['class_id'] is Map<String, dynamic>
                ? json['class_id']['name']
                : json['class_id']
            : null,
        sectionName: json['section'] != null ? json['section']['name'] : null,
        sectionId: json['section'] != null ? json['section']['_id'] : null,
        schoolId: json["school_id"],
        comment: json['comment']);
  }

  Map<String, dynamic> toJson() => {
        "status": "Pending",
        "class_id": classId,
        "branch": branch,
        "section_id": sectionId,
        "student_id": studentId.id,
        "school_id": schoolId,
      };
}

class ActivityAssignTo {
  ActivityAssignTo({
    this.status,
    this.id,
    this.classId,
    this.studentId,
    this.schoolId,
  });

  String status;
  String id;
  ClassId classId;
  StudentId studentId;
  String schoolId;

  factory ActivityAssignTo.fromJson(Map<String, dynamic> json) =>
      ActivityAssignTo(
        status: json["status"],
        id: json["_id"],
        classId: ClassId.fromJson(json["class_id"]),
        studentId: StudentId.fromJson(json["student_id"]),
        schoolId: json["school_id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "class_id": classId.toJson(),
        "student_id": studentId.toJson(),
        "school_id": schoolId,
      };
}

class ClassId {
  ClassId({
    this.id,
    this.name,
  });

  String id;
  String name;

  factory ClassId.fromJson(Map<String, dynamic> json) => ClassId(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class StudentId {
  StudentId({
    this.id,
    this.name,
    this.section,
  });

  String id;
  String name;
  ClassId section;

  factory StudentId.fromJson(Map<String, dynamic> json) => StudentId(
        id: json["_id"],
        name: json["name"],
        section: ClassId.fromJson(json["section"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "section": section.toJson(),
      };
}

class Option {
  Option({
    this.text,
    this.checked,
  });

  String text;
  String checked;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        text: json["text"],
        checked: json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "checked": checked,
      };
}

class ThreadProfile {
  String id;
  String name;
  String profileImage;

  ThreadProfile({this.id, this.profileImage, this.name});

  factory ThreadProfile.fromJson(Map<String, dynamic> data) {
    return ThreadProfile(
      id: data['_id'],
      profileImage: data['profile_image'],
      name: data['name'],
    );
  }
}

class CommentProfile {
  String id;
  String name;
  String profileImage;

  CommentProfile({
    this.id,
    this.name,
    this.profileImage,
  });

  factory CommentProfile.fromJson(Map<String, dynamic> data) {
    return CommentProfile(
      id: data['_id'],
      name: data['name'],
      profileImage: data['profile_image'],
    );
  }
}

class ThreadComments {
  String id;
  String userId;
  ThreadProfile teacherId;
  ThreadProfile otherTeacherId;
  ThreadProfile studentId;
  String text;
  DateTime commentDate;

  ThreadComments({
    this.id,
    this.text,
    this.commentDate,
    this.userId,
    this.teacherId,
    this.studentId,
    this.otherTeacherId,
  });

  factory ThreadComments.fromJson(
          Map<String, dynamic> data, String teacherId) =>
      ThreadComments(
        id: data['_id'],
        text: data['text'],
        commentDate: DateTime.tryParse(data['comment_date']).toLocal(),
        userId: data['user_id'],
        teacherId: data['teacher_id'] == null
            ? null
            : ThreadProfile.fromJson(data['teacher_id']).id == teacherId
                ? ThreadProfile.fromJson(data['teacher_id'])
                : null,
        otherTeacherId: data['teacher_id'] == null
            ? null
            : ThreadProfile.fromJson(data['teacher_id']).id != teacherId
                ? ThreadProfile.fromJson(data['teacher_id'])
                : null,
        studentId: data['student_id'] == null
            ? null
            : ThreadProfile.fromJson(data['student_id'] ?? {}),
      );

  Map<String, dynamic> toJson() {
    return {
      "comment": [
        {
          "teacher_id": userId,
          "text": text,
          "comment_date": DateTime.now().toUtc().toIso8601String(),
          "doubt_status": "cleared",
        }
      ]
    };
  }
}

class Repository {
  Repository({
    this.id,
    this.repositoryType,
    this.branch,
    this.schoolId,
    this.chapterCount,
    this.classId,
  });

  String id;
  String repositoryType;
  String branch;
  String classId;
  String schoolId;
  int chapterCount;

  factory Repository.fromJson(Map<String, dynamic> json) => Repository(
        id: json["id"],
        repositoryType: json["repository_type"],
        branch: json["branch"],
        classId: json["class_id"],
        schoolId: json['school_id'],
        chapterCount: json['chapterCount'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "repository_type": repositoryType,
        "branch": branch,
        "class_id": classId,
        "school_id": schoolId,
      };
}

class Reward {
  String activityId;
  String innovationId;
  List<RewardedStudent> students;
  List<RewardedStudent> teachers;
  List<RewardedStudent> parents;

  Reward({
    this.activityId,
    this.students,
    this.innovationId,
    this.teachers,
    this.parents,
  });

  Map<String, dynamic> toJson(
      {bool innovation = false,
      bool forTeacher = false,
      bool forParent = false}) {
    if (forTeacher) {
      return {
        "activity_id": activityId,
        "teacher_details": List<dynamic>.from(
          teachers.map((e) => e.toJson(forTeacher: true)),
        )
      };
    }
    if (forParent) {
      return {
        "activity_id": activityId,
        "parent_details": List<dynamic>.from(
          parents.map((e) => e.toJson(forParent: true)),
        )
      };
    }
    if (innovation) {
      print('publishing innovation');
      return {
        "innovation_id": innovationId,
        "student_details": List<dynamic>.from(
          students.map((e) => e.toJson()),
        ),
      };
    }
    return {
      "activity_id": activityId,
      "student_details": List<dynamic>.from(
        students.map((e) => e.toJson()),
      )
    };
  }
}

class RewardedStudent {
  final String studentId;
  final String teacherId;
  final int coinNumber;
  int extraCoin;
  bool event;
  String reason;
  String parentId;

  RewardedStudent(
    this.coinNumber, {
    this.extraCoin,
    this.studentId,
    this.reason,
    this.teacherId,
    this.parentId,
    this.event = false,
  });

  Map<String, dynamic> toJson(
      {bool forTeacher = false, bool forParent = false}) {
    if (forTeacher) {
      return {
        "teacher_id": teacherId,
        "coin": coinNumber,
        "status": "Evaluated",
        "extra_coin": extraCoin ?? 0,
      };
    }
    if (forParent) {
      return {
        "parent_id": parentId,
        "coin": coinNumber,
        "status": "Evaluated",
        "extra_coin": extraCoin ?? 0,
      };
    }
    print(extraCoin);
    return {
      "student_id": studentId,
      "coin": coinNumber,
      "extra_coin": extraCoin ?? 0,
      "reward_given": "yes",
      "reason": reason,
      "status": 'Evaluated',
      "createdBy": teacherId,
    }..removeWhere((key, value) {
        if (event) {
          return key == 'status';
        }
        return false;
      });
  }
}

class SelectedOptions {
  List<String> options;
  DateTime submittedDate;
  String id;
  String selectedBy;
  String selectedByTeacher;
  String selectedByParent;

  SelectedOptions({
    this.id,
    this.options,
    this.selectedBy,
    this.submittedDate,
    this.selectedByTeacher,
    this.selectedByParent,
  });

  factory SelectedOptions.fromJson(Map<String, dynamic> data) {
    return SelectedOptions(
      id: data['_id'],
      selectedBy: data['selected_by'],
      options: List<String>.from(
        data['options'].map((e) => e),
      ),
      submittedDate: DateTime.tryParse(data['submitted_date']) == null
          ? DateTime.now()
          : DateTime.parse(data['submitted_date']).toLocal(),
      selectedByTeacher: data['selected_by_teacher'],
      selectedByParent: data['selected_by_parent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "selected_options": [
        {
          "options": List<dynamic>.from(
            options.map((e) => e),
          ),
          "selected_by_teacher": selectedBy,
          "submitted_date": DateTime.now().toUtc().toIso8601String(),
        }
      ]
    };
  }
}

// class SelectedCheckList {
//   List<String> options;
//   DateTime submittedDate;
//   String id;
//   String selectedBy;
//   SelectedCheckList(
//       {this.id, this.options, this.selectedBy, this.submittedDate});

//   factory SelectedCheckList.fromJson(Map<String, dynamic> data) {
//     return SelectedCheckList(
//       id: data['_id'],
//       selectedBy: data['selected_by'],
//       options: List<String>.from(
//         data['options'].map((e) => e),
//       ),
//       submittedDate: DateTime.parse(data['submitted_date']),
//     );
//   }
// }

class AssignTeacher {
  String activityId;
  String teacherId;

  AssignTeacher({
    this.activityId,
    this.teacherId,
  });

  Map<String, dynamic> toJson() {
    return {
      "assignTo_you": [
        {
          "teacher_id": teacherId,
          "activity_id": activityId,
        }
      ]
    };
  }
}

class TeacherListResponse {
  int status;
  int result;
  List<UserInfo> data;
  String teacherId;

  TeacherListResponse({
    this.data,
    this.result,
    this.teacherId,
    this.status,
  });

  factory TeacherListResponse.fromJson(Map<String, dynamic> data) {
    return TeacherListResponse(
      status: data['status'],
      result: data['result'],
      data: List<UserInfo>.from(
        data['data'].map((e) => UserInfo.fromJson(e)),
      ),
    );
  }
}

class TotalRewardDetails {
  String id;
  String activityId;
  List<RewardDetails> studentDetails;
  List<RewardDetails> teacherDetails;

  TotalRewardDetails(
      {this.activityId, this.id, this.studentDetails, this.teacherDetails});

  factory TotalRewardDetails.fromJson(Map<String, dynamic> data) {
    return TotalRewardDetails(
      id: data['_id'],
      activityId: data['activity_id'],
      studentDetails: List<RewardDetails>.from(
        data['student_details'].map((e) => RewardDetails.fromJson(e)),
      ),
      teacherDetails: List<RewardDetails>.from(
        data['teacher_details'].map((e) => RewardDetails.fromJson(e)),
      ),
    );
  }
}

class RewardDetails {
  String id;
  String studentId;
  String teacherId;
  int coin;
  int extraCoins;
  String reason;
  String rewarded;

  RewardDetails({
    this.coin,
    this.extraCoins,
    this.id,
    this.reason,
    this.rewarded,
    this.studentId,
    this.teacherId,
  });

  factory RewardDetails.fromJson(Map<String, dynamic> data) {
    return RewardDetails(
      coin: data['coin'],
      extraCoins: data['extra_coin'],
      id: data['_id'],
      reason: data['reason'],
      rewarded: data['reward_given'],
      studentId: data['student_id'],
      teacherId: data['teacher_id'],
    );
  }
}

class SectionProgress {
  final String sectionId;
  final int assignmentAssigned;
  final int assignmentCompleted;
  final int livePollAssigned;
  final int livePollCompleted;
  final int checkListAssigned;
  final int checkListCompleted;
  final int eventAssigned;
  final int eventCompleted;
  final int announcementAssigned;
  final int announcementCompleted;
  final double sectionProgress;

  SectionProgress({
    this.sectionId,
    this.assignmentAssigned,
    this.assignmentCompleted,
    this.livePollAssigned,
    this.livePollCompleted,
    this.checkListAssigned,
    this.checkListCompleted,
    this.eventAssigned,
    this.eventCompleted,
    this.announcementAssigned,
    this.announcementCompleted,
    this.sectionProgress,
  });

  factory SectionProgress.fromJson(Map<String, dynamic> data) {
    return SectionProgress(
      sectionId: data['_id']['section'],
      assignmentAssigned: data['assignmentAssigned'],
      assignmentCompleted: data['assignmentCompleted'],
      livePollAssigned: data['livepollAssigned'],
      livePollCompleted: data['livepollCompleted'],
      checkListAssigned: data['checklistAssigned'],
      checkListCompleted: data['checklistCompleted'],
      eventAssigned: data['eventAssigned'],
      eventCompleted: data['eventCompleted'],
      announcementAssigned: data['announcementAssigned'],
      announcementCompleted: data['announcementCompleted'],
      sectionProgress: double.parse(data['SectionProgress'].toString()),
    );
  }
}

//model for test average in progress

class TestAvgProgress {
  TestAvgProgress({
    this.assignToStudentId,
  });

  String assignToStudentId;

  factory TestAvgProgress.fromJson(Map<String, dynamic> json) =>
      TestAvgProgress(
        assignToStudentId: json["assignTo.student_id"],
      );

  Map<String, dynamic> toJson() => {
        "assignTo.student_id": assignToStudentId,
      };
}
