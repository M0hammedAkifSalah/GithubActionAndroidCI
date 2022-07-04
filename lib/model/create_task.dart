import 'activity.dart'
    show AssignTo, SubmittedBy, Repository, Option, AssignToParent;

class AssignmentTask {
  String activityType;
  String title;
  String image;
  int likes;
  int views;
  String description;
  String status;
  String endDate;
  String teacherId;
  String dueDate;
  String startDate;
  String className;
  String learningOutcome;
  String tags;
  String publishedWith;
  String subject;
  DateTime endTime;
  int reward;
  int coin;
  List<AssignTo> assignTo = [];
  List<SubmittedBy> submittedBy = [];
  List<Repository> repository = [];
  List<String> files;
  String createdBy;
  String updateBy;
  List<String> links;
  List<String> teachers;
  DateTime startTime;
  List<AssignToParent> parents;
  bool isOffline;
  AssignmentTask({
    this.activityType = 'Assignment',
    this.assignTo,
    this.coin,
    this.teachers,
    this.createdBy,
    this.description,
    this.dueDate,
    this.endDate,
    this.startDate,
    this.endTime,
    this.image,
    this.likes = 0,
    this.links,
    this.className,
    this.learningOutcome,
    this.subject,
    this.tags = '',
    this.repository,
    this.status = 'Pending',
    this.submittedBy,
    this.title = '',
    this.updateBy,
    this.views = 0,
    this.files,
    this.startTime,
    this.publishedWith,
    this.parents,
    this.isOffline,
  });
  Map<String, dynamic> toJson() => {
        "activity_type": activityType,
        "title": title,
        "image": image,
        "like": likes,
        "view": views,
        "description": description,
        "class_name": className,
        "subject": subject,
        "status": status,
        "EndDate": endDate,
        "teacher_id": teacherId,
        "dueDate": dueDate,
        "reward": reward,
        "StartTime": startTime.toIso8601String(),
        "EndTime": endTime.toIso8601String(),
        "startDate": startDate,
        "links": links ?? [],
        "learning_Outcome": learningOutcome,
        "coin": coin,
        "publish_date": DateTime.now().toIso8601String(),
        "file": files == null ? [] : List<dynamic>.from(files.map((e) => e)),
        "assignTo_you": List<dynamic>.from(
          teachers.map((e) => {"teacher_id": e}),
        ),
        "assignTo_parent": List<dynamic>.from(parents.map((e) => e.toJson())),
        "assignTo": List<dynamic>.from(
          assignTo.map((e) => e.toJson()),
        ),
        "repository": repository == null
            ? []
            : List<dynamic>.from(
                repository.map((e) => e.toJson()),
              ),
        "created_by": createdBy,
        "updated_by": updateBy,
        "publishedWith": publishedWith,
        "isOffline":isOffline,
      };
}

class AnnouncementTask {
  String activityType;
  String title;
  String image;
  int likes;
  int views;
  String description;
  String status;
  String publishedWith;
  String endTime;
  String dueDate;
  int coin;
  List<AssignTo> assignTo = [];
  List<String> acknowledgedBy = [""];
  List<Repository> repository = [];
  List<String> files;
  List<String> links;
  String createdBy;
  String teacherId;
  String updateBy;
  List<String> teachers;
  List<AssignToParent> parents;
  AnnouncementTask({
    this.activityType = 'Announcement',
    this.assignTo,
    this.coin,
    this.createdBy,
    this.description,
    this.dueDate,
    this.endTime,
    this.image,
    this.likes = 0,
    this.teacherId,
    this.repository,
    this.publishedWith,
    this.status = 'Pending',
    this.acknowledgedBy,
    this.title = '',
    this.teachers,
    this.updateBy,
    this.links,
    this.views = 0,
    this.files,
  });
  Map<String, dynamic> toJson() => {
        "activity_type": activityType,
        "title": title,
        "image": image,
        "like": likes,
        "view": views,
        "description": description,
        "status": status,
        "EndTime": endTime,
        "dueDate": dueDate,
        "teacher_id": teacherId,
        "coin": coin,
        "publish_date": DateTime.now().toIso8601String(),
        "assignTo_you": List<dynamic>.from(
          teachers.map((e) => {"teacher_id": e}),
        ),
        "assignTo_parent": List<dynamic>.from(parents.map((e) => e.toJson())),
        "file": List<dynamic>.from(files.map((e) => e)),
        "assignTo": List<dynamic>.from(
          assignTo.map((e) => e.toJson()),
        ),
        "acknowledged_by": acknowledgedBy == null
            ? []
            : List<dynamic>.from(
                acknowledgedBy.map((e) => e),
              ),
        "repository": repository == null
            ? []
            : List<dynamic>.from(
                repository.map((e) => e.toJson()),
              ),
        "created_by": createdBy,
        "updated_by": updateBy,
        "links": links ?? [],
        "publishedWith": publishedWith,
      };
}

