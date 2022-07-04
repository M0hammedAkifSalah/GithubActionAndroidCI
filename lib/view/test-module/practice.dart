import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '/bloc/test-module/test-module-states.dart';
import '/export.dart';
import '/model/class-schedule.dart';
import '/view/test-module/practice2.dart';
import '/view/utils/custom-tagfield.dart';
import 'constants.dart';

class PracticeQuestionPaper extends StatefulWidget {
  const PracticeQuestionPaper({Key key}) : super(key: key);

  @override
  _PracticeQuestionPaperState createState() => _PracticeQuestionPaperState();
}

class _PracticeQuestionPaperState extends State<PracticeQuestionPaper> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool autoFetch = true;
  List<QuestionTypeSingle> selected = [];
  List<QuestionType> autoGenerate = [];
  List<String> learningOutcome = [];
  List<String> testChapter = [];
  List<String> testTopic = [];
  PanelController panelController = PanelController();
  GlobalKey<FormState> generateFormKey = GlobalKey<FormState>();
  TextEditingController questionCategoryController = TextEditingController();
  TextEditingController instructionController = TextEditingController();
  TextEditingController qidController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List<String> questionCategory = [];
  String _practices;
  SchoolClassDetails _class;
  TestClass testClass = TestClass();
  Subjects _subject;
  String _language;
  TestDifficultyLevel testDifficultyLevel;
  String difficultyLevel;
  String studentType;
  ExamType _examType;
  int coin;
  int award;
  QuestionPaper paper = QuestionPaper();
  bool comprehension = false;
  final focusNode = FocusNode();

  bool subjectId = false;
  bool isShouldChapterRecreate = false;

  TextEditingController chapterController = TextEditingController();
  GlobalKey<TextFieldTagsState> key = GlobalKey<TextFieldTagsState>();

  @override
  void initState() {
    super.initState();
  }

  int get getTotalQuestion {
    return selected.fold<int>(
        0, (previousValue, element) => previousValue + element.totalQuestions);
  }

  int getTotalFetchedQuestion(List<QuestionTypeSingle> type) {
    return type.fold(0,
        (previousValue, element) => previousValue + element.selectedQuestions);
  }

  Widget fetchQuestionDialog() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlocBuilder<QuestionTypeCubit, QuestionTypeStates>(
        builder: (context, state) {
          if (state is QuestionTypeLoaded) {
            List<QuestionTypeSingle> list1 = [];
           for(var i in state.singleTypeQuestions)
             {
               if(i.totalQuestions != 0)
                 {
                   list1.add(i);
                 }
             }

            return Container(
              margin: EdgeInsets.only(),
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: state.questionType.isEmpty
                      ? Center(
                          child: Container(
                            child: Text('No Matched Questions'),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // height: 40,
                                  child: Text(
                                    "Select Questions",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: kBlackColor,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                                Container(
                                  // height: 58,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              top: 3,
                                              bottom: 3),
                                          child: Center(
                                            child: InkWell(
                                              onTap: () {
                                                log(selected.length.toString());
                                                if (selected.length !=
                                                    list1.length) {
                                                  log('true');
                                                  selected =
                                                      list1;
                                                } else {
                                                  log('false');
                                                  selected = [];
                                                }
                                                setState(() {});
                                                log(selected.length.toString());

                                              },
                                              child: Text(
                                                    selected.length !=
                                                        list1.length
                                                    ? "Select All"
                                                    : 'Deselect All',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: kBlackColor,
                                                    letterSpacing: 0.3,
                                                    decoration:
                                                        TextDecoration.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Total Questions",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: kBlackColor,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "$getTotalQuestion",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: kBlackColor,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: list1.length,
                                itemBuilder: (BuildContext context, int index) {

                                  QuestionTypeSingle type =
                                      list1[index];
                                  if (type.totalQuestions == 0) {
                                    return Container();
                                  }
                                  return Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              type.title,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: kBlackColor,
                                                  letterSpacing: 0.3,
                                                  decoration:
                                                      TextDecoration.none),
                                            ),
                                            Text(
                                              "${type.totalQuestions}",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: kBlackColor,
                                                letterSpacing: 0.3,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              selected.contains(type)
                                                  ? "${type.totalQuestions} selected"
                                                  : "0 selected",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: kBlackColor,
                                                letterSpacing: 0.3,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.03,
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                    top: 3,
                                                    bottom: 3),
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (!selected.contains(
                                                          list1[
                                                              index])) {
                                                        selected.add(list1[
                                                            index]);
                                                      } else {
                                                        selected.remove(list1[
                                                            index]);
                                                      }
                                                      setState(() {});

                                                    },
                                                    child: Text(
                                                      !selected.contains(list1[
                                                              index])
                                                          ? "Select"
                                                          : "Deselect",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: kBlackColor,
                                                          letterSpacing: 0.3,
                                                          decoration:
                                                              TextDecoration
                                                                  .none),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Consumer<TimePicker>(
                              builder: (context, value, child) => InkWell(
                                onTap: () {
                                  List<QuestionType> questions = [];
                                  for (var i in selected) {
                                    for (var j in i.questionType) {
                                      j.selected = true;
                                    }
                                    questions.addAll(i.questionType);
                                  }

                                  paper.classId = _class.classId;
                                  paper.detailQuestionPaper =
                                      DetailQuestionPaper(
                                    questionCategory: questionCategory,
                                    testDifficultyLevel: testDifficultyLevel,
                                    chapters: List<TestChapter>.from(testChapter
                                        .map((e) => TestChapter(chapter: e))),
                                    topic: List<TestTopic>.from(testTopic
                                        .map((e) => TestTopic(topicId: e))),
                                    className: _class.className,
                                    testClass: testClass,
                                    studentType: [studentType],
                                    language: _language,
                                    learningOutcome: [
                                      LearningOutcomeSection(learningOutcome)
                                    ],
                                    subject: [_subject],
                                    examType:
                                        _examType == null ? [] : [_examType.id],
                                    totalQuestion: questions.length,
                                  );
                                  paper.award = award;
                                  paper.coin = coin;
                                  paper.questionTitle = titleController.text;
                                  paper.qid = qidController.text;
                                  paper.duration = value.getTime;

                                  paper.section = [
                                    QuestionSectionList(
                                      information: instructionController.text,
                                      section: questions
                                          .map(
                                            (e) {

                                              return QuestionSection(
                                              answer: e.answer,
                                              id: e.id,
                                              questions: e.questions
                                                  .map(
                                                    (v) => QuestionSection(
                                                        answer: v?.answer,
                                                        id: v?.id,
                                                        matchOptions:
                                                            v?.matchOption,
                                                        negativeScore: v != null
                                                            ? v.negativeScore
                                                                .toString()
                                                            : null,
                                                        question: v?.question,
                                                        options: v?.options,
                                                        questionType:
                                                            v?.questionType,
                                                        duration: value.getTime,
                                                        totalMarks: v.totalMarks,
                                                        reason: v.reason,
                                                        negativeMarks: v.negativeMarks,
                                                        optionsType: v.optionType,
                                                        // e.questions.fold(
                                                        //     0,
                                                        //     (previousValue, element) =>
                                                        //         previousValue +
                                                        //         element.totalMarks),
                                                        ),
                                                  )
                                                  .toList(),
                                              matchOptions: e.matchOption,
                                              negativeScore:
                                                  e.negativeScore.toString(),
                                              question: e.question,
                                              options: e.options,
                                              questionType: e.questionType,
                                              duration: value.getTime,
                                              negativeMarks: e.negativeMarks,
                                              optionsType: e.optionType,
                                              totalMarks:
                                                  //e.totalMarks
                                                  questions.fold(
                                                      0,
                                                      (previousValue,
                                                              element) =>
                                                          previousValue +
                                                          element.totalMarks),
                                              reason: e.reason
                                            );},
                                          )
                                          .toList(),
                                    )
                                  ];
                                  if (questions.isNotEmpty) {
                                    Navigator.of(context)
                                        .push(
                                      createRoute(
                                          pageWidget: SelectQuestionPaper(
                                              questions, paper)),
                                    )
                                        .then((value) {
                                      questions.clear();
                                      setState(() {});
                                    });
                                  }
                                  else
                                    {
                                      Fluttertoast.showToast(msg: 'Kindly select atleast one Question Type');
                                    }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const Center(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: kBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                ),
              ),
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget autoGenerateDialog() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: BlocBuilder<QuestionTypeCubit, QuestionTypeStates>(
        builder: (context, state) {
          if (state is QuestionTypeLoaded) {
            List<QuestionTypeSingle> type = state.singleTypeQuestions;
            return Container(
              margin: EdgeInsets.only(
                top: 80,
              ),
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            child: Text(
                              "Auto Generate QP",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kBlackColor,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Total Questions",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: kBlackColor,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                Text(
                                  "${getTotalFetchedQuestion(state.singleTypeQuestions)}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: kBlackColor,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Form(
                          key: generateFormKey,
                          child: ListView.builder(
                              itemCount: type.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (type[index].totalQuestions == 0) {
                                  return Container(
                                    height: 0,
                                  );
                                }
                                return Container(
                                  height: 60,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "${type[index].title}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: kBlackColor,
                                              letterSpacing: 0.3,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          Text(
                                            "${type[index].totalQuestions} Question Available",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: kBlackColor,
                                              letterSpacing: 0.3,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.minus),
                                              iconSize: 15,
                                              disabledColor: Colors.grey,
                                              onPressed: type[index]
                                                          .selectedQuestions ==
                                                      0
                                                  ? null
                                                  : () {
                                                      type[index]
                                                          .selectedQuestions -= 1;

                                                      setState(() {});
                                                    }),
                                          Text(
                                            type[index]
                                                .selectedQuestions
                                                .toString(),
                                            style: buildTextStyle(
                                                size: 20,
                                                weight: FontWeight.bold),
                                          ),
                                          IconButton(
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.plus),
                                              iconSize: 15,
                                              disabledColor: Colors.grey,
                                              onPressed: type[index]
                                                          .selectedQuestions ==
                                                      type[index].totalQuestions
                                                  ? null
                                                  : () {
                                                      type[index]
                                                          .selectedQuestions += 1;
                                                      setState(() {});
                                                    })
                                          // SizedBox(
                                          //   width: 50,
                                          //   height: 50,
                                          //   child: TextFormField(
                                          //     key: UniqueKey(),
                                          //     controller:
                                          //         TextEditingController.fromValue(
                                          //       TextEditingValue(
                                          //         text: selected
                                          //             .firstWhere(
                                          //                 (element) =>
                                          //                     element.title ==
                                          //                     type[index].title,
                                          //                 orElse: () {
                                          //               return QuestionTypeSingle(
                                          //                   totalQuestions: 0);
                                          //             })
                                          //             .totalQuestions
                                          //             .toString(),
                                          //       ),
                                          //     ),
                                          //     // initialValue: selected
                                          //     //         .contains(type[index])
                                          //     //     ? '${selected.firstWhere((element) => element.title == type[index].title).totalQuestions}'
                                          //     //     : '0',
                                          //     maxLength: 2,
                                          //     validator: (value) {
                                          //       selected.removeWhere((element) =>
                                          //           element.title ==
                                          //           type[index].title);
                                          //       if (int.parse(value) >
                                          //               type[index]
                                          //                   .totalQuestions ||
                                          //           int.parse(value) == 0 ||
                                          //           value.isEmpty)
                                          //         return 'Enter a valid number';
                                          //       else {
                                          //         var questions = type[index]
                                          //             .questionType
                                          //             .sublist(
                                          //                 0, int.parse(value));
                                          //         selected.add(QuestionTypeSingle(
                                          //             questionType: questions,
                                          //             totalQuestions:
                                          //                 questions.length,
                                          //             title: type[index].title));
                                          //         print(selected);
                                          //         return null;
                                          //       }
                                          //     },
                                          //     onChanged: (value) {
                                          //       print(selected
                                          //           .firstWhere(
                                          //               (element) =>
                                          //                   element.title ==
                                          //                   type[index].title,
                                          //               orElse: () {
                                          //             return QuestionTypeSingle(
                                          //                 totalQuestions: 0);
                                          //           })
                                          //           .totalQuestions
                                          //           .toString());
                                          //       // generateFormKey.currentState
                                          //       //     .validate();
                                          //     },
                                          //     textAlign: TextAlign.center,
                                          //     decoration: InputDecoration(
                                          //       counterText: '',
                                          //       errorBorder: OutlineInputBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(4),
                                          //       ),
                                          //       border: OutlineInputBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(4),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Consumer<TimePicker>(
                        builder: (context, value, child) => InkWell(
                          onTap: () {
                            List<QuestionType> questions = [];
                            for (var i in type) {
                              for (var j = 0; j < i.selectedQuestions; j++) {
                                i.questionType[j].selected = true;
                              }
                              questions.addAll(i.questionType);
                            }

                            paper.classId = _class.classId;
                            paper.detailQuestionPaper = DetailQuestionPaper(
                              questionCategory: questionCategory,
                              testDifficultyLevel: testDifficultyLevel,
                              chapters: List<TestChapter>.from(testChapter
                                  .map((e) => TestChapter(chapter: e))),
                              topic: List<TestTopic>.from(
                                  testTopic.map((e) => TestTopic(topicId: e))),
                              className: _class.className,
                              testClass: testClass,
                              studentType: [studentType],
                              language: _language,
                              subject: [_subject],
                              examType: _examType != null ? [_examType.id] : [],
                              learningOutcome: [
                                LearningOutcomeSection(learningOutcome)
                              ],
                              totalQuestion: questions.length,
                            );
                            paper.award = award;
                            paper.coin = coin;
                            paper.qid = qidController.text;
                            paper.questionTitle = titleController.text;
                            paper.duration = value.getTime;
                            paper.section = [
                              QuestionSectionList(
                                information: instructionController.text,
                                section: questions
                                    .map(
                                      (e) => QuestionSection(
                                        id: e.id,
                                        answer: e.answer,
                                        matchOptions: e.matchOption,
                                        negativeScore:
                                            e.negativeScore.toString(),
                                        question: e.question,
                                        questionType: e.questionType,
                                        duration:
                                            '${value.getHours}h ${value.getMins} min',
                                        totalMarks: questions.fold(
                                            0,
                                            (previousValue, element) =>
                                                previousValue +
                                                element.totalMarks),
                                      ),
                                    )
                                    .toList(),
                              )
                            ];
                            Navigator.of(context)
                                .push(
                              createRoute(
                                pageWidget:
                                    SelectQuestionPaper(questions, paper),
                              ),
                            )
                                .then((value) {
                              questions.clear();
                              setState(() {});
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 60,
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: const Center(
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  String validator(String value) {
    if (value.isEmpty) return "Please provide a value";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (instructionController.text.isEmpty) {
          return true;
        }
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure to go back?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                )
              ],
            );
          },
        );
      },
      child: SlidingUpPanel(
        controller: panelController,
        minHeight: 0,
        maxHeight: 510,
        borderRadius: BorderRadius.circular(20),
        backdropEnabled: true,
        panel: autoFetch ? fetchQuestionDialog() : autoGenerateDialog(),
        body: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 5,
            title: const Text(
              "PRACTICE QUESTION PAPER",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kBlackColor),
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Consumer<TimePicker>(
                        builder: (context, value, child) => Column(
                          children: [
                            BlocBuilder<AuthCubit, AuthStates>(
                                builder: (context, state) {
                              if (state is AccountsLoaded) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TeacherProfileAvatar(
                                      imageUrl:
                                          state.user.profileImage ?? 'text',
                                    ),
                                    Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Container(
                                          //   height: 35,
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.45,
                                          //   child: Row(children: [
                                          const Text(
                                            "Created by",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: kBlackColor),
                                          ),
                                          Text(
                                            state.user.name.toTitleCase(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: kBlackColor),
                                          ),
                                          //   ]),
                                          // ),
                                          Container(
                                            height: 30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: kGreyColor,
                                                    width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 2,
                                                  top: 2,
                                                ),
                                                child: DropdownButton<String>(
                                                  focusColor: Colors.white,
                                                  value: _practices,
                                                  //elevation: 5,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  iconEnabledColor:
                                                      Colors.black,
                                                  items: <String>[
                                                    'Practice',
                                                    "Test"
                                                  ].map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  hint: Text(
                                                    "Test Type",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kBlackColor),
                                                  ),
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      _practices = value;
                                                      isShouldChapterRecreate =
                                                      !isShouldChapterRecreate;
                                                      instructionController.clear();
                                                      qidController.clear();
                                                      titleController.clear();
                                                      award = 0;
                                                      coin = 0;
                                                      _subject = null;
                                                      _class = null;
                                                      _language=null;
                                                      _examType=null;
                                                      testDifficultyLevel=null;
                                                      studentType=null;
                                                      //formKey.currentState.reset();
                                                      // initState();

                                                    });
                                                  },
                                                ),
                                                // Text(
                                                //   "Practice Text",
                                                //   style: TextStyle(
                                                //       fontSize: 10,
                                                //       fontWeight: FontWeight.w400,
                                                //       color: kBlackColor),
                                                // ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: 35,
                                          //   width: MediaQuery.of(context)
                                          //           .size
                                          //           .width *
                                          //       0.4,
                                          //   child: InkWell(
                                          //     onTap: () {
                                          //       showDialog(
                                          //         context: context,
                                          //         builder: (context) {
                                          //           return TimePickerWidget();
                                          //         },
                                          //       );
                                          //     },
                                          //     child: Padding(
                                          //       padding:
                                          //           const EdgeInsets.all(8.0),
                                          //       child: Row(
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.center,
                                          //         children: [
                                          //           Icon(
                                          //             Icons.timelapse,
                                          //             size: 20,
                                          //           ),
                                          //           Text(
                                          //             value.getHours == 0 &&
                                          //                     value.getMins == 0
                                          //                 ? "  Set Test Time"
                                          //                 : value.getTime,
                                          //             style: TextStyle(
                                          //                 fontSize: 14,
                                          //                 fontWeight:
                                          //                     FontWeight.w600,
                                          //                 color: kBlackColor),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        List<int> score =
                                            await showAddTestScoreDialogue(
                                                context,
                                                award: award,
                                                coin: coin);
                                        if (score != null) {
                                          award = score[0];
                                          coin = score[1];
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/trophy.svg',
                                              height: 30,
                                            ),
                                            Container(
                                              child: Center(
                                                child: Text(
                                                  "${award ?? 0}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kBlackColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        List<int> score =
                                            await showAddTestScoreDialogue(
                                                context,
                                                award: award,
                                                coin: coin);
                                        if (score != null) {
                                          award = score[0];
                                          coin = score[1];
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 100,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/points.png',
                                              height: 30,
                                            ),
                                            Container(
                                              child: Center(
                                                child: Text(
                                                  "${coin ?? 0}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: kBlackColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 80,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          const Text(
                                            "QP ID",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: kBlackColor),
                                          ),
                                          Container(
                                            width: 55,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: kGreyColor,
                                                    width: 0.5),
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                            child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  // left: 12,
                                                  // right: 4,
                                                  bottom: 2,
                                                  top: 2,
                                                ),
                                                child: SizedBox(
                                                  width: 40,
                                                  height: 50,
                                                  child: TextFormField(
                                                    controller: qidController,
                                                    validator: validator,
                                                    cursorColor: kGreyColor,
                                                    maxLength: 3,
                                                    decoration: InputDecoration(
                                                      counterText: '',
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: kGreyColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      fillColor: kLightColor,
                                                      hintStyle: TextStyle(
                                                        color: kGreyColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                BlocProvider.of<AuthCubit>(context)
                                    .checkAuthStatus();
                                return Container();
                              }
                            }),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              color: kLightColor,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.1,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.event_note_sharp,
                                      size: 20,
                                      color: kBlackColor,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Test Instructions",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kBlackColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 80,
                              decoration: BoxDecoration(
                                color: kLightColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: kGreyColor,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.03,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Center(
                                  child: TextFormField(
                                    focusNode: focusNode,
                                    onTap: () {
                                      // FocusManager.instance.primaryFocus?.unfocus();
                                    },
                                    // validator: validator,
                                    controller: instructionController,
                                    maxLines: 3,
                                    cursorColor: kGreyColor,
                                    decoration: InputDecoration(
                                      hintText: "Test instructions",
                                      labelStyle: const TextStyle(
                                        color: kGreyColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      fillColor: kLightColor,
                                      hintStyle: TextStyle(
                                          color: kGreyColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kLightColor),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: kLightColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40,
                              color: kLightColor,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.1,
                                  right:
                                      MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Details",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kBlackColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 68,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  classDropDown(context),
                                  subjectDropDown(context),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 68,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  languageDropDown(context),
                                  examTypeDropDown(context),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 68,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  difficultyDropDown(context),
                                  studentTypeDropDown(context),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<LearningOutcomeCubit,
                                    LearningOutcomeStates>(
                                builder: (context, learningState) {
                              if (learningState is LearningOutcomeLoaded) {
                                return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kGreyColor, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                        ),
                                        child: TextFormField(
                                          controller: titleController,
                                          maxLines: 1,
                                          validator: validator,
                                          cursorColor: kGreyColor,
                                          decoration: InputDecoration(
                                            labelText: "Question Paper Title",
                                            labelStyle: const TextStyle(
                                                color: kGreyColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            fillColor: kLightColor,
                                            hintStyle: const TextStyle(
                                                color: kGreyColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kLightColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kLightColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    BlocBuilder<QuestionCategoryCubit,
                                            QuestionCategoryStates>(
                                        builder: (context, state) {
                                      if (state is QuestionCategoryLoaded) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kGreyColor, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            child: CustomTextFieldTags(
                                              key: ValueKey<bool>(
                                                  isShouldChapterRecreate),
                                              tagsStyler: TagsStyler(
                                                tagCancelIcon: const Icon(
                                                  Icons.cancel,
                                                  size: 18.0,
                                                  color: Colors.black,
                                                ),
                                                tagDecoration:
                                                    const BoxDecoration(
                                                  color: Color(0xffFFF2C9),
                                                ),
                                              ),
                                              onTag: (tag) {},
                                              onDelete: (tag) {},
                                              tagList: (tagList) {
                                                var category = state.categories
                                                    .where((element) => tagList
                                                        .contains(element.name))
                                                    .map((e) => e.id)
                                                    .toList();
                                                questionCategory = category;
                                              },
                                              suggestionList: state.categories,
                                              textFieldStyler: TextFieldStyler(
                                                cursorColor: kGreyColor,
                                                hintText: "Question Category",
                                                hintStyle: const TextStyle(
                                                    color: kGreyColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textFieldFilledColor:
                                                    kLightColor,
                                                textFieldEnabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kLightColor),
                                                ),
                                                textFieldFocusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kLightColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        BlocProvider.of<QuestionCategoryCubit>(
                                                context)
                                            .getAllQuestionCategory();
                                        return Container();
                                      }
                                    }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    BlocBuilder<TestModuleChapterCubit,
                                            TestModuleChapterStates>(
                                        builder: (context, chapterState) {
                                      if (chapterState
                                          is TestModuleChapterLoaded) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kGreyColor, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            child: CustomTextFieldTags(
                                              key: ValueKey<bool>(
                                                  isShouldChapterRecreate),
                                              tagsStyler: TagsStyler(
                                                tagCancelIcon: const Icon(
                                                  Icons.cancel,
                                                  size: 18.0,
                                                  color: Colors.black,
                                                ),
                                                tagDecoration:
                                                    const BoxDecoration(
                                                  color: Color(0xffFFF2C9),
                                                ),
                                              ),
                                              onTag: (tag) {
                                                String chapterId;
                                                for (var i in chapterState
                                                    .testChapterModel) {
                                                  if (i.name == tag) {
                                                    chapterId = i.id;
                                                  }
                                                }
                                                BlocProvider.of<
                                                            TestModuleTopicCubit>(
                                                        context)
                                                    .loadAllTopics(
                                                        _class.classId,
                                                        _subject.id,
                                                        chapterId);
                                              },
                                              onDelete: (tag) {
                                                // log('true');
                                              },
                                              tagList: (tagList) {
                                                var chapter = chapterState
                                                    .testChapterModel
                                                    .where((element) => tagList
                                                        .contains(element.name))
                                                    .map((e) => e.id)
                                                    .toList();
                                                testChapter = chapter;
                                              },
                                              suggestionList: _subject == null
                                                  ? []
                                                  : chapterState
                                                      .testChapterModel
                                                      .map((e) => e.name)
                                                      .toList(),
                                              textFieldStyler: TextFieldStyler(
                                                cursorColor: kGreyColor,
                                                hintText: "Chapters",
                                                hintStyle: const TextStyle(
                                                    color: kGreyColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textFieldFilledColor:
                                                    kLightColor,
                                                textFieldEnabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kLightColor),
                                                ),
                                                textFieldFocusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kLightColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        // BlocProvider.of<TestModuleChapterCubit>(
                                        //         context)
                                        //     .loadAllChapters(
                                        //         _class.classId, _subject.id);
                                        return Container();
                                      }
                                    }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    BlocBuilder<TestModuleTopicCubit,
                                            TestModuleTopicStates>(
                                        builder: (context, topicState) {
                                      if (topicState is TestModuleTopicLoaded) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kGreyColor, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                            ),
                                            child: CustomTextFieldTags(
                                              key: ValueKey<bool>(
                                                  isShouldChapterRecreate),
                                              tagsStyler: TagsStyler(
                                                tagCancelIcon: const Icon(
                                                  Icons.cancel,
                                                  size: 18.0,
                                                  color: Colors.black,
                                                ),
                                                tagDecoration:
                                                    const BoxDecoration(
                                                  color: Color(0xffFFF2C9),
                                                ),
                                              ),
                                              onTag: (tag) {},
                                              onDelete: (tag) {},
                                              tagList: (tagList) {
                                                var topic = topicState
                                                    .testTopicModel
                                                    .where((element) => tagList
                                                        .contains(element.name))
                                                    .map((e) => e.id)
                                                    .toList();
                                                testTopic = topic;
                                              },
                                              suggestionList: topicState
                                                  .testTopicModel
                                                  .map((e) => e.name)
                                                  .toList(),
                                              textFieldStyler: TextFieldStyler(
                                                cursorColor: kGreyColor,
                                                hintText: "Topics",
                                                hintStyle: const TextStyle(
                                                    color: kGreyColor,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textFieldFilledColor:
                                                    kLightColor,
                                                textFieldEnabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kLightColor),
                                                ),
                                                textFieldFocusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kLightColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                );
                              } else {
                                BlocProvider.of<LearningOutcomeCubit>(context)
                                    .getLearningOutcome();
                                return Container();
                              }
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                if (coin == null ||
                                    award == null ||
                                    _class == null ||
                                    _subject == null ||
                                    (value.getHours == 0 &&
                                        value.getMins == 0)) {
                                  showValidationDialogue(context);
                                  return;
                                }
                                if (formKey.currentState.validate()) {
                                  autoFetch = true;
                                  selected.clear();
                                  setState(() {
                                    BlocProvider.of<QuestionTypeCubit>(context)
                                        .loadAllQuestionType(
                                            _class != null
                                                ? _class.classId
                                                : '',
                                            _subject != null ? _subject.id : '',
                                            _examType != null
                                                ? _examType.id
                                                : '');
                                    panelController.open();
                                  });
                                } else {
                                  print('Data not entered completely');
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const Center(
                                  child: Text(
                                    "Fetch Questions",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                autoFetch = false;
                                if (coin == null ||
                                    award == null ||
                                    _class == null ||
                                    _subject == null ||
                                    (value.getHours == 0 &&
                                        value.getMins == 0)) {
                                  showValidationDialogue(context);
                                  return;
                                }
                                if (formKey.currentState.validate()) {
                                  selected.clear();
                                  setState(() {
                                    BlocProvider.of<QuestionTypeCubit>(context)
                                        .loadAllQuestionType(
                                            _class.classId, _subject.id, '');
                                    panelController.open();
                                  });
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Text(
                                    "Auto Generate Questions",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            KeyboardVisibilityBuilder(
                              builder: (_, isKeyboardVisible) => SizedBox(
                                height: isKeyboardVisible ? 100 : 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column classDropDown(BuildContext context) {
    return Column(
      children: [
        Text(
          "Class/Grade",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 42,
            decoration: BoxDecoration(
                border: Border.all(color: kGreyColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child:
                      BlocBuilder<TestModuleClassCubit, TestModuleClassStates>(
                          builder: (context, state) {
                    if (state is TestClassesLoaded) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<SchoolClassDetails>(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _subject = null;
                          },
                          focusColor: Colors.white,
                          value: _class,
                          //elevation: 5,
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: state.classDetails
                              .map<DropdownMenuItem<SchoolClassDetails>>(
                                  (SchoolClassDetails value) {
                            return DropdownMenuItem<SchoolClassDetails>(
                              value: value,
                              child: Text(
                                value.className,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            "Class",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor),
                          ),
                          onChanged: (SchoolClassDetails value) {
                            setState(() {
                              _class = value;
                              isShouldChapterRecreate =
                                  !isShouldChapterRecreate;
                              subjectId = true;
                              testClass.name = _class.className ?? '';
                              testClass.id = _class.classId ?? '';
                              BlocProvider.of<TestModuleSubjectCubit>(context)
                                  .loadAllSubjects(
                                      _class == null ? '' : _class.classId);
                              BlocProvider.of<TestModuleSubjectCubit>(context)
                                  .loadAllSubjects(
                                      _class == null ? '' : _class.classId)
                                  .then((value) {});
                            });
                          },
                        ),
                      );
                    } else {
                      BlocProvider.of<TestModuleClassCubit>(context)
                          .loadAllClasses();
                      return Container();
                    }
                  }),
                ),
              ),
            ))
      ],
    );
  }

  Column subjectDropDown(BuildContext context) {
    return Column(
      children: [
        Text(
          "Subject",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 42,
          decoration: BoxDecoration(
              border: Border.all(color: kGreyColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.01,
                ),
                child: BlocBuilder<TestModuleSubjectCubit,
                    TestModuleSubjectStates>(builder: (context, state) {
                  if (state is TestModuleSubjectLoaded) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<Subjects>(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        focusColor: Colors.white,
                        isExpanded: true,
                        value: _subject,
                        //elevation: 5,
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: (state.subjects.isEmpty
                                ? [Subjects(name: 'No Subject present')]
                                : state.subjects)
                            .map<DropdownMenuItem<Subjects>>((Subjects value) {
                          return DropdownMenuItem<Subjects>(
                            value: value ?? 'No Subject',
                            child: Text(
                              value.name,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: const Text(
                          "Subject",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor,
                          ),
                        ),
                        onChanged: (Subjects value) {
                          BlocProvider.of<TestModuleChapterCubit>(context)
                              .loadAllChapters(_class.classId, value.id)
                              .then((value) {
                            log('success');
                          });

                          if (state.subjects.isNotEmpty) {
                            setState(() {
                              Column subjectDropDown(BuildContext context) {
                                return Column(
                                  children: [
                                    const Text(
                                      "Subject",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: kGreyColor),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 22,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: kGreyColor, width: 1),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.01,
                                            ),
                                            child: BlocBuilder<
                                                    TestModuleSubjectCubit,
                                                    TestModuleSubjectStates>(
                                                builder: (context, state) {
                                              if (state
                                                  is TestModuleSubjectLoaded) {
                                                return DropdownButton<Subjects>(
                                                  onTap: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                  },
                                                  focusColor: Colors.white,
                                                  isExpanded: true,
                                                  value: _subject,
                                                  //elevation: 5,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                  iconEnabledColor:
                                                      Colors.black,
                                                  items: (state.subjects.isEmpty
                                                          ? [
                                                              Subjects(
                                                                  name:
                                                                      'No Subject present')
                                                            ]
                                                          : state.subjects)
                                                      .map<
                                                              DropdownMenuItem<
                                                                  Subjects>>(
                                                          (Subjects value) {
                                                    return DropdownMenuItem<
                                                        Subjects>(
                                                      value: value,
                                                      child: Text(
                                                        value.name,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  hint: const Text(
                                                    "Subject",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: kBlackColor,
                                                    ),
                                                  ),
                                                  onChanged: (Subjects value) {
                                                    if (state
                                                        .subjects.isNotEmpty) {
                                                      setState(() {
                                                        _subject = value;
                                                      });
                                                    }
                                                  },
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }

                              _subject = value;
                            });
                          }
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column languageDropDown(BuildContext context) {
    return Column(
      children: [
        Text(
          "Language",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 42,
            decoration: BoxDecoration(
                border: Border.all(color: kGreyColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      focusColor: Colors.white,
                      value: _language,
                      //elevation: 5,
                      style: TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.black,
                      items: <String>[
                        "English",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      hint: Text(
                        "Language",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _language = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  Column difficultyDropDown(BuildContext context) {
    return Column(
      children: [
        Text(
          "Test Difficulty",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 42,
          decoration: BoxDecoration(
              border: Border.all(color: kGreyColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.01,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    focusColor: Colors.white,
                    value: difficultyLevel,
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: <String>[
                      ...TestDifficultyLevel().toJson().keys.toList()
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Test Difficulty",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        difficultyLevel = value;
                        var level = TestDifficultyLevel().toJson();
                        level.update(value, (v) => 1);
                        log(level.toString());
                        testDifficultyLevel =
                            TestDifficultyLevel.fromJson(level);
                        log(testDifficultyLevel.toJson().toString());
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column examTypeDropDown(BuildContext context) {
    return Column(
      children: [
        Text(
          "Exam type",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 42,
            decoration: BoxDecoration(
                border: Border.all(color: kGreyColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                  ),
                  child: BlocBuilder<ExamTypeCubit, ExamTypeStates>(
                      builder: (context, state) {
                    if (state is ExamTypeLoaded)
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<ExamType>(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          focusColor: Colors.white,
                          value: _examType,
                          //elevation: 5,
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: state.data.map<DropdownMenuItem<ExamType>>(
                              (ExamType value) {
                            return DropdownMenuItem<ExamType>(
                              value: value,
                              child: Text(
                                value.name,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            "Exam Type",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor),
                          ),
                          onChanged: (ExamType value) {
                            setState(() {
                              _examType = value;
                            });
                          },
                        ),
                      );
                    else {
                      BlocProvider.of<ExamTypeCubit>(context).loadExamType();
                      return Container();
                    }
                  }),
                ),
              ),
            ))
      ],
    );
  }

  Column studentTypeDropDown(BuildContext context) {
    return Column(
      children: [
        Text(
          "Student type",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: kGreyColor,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 42,
          decoration: BoxDecoration(
              border: Border.all(color: kGreyColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.01,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    focusColor: Colors.white,
                    value: studentType,
                    //elevation: 5,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    items: [
                      'Special Needs',
                      'General',
                      'Gifted',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      "Student Type",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        studentType = value;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
