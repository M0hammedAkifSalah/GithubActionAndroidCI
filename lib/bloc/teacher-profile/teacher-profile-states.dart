import '/model/activity.dart';
import '/model/teacher-profile.dart';

abstract class TeacherAchievementStates {}

class TeacherAchievementLoading extends TeacherAchievementStates {}

class TeacherAchievementLoaded extends TeacherAchievementStates {
  List<TeacherAchievements> achievements;
  TeacherAchievementLoaded(this.achievements);
}

abstract class TeacherSkillStates {}

class TeacherSkillsLoading extends TeacherSkillStates {}

class TeacherSkillsLoaded extends TeacherSkillStates {
  final List<TeacherSkills> skills;
  TeacherSkillsLoaded(this.skills);
}

abstract class RewardTeacherStates {}

class RewardTeacherLoading extends RewardTeacherStates {}

class RewardTeacherLoaded extends RewardTeacherStates {
  List<TotalRewardDetails> rewardTeachers;
  RewardTeacherLoaded(this.rewardTeachers);
}