class LivePollTask {
  String activityType;
  String title;
  String image;
  int likes;
  int views;
  String description = '';
  String status;
  String startDate;
  String publishedWith;
  String endDate;
  String endTime;
  String teacherId;
  String dueDate;
  int coin;
  List<AssignTo> assignTo = [];
  List<Repository> repository = [];
  List<Option> options = [];
  String createdBy;
  String updateBy;
  List<String> teachers;
  List<AssignToParent> parents;
  LivePollTask({
    this.activityType = 'LivePoll',
    this.assignTo,
    this.coin,
    this.createdBy,
    this.teacherId,
    this.teachers,
    this.description,
    this.dueDate,
    // this.endDate,
    this.image,
    this.likes = 0,
    this.parents,
    this.repository,
    this.status = 'Pending',
    this.title = '',
    this.updateBy,
    this.views = 0,
    this.options,
    this.publishedWith,
    this.startDate,
    this.endTime,
    this.endDate,
  });
  Map<String, dynamic> toJson() => {
        "activity_type": activityType,
        "title": title,
        "image": image,
        "like": likes,
        "teacher_id": teacherId,
        "view": views,
        "description": description,
        "status": status,
        "EndDate": endDate,
        "EndTime": endTime,
        "startDate": startDate,
        "dueDate": dueDate,
        "coin": coin,
        "publish_date": DateTime.now().toIso8601String(),
        "options": List<dynamic>.from(options.map((e) => e.toJson())),
        "assignTo": List<dynamic>.from(
          assignTo.map((e) => e.toJson()),
        ),
        "assignTo_parent": List<dynamic>.from(parents.map((e) => e.toJson())),
        "assignTo_you": List<dynamic>.from(
          teachers.map((e) => {"teacher_id": e}),
        ),
        // "acknowledged_by": acknowledgedBy == null
        //     ? []
        //     : List<dynamic>.from(
        //         acknowledgedBy.map((e) => e),
        //       ),
        "repository": repository == null
            ? []
            : List<dynamic>.from(
                repository.map((e) => e.toJson()),
              ),
        "created_by": createdBy,
        "updated_by": updateBy,
        "publishedWith": publishedWith,
      };
}

