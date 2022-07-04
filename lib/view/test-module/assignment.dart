import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/extensions/utils.dart';
import '/model/test-model.dart';
import '/view/assign-task/assign_class.dart';
import '/view/homepage/home_sliver_appbar.dart';
import '/view/utils/bottom_bar.dart';
import '/view/utils/utils.dart';
import 'constants.dart';

class AssignTest extends StatefulWidget {
  final QuestionPaper questionPaper;
  AssignTest(this.questionPaper);

  @override
  _AssignTestState createState() => _AssignTestState();
}

class _AssignTestState extends State<AssignTest> {
  DateTime startDate;
  DateTime endDate;

  Future<DateTime> pickDate({DateTime selectedDate}) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: selectedDate ?? DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 60)),
    );
    var time = await showTimePicker(
      context: context,
      initialTime: selectedDate != null
          ? TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute)
          : TimeOfDay.now(),
    );
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  String getQuestionType(String type) {
    String questionType;
    switch (type) {
      case 'twoColMtf':
        questionType = 'Two Column Match the Following';
        break;
      case 'threeColMtf':
        questionType = 'Three Column Match the Following';
        break;
      case 'mcq':
        questionType = 'MCQ';
        break;
      case 'objectives':
        questionType = 'Objectives';
        break;
      case 'fillInTheBlanks':
        questionType = 'Fill In The Blanks';
        break;
      case 'trueOrFalse':
        questionType = 'True Or False';
        break;
      case 'freeText':
        questionType = 'Free Text';
        break;
      case 'comprehension':
        questionType = 'Comprehension';
        break;
      case 'NumericalRange':
        questionType = 'Numerical Range';
        break;
      case 'optionLevelScoring':
        questionType = 'Option Level Scoring';
        break;
      case '3colOptionLevelScoring':
        questionType = 'Three Column Option Level';
        break;
      default:
        questionType = '';
    }
    return questionType;
  }

  String secondsToHours(String time) {
    int seconds;
    int mins;
    int hours;
    try {
      seconds = int.tryParse(time);
      seconds != null ? mins = ((seconds % 3600) ~/ 60) : 0;
      seconds != null ? hours = (seconds ~/ 3600) : 0;
    } catch (error) {
      log(error.toString());
    }
    return '$hours hr $mins min';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffE5e5e5),
      appBar: AppBar(
          // iconTheme: IconThemeData(
          //     color: Colors.black
          // ),
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          title: appMarker()),
      body: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Colors.white,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: kLightColor, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${widget.questionPaper.questionTitle}',
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400,
                      color: kBlackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return TimePickerWidget();
                      },
                    );
                    widget.questionPaper.duration =
                        Provider.of<TimePicker>(context, listen: false).getTime;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.access_time,
                    color: Colors.greenAccent,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.questionPaper.duration == null
                      ? 'Set the Time'
                      : widget.questionPaper.duration,
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w600,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomRaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: AssignClass(
                      questionPaper: widget.questionPaper,
                    ),
                  ),
                );
              },
              title: 'Assign',
              check: startDate != null &&
                  endDate != null &&
                  widget.questionPaper.duration != null,
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.of(context).push(
            //       createRoute(
            //           pageWidget: AssignClass(
            //         questionPaper: widget.questionPaper,
            //       ),),
            //     );
            //   },
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * 0.6,
            //     height: 30,
            //     decoration: BoxDecoration(
            //         color: startDate==null || endDate==null? kPrimaryColor:Colors.transparent,
            //         borderRadius: BorderRadius.circular(20)),
            //     child: Padding(
            //       padding: EdgeInsets.only(
            //         left: MediaQuery.of(context).size.width * 0.05,
            //         right: MediaQuery.of(context).size.width * 0.05,
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Center(
            //             child: Text(
            //               "Assign",
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 decoration: TextDecoration.none,
            //                 fontWeight: FontWeight.w500,
            //                 color: kBlackColor,
            //               ),
            //             ),
            //           ),
            //           Icon(
            //             Icons.arrow_forward_ios,
            //             color: kBlackColor,
            //           )
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 1,
              color: kGreyColor,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                startDate = await pickDate();
                widget.questionPaper.startDate = startDate;
                setState(() {});
              },
              child: Text(
                startDate == null
                    ? "Select Start Date"
                    : "Start date of submission - ${DateFormat('dd/MM/yyyy hh:mm').format(startDate)}",
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                endDate = await pickDate(selectedDate: startDate);
                setState(() {});
                widget.questionPaper.dueDate = endDate;
              },
              child: Text(
                endDate == null
                    ? "Select Last Date"
                    : "Last date of submission - ${DateFormat('dd/MM/yyyy hh:mm').format(endDate)}",
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  color: Colors.greenAccent,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TeacherProfileAvatar(),
                    Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor,
                      ),
                    ),
                    Text(
                      "${widget.questionPaper.section[0].section.length} Questions",
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.w600,
                        color: kBlackColor,
                      ),
                    ),
                    Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/svg/trophy.svg', height: 30),
                          Container(
                            child: Center(
                              child: Text(
                                "${widget.questionPaper.award}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/points.png',
                            height: 30,
                          ),
                          Container(
                            child: Center(
                              child: Text(
                                "${widget.questionPaper.coin}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kBlackColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.questionPaper.section[0].section.length,
                itemBuilder: (BuildContext context, int index) {
                  var section = widget.questionPaper.section[0].section;

                  return Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.05,
                        bottom: 5),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 25,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 1,
                                      height: 60,
                                      color: kGreyColor,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Color(0xff6FCF97),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Container(
                                height: 25,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 1,
                                      height: 60,
                                      color: kGreyColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Question ${index + 1}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: kBlackColor),
                                    ),
                                    Text(
                                      getQuestionType(
                                          section[index].questionType[0]),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: kGreyColor),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${section[index].totalMarks}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: kGreyColor),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: kPrimaryColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
