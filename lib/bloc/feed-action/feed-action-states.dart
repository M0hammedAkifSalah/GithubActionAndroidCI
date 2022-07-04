import '/model/feedback.dart';

abstract class FeedActionStates {}

class PostingThreadState extends FeedActionStates {}

// class FeedActionLoading extends FeedActionStates {}
abstract class FeedBackStates {}

class FeedBacksLoading extends FeedBackStates {}

class FeedBacksLoaded extends FeedBackStates {
  final List<FeedBackStudent> feedback;
  FeedBacksLoaded(this.feedback);
}

// class LoadAnnouncementFeed extends FeedActionStates {
//   final Activity activity;

//   LoadAnnouncementFeed(this.activity);
// }

// class LoadAssignmentFeed extends FeedActionStates {
//   final Activity activity;

//   LoadAssignmentFeed(this.activity);
// }

// class LoadEventFeed extends FeedActionStates {
//   final Activity activity;

//   LoadEventFeed(this.activity);
// }

// class LoadLivePollFeed extends FeedActionStates {
//   final Activity activity;

//   LoadLivePollFeed(this.activity);
// }

// class LoadCheckListFeed extends FeedActionStates {
//   final Activity activity;

//   LoadCheckListFeed(this.activity);
// }
