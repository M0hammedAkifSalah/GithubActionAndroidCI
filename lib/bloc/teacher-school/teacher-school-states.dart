import '/model/activity.dart';
import '/model/user.dart';

abstract class SchoolTeacherStates {}

class SchoolTeacherLoading extends SchoolTeacherStates {}

class SchoolTeacherLoaded extends SchoolTeacherStates {
  List<UserInfo> teachers;
  String teacherId;
  SchoolTeacherLoaded(this.teachers, this.teacherId);
}

abstract class AssignToYouStates {}

class AssignedActivitiesLoading extends AssignToYouStates {}

class AssignActivityFilterLoading extends AssignToYouStates {
  AssignActivityFilterLoading();
}

class AssignedActivitiesLoaded extends AssignToYouStates {
  final List<Activity> activities;
  final bool hasMoreData;
  AssignedActivitiesLoaded(this.activities,this.hasMoreData);
}
