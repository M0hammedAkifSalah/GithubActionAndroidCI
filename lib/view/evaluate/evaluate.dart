import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '/bloc/activity/assignment-cubit.dart';
import '/bloc/activity/assignment-states.dart';
import '/bloc/test-module/test-module-states.dart';
import '/export.dart';
import '/view/announcements/create_announcement.dart';
import '/view/event/create_event.dart';
import '/view/livepoll/create_livepoll.dart';
import '/view/test-module/evaluate-test-widget.dart';
import 'submission-indicator.dart';

class EvaluateTask extends StatefulWidget {
  final Activity activity;
  final bool evaluate;
  final QuestionPaper questionPaper;

  EvaluateTask([
    this.activity,
    this.evaluate,
    this.questionPaper,
  ]);

  @override
  _EvaluateTaskState createState() => _EvaluateTaskState();
}

class _EvaluateTaskState extends State<EvaluateTask>
    with SingleTickerProviderStateMixin {
  TabController _tab;
  List<String> studentsRewarded = [];
  List<String> lateSubmission = [];
  bool rewarded = false;
  bool init = true;
  List<QuestionPaperAnswer> questionPaperAnswer = [];
  final SubmittedBy submittedBy = SubmittedBy();

  bool _isLoading = false;
  List<Map<String, dynamic>> offlineSubmitted = [];
  String selectAllStatus = "pending";



  @override
  void initState() {
    super.initState();

    _tab = TabController(vsync: this, length: 2);
    _tab.addListener(() {
      if (_tab.indexIsChanging) {
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          setState(() {});
        });
      }
    });
    // checkWidget(widget.activity);
    // status.addAll({'ableto'});
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget checkWidget(Activity activity) {
    if (widget.questionPaper != null) {
      return Container(
        child: TestEvaluateWidget(
          questionPaper: widget.questionPaper,
        ),
      );
    }
    switch (activity.activityType) {
      case 'Announcement':
        return AnnouncementWidget(
          activity: activity,
          editable: false,
        );
      case 'Event':
        return EventWidget(
          activity: activity,
          editable: false,
        );
      case 'LivePoll':
        return LivePollWidget(
          activity: activity,
          editable: false,
        );
      case 'Check List':
        return CheckListWidget(
          activity: activity,
          editable: false,
        );
        break;
      case 'Assignment':
        return AssignmentWidget(
          activity: activity,
          editable: false,
        );
        break;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      switch (widget.activity.assigned) {
        case (Assigned.parent):
          getRewardParents();
          break;

        case (Assigned.student):
          getRewardStudents();
          break;

        case (Assigned.faculty):
          getRewardTeachers();
          break;

        default:
      }

      init = false;
    }
    return Scaffold(
      bottomNavigationBar: widget.activity.activityType != 'Assignment'
          ? !widget.evaluate
              ? Container(
                  color: Colors.white,
                  height: 0,
                )
              : BlocBuilder<GroupCubit, GroupStates>(
                  builder: (context, state) => CustomBottomBar(
                    title: _tab.index == 0
                        ? 'Evaluate'
                        : rewarded
                            ? 'Evaluated'
                            : 'Evaluate',
                    onPressed: _tab.index == 0
                        ? () {
                            _tab.animateTo(1,
                                duration: Duration(milliseconds: 300));
                            setState(() {});
                          }
                        : rewarded || studentsRewarded.isEmpty
                            ? null
                            : handleEvaluate,
                  ),
                )
          : Container(
              height: 0,
              color: Colors.white,
            ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        // bottom:
        title: Text(
          'Evaluate',
          style: buildTextStyle(weight: FontWeight.bold),
        ),
        actions: [
          if (widget.activity.activityType == 'Assignment' &&
              offlineSubmitted.isNotEmpty)
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      DateTime lateDate =
                          widget.activity.endDateTime.add(Duration(hours: 1));
                      DateTime submissionDate = widget.activity.endDateTime
                          .subtract(Duration(hours: 1));
                      List<Map<String, dynamic>> submissionData =
                          offlineSubmitted.map((Map<String, dynamic> e) {
                        e["date"] = e["is_late"] ? lateDate : submissionDate;
                        return e;
                      }).toList();
                      await BlocProvider.of<ActivityCubit>(context)
                          .submitOfflineAssignment(
                              submissionData, widget.activity.id);
                      widget.activity.submitedBy.addAll(submissionData
                          .map((e) => SubmittedBy(
                                studentId: e["student_id"],
                                message: [
                                  SubmittedMessage(
                                    isOffline: true,
                                    file: [],
                                    evaluator: false,
                                    submittedDate: e["date"],
                                    text: "",
                                  )
                                ],
                                // lateSubmission: e["date"]
                                //     .isAfter(widget.activity.endDateTime),
                                lateSubmission: e["is_late"],
                                submittedDate: DateTime.now(),
                              ))
                          .toList());
                      for (var id in submissionData) {
                        widget
                            .activity
                            .assignTo[widget.activity.assignTo.indexWhere(
                                (element) =>
                                    element.studentId.id == id["student_id"])]
                            .status = "Submitted";
                      }
                      studentsRewarded.addAll(submissionData
                          .map<String>((e) => e["student_id"])
                          .toList());
                      offlineSubmitted = [];
                      setState(() {
                        _isLoading = false;
                      });
                      BlocProvider.of<AssignmentSubmissionCubit>(context)
                          .addData(widget.activity.submitedBy,
                              widget.activity.assignTo);
                    },
                    icon: Icon(Icons.done),
                  ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                // alignment: Alignment.bottomCenter,
                // height: MediaQuery.of(context).size.height * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 5,
                      blurRadius: 5,
                    )
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      child: TabBar(
                        onTap: (val) {
                          Future.delayed(Duration(milliseconds: 500))
                              .then((value) {
                            setState(() {});
                          });
                        },
                        controller: _tab,
                        indicatorColor: Color(0xffFFC30A),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding: EdgeInsets.symmetric(vertical: 5),
                        labelStyle:
                            buildTextStyle(size: 15, color: Colors.grey),
                        tabs: const [
                          Text(
                            'Turnout',
                            // style: buildTextStyle(size: 15, color: Colors.grey),
                          ),
                          Text('Evaluate'),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                    ),
                    // Spacer(),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Container(
                        // padding: EdgeInsets.symmetric(horizontal: 1),
                        // padding: EdgeInsets.symmetric(horizontal: 15),
                        width: double.infinity,
                        // alignment: Alignment.bottomCenter,
                        // height: MediaQuery.of(context).size.height * 0.575,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black26,
                          //     spreadRadius: 5,
                          //     blurRadius: 5,
                          //   )
                          // ],
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(15),
                          //   topRight: Radius.circular(15),
                          // ),
                        ),
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: _tab,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        buildSubmissionIndicator(fill: false),
                                        buildSubmissionIndicator(
                                          color: Color(0xffFDA429),
                                          title: 'Late Submitted',
                                          fill: false,
                                        ),
                                        buildSubmissionIndicator(
                                          color: Color(0xffEB5757),
                                          title: 'Not Submitted',
                                          fill: false,
                                        ),
                                        // if (widget.questionPaper == null)
                                        //   kLateSubmitIndicator(false),
                                        // kNoSubmitIndicator(false),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: checkAssignedList(),
                                    margin: EdgeInsets.only(bottom: 10),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: checkWidget(widget.activity),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkAssignedList() {
    if (widget.questionPaper != null) {
      return submittedTestByStudents();
    }
    switch (widget.activity.assigned) {
      case (Assigned.student):
        if (widget.activity.activityType == 'Assignment') {
          return assignmentSubmissionByStudents();
        }
        return submittedByStudents();
      case (Assigned.parent):
        return submittedByParents();
      case (Assigned.faculty):
        return submittedByTeachers();
      default:
        return Container();
    }
  }

  Widget assignmentSubmissionByStudents() {
    widget.activity.assignTo.sort((comp1, comp2) {
      if (comp1.status == 'Submitted' || comp1.status == 'Re-submitted') {
        return 0;
      }
      return -1;
    });
    return BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionStates>(
        builder: (context, snapshot) {
      if (snapshot is AssignmentSubmissionLoaded) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.allStudents.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              var pendingStudents = snapshot.allStudents
                  .where((element) => element.status == "Pending")
                  .toList();
              return Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'Submission: (${snapshot.submission.length}/${snapshot.allStudents.length})',
                      ),
                    ),
                    if (pendingStudents.isNotEmpty)
                      InkWell(
                        onTap: () {
                          if (selectAllStatus == "pending") {
                            offlineSubmitted = pendingStudents
                                .map((e) => {
                                      "student_id": e.studentId.id,
                                      "is_late": false
                                    })
                                .toList();
                            selectAllStatus = "submitted";
                          } else if (selectAllStatus == "late") {
                            offlineSubmitted = [];
                            selectAllStatus = "pending";
                          } else {
                            offlineSubmitted = pendingStudents
                                .map((e) => {
                                      "student_id": e.studentId.id,
                                      "is_late": true
                                    })
                                .toList();
                            selectAllStatus = "late";
                          }
                          setState(() {});
                        },
                        child: Container(
                          height: 40.0,
                          width: 80.0,
                          decoration: ShapeDecoration(
                            color: selectAllStatus == "pending"
                                ? Color(0xff6fcf97)
                                : selectAllStatus == "submitted"
                                    ? Color(0xffFDA429)
                                    : Color(0xffEB5757),
                            shape: StadiumBorder(),
                          ),
                          child: Center(
                            child: Text(
                              selectAllStatus == "pending"
                                  ? "Submitted All"
                                  : selectAllStatus == "submitted"
                                      ? "Late All"
                                      : "Pending All",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }
            var assign = snapshot.allStudents;
            var student = widget.activity.assignTo.firstWhere((stud) {
              return stud.studentId.id == assign[index - 1].studentId.id;
            });

            if (assign[index - 1] != null) {
              return buildSubmissionListOnline(
                  student, snapshot, assign, index, context);
            } else
              return Container();
          },
        );
      } else {
        return Container(
          child: Center(child: loadingBar),
        );
      }
    });
  }

  Widget buildSubmissionListOnline(
      AssignTo student,
      AssignmentSubmissionLoaded snapshot,
      List<AssignTo> assign,
      int index,
      BuildContext context) {
    Offset _tapDownPosition;
    String studentId = assign[index - 1].studentId.id;
    int indexOfStudent = offlineSubmitted
        .indexWhere((element) => element["student_id"] == studentId);
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _tapDownPosition = details.globalPosition;
      },
      child: ListTile(
        onLongPress: assign[index - 1].status.toLowerCase() == 'pending'
            ? () async {
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject();

                String value = await showMenu<String>(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  items: [
                    PopupMenuItem(value: 'offline', child: Text('Offline')),
                  ],
                  position: RelativeRect.fromLTRB(
                    _tapDownPosition.dx,
                    _tapDownPosition.dy,
                    overlay.size.width - _tapDownPosition.dx,
                    overlay.size.height - _tapDownPosition.dy,
                  ),
                );
                if (value == 'offline') {
                  DateTime submissionDate;
                  DateTime __date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.parse(widget.activity.startDate),
                    lastDate: DateTime.parse(widget.activity.startDate).add(
                      Duration(days: 500),
                    ),
                  );
                  if (__date != null) {
                    submissionDate = __date;
                    TimeOfDay _td = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (_td != null) {
                      submissionDate = DateTime(
                          submissionDate.year,
                          submissionDate.month,
                          submissionDate.day,
                          _td.hour,
                          _td.minute);
                      Fluttertoast.showToast(
                          msg: submissionDate.toIso8601String());
                      await BlocProvider.of<ActivityCubit>(context)
                          .submitOfflineAssignment([
                        {
                          "student_id": student.studentId.id,
                          "date": submissionDate
                        }
                      ], widget.activity.id);
                      widget.activity.submitedBy.add(
                        SubmittedBy(
                          studentId: student.studentId.id,
                          message: [
                            SubmittedMessage(
                              isOffline: true,
                              file: [],
                              evaluator: false,
                              submittedDate: submissionDate,
                              text: "",
                            )
                          ],
                          lateSubmission: submissionDate
                              .isAfter(widget.activity.endDateTime),
                          submittedDate: submissionDate,
                        ),
                      );
                      widget.activity.assignTo[index - 1].status = "Submitted";
                      studentsRewarded.add(student.studentId.id);
                      offlineSubmitted = [];
                      BlocProvider.of<AssignmentSubmissionCubit>(context)
                          .addData(widget.activity.submitedBy,
                              widget.activity.assignTo);
                    }
                  }
                }
              }
            : null,
        onTap: () {
          if (studentsRewarded.contains(studentId)) {
            Navigator.of(context).push(
              createRoute(
                pageWidget: BlocProvider<AssignmentSubmissionCubit>(
                  create: (context) => AssignmentSubmissionCubit()
                    ..addData(
                        widget.activity.submitedBy, widget.activity.assignTo),
                  child: EvaluateAssignment(
                    activity: widget.activity,
                    studentInfo: StudentInfo(
                      id: student.studentId.id,
                      name: student.name,
                      profileImage: student.profileImage,
                    ),
                    comment: student.comment,
                    submittedBy:
                        widget.activity.submitedBy.firstWhere((submit) {
                      return submit.studentId == student.studentId.id;
                    }, orElse: () {
                      // return SubmittedBy(
                      //   message: [
                      //     SubmittedMessage(text: 'Data Not Found'),
                      //   ],
                      // );
                      return null;
                    }),
                  ),
                ),
              ),
            );
          }
          // if (value)
          //   studentsRewarded.add(assign[index].studentId);
          // else
          //   studentsRewarded.remove(assign[index].studentId);
          // setState(() {});
        },
        leading: CircleAvatar(
          child: TeacherProfileAvatar(
            fill: true,
            bgColor: getRespectiveIndicator(
              snapshot.submission.map((e) => e.studentId).contains(studentId),
              snapshot.submission.firstWhere(
                    (element) => element.studentId == studentId,
                    orElse: () {
                      return SubmittedBy(lateSubmission: false);
                    },
                  ).lateSubmission ??
                  false,
            ),
            imageUrl:
                // profile.toString() ?? 'text',
                student.studentId.profileImage ?? 'text',
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LimitedBox(
              maxWidth: 310,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: '${student.name} ',
                          style: buildTextStyle(),
                        ),
                        // if (assign[index - 1].status == 'Re-work')
                        //   TextSpan(
                        //     text: '(Re-work)',
                        //     style: buildTextStyle(
                        //       color: Colors.red,
                        //       size: 10,
                        //     ),
                        //   )
                      ]),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          if (assign[index - 1].status == 'Re-work')
                            TextSpan(
                              text: '(Re-Assigned)',
                              style: buildTextStyle(
                                color: Colors.red,
                                size: 10,
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        subtitle: Text(
            "Class : ${student.className ?? ''} ${(student.studentId.sectionName != null) ? student.studentId.sectionName : ''}"),
        trailing: assign[index - 1].status == 'Pending'
            ? InkWell(
                onTap: () {
                  if (indexOfStudent != -1) {
                    if (!offlineSubmitted[indexOfStudent]["is_late"]) {
                      offlineSubmitted[indexOfStudent]["is_late"] = true;
                    } else {
                      offlineSubmitted.removeAt(indexOfStudent);
                    }
                  } else {
                    offlineSubmitted
                        .add({"student_id": studentId, "is_late": false});
                  }
                  setState(() {});
                },
                child: Container(
                  height: 40.0,
                  width: 80.0,
                  decoration: ShapeDecoration(
                    color: indexOfStudent != -1
                        ? offlineSubmitted[indexOfStudent]["is_late"]
                            ? Color(0xffFDA429)
                            : Color(0xff6fcf97)
                        : Color(0xffEB5757),
                    shape: StadiumBorder(),
                  ),
                  child: Center(
                    child: Text(
                      indexOfStudent != -1
                          ? offlineSubmitted[indexOfStudent]["is_late"]
                              ? "Late"
                              : "Submitted"
                          : "Pending",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            : Checkbox(
                  value: assign[index - 1].status == 'Evaluated',
                  onChanged: null,
                ),
      ),
    );
  }

  Widget submittedByStudents() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.activity.assignTo.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            child: Text(
              'Submission: (${studentsRewarded.length}/${widget.activity.assignTo.length})',
            ),
          );
        }

        var assign = widget.activity.assignTo;
        var student = assign[index - 1];

        if (assign[index - 1] != null) {
          return Container(
            color: Colors.transparent,
            child: CheckboxListTile(
              secondary: TeacherProfileAvatar(
                radius: 20,
                bgColor: getRespectiveIndicator(
                  assign[index - 1].status.toLowerCase() == 'submitted',
                  // studentsRewarded
                  //     .contains('${assign[index - 1].studentId.id}'),
                  lateSubmission.contains('${assign[index - 1].studentId.id}'),
                ),
                fill: true,
                imageUrl: student.studentId.profileImage ?? 'text',
              ),
              onChanged: (value) {},
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LimitedBox(
                    child: Container(
                      width: 130,
                      child: Text('${student.studentId.name ?? ''}'),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                  "Class : ${student.className ?? ''} ${student.studentId.sectionName != null ? student.studentId.sectionName : ''}"),
              value: widget.activity.activityType != 'Assignment'
                  ? widget.activity.status.toLowerCase() == 'evaluated'
                  : assign[index - 1].status.toLowerCase() == 'evaluated',
            ),
          );
        } else
          return Container();
      },
    );
  }

  Widget submittedTestByStudents() {
    widget.questionPaper.assignTo.sort((a, b) => a.status.compareTo(b.status));
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.questionPaper.assignTo.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
              child: Text(
                  'Submission: ${widget.questionPaper.assignTo.where((element) => element.status.toLowerCase() != 'pending').length}/${widget.questionPaper.assignTo.length}'));
        }
        var assign = widget.questionPaper.assignTo;
        var student = assign[index - 1];

        if (assign[index - 1] != null) {
          return Container(
            // color: studentsRewarded.contains(student.id)
            //     ? Color(0xff6FCF97).withOpacity(0.25)
            //     : Colors.transparent,
            child: CheckboxListTile(
              subtitle:
                  Text("Class : ${student.className} ${student.sectionName}"),
              secondary: TeacherProfileAvatar(
                fill: true,
                bgColor: getRespectiveIndicator(
                  assign[index - 1].status.toLowerCase() == 'evaluated',
                  lateSubmission.contains(assign[index - 1].studentId),
                ),
                imageUrl: student.profileImage ?? 'text',
              ),
              onChanged: (value) {
                // if (value)
                //   studentsRewarded.add(assign[index].studentId);
                // else
                //   studentsRewarded.remove(assign[index].studentId);
                // setState(() {});
              },
              title: LimitedBox(
                maxWidth: 200,
                child: GestureDetector(
                  onTap: () {
                    // if(studentsRewarded.contains(assign[index - 1].studentId) || lateSubmission.contains(assign[index - 1].studentId)) {
                    //   log(studentsRewarded.contains(assign[index - 1].studentId).toString());
                    //   log(index.toString());
                    //   Navigator.of(context).push(
                    //   createRoute(
                    //     pageWidget: TestResultPage(
                    //       questionPaper: widget.questionPaper,
                    //       questionPaperAnswer: questionPaperAnswer[0],
                    //     ),
                    //   ),
                    // );
                    // }
                  },
                  child: Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 150, child: Text('${student.name}')),
                      ],
                    ),
                  ),
                ),
              ),
              // value: studentsRewarded.contains(assign[index - 1].studentId),
              value: assign[index - 1].status.toLowerCase() == 'evaluated',
            ),
          );
        } else
          return Container();
      },
    );
  }

  Widget submittedByTeachers() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.activity.assignToYou.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
              child: Text(
            'Submission: ${studentsRewarded.length}/${widget.activity.assignToYou.length}',
          ));
        }
        var assign = widget.activity.assignToYou;
        var teacher = assign[index - 1];
        // AssignTo _assign = AssignTo(
        //     branch: student.branchId,
        //     classId: student.userInfoClass,
        //     schoolId: student.schoolId,
        //     studentId: student.id);
        // print(assign.length);
        if (assign[index - 1] != null) {
          return Container(
            color: studentsRewarded.contains(assign[index - 1])
                ? Color(0xff6FCF97).withOpacity(0.25)
                : Colors.transparent,
            child: CheckboxListTile(
              secondary: TeacherProfileAvatar(
                fill: true,
                bgColor: getRespectiveIndicator(
                  studentsRewarded.contains(assign[index - 1].teacherId),
                  lateSubmission.contains(assign[index - 1].teacherId),
                ),
                imageUrl: teacher.profileImage ?? 'text',
              ),
              onChanged: (value) {
                // if (value)
                //   studentsRewarded.add(assign[index]);
                // else
                //   studentsRewarded.remove(assign[index]);
                // setState(() {});
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LimitedBox(
                    maxWidth: 180,
                    child: Text(
                      '${teacher.name}',
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              value: widget.activity.status.toLowerCase() == 'evaluated',
            ),
          );
        } else
          return Container();
      },
    );
  }

  Widget submittedByParents() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.activity.assignToParent.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
              child: Text(
                  'Submission: ${studentsRewarded.length}/${widget.activity.assignToParent.length}'));
        }
        var assign = widget.activity.assignToParent;
        var parent = assign[index - 1];
        print(assign.length);
        if (assign[index - 1] != null)
          return Container(
              child: CheckboxListTile(
            secondary: CircleAvatar(
              child: TeacherProfileAvatar(
                fill: true,
                bgColor: getRespectiveIndicator(
                  studentsRewarded.contains(assign[index - 1].parentId),
                  lateSubmission.contains(assign[index - 1].parentId),
                ),
                imageUrl: parent.profileImage ?? "test",
              ),
            ),
            onChanged: (value) {
              // if (value)
              //   studentsRewarded.add(parent.parentId);
              // else
              //   studentsRewarded.remove(parent.parentId);
              setState(() {});
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${parent.name}'),
              ],
            ),
            value: widget.activity.status.toLowerCase() == 'evaluated',
          ));
        else
          return Container();
      },
    );
  }

  onChanges(AssignTo student, bool value) {
    // print(student.studentId);
    // print('pressed length == ${studentsRewarded.length}');
    if (value) {
      // print(studentsRewarded[0].studentId);
      studentsRewarded.add(student.studentId.id);
    } else
      studentsRewarded.removeWhere(
        (stud) => student.studentId.id == stud,
      );
    setState(() {});
  }

  bool check(AssignTo student) {
    print(student.studentId);
    for (var i in studentsRewarded) {
      if (i == student.studentId.id) return true;
    }
    // return false;
    print(studentsRewarded.contains(student));
    return studentsRewarded.contains(student);
  }

  void handleEvaluate() {
    rewarded = true;
    setState(() {});
    widget.activity.status = 'Evaluated';

    if (widget.activity.assigned == Assigned.student)
      context.read<GroupCubit>().rewardStudents(
            Reward(
              activityId: widget.activity.id,
              students: List<RewardedStudent>.from(
                studentsRewarded.map(
                  (e) => RewardedStudent(widget.activity.coin,
                      studentId: e,
                      event: widget.activity.activityType.toLowerCase() ==
                          'event'),
                ),
              ),
            ),
          );
    else if (widget.activity.assigned == Assigned.parent) {
      BlocProvider.of<RewardTeacherCubit>(context, listen: false).rewardParent(
        Reward(
          activityId: widget.activity.id,
          parents: List<RewardedStudent>.from(
            studentsRewarded.map(
              (e) => RewardedStudent(widget.activity.coin, parentId: e),
            ),
          ),
        ),
      );
    } else {
      BlocProvider.of<RewardTeacherCubit>(context, listen: false).rewardTeacher(
        Reward(
          activityId: widget.activity.id,
          teachers: List<RewardedStudent>.from(
            studentsRewarded.map(
              (e) => RewardedStudent(widget.activity.coin, teacherId: e),
            ),
          ),
        ),
      );
    }
    Fluttertoast.showToast(msg: 'Rewarded');
    // _tab.animateTo(1,
    //     duration: Duration(milliseconds: 300));
    // setState(() {});
    Navigator.of(context).pushReplacement(
      createRoute(
        pageWidget: BlocProvider<GroupCubit>(
          create: (context) => GroupCubit(),
          child: EvaluateTask(
              widget.activity,
              widget.activity.status.toLowerCase() == 'evaluate' ||
                  widget.activity.status.toLowerCase() == 'pending',
              null),
        ),
      ),
    );
  }

  void getRewardStudents() {
    if (questionPaperAnswer.isNotEmpty) {
      studentsRewarded = List<String>.from(
          questionPaperAnswer.map((e) => e.studentDetails.studentId));
      return;
    }
    switch (widget.activity.activityType) {
      case 'Assignment':
        studentsRewarded = List<String>.from(
          widget.activity.assignTo
              .where((student) {
                bool present = false;
                for (var submit in widget.activity.submitedBy) {
                  if (student.studentId.id == submit.studentId
                      // &&
                      // student.status != 'Re-work'
                      ) {
                    present = true;
                    break;
                  } else
                    present = false;
                }
                return present;
              })
              .map((assign) => assign.studentId.id)
              .toList(),
        );
        break;
      case 'LivePoll':
        studentsRewarded = List<String>.from(
          widget.activity.assignTo
              .where((student) {
                bool present = false;

                for (var submit in widget.activity.selectedLivePoll) {
                  if (student.studentId.id == submit.selectedBy) {
                    present = true;
                    if (submit.submittedDate
                        .isAfter(widget.activity.endDateTime))
                      lateSubmission.add(student.studentId.id);
                    print(student);
                    break;
                  } else
                    present = false;
                }
                return present;
              })
              .map((assign) => assign.studentId.id)
              .toList(),
        );
        break;
      case 'Check List':
        studentsRewarded =
            List<String>.from(widget.activity.selectedCheckList.map((e) {
          if (e.submittedDate.isAfter(widget.activity.endDateTime))
            lateSubmission.add(e.selectedBy);
          return e.selectedBy;
        })).toList();

        break;
      case 'Announcement':
        studentsRewarded = List<String>.from(
          widget.activity.assignTo
              .where((student) {
                return widget.activity.acknowledgeBy.map((e) {
                  if (e.submittedDate.isAfter(widget.activity.endDateTime)) {
                    lateSubmission.add(student.studentId.id);
                  }
                  return e.acknowledgeByStudent;
                }).contains(student.studentId.id);
              })
              .map((assign) => assign.studentId.id)
              .toList(),
        );
        break;
      case 'Event':
        studentsRewarded = List<String>.from(
          widget.activity.assignTo
              .where((student) {
                bool present = false;
                for (var submit in widget.activity.going) {
                  if (student.studentId.id == submit) {
                    present = true;

                    break;
                  } else
                    present = false;
                }
                return present;
              })
              .map((assign) => assign.studentId.id)
              .toList(),
        );
        break;
      default:
    }
  }

  void getRewardTeachers() {
    switch (widget.activity.activityType) {
      case 'LivePoll':
        studentsRewarded = List<String>.from(
          widget.activity.assignToYou.where((student) {
            bool present = false;
            for (var submit in widget.activity.selectedLivePoll) {
              if (student.teacherId == submit.selectedByTeacher) {
                present = true;
                print(student);
                break;
              } else
                present = false;
            }
            return present;
          }).map((e) => e.teacherId),
        );
        break;
      case 'Check List':
        studentsRewarded = List<String>.from(
          widget.activity.assignToYou.where((student) {
            bool present = false;
            for (var submit in widget.activity.selectedCheckList) {
              if (student.teacherId == submit.selectedByTeacher) {
                present = true;
                if (submit.submittedDate.isAfter(widget.activity.endDateTime))
                  lateSubmission.add(student.teacherId);
                print(student);
                break;
              } else
                present = false;
            }
            return present;
          }).map((e) => e.teacherId),
        );
        break;
      case 'Announcement':
        studentsRewarded = List<String>.from(
          widget.activity.assignToYou.where((student) {
            bool present = false;
            for (var submit in widget.activity.acknowledgeByTeacher) {
              if (student.teacherId == submit.acknowledgeByTeacher) {
                present = true;
                print(student);
                break;
              } else
                present = false;
            }
            return present;
          }).map((e) => e.teacherId),
        );
        break;
      case 'Event':
        studentsRewarded = List<String>.from(
          widget.activity.assignToYou.where((student) {
            bool present = false;
            widget.activity.goingByTeacher
                .addAll(widget.activity.notGoingByTeacher);
            for (var submit in widget.activity.goingByTeacher) {
              if (student.teacherId == submit) {
                present = true;
                print(student);
                break;
              } else
                present = false;
            }
            return present;
          }).map((e) => e.teacherId),
        );
        break;
      default:
    }
  }

  void getRewardParents() {
    switch (widget.activity.activityType) {
      case 'LivePoll':
        studentsRewarded = List<String>.from(
          widget.activity.assignToParent
              .where((student) {
                bool present = false;
                for (var submit in widget.activity.selectedLivePoll) {
                  if (student.parentId == submit.selectedByParent) {
                    present = true;
                    print(student);
                    break;
                  } else
                    present = false;
                }
                return present;
              })
              .map((assign) => assign.parentId)
              .toList(),
        );
        break;
      case 'Check List':
        studentsRewarded = List<String>.from(
          widget.activity.assignToParent
              .where((student) {
                bool present = false;
                for (var submit in widget.activity.selectedCheckList) {
                  if (student.parentId == submit.selectedByParent) {
                    present = true;
                    print(student);
                    break;
                  } else
                    present = false;
                }
                return present;
              })
              .map((assign) => assign.parentId)
              .toList(),
        );
        break;
      case 'Announcement':
        studentsRewarded = List<String>.from(
          widget.activity.assignToParent
              .where((student) {
                bool present = false;
                for (var submit in widget.activity.acknowledgeByParent) {
                  if (student.parentId == submit.acknowledgeByParent) {
                    present = true;
                    print(student);
                    break;
                  } else
                    present = false;
                }
                return present;
              })
              .map((assign) => assign.parentId)
              .toList(),
        );
        break;
      case 'Event':
        studentsRewarded = List<String>.from(
          widget.activity.assignToParent
              .where((student) {
                bool present = false;
                widget.activity.goingByParent
                    .addAll(widget.activity.notGoingByParent);
                for (var submit in widget.activity.goingByParent) {
                  if (student.parentId == submit) {
                    present = true;
                    print(student);
                    break;
                  } else
                    present = false;
                }
                return present;
              })
              .map((assign) => assign.parentId)
              .toList(),
        );
        break;
      default:
    }
  }

  Widget buildSubmissionListOffline(
      AssignTo student,
      AssignmentSubmissionLoaded snapshot,
      List<AssignTo> assign,
      int index,
      BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: ListTile(
        subtitle: Text(
            "Class : ${student.className ?? ''} ${(student.studentId.sectionName != null) ? student.studentId.sectionName : ''}"),
        leading: CircleAvatar(
          child: TeacherProfileAvatar(
            fill: true,
            bgColor: getRespectiveIndicator(
              snapshot.submission
                  .map((e) => e.studentId)
                  .contains(assign[index - 1].studentId.id),
              snapshot.submission.firstWhere(
                    (element) =>
                        element.studentId == assign[index - 1].studentId.id,
                    orElse: () {
                      return SubmittedBy(lateSubmission: false);
                    },
                  ).lateSubmission ??
                  false,
            ),
            imageUrl:
                // profile.toString() ?? 'text',
                student.studentId.profileImage ?? 'text',
          ),
        ),
        // onChanged: (value) {
        //   if (studentsRewarded
        //       .contains(assign[index - 1].studentId.id)) {
        //     Navigator.of(context).push(
        //       createRoute(
        //         pageWidget: BlocProvider<AssignmentSubmissionCubit>(
        //           create: (context) => AssignmentSubmissionCubit()
        //             ..addData(widget.activity.submitedBy,
        //                 widget.activity.assignTo),
        //           child: EvaluateAssignment(
        //             activity: widget.activity,
        //             studentInfo: StudentInfo(
        //               id: student.studentId.id,
        //               name: student.name,
        //               profileImage: student.profileImage,
        //             ),
        //             comment: student.comment,
        //             submittedBy: widget.activity.submitedBy
        //                 .firstWhere((submit) {
        //               return submit.studentId == student.studentId.id;
        //             }, orElse: () {
        //               // return SubmittedBy(
        //               //   message: [
        //               //     SubmittedMessage(text: 'Data Not Found'),
        //               //   ],
        //               // );
        //               return null;
        //             }),
        //           ),
        //         ),
        //       ),
        //     );
        //   }
        //   // if (value)
        //   //   studentsRewarded.add(assign[index].studentId);
        //   // else
        //   //   studentsRewarded.remove(assign[index].studentId);
        //   // setState(() {});
        // },
        title: LimitedBox(
          maxWidth: 310,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '${student.name} ',
                      style: buildTextStyle(),
                    ),
                    // if (assign[index - 1].status == 'Re-work')
                    //   TextSpan(
                    //     text: '(Re-work)',
                    //     style: buildTextStyle(
                    //       color: Colors.red,
                    //       size: 10,
                    //     ),
                    //   )
                  ]),
                ),
                if (assign[index - 1].status == 'Re-work')
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '(Re-Assigned)',
                          style: buildTextStyle(
                            color: Colors.red,
                            size: 10,
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        trailing: Container(
            width: 145,
            // color: Colors.amber,
            child: Row(
              children: [
                // InkWell(
                //   onTap: () {
                //     ableTo = !ableTo;
                //     // if (ableTo == true) {
                //     //   notAbleTo = true;
                //     //   ableTo = false;
                //     // } else if(notAbleTo == true){
                //     //   notAbleTo = false;
                //     //   ableTo = true;
                //     // }
                //     setState(() {});
                //   },
                //   child: Container(
                //     height: 30,
                //     width: 67.0,
                //     decoration: BoxDecoration(
                //         // color: Color(0xff6fcf97),
                //         color: ableTo ? Color(0xffFFC30A) : Colors.white,
                //         //     :
                //         // Color(0xffFB4D3D),
                //         borderRadius: BorderRadius.circular(15.0),
                //         border: !ableTo ? Border.all(color: Colors.black) : null),
                //     child: Center(
                //         child: Text(
                //       ableTo ? "Able To" : "Not Able",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //           color: ableTo ? Colors.white : Colors.black,
                //           fontSize: 13,
                //           fontWeight: FontWeight.bold),
                //     )),
                //   ),
                // ),
                SizedBox(width: 2),
                // InkWell(
                //   onTap: () {
                //     // if(notSubmitted == true){
                //     //   submitted = true;
                //     //   notSubmitted = false;
                //     //   lateSubmitted =false;
                //     // } else if(submitted = true) {
                //     //   lateSubmitted = true;
                //     //   notSubmitted = false;
                //     //   submitted = false;
                //     // } else if(lateSubmitted = true) {
                //     //   lateSubmitted = false;
                //     //   notSubmitted = true;
                //     //   submitted = false;
                //     // }
                //
                //     // outCome.map((bool) =>
                //
                //     // if (outCome[index] == 'notSubmitted') {
                //     //   outCome[index] = 'submitted';
                //     //   log(outCome[index]);
                //     // } else if (outCome[index] == 'submitted') {
                //     //   outCome[index] = "lateSubmitted";
                //     //   log(outCome[index]);
                //     // } else if (outCome[index] == 'lateSubmitted') {
                //     //   outCome[index] = "notSubmitted";
                //     //   log(outCome[index]);
                //     // }
                //     // setState(() {});
                //   },
                //   child: Container(
                //     height: 30,
                //     width: 74.0,
                //     decoration: BoxDecoration(
                //       color: outCome[index] == 'submitted'
                //           ? Color(0xff6fcf97)
                //           : outCome[index] == 'notSubmitted'
                //               ? Color(0xffFB4D3D)
                //               : Color(0xffFDA429),
                //       borderRadius: BorderRadius.circular(15.0),
                //     ),
                //     child: Center(
                //         child: Text(
                //       outCome[index] == 'notSubmitted'
                //           ? "Not"
                //           : outCome[index] == 'submitted'
                //               ? "Submitted"
                //               : "Late",
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //           color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                //     )),
                //   ),
                // ),
              ],
            )),
        // value: assign[index - 1].status == 'Evaluated',
      ),
    );
  }
}
