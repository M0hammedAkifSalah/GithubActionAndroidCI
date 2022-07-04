import 'dart:developer';

import 'package:growonplus_teacher/model/session-report.dart';

abstract class SessionReportStates{}

abstract class SessionReportStudentStates{}

abstract class SessionReportTeacherStates{}

class SessionReportLoaded extends SessionReportStates{
  final List<SessionSchoolReport> sessionSchoolReport;
  SessionReportLoaded(this.sessionSchoolReport);
}

class SessionReportLoadedStudent extends SessionReportStudentStates{
  final List<SessionReportStudent> studentsReport;
  final bool hasMore;
  SessionReportLoadedStudent(this.studentsReport,{this.hasMore=true});
}
class SessionReportLoadedTeacher extends SessionReportTeacherStates{
  final List<SessionReportStudent> teacherReport;
  final bool hasMore;
  SessionReportLoadedTeacher(this.teacherReport,{this.hasMore=true});
}

class SessionReportLoading extends SessionReportStates{}

class SessionReportFailed extends SessionReportStates{}

class SessionReportLoadingStudent extends SessionReportStudentStates{}

class SessionReportLoadingTeacher extends SessionReportTeacherStates{}