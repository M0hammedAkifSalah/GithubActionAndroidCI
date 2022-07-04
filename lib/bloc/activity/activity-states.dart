
import '/model/activity.dart';

abstract class ActivityStates {}

class ActivityLoading extends ActivityStates {
  ActivityLoading();
}

class ActivityFilterLoading extends ActivityStates {
  ActivityFilterLoading();
}

class ActivityLoaded extends ActivityStates {
  final List<Activity> allActivities;
  final bool hasMoreData;

  ActivityLoaded({
    this.allActivities,
    this.hasMoreData = true,
  });
}

class AdminActivityLoaded extends ActivityStates {
  final List<Activity> allActivities;
  final bool hasMoreData;

  AdminActivityLoaded({
    this.allActivities,
    this.hasMoreData = true,
  });
}

class TaskDeleted extends ActivityStates {}

class TaskUploading extends ActivityStates {}

class TaskUploaded extends ActivityStates {}

abstract class SectionProgressStates {}

class SectionProgressLoading extends SectionProgressStates {}

class SectionProgressLoaded extends SectionProgressStates {
  List<SectionProgress> sectionProgress;
  SectionProgressLoaded(this.sectionProgress);
}
