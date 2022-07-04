import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/bloc/attendance/attendance-cubit.dart';

import '/bloc/activity/assignment-cubit.dart';
import '/bloc/admin-mode/admin-mode-cubit.dart';
import 'export.dart';

List<BlocProvider> blocProvider = [
  BlocProvider<AuthCubit>(
    create: (BuildContext context) => AuthCubit()..checkAuthStatus(),
  ),
  BlocProvider<LearningStudentIdCubit>(
    create: (BuildContext context) => LearningStudentIdCubit(),
  ),
  BlocProvider<LearningTeacherIdCubit>(
    create: (BuildContext context) => LearningTeacherIdCubit(),
  ),
  BlocProvider<LearningParentIdCubit>(
    create: (BuildContext context) => LearningParentIdCubit(),
  ),
  BlocProvider<ActivityCubit>(
    create: (BuildContext context) => ActivityCubit(),
  ),
  BlocProvider<AssignedActivitiesCubit>(
    create: (BuildContext context) => AssignedActivitiesCubit(),
  ),
  BlocProvider<StudentProfileCubit>(
    create: (BuildContext context) => StudentProfileCubit(),
  ),
  BlocProvider<GroupCubit>(
    create: (BuildContext context) => GroupCubit(),
  ),
  BlocProvider<ScheduleClassCubit>(
    create: (BuildContext context) => ScheduleClassCubit(),
  ),
  BlocProvider<ScheduleClassIdCubit>(
    create: (BuildContext context) => ScheduleClassIdCubit(),
  ),
  BlocProvider<SubjectDetailsCubit>(
    create: (BuildContext context) => SubjectDetailsCubit(),
  ),
  BlocProvider<TeacherAchievementsCubit>(
    create: (BuildContext context) => TeacherAchievementsCubit(),
  ),
  BlocProvider<TeacherSkillsCubit>(
    create: (BuildContext context) => TeacherSkillsCubit(),
  ),
  BlocProvider<RewardStudentCubit>(
    create: (BuildContext context) => RewardStudentCubit(),
  ),
  BlocProvider<SchoolTeacherCubit>(
    create: (BuildContext context) => SchoolTeacherCubit(),
  ),
  BlocProvider<FeedBackCubit>(
    create: (BuildContext context) => FeedBackCubit(),
  ),
  BlocProvider<TakeActionCubit>(
    create: (BuildContext context) => TakeActionCubit(),
  ),
  BlocProvider<LearningClassCubit>(
    create: (BuildContext context) => LearningClassCubit()..getClasses(),
  ),
  BlocProvider<LearningDetailsCubit>(
    create: (BuildContext context) => LearningDetailsCubit(),
  ),
  BlocProvider<RecentFilesCubit>(
    create: (BuildContext context) => RecentFilesCubit(),
  ),
  BlocProvider<RewardTeacherCubit>(
    create: (BuildContext context) => RewardTeacherCubit(),
  ),
  BlocProvider<QuestionPaperCubit>(
    create: (BuildContext context) => QuestionPaperCubit(),
  ),
  BlocProvider<TestModuleChapterCubit>(
    create: (BuildContext context) => TestModuleChapterCubit(),
  ),
  BlocProvider<TestModuleSubjectCubit>(
    create: (BuildContext context) => TestModuleSubjectCubit(),
  ),
  BlocProvider<TestModuleClassCubit>(
      create: (BuildContext context) => TestModuleClassCubit()),
  BlocProvider<TestModuleTopicCubit>(
      create: (BuildContext context) => TestModuleTopicCubit()),
  BlocProvider<ExamTypeCubit>(
    create: (BuildContext context) => ExamTypeCubit(),
  ),
  BlocProvider<QuestionTypeCubit>(
    create: (BuildContext context) => QuestionTypeCubit(),
  ),
  BlocProvider<ClassDetailsCubit>(
    create: (BuildContext context) =>
        ClassDetailsCubit()..loadClassDetails(removeCheck: true),
  ),
  BlocProvider<LearningOutcomeCubit>(
    create: (BuildContext context) => LearningOutcomeCubit(),
  ),
  BlocProvider<QuestionAnswerCubit>(
    create: (BuildContext context) => QuestionAnswerCubit(),
  ),
  BlocProvider<CorrectQuestionCubit>(
    create: (BuildContext context) => CorrectQuestionCubit(),
  ),
  BlocProvider<LearningChapterCubit>(
    create: (BuildContext context) => LearningChapterCubit(),
  ),
  BlocProvider<NewLearningFilesCubit>(
    create: (BuildContext context) => NewLearningFilesCubit(),
  ),
  BlocProvider<LearningTopicCubit>(
    create: (BuildContext context) => LearningTopicCubit(),
  ),
  BlocProvider<QuestionCategoryCubit>(
    create: (BuildContext context) => QuestionCategoryCubit(),
  ),
  BlocProvider<AssignmentSubmissionCubit>(
    create: (BuildContext context) => AssignmentSubmissionCubit(),
  ),
  BlocProvider<SectionProgressCubit>(
    create: (BuildContext context) => SectionProgressCubit(),
  ),
  BlocProvider<AdminModeCubit>(
    create: (BuildContext context) => AdminModeCubit(),
  ),
  BlocProvider<AttendanceCubit>(
    create: (BuildContext context) => AttendanceCubit(),
  ),
  BlocProvider<InstituteCubit>(
    create: (BuildContext context) => InstituteCubit(),
  ),
  BlocProvider<SessionCubit>(
      create: (BuildContext context) => SessionCubit()),
  BlocProvider<SessionReportCubit>(
      create: (BuildContext context) => SessionReportCubit()),
  BlocProvider<SessionReportStudentCubit>(
      create: (BuildContext context) => SessionReportStudentCubit()),
  BlocProvider<SessionReportTeacherCubit>(
      create: (BuildContext context) => SessionReportTeacherCubit()),
  BlocProvider<SubmitMarksCubit>(
      create: (BuildContext context) => SubmitMarksCubit()),
  BlocProvider<AttendanceReportCubit>(
      create: (BuildContext context) => AttendanceReportCubit()),
  BlocProvider<AttendanceReportByStudentCubit>(
      create: (BuildContext context) => AttendanceReportByStudentCubit()),
];
