
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/view/test-module/TestUtils.dart';

import 'question_view.dart';

class TestEvaluation extends StatefulWidget {
  TestEvaluation(
      {Key key,
      this.questionPaper,
      this.questionPaperAnswer,
      this.correctedAnswer,
      this.count})
      : super(key: key);

  final QuestionPaper questionPaper;
  final QuestionPaperAnswer questionPaperAnswer;
  final List<CorrectedAnswer> correctedAnswer;
  int count;

  @override
  _TestEvaluationState createState() => _TestEvaluationState();
}

class _TestEvaluationState extends State<TestEvaluation> {
  PageController pageController ;

  SecureStorage storage = SecureStorage();

  bool status;

  // bool chnage = false;

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    String statusText = widget.questionPaperAnswer.status;
    pageController = PageController(initialPage: widget.count);
    status = statusText == 'Under Review' ? false : true;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: KeyboardDismissOnTap(
              child: Container(
                // height: 200,
                color: Theme.of(context).backgroundColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.arrow_back_outlined)),
                            ],
                          ),
                          // status
                          //     ? Container(
                          //         height: 0,
                          //         width: 0,
                          //       )
                          //     : TextButton(
                          //         onPressed: () {
                          //           sample();
                          //         },
                          //         child: const Text('Final Evaluation'),
                          //       ),
                          // Visibility(
                          //   maintainSize: true,
                          //   maintainAnimation: true,
                          //   maintainState: true,
                          //   // visible: status ? false : true,
                          //   visible: false,
                          //   child: Container(
                          //     height: 40.0,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(20.0)
                          //     ),
                          //     child: RaisedButton(
                          //       child: Text('Submit Evaluation'),
                          //         color: Colors.blue,
                          //         textColor: Colors.white,
                          //         onPressed: () {
                          //         //  sample();
                          //         },
                          //
                          //     ),
                          //   ),
                          // ),

                        ],
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height - 100,
                        child: PageView.builder(
                            physics: BouncingScrollPhysics(),
                            onPageChanged: (index) {},
                            controller: pageController,
                          // itemCount: widget.questionPaperAnswer.answerDetails.length,
                          //   itemCount: widget.count != null
                          //       ? 1
                          //       : widget
                          //           .questionPaper.section[0].section.length,
                          itemCount: widget.questionPaper.section[0].section.length,
                            itemBuilder: (context, index) {
                              return QuestionView(
                                // index: widget.count ?? index,
                                index: index,
                                count: widget.count,
                                questionPaper: widget.questionPaper,
                                answer: widget.questionPaperAnswer,
                                //freeTextMarks: widget.freeTextMarks,
                              );
                            },
                          scrollDirection: Axis.horizontal,
                          allowImplicitScrolling: true,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void exitDialog() {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Success'),
  //           content: const Text(
  //               'You have successfully Submitted the marks for this Paper'),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   for (int i = 1; i <= 5; i++) {
  //                     Navigator.of(context).pop();
  //                   }
  //                 },
  //                 child: const Text('Ok'))
  //           ],
  //         );
  //       });
  // }

  // void sample() {
  //   List<String> questionIds = [];
  //   List<String> comQuestionIds = [];
  //   List<String> comFreeTextIds = [];
  //   List<AnswerDetail> list = [];
  //   List<Answer> list2 = [];
  //   String studentId;
  //
  //   studentId = widget.questionPaperAnswer.studentDetails.studentId;
  //
  //   for (var element in widget.questionPaper.section[0].section) {
  //     if (element.questionType.first == 'freeText') {
  //       questionIds.add(element.id);
  //     }
  //     if (element.questionType.first == 'comprehension') {
  //       for (var i in element.questions) {
  //         if (i.questionType.first == 'freeText') {
  //           comQuestionIds.add(element.id);
  //           comFreeTextIds.add(i.id);
  //         }
  //       }
  //     }
  //   }
  //
  //   storage.readAll().then((value) {
  //     Map map = value;
  //
  //     for (var element in questionIds) {
  //       map.forEach((key, value) {
  //         if (element == key) {
  //           List l1 = value.toString().split(',');
  //
  //           list.add(AnswerDetail(
  //               answers: list2 ?? [],
  //               questionId: key,
  //               id: l1[0],
  //               obtainedMarks: int.tryParse(l1[1])));
  //         }
  //       });
  //     }
  //
  //     for (var element in comQuestionIds) {
  //       map.forEach((key, value) {
  //         if (element == key) {
  //           List l1 = value.toString().split(',');
  //         }
  //       });
  //     }
  //
  //     submit(list);
  //   });
  // }

  // String submit(List<AnswerDetail> list) {
  //   List<AnswerDetail> answerDetails = [];
  //   AnswerDetail answerDetail;
  //   FreeTextAnswer answer;
  //   String qId = widget.questionPaperAnswer.questionId;
  //   for (var element in list) {
  //     answerDetail = AnswerDetail(
  //         answers: element.answers,
  //         questionId: element.questionId,
  //         obtainedMarks: element.obtainedMarks,
  //         correctOrNot: 'Yes',
  //         id: element.id);
  //     answerDetails.add(answerDetail);
  //   }
  //   answer = FreeTextAnswer(
  //     questionId: qId,
  //     studentId: widget.questionPaperAnswer.studentDetails.studentId,
  //     isEvaluated: true,
  //     answerDetails: answerDetails,
  //   );
  //   log(answerDetail.toString());
  //   log('before submitting ' + answer.toJson().toString());
  //
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text("Final Submission"),
  //           content: Container(
  //             height: MediaQuery.of(context).size.height * 0.10,
  //             child: Column(
  //               children: const [
  //                 Text('Proceed to Evaluate Paper'),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               child: const Text('cancel'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             FlatButton(
  //               onPressed: () {
  //                 BlocProvider.of<QuestionAnswerCubit>(context)
  //                     .submitFreeTextMarks(freeTextAnswer: answer)
  //                     .then((value) {
  //                   log(value.toString());
  //                 });
  //                 storage.deleteAll();
  //                 exitDialog();
  //               },
  //               child: const Text("Submit"),
  //               color: const Color(0xffFFC30A),
  //               textColor: Colors.white,
  //             )
  //           ],
  //         );
  //       });
  // }
}


