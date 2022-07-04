import '/export.dart';

abstract class AssignmentSubmissionStates {}

class AssignmentSubmissionLoading extends AssignmentSubmissionStates {}

class AssignmentSubmissionLoaded extends AssignmentSubmissionStates {
  final List<SubmittedBy> submission;
  final List<AssignTo> allStudents;
  AssignmentSubmissionLoaded({this.submission, this.allStudents});
}
