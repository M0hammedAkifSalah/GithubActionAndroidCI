import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/bloc/test-module/test-module-states.dart';
import '/export.dart';

class TestListingPage extends StatefulWidget {
  @override
  _TestListingPageState createState() => _TestListingPageState();
}

class _TestListingPageState extends State<TestListingPage> {
  QuestionPaperLoaded stateQuestionPaper;
  final testPagingController1 =
  PagingController<int, QuestionPaper>(firstPageKey: 1);
  FocusNode focusNode = FocusNode();

  TextEditingController textEditingController = TextEditingController();



  @override
  void initState() {
    super.initState();
    testPagingController1.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await BlocProvider.of<QuestionPaperCubit>(context)
          .loadAllQuestionPapers(
        searchText: textEditingController.text.trim(),
        isEvaluate: true,
        limit: 5,
        page: pageKey,
      );
      final isLastPage = newItems.length < 5;
      if (isLastPage) {
       testPagingController1.appendLastPage(newItems);
      } else {

        final nextPageKey = pageKey + 1;
        testPagingController1.appendPage(newItems, nextPageKey);
      }
    }catch(e){
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              'My Tests',
              style: buildTextStyle(
                weight: FontWeight.w500
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, color: Colors.black),
              ),
            ]),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  style: const TextStyle(fontSize: 13),
                  onChanged: (value) {
                    setState(() {});
                    testPagingController1.refresh();

                    if(value.isEmpty)
                      focusNode.unfocus();
                  },
                  onSubmitted: (val){
                    setState(() {});
                    testPagingController1.refresh();
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Color(0xffc4c4c4),
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(
                            color: Color(0xffc4c4c4),
                          )),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding:
                      const EdgeInsets.only(top: 6, bottom: 6, left: 8),
                      suffixIcon: textEditingController.text != ""
                          ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {});
                            if(focusNode.hasFocus)
                              focusNode.unfocus();
                            textEditingController.clear();
                            // _textEditingControllerStudent.sink.add(null);
                            testPagingController1.refresh();
                          })
                          : const Icon(
                        Icons.search,
                        size: 22,
                      ),
                      labelText: 'Search Title,Subject...',
                      labelStyle:
                      const TextStyle(fontSize: 11, color: Colors.grey),
                      hintText: 'Search Title,Subject...',
                      hintStyle:
                      const TextStyle(fontSize: 11, color: Colors.grey),
                      fillColor: Colors.white70),
                ),

              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: PagedListView<int, QuestionPaper>(
                      pagingController: testPagingController1,
                      builderDelegate: PagedChildBuilderDelegate<QuestionPaper>(
                        itemBuilder: (context, item, index) => TestCardWidget(item, item.status.toString() == 'evaluated'),
                        newPageProgressIndicatorBuilder: (context) => loadingBar,
                        firstPageProgressIndicatorBuilder: (context) => loadingBar,
                      ),

                  )
                ),
              ),
            ],
          ),
        ));
  }
}

class TestCardWidget extends StatelessWidget {
  final QuestionPaper questionPaper;
  final bool status;

