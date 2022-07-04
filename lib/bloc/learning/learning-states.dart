import '/model/learning.dart';
import '/model/user.dart';

abstract class LearningStates {}

abstract class LearningStudentIdStates {}

abstract class LearningParentIdStates {}

abstract class LearningTeacherIdStates {}

abstract class RecentFileStates {}

abstract class LearningClassesStates {}

abstract class LearningChapterStates {}

abstract class LearningTopicStates {}

class LearningSubjectLoading extends LearningStates {}

class LearningStudentIdLoading extends LearningStudentIdStates {}

class LearningStudentIdLoaded extends LearningStudentIdStates {
  final List<StudentInfo> students;
  LearningStudentIdLoaded(this.students);
}

class LearningParentIdLoading extends LearningParentIdStates {}

class LearningParentIdLoaded extends LearningParentIdStates {
  final List<StudentInfo> students;
  LearningParentIdLoaded(this.students);
}

class LearningTeacherIdLoading extends LearningTeacherIdStates {}

class LearningTeacherIdLoaded extends LearningTeacherIdStates {
  final List<String> teachers;
  LearningTeacherIdLoaded(this.teachers);
}

class LearningSubjectLoaded extends LearningStates {
  List<Learnings> subjectLearning;
  LearningSubjectLoaded(this.subjectLearning);
}

class LearningSubjectEmpty extends LearningStates {}

class LearningSubjectInitial extends LearningStates {}

class LearningChapterLoading extends LearningChapterStates {}

class LearningTopicLoading extends LearningTopicStates {}

class LearningChapterLoaded extends LearningChapterStates {
  List<Learnings> chapterLearning;
  LearningChapterLoaded(this.chapterLearning);
}

class LearningTopicLoaded extends LearningTopicStates {
  List<Learnings> topicLearning;
  LearningTopicLoaded(this.topicLearning);
}

class LearningClassLoading extends LearningClassesStates {}

class LearningClassLoaded extends LearningClassesStates {
  final List<LearningClassDetails> classDetails;
  LearningClassLoaded(this.classDetails);
}

class LearningStudentsLoading extends LearningClassesStates {}

class LearningStudentsFailed extends LearningClassesStates {}

class LearningStudentsLoaded extends LearningClassesStates {
  final List<StudentInfo> students;
  final bool hasMoreData;
  LearningStudentsLoaded(this.students, {this.hasMoreData = true});
}

class RecentFileLoading extends RecentFileStates {}

class RecentFileLoaded extends RecentFileStates {
  final List<LearningFiles> files;
  RecentFileLoaded(this.files);
}

abstract class NewLearningFilesStates {}

class NewLearningFilesLoading extends NewLearningFilesStates {}

class NewLearningFilesLoaded extends NewLearningFilesStates {
  List<LearningFiles> newFiles;
  bool forTopic;
  NewLearningFilesLoaded(this.newFiles, this.forTopic);
}
