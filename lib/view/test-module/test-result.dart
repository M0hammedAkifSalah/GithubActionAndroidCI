
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/view/test-module/test-evaluation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '/bloc/test-module/test-module-states.dart';
import '/export.dart';
import 'TestUtils.dart';
import 'constants.dart';

class TestResultPage extends StatefulWidget {
  final QuestionPaper questionPaper;
  final QuestionPaperAnswer questionPaperAnswer;

  final StudentInfo student = StudentInfo();

  TestResultPage({
    this.questionPaper,
    this.questionPaperAnswer,
  });

  @override
  _TestResultPageState createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage>  {
  String feedBack;
  bool rewarded = false;
  bool checkForNote = false;
  bool isCorrected = false;
  bool status;
  SecureStorage storage = SecureStorage();
  final TextEditingController _txtComment = TextEditingController();
  QuestionPaperCubit questionPaperCubit = QuestionPaperCubit();
  String buttonText = 'Start Evaluation';

  @override
  void initState() {
    // TODO: implement initState
    if (widget.questionPaperAnswer.status == 'Under Review') {
      isCorrected = false;
    } else {
      isCorrected = true;
    }
    isCorrected ? buttonText = 'View Paper' : buttonText = 'Start Evaluation';
    String statusText = widget.questionPaperAnswer.status;
    status = statusText == 'Under Review' ? false : true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:
          BlocBuilder<CorrectQuestionCubit, CorrectQuestionState>(
              builder: (context, state) {
        return !rewarded
            ? CustomBottomBar(
                check: checkForNote,
                title: 'Comment',
                icon: Icons.done,
                onPressed: () {
                  questionPaperCubit
                      .sendRewards(_txtComment.text, feedBack)
                      .then((value) => {
                            if (value)
                              {
                                showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    // return CustomAlertDialog(
                                    //   message: 'Comment Posted Successfully',
                                    //   confirm: 'Ok',
                                    // );
                                  },
                                ).then((value) {
                                  Navigator.of(context).pop();
                                }),
                              }
                            else
                              {
                                showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    // return CustomAlertDialog(
                                    //   message:
                                    //       'Something Went Wrong Please Try Again Later',
                                    //   confirm: 'ok',
                                    // );
                                  },
                                ).then((value) {
                                  Navigator.of(context).pop();
                                }),
                              }
                          });
                },
              )
            : Container(
                height: 0,
              );
      }),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildTopBar(context),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            top: 20,
                          ),
                          // height: 400,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // padding: EdgeInsets.all(10),

                          child: Column(
                            // physics: BouncingScrollPhysics(),
                            // shrinkWrap: true,
                            // padding: const EdgeInsets.fromLTRB(
                            //     15.0, 0.0, 15.0, 15.0),
                            children: [
                              Center(
                                child: Text(
                                  'Test Details',
                                  style: buildTextStyle(
                                    color: Color(0xffFF5A79),
                                    size: 18,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Text(widget.questionPaper.questionTitle,
                                  style: const TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15.0),
                                  textAlign: TextAlign.center),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          7.5, 5.0, 7.5, 30.0),
                                      width: 150,
                                      height: 150,
                                      padding: EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xfafaf4e3),
                                        borderRadius:
                                            BorderRadius.circular(75.0),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularPercentIndicator(
                                            animation: true,
                                            animationDuration: 1500,
                                            arcType: ArcType.FULL,
                                            arcBackgroundColor:
                                                Color(0xffe9ecef),
                                            progressColor: Color(0xffFFC30A),
                                            lineWidth: 10.0,
                                            percent: widget.questionPaperAnswer
                                                    .attemptQuestion /
                                                widget.questionPaperAnswer
                                                    .answerDetails.length,
                                            // startAngle: 1.0,
                                            radius: 55,
                                            circularStrokeCap:
                                                CircularStrokeCap.round,
                                          ),
                                          Text(
                                            '${widget.questionPaperAnswer.attemptQuestion}/${widget.questionPaperAnswer.answerDetails.length}',
                                            style: const TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Poppins",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 18.0),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 5.0),
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Text(
                                                '${widget.questionPaper.coin} Coins',
                                                style: const TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                    color: Color(0xffFFC30A),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Poppins",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7.5),
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFC30A),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0x40ffc30a),
                                              offset: Offset(0, 0),
                                              blurRadius: 10,
                                              spreadRadius: 5)
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/trophy.svg",
                                            width: 25.0,
                                            height: 25.0,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            'Rank ${widget.questionPaperAnswer.rank}/${widget.questionPaperAnswer.totalStudents }',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Poppins",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    'Total Question : ${widget.questionPaperAnswer.answerDetails.length}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Total Marks : ${widget.questionPaperAnswer.totalMarks}',

                                    // "Total Marks : 25",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Exam Duration : ${widget.questionPaper.duration.secondsToHours}',
                                    // "Total Question : ${state.answerDetails.length}",
                                    //  "Exam Duration : 3 hr 0 min",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    'Unattempted Questions : ${widget.questionPaperAnswer.answerDetails.length - widget.questionPaperAnswer.attemptQuestion}'
                                    // "Unattempted Questions : ${state.answerDetails.length - state.attempted}",
                                    // "Unattempted Questions : 0",
                                    ,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        decoration: TextDecoration.none,
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  IntrinsicHeight(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Correct Answers : ${widget.questionPaperAnswer.answerDetails.where((element) => element.correctOrNot == true).length}",
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Score : ${widget.questionPaperAnswer.marksObtained}",
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                          ],
                                        ),
                                        VerticalDivider(
                                          color: const Color(0xff000000),
                                          thickness: 1,
                                          indent: 0,
                                          endIndent: 0,
                                          width: 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Incorrect Answers : ${widget.questionPaperAnswer.answerDetails.where((element) => element.correct.trim() == "no").length}",
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              "Negative Score : ${widget.questionPaperAnswer.answerDetails.fold(0, (previousValue, element) => previousValue+element.negativeMarks)}",
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color:
                                                      const Color(0xff000000),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Montserrat",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(),
                                  TextButton(
                                    onPressed: () {
                                      buildDetailsMethod();
                                    },
                                    child: Text(
                                      "Detail Summary",
                                      style: const TextStyle(
                                          color: const Color(0xff2892FC),
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Container(
                      //     width:double.infinity,
                      //     height: 125.0,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.only(
                      //             topRight: Radius.circular(20),
                      //             topLeft: Radius.circular(20)) ,
                      //         color: const Color(0xffffffff)),
                      //     child:
                      //     // BlocBuilder<TestDetailsCubit, TestDetailsState>(
                      //     //     builder: (context, state) {
                      //     //       if (state is TestQuestionPapersDetailsLoaded)
                      //     //         return
                      //
                      //     //====================================//====================================//=============
                      //
                      //     Column(
                      //         children: [
                      //           SizedBox(
                      //             height: 14,
                      //           ),
                      //           // Wrap(
                      //           //   crossAxisAlignment: WrapCrossAlignment.center,
                      //           //   runAlignment: WrapAlignment.center,
                      //           //   alignment: WrapAlignment.center,
                      //           //   spacing: 4,
                      //           //   children:
                      //           // state
                      //           //                                   .questionPaper.detailQuestionPaper.subject
                      //           //                                   .map((e) => Padding(
                      //           //                                 padding: const EdgeInsets.all(8.0),
                      //           //                                 child:
                      //           Container(
                      //             decoration: BoxDecoration(
                      //                 borderRadius: BorderRadius.all(
                      //                     Radius.circular(20)),
                      //                 color: const Color(0xfff4f8fe)),
                      //             child:  Padding(
                      //               padding: EdgeInsets.only(
                      //                   left: 8.0,
                      //                   right: 8,
                      //                   top: 4,
                      //                   bottom: 4),
                      //               child: Text(
                      //
                      //                 widget.questionPaper.detailQuestionPaper.subject.first.name  ,
                      //                  style: TextStyle(
                      //                     color:
                      //                     Color(0xff000000),
                      //                     fontWeight: FontWeight.w400,
                      //                     fontSize: 14.0),
                      //               ),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 1.5,
                      //           ),
                      //           GestureDetector(
                      //             onTap: () {
                      //                 buildDetailsMethod();
                      //             },
                      //             child: Text(
                      //               "Details",
                      //               style: const TextStyle(
                      //                   color: const Color(0xff168de2),
                      //                   fontWeight: FontWeight.w400,
                      //                   fontSize: 15.0),
                      //             ),
                      //           ),
                      //           SizedBox(
                      //             height: 9.5,
                      //           ),
                      //           SizedBox(
                      //             width: MediaQuery.of(context).size.width - 100,
                      //             child: RaisedButton(
                      //               color: const Color(0xffFFC30A),
                      //               onPressed: () {
                      //                 Navigator.push(
                      //                   context,MaterialPageRoute(builder: (context)=> BlocBuilder<CorrectQuestionCubit, CorrectQuestionState>(
                      //                   builder: (context, state)
                      //                   {
                      //
                      //                                 return TestEvaluation(
                      //                                   questionPaperAnswer: widget.questionPaperAnswer,
                      //                                   questionpaper: widget.questionPaper,
                      //                                   correctedAnswer: state is CorrectQuestionsLoaded ? state.answers : [],
                      //                                 );
                      //                   }
                      //                   ))
                      //                 );
                      //                 // Navigator.push(
                      //                 //     contextA,
                      //                 //     MaterialPageRoute(
                      //                 //         builder: (contextA) => BlocProvider(
                      //                 //           create:
                      //                 //               (BuildContext contextA) =>
                      //                 //           TestSessionCubit()
                      //                 //             ..initiateTestSession(
                      //                 //               BlocProvider.of<
                      //                 //                   TestDetailsCubit>(
                      //                 //                   context)
                      //                 //                   .state
                      //                 //                   .questionPaper,
                      //                 //             ),
                      //                 //           child: TestQuestionPaper(),
                      //                 //         )));
                      //               },
                      //               shape: RoundedRectangleBorder(
                      //                 borderRadius:
                      //                 BorderRadius.all(Radius.circular(50)),
                      //               ),
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(
                      //                     left: 8.0, right: 8.0),
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //                   children:  [
                      //                     Text(
                      //                       buttonText,
                      //                       style: TextStyle(
                      //                           color: Color(0xffffffff),
                      //                           fontWeight: FontWeight.w600,
                      //                           fontFamily: "Montserrat",
                      //                           fontSize: 14.0),
                      //                     ),
                      //                     Icon(
                      //                       Icons.arrow_forward_ios_rounded,
                      //                       size: 14,
                      //                       color: Colors.white,
                      //                     )
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ])
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //     width: 281.5151672363281,
                      //     height: 1,
                      //     decoration: BoxDecoration(
                      //         color: const Color(0xffdadada))),
                      // SizedBox(
                      //   height: 6,
                      // ),
                      // Text(
                      //   widget.questionPaper.questionTitle ,
                      //    style: const TextStyle(
                      //         color: const Color(0xff000000),
                      //         fontWeight: FontWeight.w600,
                      //         fontFamily: "Poppins",
                      //         fontStyle: FontStyle.normal,
                      //         fontSize: 14.0),
                      //     textAlign: TextAlign.center),
                      // SizedBox(
                      //   height: 15.0,
                      // ),
                      // Padding(
                      //   padding:
                      //   const EdgeInsets.only(left: 30.0, right: 30),
                      //   child: Row(
                      //     mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Row(
                      //         children:  [
                      //           const SizedBox(
                      //             width: 9,
                      //           ),
                      //           const Text(
                      //             "Total Questions :",
                      //             style: TextStyle(
                      //                 color: Color(0xff000000),
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 14.0),
                      //           ),
                      //           const SizedBox(
                      //             width: 9,
                      //           ),
                      //           Text(widget.questionPaper.detailQuestionPaper.totalQuestion.toString() ,
                      //
                      //              style: const TextStyle(
                      //                 color: Color(0xff000000),
                      //                 fontWeight: FontWeight.w400,
                      //                 fontSize: 14.0),
                      //           )
                      //         ],
                      //       ),
                      //       Row(
                      //         children: [
                      //           // Column(
                      //           //   children: [
                      //           //     SvgPicture.asset(
                      //           //         "assets/svg/trophy.svg"),
                      //           //     Text(
                      //           //       "${state.questionPaper.award}",
                      //           //       style: const TextStyle(
                      //           //           color: const Color(0xff000000),
                      //           //           fontWeight: FontWeight.w400,
                      //           //           fontSize: 12.0),
                      //           //     )
                      //           //   ],
                      //           // ),
                      //           SizedBox(
                      //             width: 20,
                      //           ),
                      //           // Column(
                      //           //   children: [
                      //           //     SvgPicture.asset(
                      //           //         "assets/svg/medal.svg"),
                      //           //     Text(
                      //           //       "${state.questionPaper.coin}",
                      //           //       style: const TextStyle(
                      //           //           color: const Color(0xff000000),
                      //           //           fontWeight: FontWeight.w400,
                      //           //           fontSize: 12.0),
                      //           //     )
                      //           //   ],
                      //           // )
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // ListView.builder(
                      //     physics: BouncingScrollPhysics(),
                      //     shrinkWrap: true,
                      //     padding: EdgeInsets.only(bottom: 50),
                      //     // itemCount: state.questionPaper.section.length,
                      //     itemCount: 1,
                      //     itemBuilder: (context, index) => Column(
                      //       children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 30.0, right: 30),
                      //   // child: TimelineTile(
                      //   //   alignment: TimelineAlign.start,
                      //   //   isFirst: true,
                      //   // endChild: Padding(
                      //   //   padding: const EdgeInsets.only(
                      //   //       left: 9.0),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       // showDialog(
                      //       //     context: context,
                      //       //     builder: (BuildContext
                      //       //     context) {
                      //       //       return TestPartDetailsDialog(
                      //       //           state.questionPaper
                      //       //               .section[
                      //       //           index]);
                      //       //     });
                      //     },
                      //     child: Text(
                      //       widget.questionPaper.section.first.sectionName ,
                      //        style: const TextStyle(
                      //           color: const Color(
                      //               0xff3aa2eb),
                      //           fontWeight:
                      //           FontWeight.w400,
                      //           fontSize: 18.0),
                      //     ),
                      //   ),
                      //   // ),
                      //   // afterLineStyle: LineStyle(
                      //   //     color: Color(0xffc4c4c4),
                      //   //     thickness: 2),
                      //   // beforeLineStyle: LineStyle(
                      //   //     color: Color(0xffc4c4c4),
                      //   //     thickness: 2),
                      //   // indicatorStyle: IndicatorStyle(
                      //   //   indicator: CircleAvatar(
                      //   //       radius: 200,
                      //   //       backgroundColor:
                      //   //       Colors.grey,
                      //   //       child: Padding(
                      //   //         padding:
                      //   //         const EdgeInsets.all(
                      //   //             1.0),
                      //   //         child: CircleAvatar(
                      //   //           radius: 50,
                      //   //           backgroundColor:
                      //   //           Colors.white,
                      //   //         ),
                      //   //       )),
                      //   // ),
                      //   // ),
                      // ),
                      // ListView.builder(
                      //   itemCount: widget.questionPaper.section[0].section.length,
                      //     shrinkWrap: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     padding: EdgeInsets.zero,
                      //     itemBuilder:
                      //         (BuildContext context,
                      //         int subIndex) =>
                      //         Padding(
                      //           padding:
                      //           const EdgeInsets
                      //               .only(
                      //               left: 30.0,
                      //               right: 30),
                      //           child:
                      //           Container(
                      //             child: Row(
                      //               mainAxisAlignment:
                      //               MainAxisAlignment
                      //                   .spaceBetween,
                      //               children: [
                      //                 Padding(
                      //                   padding: const EdgeInsets
                      //                       .only(
                      //                       left:
                      //                       16.0,
                      //                       top: 16),
                      //                   child: Column(
                      //                     mainAxisAlignment:
                      //                     MainAxisAlignment
                      //                         .start,
                      //                     crossAxisAlignment:
                      //                     CrossAxisAlignment
                      //                         .start,
                      //                     children: [
                      //                       Text(
                      //                         "Question ${subIndex + 1}",
                      //                         style: const TextStyle(
                      //                             color:
                      //                             const Color(0xff000000),
                      //                             fontWeight: FontWeight.w400,
                      //                             fontSize: 14.0),
                      //                       ),
                      //                       Text(
                      //                         getQuestionType(
                      //                         widget.questionPaper.section[0].section[subIndex].questionType[0]) ,
                      //                         style: const TextStyle(
                      //                            //  color:
                      //                            // // const Color(0xffc4c4c4),
                      //                             fontWeight: FontWeight.w400,
                      //                             fontSize: 12.0),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding: const EdgeInsets
                      //                       .only(
                      //                       right:
                      //                       20.0),
                      //                   child: Row(
                      //                     children: [
                      //                       Icon(
                      //                         Icons
                      //                             .star_rounded,
                      //                         color: Color(
                      //                             0xffffc850),
                      //                       ),
                      //                       Text(
                      //                         widget.questionPaper.section.first.section[subIndex].totalMarks.toString(),
                      //                         style: const TextStyle(
                      //                             color:
                      //                             const Color(0xff000000),
                      //                             fontWeight: FontWeight.w400,
                      //                             fontSize: 12.0),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           ),
                      //           // indicatorStyle: IndicatorStyle(
                      //           //     color: Color(0xff6fcf97),
                      //           //     indicator: Container(
                      //           //         width: 12,
                      //           //         height: 12,
                      //           //         decoration: BoxDecoration(
                      //           //             border: Border.all(color: const Color(0xffffffff), width: 1),
                      //           //             borderRadius: BorderRadius.circular(12),
                      //           //             boxShadow: [
                      //           //               BoxShadow(
                      //           //                   color: const Color(
                      //           //                       0x40000000),
                      //           //                   offset: Offset(
                      //           //                       0, 0),
                      //           //                   blurRadius:
                      //           //                   4,
                      //           //                   spreadRadius:
                      //           //                   0)
                      //           //             ],
                      //           //             color: const Color(0xff6fcf97)))),
                      //           // ),
                      //         ))
                      //   ],
                      // )),

                      //==============================================//==========================================//==============================

                      buildFeedbackMethod(),
                      !rewarded
                          ? Container(
                              padding: EdgeInsets.all(20),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    padding: EdgeInsets.only(
                                        top: 50, left: 10, right: 10),
                                    child: TextField(
                                      controller: _txtComment,
                                      onChanged: (value) {
                                        setState(() {
                                          checkForNote = true;
                                        });
                                      },
                                      maxLines: 5,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        fillColor: Color(0xffF4F8FE),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 0),
                                        ),
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 0),
                                        ),
                                      ),
                                    ),
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xffF4F8FE),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 30,
                                        ),
                                        TeacherProfileAvatar(
                                          radius: 35,
                                          imageUrl: 'text',
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '',
                                              style: buildTextStyle(
                                                size: 12,
                                                color: Color(0xff828282),
                                              ),
                                            ),
                                            Text(
                                              "Evaluator's Note",
                                              style: buildTextStyle(
                                                size: 12,
                                                color: Color(0xff828282),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 0,
                            )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void buildDetailsMethod() {
     showGeneralDialog(
        barrierLabel: "Barrier",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: Duration(milliseconds: 300),
        transitionBuilder: (_, anim, __, child) {
          return SlideTransition(
            position:
                Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
            child: child,
          );
        },
        context: context,
        pageBuilder: (_, __, ___) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                top: 80,
              ),
              // height: MediaQuery.of(context).size.height * 0.85,
              height: status
                  ? MediaQuery.of(context).size.height * 0.8
                  : MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Detail Summary",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Color(0xff2892FC),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Montserrat",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      // controller: sc,
                      // physics: BouncingScrollPhysics(),
                      // shrinkWrap: true,
                      // padding: const EdgeInsets.all(10.0),
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 32.5),
                                    width: 150,
                                    height: 150,
                                    padding: EdgeInsets.all(20.0),
                                    decoration: BoxDecoration(
                                      color: Color(0xfafaf4e3),
                                      borderRadius: BorderRadius.circular(75.0),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularPercentIndicator(
                                          animation: true,
                                          animationDuration: 1500,
                                          arcType: ArcType.FULL,
                                          arcBackgroundColor: Color(0xffe9ecef),
                                          progressColor: Color(0xffffc30a),
                                          lineWidth: 10.0,
                                          percent: widget.questionPaperAnswer
                                                  .attemptQuestion /
                                              widget.questionPaperAnswer
                                                  .answerDetails.length,
                                          radius: 55,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                        ),
                                        // CircularPercentIndicator(
                                        //   animation: false,
                                        //   backgroundColor: Color(0xffE9ECEF),
                                        //   progressColor: Color(0xff6FCF97),
                                        //   lineWidth: 10.0,
                                        //   // percent: state.attempted /
                                        //   //     state.answerDetails.length,
                                        //   percent: 0.5,
                                        //   radius: 50,
                                        //   circularStrokeCap: CircularStrokeCap.round,
                                        // ),
                                        Text(
                                          '${widget.questionPaperAnswer.attemptQuestion}/${widget.questionPaperAnswer.answerDetails.length}',
                                          style: const TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 18.0),
                                        ),
                                        // Text(
                                        //   // '${state.attempted}/${state.answerDetails.length}',
                                        //   '5/5',
                                        //   style: TextStyle(
                                        //       color: const Color(0xff000000),
                                        //       fontWeight: FontWeight.w400,
                                        //       fontFamily: "Poppins",
                                        //       fontStyle: FontStyle.normal,
                                        //       fontSize: 18.0),
                                        // ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0,
                                                vertical: 5.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xffffffff),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Text(
                                              '${widget.questionPaper.coin} Coins',
                                              style: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  color: Color(0xffFFC30A),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 14.0),
                                            ),
                                          ),
                                        ),
                                        // Align(
                                        //   alignment: Alignment.bottomCenter,
                                        //   child: Container(
                                        //     padding: EdgeInsets.symmetric(
                                        //         horizontal: 15.0, vertical: 5.0),
                                        //     decoration: BoxDecoration(
                                        //       color: Color(0xffffffff),
                                        //       borderRadius:
                                        //       BorderRadius.circular(15.0),
                                        //     ),
                                        //     child: Text(
                                        //       // '${state.coin} coins',
                                        //       '9 coins',
                                        //       style: TextStyle(
                                        //           color: const Color(0xff6FCF97),
                                        //           fontWeight: FontWeight.w400,
                                        //           fontFamily: "Poppins",
                                        //           fontStyle: FontStyle.normal,
                                        //           fontSize: 14.0),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 7.5),
                                      decoration: BoxDecoration(
                                        color: Color(0xffFFC30A),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color(0x40ffc30a),
                                              offset: Offset(0, 0),
                                              blurRadius: 10,
                                              spreadRadius: 5)
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/trophy.svg",
                                            width: 25.0,
                                            height: 25.0,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            'Rank ${widget.questionPaperAnswer.rank}/${widget.questionPaperAnswer.totalStudents }',
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: const TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Poppins",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 16.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.symmetric(
                                    //       horizontal: 10.0, vertical: 7.5),
                                    //   decoration: BoxDecoration(
                                    //       color: Color(0xff6FCF97),
                                    //       borderRadius: BorderRadius.circular(20.0),
                                    //       boxShadow: [
                                    //         BoxShadow(
                                    //             color: Color(0x406FCF97),
                                    //             offset: Offset(0, 0),
                                    //             blurRadius: 10,
                                    //             spreadRadius: 5)
                                    //       ]),
                                    //   child: Center(
                                    //     child: Row(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       children: [
                                    //         SvgPicture.asset(
                                    //           "assets/svg/test-medal.svg",
                                    //           width: 25.0,
                                    //           height: 25.0,
                                    //         ),
                                    //         SizedBox(
                                    //           width: 5.0,
                                    //         ),
                                    //         Text(
                                    //           // 'Rank ${state.response.data[0].rank}',
                                    //           'Rank 1',
                                    //           overflow: TextOverflow.ellipsis,
                                    //           style: TextStyle(
                                    //               color: const Color(0xffffffff),
                                    //               fontWeight: FontWeight.w400,
                                    //               fontFamily: "Poppins",
                                    //               fontStyle: FontStyle.normal,
                                    //               fontSize: 16.0),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      "Your Position",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 18,
                                          color: kBlackColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    LinearPercentIndicator(
                                        animation: true,
                                        // linearStrokeCap: LinearStrokeCap.roundAll,
                                        barRadius: Radius.circular(10),
                                        lineHeight: 14.0,
                                        animationDuration: 1000,
                                        percent:widget.questionPaperAnswer.totalMarks == 0 ? 0 : widget.questionPaperAnswer.marksObtained < 0 ? 0 : widget.questionPaperAnswer.marksObtained/widget.questionPaperAnswer.totalMarks,
                                        center: Text(
                                          'avg ${widget.questionPaperAnswer.avg}',
                                          style: const TextStyle(
                                              color: kBlackColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0),
                                        ),
                                        alignment: MainAxisAlignment.start,
                                        // linearStrokeCap: LinearStrokeCap.roundAll,
                                        progressColor: Color(0xffFFC30A),
                                        backgroundColor: Color(0xfafaf4e3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 37.0,
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              // Container(
                              //   height: 15.0,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     border: Border.all(
                              //         width: 4.0,
                              //         color: Color(0xff1ba555),),
                              //     boxShadow: [
                              //       BoxShadow(
                              //         color: const Color(0xff6FCF97)
                              //             .withOpacity(0.25),
                              //         blurRadius: 5,
                              //         spreadRadius: 3,
                              //       ),
                              //     ],
                              //   ),
                              //   // child: CircleAvatar(
                              //   //     radius: 22,
                              //   //     child:  Icon(
                              //   //       Icons.done,
                              //   //       color: Colors.white,
                              //   //     ),
                              //   //     backgroundColor: Colors.white),
                              // ),
                              Container(
                                padding: new EdgeInsets.all(5.0),
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xff1ba555),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Text(
                                  "Correct Answer",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      // fontStyle: FontStyle.italic,
                                      // fontWeight: FontWeight.w200,
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: new EdgeInsets.all(5.0),
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xfffd4223),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Text(
                                  "Wrong Answer",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      // fontStyle: FontStyle.italic,
                                      // fontWeight: FontWeight.w200,
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: new EdgeInsets.all(5.0),
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xff2d59f8),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Text(
                                  "Free Text",
                                  style: TextStyle(
                                      // fontStyle: FontStyle.italic,
                                      // fontWeight: FontWeight.w200,
                                      decoration: TextDecoration.none,
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: new EdgeInsets.all(5.0),
                                margin: new EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xffFFBD49),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: const Text(
                                  "Not Attempted",
                                  style: TextStyle(
                                      decoration: TextDecoration.none,
                                      // fontStyle: FontStyle.italic,
                                      // fontWeight: FontWeight.w200,
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                              ),
                              // Container(
                              //   padding: new EdgeInsets.all(5.0),
                              //   margin: new EdgeInsets.symmetric(horizontal: 2.0,vertical: 5.0),
                              //   decoration: BoxDecoration(
                              //       // color: Color(0xffFFBD49),
                              //       border:
                              //       Border.all(color: Colors.purple,width: 3.0),
                              //       borderRadius:
                              //       BorderRadius.circular(30.0)),
                              //   child: Text("Comprehession",style: TextStyle(
                              //       decoration: TextDecoration.none,
                              //       fontStyle: FontStyle.italic,
                              //       fontWeight: FontWeight.w200,
                              //       fontSize: 11.0,
                              //       color: Colors.purple),),
                              // ),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                widget.questionPaper.section[0].section.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.portrait)
                                            ? 4
                                            : 2),
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(createRoute(
                                      pageWidget: TestEvaluation(
                                    questionPaper: widget.questionPaper,
                                    questionPaperAnswer:
                                          widget.questionPaperAnswer,
                                    count: index,
                                  ),
                                      ));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 46.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 4.0,
                                              color: getBackgroundColor(
                                                  widget.questionPaperAnswer
                                                      .answerDetails[index],
                                                  isFreeText: widget
                                                              .questionPaper
                                                              .section[0]
                                                              .section[index]
                                                              .questionType
                                                              .first ==
                                                          'freeText'
                                                      ? true
                                                      : false,
                                                  isComprehension: widget
                                                              .questionPaper
                                                              .section[0]
                                                              .section[index]
                                                              .questionType
                                                              .first ==
                                                          'comprehension'
                                                      ? true
                                                      : false)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xff6FCF97)
                                                  .withOpacity(0.25),
                                              blurRadius: 5,
                                              spreadRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                            radius: 22,
                                            child: checkNegative(widget.questionPaperAnswer.answerDetails[index].correctOrNot, widget.questionPaperAnswer.answerDetails[index].negativeMarks),
                                            // widget
                                            //         .questionPaperAnswer
                                            //         .answerDetails[index]
                                            //         .correctOrNot
                                            //     ? Icon(
                                            //         Icons.done,
                                            //         color: Colors.white,
                                            //       )
                                            //     : Icon(
                                            //         Icons.close,
                                            //         color: Colors.white,
                                            //       ),
                                            backgroundColor: getBackgroundColor(
                                                widget.questionPaperAnswer
                                                    .answerDetails[index],
                                                isFreeText: widget
                                                            .questionPaper
                                                            .section[0]
                                                            .section[index]
                                                            .questionType
                                                            .first ==
                                                        'freeText'
                                                    ? true
                                                    : false,
                                                isComprehension: widget
                                                            .questionPaper
                                                            .section[0]
                                                            .section[index]
                                                            .questionType
                                                            .first ==
                                                        'comprehension'
                                                    ? true
                                                    : false)),
                                      ),
                                      Text(
                                        'Q${index + 1}',
                                        style: buildTextStyle(
                                          size: 14,
                                          weight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                              //         ],
                              //       );
                            },
                          ),
                        ),
                        BlocBuilder<SubmitMarksCubit,SubmitMarksStates>(
                          builder: (context,state) {
                            if(state is FreeTextAnswerSubmission)
                            return Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: status ? false : true,
                              child: CustomRaisedButton(
                                width: 163,
                                title: 'Submit Evaluation',
                                bgColor: Colors.blue,
                                textColor: Colors.white,
                                onPressed: () {
                                  // sample();
                                  submitMarks(state: state);
                                },
                              ),
                            );
                            return Container(height: 0,);
                          }
                        ),
                        SizedBox(height: 10),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'You got ',
                            style: const TextStyle(
                                color: const Color(0xff000000),
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      // '',
                                      '${widget.questionPaperAnswer.answerDetails.where((element) => element.correctOrNot == true).length} Correct answers',
                                  style: const TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Montserrat",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0)),
                              TextSpan(
                                text: ' & \n',
                                style: const TextStyle(
                                    color: const Color(0xff000000),
                                    fontFamily: "Montserrat",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                              TextSpan(
                                text: widget.questionPaperAnswer.answerDetails.length - widget.questionPaperAnswer.attemptQuestion == 0 ? 'Attempted All the Questions' :
                                    'Not attempted ${widget.questionPaperAnswer.answerDetails.length - widget.questionPaperAnswer.attemptQuestion} Question',
                                style: const TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

 Icon checkNegative(bool correctOrNot,int negative){
    if(negative != null)
      {
        if(negative != 0)
          {
            return Icon(Icons.remove,color: Colors.white,);
          }
        else
          {
            return  correctOrNot ? Icon(
              Icons.done,
              color: Colors.white,
            )
                : Icon(
              Icons.close,
              color: Colors.white,
            );
          }
      }
    else
      {
        correctOrNot ? Icon(
          Icons.done,
          color: Colors.white,
        )
            : Icon(
          Icons.close,
          color: Colors.white,
        );
      }
  }

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
  //           if (comQuestionIds.contains(element)) {
  //             int totMarks = 0;
  //             for (var i in comQuestionIds) {
  //               map.forEach((key, subvalue) {
  //                 if (i == key) {
  //                   List l1 = subvalue.toString().split(',');
  //                   String qId = l1[0];
  //                   int marks = int.tryParse(l1[1]);
  //                   totMarks += marks;
  //                   list2.add(Answer(
  //                       questionId: qId,
  //                       obtainedMarks: marks,
  //                       correctOrNot: 'yes'));
  //                 }
  //               });
  //             }
  //             list.add(AnswerDetail(
  //               answers: list2,
  //               correctOrNot: 'yes',
  //               obtainedMarks: totMarks,
  //             ));
  //           } else {
  //             list.add(AnswerDetail(
  //                 answers: [],
  //                 questionId: key,
  //                 id: l1[0],
  //                 obtainedMarks: int.tryParse(l1[1])));
  //           }
  //         }
  //       });
  //     }
  //
  //     // for (var element in comQuestionIds) {
  //     //   map.forEach((key, value) {
  //     //     if (element == key) {
  //     //       List l1 = value.toString().split(',');
  //     //       String qId = l1[0];
  //     //       int marks = int.tryParse(l1[1]);
  //     //     }
  //     //   });
  //     // }
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

  // String get totalMarks {
  //   return widget.questionPaper.section[0].section.fold(0,
  //       (previousValue, element) {
  //     return previousValue + element.totalMarks;
  //   }).toString();
  // }

  Container buildFeedbackMethod() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            child: Row(
              children: [
                Spacer(),
                Text(
                  'Feedback Type:',
                  style: buildTextStyle(
                    color: Color(0xffFF5A79),
                    size: 14,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ).expand,
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PopUpMenuWidget(
                  onSelected: (val) {
                    print(val);
                    feedBack = val;
                    setState(() {});
                  },
                  children: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Very Good',
                      child: Text(
                        'Very Good',
                        style: buildTextStyle(),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Good',
                      child: Text(
                        'Good',
                        style: buildTextStyle(),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Average',
                      child: Text(
                        'Average',
                        style: buildTextStyle(),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Poor',
                      child: Text(
                        'Poor',
                        style: buildTextStyle(),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'Very Poor',
                      child: Text(
                        'Very Poor',
                        style: buildTextStyle(),
                      ),
                    ),
                  ],
                  child: Container(
                    height: 40,
                    width: 120,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    child: Text(feedBack ?? 'Feedback'),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0xffDADADA),
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).expand,
        ],
      ),
    );
  }

  // String getRewardedMarks(List<CorrectedAnswer> ans) {
  //   return ans.fold(0, (previousValue, element) {
  //     return previousValue + element.marks;
  //   }).toString();
  // }

  // Container buildQuestionList() {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     child: BlocBuilder<CorrectQuestionCubit, CorrectQuestionState>(
  //         builder: (context, state) {
  //       return GridView.builder(
  //         shrinkWrap: true,
  //         physics: NeverScrollableScrollPhysics(),
  //         itemCount: widget.questionPaper.section[0].section.length,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: 4,
  //         ),
  //         itemBuilder: (context, index) {
  //           return InkWell(
  //             onTap: () {
  //               Navigator.of(context).push(createRoute(
  //                   pageWidget: BlocProvider(
  //                     create: (context)=>SubmitMarksCubit()..initiateFreeTextEvaluation(),
  //                     child: TestEvaluation(
  //                 questionPaper: widget.questionPaper,
  //                 questionPaperAnswer: widget.questionPaperAnswer,
  //                 count: index,
  //               ),
  //                   )));
  //             },
  //             child: Container(
  //               padding: const EdgeInsets.all(10),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: const Color(0xff6FCF97).withOpacity(0.25),
  //                           blurRadius: 5,
  //                           spreadRadius: 3,
  //                         ),
  //                       ],
  //                     ),
  //                     child: CircleAvatar(
  //                         radius: 22,
  //                         child: widget.questionPaperAnswer.answerDetails[index]
  //                                 .correctOrNot
  //                             ? Icon(
  //                                 Icons.done,
  //                                 color: Colors.white,
  //                               )
  //                             : Icon(
  //                                 Icons.close,
  //                                 color: Colors.white,
  //                               ),
  //                         backgroundColor: getBackgroundColor(
  //                             widget.questionPaperAnswer.answerDetails[index],
  //                             isComprehension: widget.questionPaper.section[0]
  //                                         .section[index].questionType.first ==
  //                                     'comprehension'
  //                                 ? true
  //                                 : false,
  //                             isFreeText: widget.questionPaper.section[0]
  //                                         .section[index].questionType.first ==
  //                                     'freeText'
  //                                 ? true
  //                                 : false)),
  //                   ),
  //                   Text(
  //                     'Q${index + 1}',
  //                     style: buildTextStyle(
  //                       size: 14,
  //                       weight: FontWeight.w700,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     }),
  //   );
  // }

  Color getBackgroundColor(TestAnswerDetails answer,
      {bool isFreeText, bool isComprehension}) {
    if ((answer.answerByStudent == null || answer.answerByStudent.isEmpty) &&
        !isComprehension) {
      return const Color(0xffFFBD49);
    }
    if (answer.correctOrNot) return const Color(0xff1ba555);
    if (isFreeText) return const Color(0xff2d59f8);
    if (answer.correct.toLowerCase() == 'partially correct') {
      return const Color(0xff336146);
    }
    if (isComprehension) {
      return const Color(0xff0aeecc);
    }
    return Color(0xfffd4223);
  }

  Container buildTopBar(BuildContext context) {
    var student = widget.questionPaper.assignTo.firstWhere((element) =>
        element.studentId ==
        widget.questionPaperAnswer.studentDetails.studentId);

    return Container(
      padding: EdgeInsets.all(5),
      height: 125,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xffF4F8FE),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TeacherProfileAvatar(
                      imageUrl: student.profileImage ?? 'text',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.questionPaperAnswer.createdBy}',
                          style: buildTextStyle(size: 14),
                        ),
                        Text(
                          // 'aa,',
                          '${widget.questionPaperAnswer.totalTimeTaken != null && widget.questionPaperAnswer.totalTimeTaken != 'null' ? widget.questionPaperAnswer.totalTimeTaken.secondsToHours : ''}',
                          style: buildTextStyle(
                            size: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/points.png',
                          height: 36,
                          width: 36,
                        ),
                        Text(
                          '${widget.questionPaper.coin}',
                          style: buildTextStyle(
                            size: 18,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/trophy.svg',
                          height: 36,
                          width: 36,
                        ),
                        Text(
                          '${widget.questionPaper.award}',
                          style: buildTextStyle(
                            size: 18,
                            weight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // String getQuestionType(String type) {
  //   String questionType;
  //   switch (type) {
  //     case 'twoColMtf':
  //       questionType = 'Two Column Match the Following';
  //       break;
  //     case 'threeColMtf':
  //       questionType = 'Three Column Match the Following';
  //       break;
  //     case 'mcq':
  //       questionType = 'MCQ';
  //       break;
  //     case 'objectives':
  //       questionType = 'Objectives';
  //       break;
  //     case 'fillInTheBlanks':
  //       questionType = 'Fill In The Blanks';
  //       break;
  //     case 'trueOrFalse':
  //       questionType = 'True Or False';
  //       break;
  //     case 'freeText':
  //       questionType = 'Free Text';
  //       break;
  //     case 'comprehension':
  //       questionType = 'Comprehension';
  //       break;
  //     case 'NumericalRange':
  //       questionType = 'Numerical Range';
  //       break;
  //     case 'optionLevelScoring':
  //       questionType = 'Option Level Scoring';
  //       break;
  //     case '3colOptionLevelScoring':
  //       questionType = 'Three Column Option Level';
  //       break;
  //     default:
  //       questionType = '';
  //   }
  //   return questionType;
  // }

  // Color checkCorrectOrNot(bool correctOrNot, {bool isFreeText}) {
  //   if (isFreeText != null) {
  //     if (isFreeText) {
  //       return Colors.blueAccent;
  //     }
  //   }
  //   if (correctOrNot) {
  //     return Colors.greenAccent;
  //   } else {
  //     return Colors.redAccent;
  //   }
  // }

  void submitMarks({FreeTextAnswerSubmission state}) {
    FreeTextAnswer freeTextAnswer = FreeTextAnswer(
      questionId: widget.questionPaperAnswer.questionId,
      isEvaluated: true,
      studentId: widget.questionPaperAnswer.studentDetails.studentId,
      answerDetails: state.answerDetails,
    );
    BlocProvider.of<QuestionAnswerCubit>(context).submitFreeTextMarks(freeTextAnswer: freeTextAnswer).then((value) {
     BlocProvider.of<SubmitMarksCubit>(context).submittedMarks();
     BlocProvider.of<QuestionAnswerCubit>(context).getAllSubmittedAnswer(widget.questionPaper.id,1,5);
     state.answerDetails.clear();
     Navigator.pop(context);
     Navigator.pop(context);
     Navigator.pop(context);
     Fluttertoast.showToast(msg: 'Marks Submitted Successfully');
     setState(() {

     });

    });
  }

  getCorrectAnswersCount(int index) {
    int total = widget.questionPaperAnswer.answerDetails.length;
    int attempted = widget.questionPaperAnswer.attemptQuestion;
    int notAttempted = total - attempted;
    int correctAnswers = widget.questionPaperAnswer.answerDetails.map((e) => e.correctOrNot == true).length;

  }
}