class CheckListTask {
  String activityType;
  String title;
  String image;
  int likes;
  int views;
  String description = '';
  String status;
  String startDate;
  String endDate;
  String publishedWith;
  String teacherId;
  String endTime;
  String dueDate;
  int coin;
  List<AssignTo> assignTo = [];
  List<Repository> repository = [];
  List<Option> options = [];
  List<dynamic> selectedOptions = [];
  String createdBy;
  String updateBy;
  List<String> teachers;
  List<AssignToParent> parents;
  CheckListTask({
    this.activityType = 'Check List',
    this.assignTo,
    this.coin,
    this.createdBy,
    this.parents,
    this.teacherId,
    this.teachers,
    this.description,
    this.dueDate,
    this.endTime,
    // this.endDate,
    this.image,
    this.likes = 0,
    this.repository,
    this.status = 'Pending',
    this.title = '',
    this.updateBy,
    this.views = 0,
    this.options,
    this.publishedWith,
    this.startDate,
    this.endDate,
  });
  Map<String, dynamic> toJson() => {
        "activity_type": activityType,
        "title": title,
        "image": image,
        "like": likes,
        "teacher_id": teacherId,
        "view": views,
        "description": description,
        "status": status,
        "EndDate": endDate,
        "startDate": startDate,
        "dueDate": dueDate,
        "EndTime": endTime,
        "coin": coin,
        "publish_date": DateTime.now().toIso8601String(),
        "selected_options": selectedOptions,
        "options": List<dynamic>.from(options.map((e) => e.toJson())),
        "assignTo": List<dynamic>.from(
          assignTo.map((e) => e.toJson()),
        ),
        "assignTo_you": List<dynamic>.from(
          teachers.map((e) => {"teacher_id": e}),
        ),
        "assignTo_parent": List<dynamic>.from(parents.map((e) => e.toJson())),
        // "acknowledged_by": acknowledgedBy == null
        //     ? []
        //     : List<dynamic>.from(
        //         acknowledgedBy.map((e) => e),
        //       ),
        "repository": repository == null
            ? []
            : List<dynamic>.from(
                repository.map((e) => e.toJson()),
              ),
        "created_by": createdBy,
        "updated_by": updateBy,
        "publishedWith": publishedWith,
      };
}

class EventTask {
  String activityType;
  String title;
  String image;
  int likes;
  String teacherId;
  String publishedWith;
  int views;
  String eventType = '';
  String description = '';
  String location;
  String status;
  String startDate;
  String endTime;
  String endDate;
  String dueDate;
  int coin;
  List<AssignTo> assignTo = [];
  List<Repository> repository = [];
  // List<Option> options = [];
  String createdBy;
  List<String> teachers;
  List<AssignToParent> parents;
  String updateBy;
  EventTask({
    this.activityType = 'Event',
    this.assignTo,
    this.coin,
    this.createdBy,
    this.description,
    this.teachers,
    this.dueDate,
    this.publishedWith,
    this.teacherId,
    this.parents,
    this.endTime,
    // this.endDate,
    this.image,
    this.likes = 0,
    this.repository,
    this.status = 'Pending',
    this.title = '',
    this.updateBy,
    this.views = 0,
    // this.options,
    this.startDate,
    this.endDate,
  });
  Map<String, dynamic> toJson() => {
        "activity_type": activityType,
        "title": title,
        "image": image,
        "like": likes,
        "teacher_id": teacherId,
        "view": views,
        "description": description,
        "status": status,
        "EndDate": endDate,
        "EndTime": endTime,
        "startDate": startDate,
        "locations": location,
        "event_type": eventType,
        "dueDate": dueDate,
        "coin": coin,
        "publish_date": DateTime.now().toIso8601String(),
        // "options": List<dynamic>.from(options.map((e) => e.toJson())),
        "assignTo": List<dynamic>.from(
          assignTo.map((e) => e.toJson()),
        ),
        "assignTo_parent": List<dynamic>.from(parents.map((e) => e.toJson())),
        "assignTo_you": List<dynamic>.from(
          teachers.map((e) => {"teacher_id": e}),
        ),
        // "acknowledged_by": acknowledgedBy == null
        //     ? []
        //     : List<dynamic>.from(
        //         acknowledgedBy.map((e) => e),
        //       ),
        "repository": repository == null
            ? []
            : List<dynamic>.from(
                repository.map((e) => e.toJson()),
              ),
        "created_by": createdBy,
        "updated_by": updateBy,
        "publishedWith": publishedWith,
      };
}
