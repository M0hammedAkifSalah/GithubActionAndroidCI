
import '/model/activity.dart';
import '/model/user.dart';

abstract class StudentProfileStates {}

abstract class GroupStates {}

abstract class RewardStudentStates {}

class StudentProfileLoading extends StudentProfileStates {}

class StudentProfileLoaded extends StudentProfileStates {
  final List<StudentInfo> studentInfo;

  StudentProfileLoaded(this.studentInfo);
}

class StudentGroupsLoading extends GroupStates {}

class StudentGroupsLoaded extends GroupStates {
  final Groups group;
  StudentGroupsLoaded(this.group);
}

class RewardStudentLoading extends RewardStudentStates {}

class RewardStudentLoaded extends RewardStudentStates {
  List<TotalRewardDetails> rewardStudent;
  RewardStudentLoaded(this.rewardStudent);
}
