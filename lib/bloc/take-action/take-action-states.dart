import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';

import '/model/activity.dart';

abstract class TakeActionStates {}

class Loading extends TakeActionStates {}

class TakeActionInitialized extends TakeActionStates {
  final ReceivedSession session;

  TakeActionInitialized(this.session);
}


class TakeActionAnnouncement extends TakeActionStates {
  final Activity activity;
  TakeActionAnnouncement(this.activity);
}

class TakeActionLivePoll extends TakeActionStates {
  final Activity activity;
  TakeActionLivePoll(this.activity);
}

class TakeActionEvent extends TakeActionStates {
  final Activity activity;
  TakeActionEvent(this.activity);
}

class TakeActionCheckList extends TakeActionStates {
  final Activity activity;
  TakeActionCheckList(this.activity);
}