  TestCardWidget(this.questionPaper,this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(createRoute(
            pageWidget: EvaluateTask(
              Activity(assigned: Assigned.student),
              false,
              questionPaper,
            ),
          ));
          // if (activity.status.toLowerCase() == 'evaluate' ||
          //     activity.status.toLowerCase() == 'evaluated')
          // Navigator.of(context).push(
          //   createRoute(
          //     pageWidget: BlocProvider<GroupCubit>(
          //       create: (context) => GroupCubit(),
          //       child: EvaluateTask(activity, activity.status == 'Evaluate'),
          //     ),
          //   ),
          // );
        },
        child: Container(
          // height: activity.comment.isEmpty ? 170 : 350,
          child: Column(
            children: [
              // if (showAssigned)
              //   Container(
              //     height: 50,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //       boxShadow: [
              //         BoxShadow(
              //           color: const Color(0x26000000),
              //           offset: Offset(0, 0),
              //           blurRadius: 5,
              //           spreadRadius: 0,
              //         )
              //       ],
              //     ),
              //     padding: EdgeInsets.all(15),
              //     margin: EdgeInsets.only(right: 9, left: 9, bottom: 4),
              //     child: Text(
              //       activity.assignTo.isNotEmpty
              //           ? 'Assigned to Student'
              //           : 'Assigned to You',
              //       style: buildTextStyle(
              //         size: 18,
              //       ),
              //     ),
              //   ),
              // Text(questionPaper.status.toTitleCase()),
              Container(
                // height: 150,
                margin: EdgeInsets.only(left: 9, right: 9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x26000000),
                        offset: Offset(0, 0),
                        blurRadius: 5,
                        spreadRadius: 0,
                      )
                    ],
                    color: status
                        ? const Color(0xffEEFFF5)
                        : const Color(0xffffffff)),
                padding: EdgeInsets.only(left: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // BlocProvider.of<FeedActionCubit>(context).updateFeedPanelContent("TestCardWidget", activity);
                        // feedActionPanelController.open();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: TeacherProfileAvatar(
                                  imageUrl:
                                      questionPaper.userId.profileImage ?? '',
                                ),
                              ),
                              SizedBox(
                                width: 9,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 101,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(top: 5.0),
                                        //   child: Container(
                                        //     width: MediaQuery.of(context)
                                        //             .size
                                        //             .width *
                                        //         0.35,
                                        //     alignment: Alignment.center,
                                        //     child: Text(
                                        //       questionPaper.status ??
                                        //           'Pending',
                                        //       style: const TextStyle(
                                        //         color:
                                        //             const Color(0xffffffff),
                                        //         fontWeight: FontWeight.w400,
                                        //         fontSize: 14.0,
                                        //       ),
                                        //     ),
                                        //     height: 22.778032302856445,
                                        //     decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(20)),
                                        //       color: questionPaper.status
                                        //                   .toLowerCase() ==
                                        //               'pending'
                                        //           ? const Color(0xffeb5757)
                                        //           : questionPaper.status
                                        //                       .toLowerCase() ==
                                        //                   'Evaluated'
                                        //               ? Color(0xff6FCF97)
                                        //               : Color(0xff5458EA),
                                        //     ),
                                        //   ),
                                        // ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 150,
                                          height: 29,
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 7),
                                          child: Text(
                                            "Test",
                                            style: const TextStyle(
                                              color: const Color(0xff822111),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10)),
                                            color: const Color(0xfff6c5be),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 7),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            questionPaper.createdBy ??
                                                'Name Not found'.toTitleCase(),
                                            style: const TextStyle(
                                              color: const Color(0xff828282),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Spacer(),
                                          // Image.asset(
                                          //   'assets/images/points.png',
                                          //   height: 20,
                                          //   width: 20,
                                          // ),
                                          // Text(
                                          //   10,
                                          //   style: buildTextStyle(size: 12),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff828282),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 11.0),
                                                text: '',
                                              ),
                                              TextSpan(
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff828282),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11.0),
                                                text: DateFormat('d MMM').format(
                                                    questionPaper.createdAt),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${questionPaper.questionTitle}',
                            softWrap: true,
                            style: const TextStyle(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Subject: ${questionPaper.detailQuestionPaper.subject.isNotEmpty ? questionPaper.detailQuestionPaper.subject.first.name : ''}',
                            softWrap: true,
                            style: const TextStyle(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start : ${questionPaper.startDate.toDateTimeFormat(context)}',
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Text(
                                      'End : ${questionPaper.dueDate.toDateTimeFormat(context)}',
                                      softWrap: true,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Total Marks\n ${questionPaper.totalMarks?.toInt()}',
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                    Container(
                                      height: 2,
                                      color: Colors.black,
                                      width: 80,
                                    ),
                                    Text(
                                      'Duration\n ${questionPaper.duration == null ? questionPaper.duration : secondsToHours(questionPaper.duration)}',
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/trophy.svg',
                                height: 30,
                              ),
                              Text(
                                '${questionPaper.award}',
                                style: buildTextStyle(size: 14),
                              ),
                              Image.asset(
                                'assets/images/points.png',
                                height: 30,
                              ),
                              Text(
                                '${questionPaper.coin}',
                                style: buildTextStyle(size: 14),
                              ),
                            ],
                          ),
                        ),
                        Text(
                            '${calculateTime(questionPaper.dueDate == null ? DateTime.now() : questionPaper.dueDate)}'),
                        SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 11,
                    ),
                  ],
                ),
              ),
              // if (activity.comment.isNotEmpty && activity.status != 'Evaluated')
              //   ThreadWidget(
              //     comments: activity.comment,
              //     teacherId: activity.teacherProfile.id,
              //     activity: activity,
              //   ),
            ],
          ),
        ),
      ),
    );
    // else {
    //   BlocProvider.of<QuestionAnswerCubit>(context)
    //       .getAllSubmittedAnswer(questionPaper.id);
    //   return Container(
    //     child: Center(

    //       child: CupertinoActivityIndicator(),
    //     ),
    //   );
    // }
  }

  String getStatus(List<QuestionPaperAnswer> answer) {
    if (questionPaper.assignTo.length == answer.length) {
      return 'Evaluate';
    } else
      return 'Pending';
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

  String calculateTime(DateTime endTime) {
    var now = DateTime.now();
    int days = endTime.difference(now).inDays;
    if (days <= 0) {
      int hours = endTime.hour - now.hour;
      if (hours <= 0) {
        int mins = endTime.minute - now.minute;
        if (mins <= 0) {
          mins = 0;
          return 'Time Over';
        }
        return '$mins mins left';
      }
      return '$hours hours left';
    }
    return '$days days left';
  }

  void handleOnSelected(String value, BuildContext context) async {
    if (value != 'Delete') {
      // Navigator.of(context).push(
      //   createRoute(
      //     pageWidget: BlocProvider<GroupCubit>(
      //       create: (context) => GroupCubit(),
      //       child: EvaluateTask(
      //         activity,
      //         activity.status != 'Evaluated',
      //       ),
      //     ),
      //   ),
      // );
    } else {
      bool delete = false;
      delete = await showDeleteDialogue(context);
      if (delete) {
        Fluttertoast.showToast(msg: 'Deleting');
        // await BlocProvider.of<ActivityCubit>(context, listen: false)
        //     .deleteActivity(activity.id);
        // BlocProvider.of<ActivityCubit>(context, listen: false)
        //     .loadActivities('');
      }
    }
  }
}

getAssignedList(List<String> groups) {
  String assignedTo = ' ';

  for (final group in groups) assignedTo = assignedTo + group + "or ";

  return assignedTo.substring(0, assignedTo.length - 3);
}
