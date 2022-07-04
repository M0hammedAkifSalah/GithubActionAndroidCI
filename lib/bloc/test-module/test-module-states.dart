import 'package:growonplus_teacher/model/Test%20Models/TestTopicModel.dart';

import '/model/class-schedule.dart';
import '/model/test-model.dart';
import '../../model/Test Models/TestChapterModel.dart';

abstract class QuestionPaperStates {}

class QuestionPaperLoading extends QuestionPaperStates {}

class QuestionPaperLoaded extends QuestionPaperStates {
  final List<QuestionPaper> questionPaper;
  QuestionPaperLoaded(this.questionPaper);
}

class QuestionPaperNotLoaded extends QuestionPaperStates {}

abstract class TestModuleClassStates {}

class TestClassesLoading extends TestModuleClassStates {}

class TestClassesLoaded extends TestModuleClassStates {
  final List<SchoolClassDetails> classDetails;
  TestClassesLoaded(this.classDetails);
}

abstract class TestModuleLanguageStates {}

class TestModuleLanguageLoading extends TestModuleLanguageStates {}

class TestModuleLanguageLoaded extends TestModuleLanguageStates {}

abstract class ExamTypeStates {}

class ExamTypeLoading extends ExamTypeStates {}

class ExamTypeLoaded extends ExamTypeStates {
  final List<ExamType> data;
  ExamTypeLoaded(this.data);
}

abstract class TestModuleSubjectStates {}

class TestModuleSubjectLoading extends TestModuleSubjectStates {}

class TestModuleSubjectLoaded extends TestModuleSubjectStates {
  final List<Subjects> subjects;
  TestModuleSubjectLoaded(this.subjects);
}

class TestModuleNoSubjects extends TestModuleSubjectStates {}

abstract class TestModuleChapterStates {}

class TestModuleChapterLoading extends TestModuleChapterStates {}

class TestModuleChapterLoaded extends TestModuleChapterStates {
  final List<TestChapterModel> testChapterModel;
  TestModuleChapterLoaded(this.testChapterModel);
}

class TestModuleChapterFailed extends TestModuleChapterStates {}

abstract class TestModuleTopicStates {}

class TestModuleTopicLoading extends TestModuleTopicStates {}

class TestModuleTopicFailed extends TestModuleTopicStates {}

class TestModuleTopicLoaded extends TestModuleTopicStates {
  final List<TestTopicModel> testTopicModel;
  TestModuleTopicLoaded(this.testTopicModel);
}

abstract class QuestionTypeStates {}

class QuestionTypeLoading extends QuestionTypeStates {}

class QuestionTypeLoaded extends QuestionTypeStates {
  final List<QuestionType> questionType;
  final List<QuestionTypeSingle> singleTypeQuestions;
  QuestionTypeLoaded(this.questionType, this.singleTypeQuestions);
}

abstract class LearningOutcomeStates {}

class LearningOutcomeLoading extends LearningOutcomeStates {}

class LearningOutcomeLoaded extends LearningOutcomeStates {
  final List<LearningOutcome> learningOutcome;
  LearningOutcomeLoaded(this.learningOutcome);
}

abstract class QuestionAnswerStates {}

abstract class SubmitMarksStates {
  List<AnswerDetail> answerDetails;
}

class FreeTextAnswerSubmission extends SubmitMarksStates{
  List<AnswerDetail> answerDetails = [];

  FreeTextAnswerSubmission(this.answerDetails);
}
class QuestionAnswerLoading extends QuestionAnswerStates {}

class QuestionAnswerLoaded extends QuestionAnswerStates {
  final List<QuestionPaperAnswer> answer;
  QuestionAnswerLoaded(this.answer);
}

abstract class CorrectQuestionState {}

class CorrectQuestionsLoading extends CorrectQuestionState {}

class CorrectQuestionsLoaded extends CorrectQuestionState {
  final List<CorrectedAnswer> answers;
  CorrectQuestionsLoaded(this.answers);
}

abstract class QuestionCategoryStates {}

class QuestionCategoryLoading extends QuestionCategoryStates {}

class QuestionCategoryLoaded extends QuestionCategoryStates {
  List<QuestionCategory> categories;
  QuestionCategoryLoaded(this.categories);
}
