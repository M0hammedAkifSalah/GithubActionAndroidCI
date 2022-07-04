import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/activity/assignment-states.dart';
import '/export.dart';

class AssignmentSubmissionCubit extends Cubit<AssignmentSubmissionStates> {
  AssignmentSubmissionCubit() : super(AssignmentSubmissionLoading());

  void addData(List<SubmittedBy> submission, List<AssignTo> assignees) {
    submission.sort((comp1, comp2) {
      if (comp1.coins == null || comp2.coins == null) return 0;
      return comp2.coins.compareTo(comp1.coins);
    });
    emit(AssignmentSubmissionLoaded(
        submission: submission, allStudents: assignees));
  }
}
