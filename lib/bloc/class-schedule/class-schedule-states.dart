
import '/model/class-schedule.dart';

abstract class ClassScheduleStates {}

abstract class ClassScheduleIdStates {}

abstract class ClassDetailsState {}

abstract class SubjectDetails {}

abstract class ChapterDetailsStates {}

abstract class TopicDetailsStates {}

class ClassDetailsLoading extends ClassDetailsState {}

class ClassDetailsLoaded extends ClassDetailsState {
  final List<SchoolClassDetails> classDetails;
  final List<SchoolClassDetails> mappedClassDetails;
  ClassDetailsLoaded(this.classDetails, this.mappedClassDetails);
}

class SubjectDetailsLoading extends SubjectDetails {}

class SubjectDetailsLoaded extends SubjectDetails {
  final List<Subjects> subjects;
  SubjectDetailsLoaded(this.subjects);
}

class ClassScheduleLoading extends ClassScheduleStates {
  ClassScheduleLoading();
}

class ClassScheduleLoaded extends ClassScheduleStates {
  final List<ScheduledClassTask> allClassSchedules;
  final List<ScheduledClassTask> dateSpecificClassSchedules;
  final bool hasMore;
  // final DateTime selectedDate;
  final String teacherId;

  ClassScheduleLoaded({
    this.allClassSchedules,
    this.dateSpecificClassSchedules,
    // this.selectedDate,
    this.hasMore = true,
    this.teacherId,
  });
}

class ClassScheduleIdLoading extends ClassScheduleIdStates {
  ClassScheduleIdLoading();
}

class ClassScheduleIdLoaded extends ClassScheduleIdStates {
  final List<ScheduledClassTask> allClassSchedules;
  // final DateTime selectedDate;

  ClassScheduleIdLoaded({
    this.allClassSchedules,
    // this.selectedDate,
  });
}

// class ChapterDetailsLoading extends ChapterDetailsStates {}

// class ChapterDetailsLoaded extends ChapterDetailsStates {
//   final List<Chapters> allChapters;
//   ChapterDetailsLoaded(this.allChapters);
// }

// class TopicDetailsLoading extends TopicDetailsStates {}

// class TopicDetailsLoaded extends TopicDetailsStates {
//   final List<Topics> allTopics;
//   TopicDetailsLoaded(this.allTopics);
// }
