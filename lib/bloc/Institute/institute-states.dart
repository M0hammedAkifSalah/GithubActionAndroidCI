
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';

abstract class InstituteStates {}

class InstituteLoaded extends InstituteStates {
  final InstituteModel instituteModel;
  InstituteLoaded(this.instituteModel);
}

class InstituteLoading extends InstituteStates {}

class InstituteFailed extends InstituteStates {}

abstract class DisplaySessionStates {}

class SessionLoaded extends DisplaySessionStates {
   List<ReceivedSession> session;
  SessionLoaded(this.session);
}

class SessionLoading extends DisplaySessionStates {}

class SessionFailed extends DisplaySessionStates {}
