import 'package:growonplus_teacher/model/attendance.dart';

abstract class AttendanceStates {}

class AttendanceLoading extends AttendanceStates {
  AttendanceLoading();
}

class AttendanceLoaded extends AttendanceStates {
 List<GetByDateAttendanceResponse> getByDateAttendanceResponse;

  AttendanceLoaded({this.getByDateAttendanceResponse
  });
}

class AttendanceNotLoaded extends AttendanceStates {
  AttendanceNotLoaded();
}

abstract class AttendanceReport{}

class AttendanceReportLoaded extends AttendanceReport{
  List<AttendanceReportBySchoolModel> reportByDate;
  AttendanceReportLoaded(this.reportByDate);
}
class AttendanceReportLoading extends AttendanceReport{}
class AttendanceReportNotLoaded extends AttendanceReport{}

abstract class AttendanceReportByStudent{}

class AttendanceReportByStudentLoaded extends AttendanceReportByStudent{
  // List<AttendanceReportByStudentModel> reportByStudent;
  // AttendanceReportByStudentLoaded(this.reportByStudent);
}
class AttendanceReportByStudentLoading extends AttendanceReportByStudent{}
class AttendanceReportByStudentNotLoaded extends AttendanceReportByStudent{}