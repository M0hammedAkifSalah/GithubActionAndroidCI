import '/model/user.dart';
import '../model/activity.dart';

class FeedBackStudent {
  Repository repository;
  DateTime createdAt;
  DateTime updatedAt;
  String id;
  UserInfo teacherId;
  String teacherIdString;
  String studentId;
  String feed;
  String feedType;
  String awardBadge;
  String awardBadgeImage;
  FeedBackStudent({
    this.awardBadge,
    this.awardBadgeImage,
    this.createdAt,
    this.feed,
    this.feedType,
    this.id,
    this.repository,
    this.studentId,
    this.teacherId,
    this.updatedAt,
  });
  factory FeedBackStudent.fromJson(Map<String, dynamic> data) {
    return FeedBackStudent(
      id: data['_id'],
      feed: data['feed'],
      feedType: data['feed_type'],
      awardBadge: data['award_badge'],
      awardBadgeImage: data['award_badge_image'],
      teacherId: UserInfo.fromJson(data['teacher_id']),
      studentId: data['student_id'],
      createdAt: DateTime.parse(data['created_By']),
      updatedAt: DateTime.parse(data['updated_By']),
      repository: Repository.fromJson(data['repository']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "teacher_id": teacherIdString,
      "student_id": studentId,
      "feed": feed,
      "created_By": DateTime.now().toIso8601String(),
      "feed_type": feedType,
      "award_badge": awardBadge,
      "award_badge_image": awardBadgeImage,
      "repository": repository.toJson(),
    };
  }
}
