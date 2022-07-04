import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/bloc/Institute/institute-cubit.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../const.dart';
import '../../model/InstituteSessionModel.dart';
import '../../model/user.dart';
import '../homepage/home_sliver_appbar.dart';

typedef OnTaskClickHandler = Function();

class InstituteSession extends StatefulWidget {
  const InstituteSession({Key key, this.session, this.onTaskClickHandler,this.user})
      : super(key: key);

  final UserInfo user;
  final ReceivedSession session;
  final OnTaskClickHandler onTaskClickHandler;

  @override
  _InstituteSessionState createState() => _InstituteSessionState();
}

class _InstituteSessionState extends State<InstituteSession> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // isLoading = widget.session.isTeacherJoined;
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if (widget.onTaskClickHandler != null) {
          widget.onTaskClickHandler();
        }
        // if (widget.activity.assigned == Assigned.teacher &&
        //     widget.activity.status.toLowerCase() == 'pending') {
        //   Navigator.of(context).push(
        //     createRoute(
        //       pageWidget: BlocProvider<GroupCubit>(
        //         create: (context) => GroupCubit(),
        //         child: EventActionPanel(activity: widget.activity),
        //       ),
        //     ),
        //   );
        // } else if (widget.activity.assigned != Assigned.teacher) {
        //   Navigator.of(context).push(
        //     createRoute(
        //       pageWidget: BlocProvider<GroupCubit>(
        //         create: (context) => GroupCubit(),
        //         child: EvaluateTask(
        //             widget.activity, widget.activity.status == 'Evaluate'),
        //       ),
        //     ),
        //   );
        // }
      },
      child: Container(
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
            //     margin: EdgeInsets.only(right: 9, left: 9, top: 9, bottom: 3),
            //     child: Text(
            //       activity.assignTo.isNotEmpty
            //           ? 'Assigned to Student'
            //           : 'Assigned to You',
            //       style: buildTextStyle(
            //         size: 18,
            //       ),
            //     ),
            //   ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 4, right: 4, bottom: 10),
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
                color:
                    // widget.activity.status == 'Evaluated'
                    //     ? const Color(0xffEEFFF5)
                    //     :
                    const Color(0xffffffff),
              ),
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // BlocProvider.of<FeedActionCubit>(context)
                      //     .updateFeedPanelContent("Event", activity);
                      // feedActionPanelController.open();
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: TeacherProfileAvatar(
                                imageUrl: widget.session.createdBy != null
                                    ? widget.session.createdBy.profileImage ?? 'test'
                                    : 'text',
                              ),
                              // child: CachedNetworkImage(
                              //   imageUrl: "test.png",
                              //   progressIndicatorBuilder:
                              //       (context, url, downloadProgress) => CircleAvatar(
                              //     backgroundColor: Colors.grey[200],
                              //     radius: 25,
                              //   ),
                              //   errorWidget: (context, url, error) => CircleAvatar(
                              //     backgroundColor: Colors.grey[200],
                              //     radius: 25,
                              //   ),
                              // ),
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 95,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Spacer(),
                                      // Padding(
                                      //   padding:
                                      //       const EdgeInsets.only(top: 5.0),
                                      //   child: Container(
                                      //     width: MediaQuery.of(context)
                                      //             .size
                                      //             .width *
                                      //         0.35,
                                      //     alignment: Alignment.center,
                                      //     child: LimitedBox(
                                      //       child: Text(
                                      //         "activity status",
                                      //         // widget.activity.status
                                      //         //     .toTitleCase(),
                                      //         style: const TextStyle(
                                      //           color: const Color(0xffffffff),
                                      //           fontWeight: FontWeight.w400,
                                      //           fontSize: 12.0,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     height: 22.778032302856445,
                                      //     decoration: BoxDecoration(
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(20)),
                                      //       color:
                                      //           // widget.activity.forwarded
                                      //           //     ? Color(0xff5458EA)
                                      //           //     : widget.activity.status
                                      //           //     .toLowerCase() ==
                                      //           //     'pending'
                                      //           //     ? const Color(0xffeb5757)
                                      //           //     : widget.activity.status ==
                                      //           //     'Evaluated'
                                      //           //     ? Color(0xff6FCF97)
                                      //           //     :
                                      //           Color(0xff5458EA),
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          if (widget.onTaskClickHandler != null) {
                                            widget.onTaskClickHandler();
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          height: 29,
                                          padding: EdgeInsets.symmetric(horizontal: 7),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Session",
                                                style: const TextStyle(
                                                  color: const Color(0xff887fdc),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              if(widget.user.isAuthorized)
                                              Padding(
                                                padding: EdgeInsets.only(right: 13),
                                                child: InkWell(
                                                  onTap: () {
                                                    if (widget.onTaskClickHandler != null) {
                                                      widget.onTaskClickHandler();
                                                    }
                                                  },
                                                  child: SvgPicture.asset(
                                                      "assets/svg/mask.svg",
                                                      color: Colors.black),
                                                ),
                                              )
                                              // PopUpMenuWidget(
                                              //   showEdit:
                                              //   widget.activity.going.isEmpty &&
                                              //       widget
                                              //           .activity
                                              //           .goingByParent
                                              //           .isEmpty &&
                                              //       widget
                                              //           .activity
                                              //           .goingByTeacher
                                              //           .isEmpty &&
                                              //       widget.activity.notGoing
                                              //           .isEmpty &&
                                              //       widget
                                              //           .activity
                                              //           .notGoingByParent
                                              //           .isEmpty &&
                                              //       widget
                                              //           .activity
                                              //           .notGoingByTeacher
                                              //           .isEmpty &&
                                              //       widget.activity.editable,
                                              //   children: widget
                                              //       .activity.assigned !=
                                              //       Assigned.teacher
                                              //       ? null
                                              //       : (context) => [
                                              //     if (widget
                                              //         .activity.status
                                              //         .toLowerCase() ==
                                              //         'pending')
                                              //       PopupMenuItem<String>(
                                              //         height: 30,
                                              //         value:
                                              //         'Take action',
                                              //         child: Container(
                                              //           // width: 20,
                                              //           child: Row(
                                              //             mainAxisAlignment:
                                              //             MainAxisAlignment
                                              //                 .spaceAround,
                                              //             children: [
                                              //               Text(
                                              //                 'Take Action',
                                              //                 style: buildTextStyle(
                                              //                     size:
                                              //                     15),
                                              //               ),
                                              //               SizedBox(
                                              //                 width: 5,
                                              //               ),
                                              //               SvgPicture.asset(
                                              //                   'assets/svg/take-icon.svg'),
                                              //             ],
                                              //           ),
                                              //         ),
                                              //       )
                                              //   ],
                                              //   onSelected: (value) async {
                                              //     handleOnSelected(
                                              //         context, value);
                                              //   },
                                              // )
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                            ),
                                            color: const Color(0xffe4d7f5),
                                          ),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.session.createdBy != null
                                              ? widget.session.createdBy.name
                                              : 'No Data',
                                          // '${widget.activity.teacherProfile.name}'
                                          //     .toTitleCase(),
                                          style: const TextStyle(
                                            color: const Color(0xff828282),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        // Spacer(),
                                        // Image.asset(
                                        //   'assets/images/points.png',
                                        //   height: 20,
                                        //   width: 20,
                                        // ),
                                        // Text('activity coin',
                                        //   // widget.activity.coin.toString(),
                                        //   style: buildTextStyle(size: 12),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              style: const TextStyle(
                                                color: const Color(0xff828282),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11.0,
                                              ),
                                              text: DateFormat('dd-MMM ').format(
                                                      DateTime.parse(
                                                          widget.session.createdAt)) ??
                                                  '',
                                            ),
                                            // TextSpan(
                                            //     style: const TextStyle(
                                            //       color:
                                            //           const Color(0xffff5a79),
                                            //       fontWeight: FontWeight.w500,
                                            //       fontSize: 11.0,
                                            //     ),
                                            //     // text: widget.showAssigned
                                            //     //     ? checkAssignedTo(
                                            //     //     widget.activity.assigned)
                                            //     //     : '',
                                            //     text: "Published to Group")
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
                        InkWell(
                          onTap: () {
                            if (widget.onTaskClickHandler != null) {
                              widget.onTaskClickHandler();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Container(
                              // height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  begin: Alignment(0, 0),
                                  end: Alignment(0, 0),
                                  colors: [
                                    const Color(0xff9188e5),
                                    const Color(0xff756dca)
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 7.0, top: 15, bottom: 15),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${DateFormat('d MMM yyyy').format(widget.session.sessionStartDate)}",
                                          style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          widget.session.sessionStartTime != null
                                              ? TimeOfDay.fromDateTime(
                                                      widget.session.sessionStartTime)
                                                  .format(context)
                                              : '',
                                          // "${DateFormat('hh:mm').format(DateTime.now())}",
                                          // "${DateFormat('hh:mm').format(widget.session.sessionStartTime)}",
                                          // DateFormat('dd-MM-yyyy').format(
                                          //     DateTime.parse(
                                          //         widget.activity.startDate)),
                                          style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if (widget.session.sessionEndDate != null)
                                          Text(
                                            "${DateFormat('d MMM yyyy').format(widget.session.sessionEndDate)}",
                                            style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        Text(
                                          widget.session.sessionEndTime != null
                                              ? TimeOfDay.fromDateTime(
                                                      widget.session.sessionEndTime)
                                                  .format(context)
                                              : '',
                                          // "${DateFormat('hh:mm').format(DateTime.now())}",
                                          // "${DateFormat('hh:mm').format(widget.session.sessionEndTime)}",
                                          // DateFormat('dd-MM-yyyy').format(
                                          //     DateTime.parse(
                                          //         widget.activity.endDate)),
                                          style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 76.74815368652344,
                                      decoration: BoxDecoration(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.58,
                                          child: Text(
                                            widget.session.subjectName,
                                            // widget.activity.title,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                        // if(widget.session.isDaily != null && widget.session.doesSessionRepeat !=null)
                                        if (widget.session.isDaily.toLowerCase() ==
                                                'yes' ||
                                            widget.session.doesSessionRepeat
                                                    .toLowerCase() ==
                                                'yes')
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(10)),

                                            // width: 245,
                                            child: Text(
                                              widget.session.doesSessionRepeat
                                                          .toLowerCase() ==
                                                      'yes'
                                                  ? 'Weekly'
                                                  : widget.session.isDaily
                                                              .toLowerCase() ==
                                                          'yes'
                                                      ? 'Daily'
                                                      : '',
                                              // widget.activity.title,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                                width: MediaQuery.of(context).size.width *
                                                    0.2),
                                            // ElevatedButton(
                                            //   onPressed: isLoading
                                            //       ? null
                                            //       : () {
                                            //           handleJoinSessionRequest(context);
                                            //         },
                                            //   child: isLoading
                                            //       ? SizedBox.square(
                                            //           dimension: 20,
                                            //           child: CircularProgressIndicator(),
                                            //         )
                                            //       : Text(
                                            //           !widget.session.isTeacherJoined
                                            //               ? 'Join Session'
                                            //               : 'Attended',
                                            //           style: TextStyle(
                                            //               fontSize: MediaQuery.of(context)
                                            //                       .size
                                            //                       .width *
                                            //                   0.04),
                                            //         ),
                                            //   style: ElevatedButton.styleFrom(
                                            //       primary: widget.session.isTeacherJoined
                                            //           ? Color(0xff6fcf97)
                                            //           : Color(0xffEB5757),
                                            //       fixedSize: Size(
                                            //           MediaQuery.of(context).size.width *
                                            //               0.37,
                                            //           MediaQuery.of(context).size.height *
                                            //               0.05),
                                            //       elevation: 1,
                                            //       shape: RoundedRectangleBorder(
                                            //           borderRadius:
                                            //               BorderRadius.circular(20))),
                                            // ),
                                            InkWell(
                                              onTap: isLoading
                                                  ? null
                                                  : () {
                                                      handleJoinSessionRequest(context);
                                                    },
                                              child: AnimatedContainer(
                                                curve: Curves.fastOutSlowIn,
                                                alignment: Alignment.center,
                                                duration: Duration(milliseconds: 550),
                                                width: isLoading
                                                    ? 30
                                                    : MediaQuery.of(context).size.width *
                                                        0.37,
                                                height:
                                                    MediaQuery.of(context).size.height *
                                                        0.05,
                                                decoration: BoxDecoration(
                                                  color: widget.session.isTeacherJoined
                                                      ? Color(0xff6fcf97)
                                                      : Color(0xffEB5757),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20)),
                                                ),
                                                child: isLoading
                                                    ? SizedBox(
                                                    height: 20,
                                                    width: 30,
                                                    child: CircularProgressIndicator())
                                                    : Center(
                                                        child: Text(
                                                          !widget.session.isTeacherJoined
                                                              ? 'Join Session'
                                                              : 'Attended',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  screenwidth < 600 ?
                                                                  MediaQuery.of(context)
                                                                          .size
                                                                          .width *
                                                                      0.04 : 17 ,
                                                              color: Colors.white),
                                                        ),
                                                      ),
                                              ),
                                            )
                                          ],
                                        ),
                                        // LimitedBox(
                                        //   maxHeight: 20,
                                        //   maxWidth: 245,
                                        //   child: Text(
                                        //     'activity location',
                                        //     // widget.activity.locations,
                                        //     style: const TextStyle(
                                        //       color: const Color(0xffffffff),
                                        //       fontWeight: FontWeight.w400,
                                        //       fontSize: 12.0,
                                        //     ),
                                        //     softWrap: true,
                                        //   ),
                                        // ),
                                        // Text(
                                        //   "teacher are going",
                                        //   // "${widget.activity.assigned == Assigned.student ? widget.activity.going.length : widget.activity.assigned == Assigned.faculty ? widget.activity.goingByTeacher.length : widget.activity.assigned == Assigned.teacher ? widget.activity.goingByTeacher.length : widget.activity.goingByParent.length} ${widget.activity.assigned == Assigned.student ? 'students' : widget.activity.assigned == Assigned.parent ? 'parents' : 'teachers'} are Going",
                                        //   style: const TextStyle(
                                        //     color: const Color(0xffffffff),
                                        //     fontWeight: FontWeight.w400,
                                        //     fontSize: 12.0,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ],
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
                  // if (activity.status != 'Evaluated')
                  // InstituteBottomWidgetTasks(
                  //   // activity: widget.activity,
                  //   // addSaved: widget.saved,
                  //   // toYou: widget.showAssigned,
                  // ),
                  SizedBox(
                    height: 11,
                  ),
                ],
              ),
            ),
            // if (widget.activity.comment.isNotEmpty)
            //   ThreadWidget(
            //     comments: widget.activity.comment,
            //     teacherId: widget.activity.teacherProfile.id,
            //     activity: widget.activity,
            //   ),
          ],
        ),
      ),
    );
  }

  bool checkValidSessionJoiningTime(DateTime startDate, DateTime endDate) {
    ///check the time join is clicked is between session start date and session end date
    DateTime now = DateTime.now();

    // if (now.isAfter(endDate)) {
    //   Fluttertoast.showToast(
    //       msg: "Sorry, Looks like this session is over.",
    //       fontSize: 16,
    //       textColor: Colors.white,
    //       backgroundColor: const Color(0xff6fcf97));
    //   // return null;
    // }

    if (now.isBefore(startDate)) {
      Fluttertoast.showToast(
          msg: "Your session has not started yet.",
          fontSize: 16,
          textColor: Colors.white,
          backgroundColor: const Color(0xff6fcf97));
      // return null;
    }


    return now.isAfter(startDate);
        // && now.isBefore(endDate);
  }

  Future<void> handleJoinSessionRequest(BuildContext context) async {
    try {
      var startDate = widget.session.sessionStartDate;
      var startTime = widget.session.sessionStartTime;
      var endDate = widget.session.sessionEndDate;
      var endTime = widget.session.sessionEndTime;

      ///check if session time is over
      // if(endDate != null)
      if (!checkValidSessionJoiningTime(
          DateTime(startDate.year, startDate.month, startDate.day, startTime.hour,
              startTime.minute, startTime.second),
          DateTime(endDate.year, endDate.month, endDate.day, endTime.hour, endTime.minute,
              endTime.second))) {
        return;
      }

      ///avoid reattend session

      if (widget.session.isTeacherJoined) {
        // await
        // canLaunch(widget.session.meetingLink)
        //     ?
        await launchUrl(Uri.parse(widget.session.meetingLink),webViewConfiguration: WebViewConfiguration(
          enableJavaScript: true
        ),
          mode: LaunchMode.externalApplication
        );
        // : throw 'Could not launch ${widget.session.meetingLink}';
        return;
      }

      setState(() {
        isLoading = true;
      });

      ///if everything clear , do join session
      String status = await BlocProvider.of<SessionCubit>(context)
          .joinSessionForTeacher(widget.session, widget.user.schoolId.id);

      setState(() {
        log("loading");
        isLoading = false;
      });

      if (status == "success") {
        // await
        // canLaunch(widget.session.meetingLink)
        //     ?
        await launch(widget.session.meetingLink);
        // : throw 'Could not launch ${widget.session.meetingLink}';
      }
    } catch (e) {
      // TODO
      log(e.toString() + e.runtimeType.toString());
    }
  }
}

class InstituteBottomWidgetTasks extends StatefulWidget {
  const InstituteBottomWidgetTasks({
    Key key,
    // @required this.activity,
    // this.addSaved = false,
    // this.toYou,
  }) : super(key: key);

  // final bool addSaved;
  // final Activity activity;
  // final bool toYou;

  @override
  _InstituteBottomWidgetTasksState createState() => _InstituteBottomWidgetTasksState();
}

class _InstituteBottomWidgetTasksState extends State<InstituteBottomWidgetTasks> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Row(
              children: [
                // if (widget.activity.assigned != Assigned.teacher)
                SvgPicture.asset(
                  "assets/svg/likes.svg",
                  height: 18,
                  width: 18,
                  color: Color(0xffFF5A79),
                ),
                // if (widget.activity.assigned == Assigned.teacher)
                //   LikeButton(
                //     size: 18,
                //     circleColor: CircleColor(
                //         start: Color(0xffFF5A79).withOpacity(0.1),
                //         end: Color(0xffFF5A79)),
                //     bubblesColor: BubblesColor(
                //       dotPrimaryColor: Color(0xffFF5A79).withOpacity(0.1),
                //       dotSecondaryColor: Color(0xffFF5A79),
                //     ),
                //     likeBuilder: (bool isLiked) {
                //       return SvgPicture.asset(
                //         "assets/svg/likes.svg",
                //         height: 30,
                //         width: 30,
                //         color: isLiked ? Color(0xffFF5A79) : Colors.grey,
                //       );
                //     },
                //     // isLiked: widget.activity.liked,
                //     onTap: (isLiked) async {
                //       // log('$isLiked function liked - ${widget.activity.liked} activity liked.');
                //       //
                //       // /// send your request here
                //       // widget.activity.liked = !widget.activity.liked;
                //       // if (isLiked) {
                //       //   widget.activity.like -= 1;
                //       //   BlocProvider.of<ActivityCubit>(context)
                //       //       .disLikeActivity(widget.activity.id);
                //       // } else {
                //       //   widget.activity.like += 1;
                //       //   BlocProvider.of<ActivityCubit>(context)
                //       //       .likeActivity(widget.activity.id);
                //       // }
                //       // setState(() {});
                //       // // return;
                //       // // /// if failed, you can do nothing
                //       // return widget.activity.liked;
                //     },
                //     // likeCount: widget.activity.like,
                //     countBuilder: (int count, bool isLiked, String text) {
                //       var color = isLiked ? Color(0xffff5a79) : Colors.grey;
                //       Widget result;
                //       if (count == 0) {
                //         result = Text(
                //           "Like",
                //           style: TextStyle(color: color),
                //         );
                //       } else
                //         result = Text(
                //           text,
                //           style: TextStyle(color: color),
                //         );
                //       return result;
                //     },
                //   ),
                SizedBox(
                  width: 4,
                ),
                // if (widget.activity.assigned != Assigned.teacher)
                Text(
                  '5',
                  // widget.activity.like.toString(),
                  style: TextStyle(
                    color: Color(0xffff5a79),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 5,
            ),
            // if (widget.addSaved)
            // SvgPicture.asset("assets/svg/assigned.svg"),
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg/bookmark.svg',
                height: 16,
                width: 16,
                color:
                    // widget.activity.saved
                    //     ? Color(0xffFF5A79)
                    //     :
                    Colors.black,
              ),
              onPressed: () {
                // widget.activity.saved = !widget.activity.saved;
                // BlocProvider.of<ActivityCubit>(context).saveActivity(
                //     widget.activity.id,
                //     remove: !widget.activity.saved);
                // setState(() {});
              },
            ),
            SizedBox(width: 5),
            // if (widget.toYou)
            IconButton(
              icon: SvgPicture.asset("assets/svg/assigned.svg"),
              onPressed: () {
                // Navigator.of(context).push(
                //   createRoute(
                //     pageWidget: ActionByWidget(widget.activity),
                //   ),
                // );
              },
            ),
            Text(
              'You or Group',
              // calculateTime(widget.activity.endDateTime),
              style: buildTextStyle(size: 12, color: Color(0xffFF715A)),
            ),
          ],
        ),
        Row(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/views.svg",
                  height: 16,
                  width: 16,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  '4',
                  // widget.activity.view.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  icon: Icon(
                    Icons.message,
                    color: Color(0xffFF715A),
                  ),
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   createRoute(
                    //     pageWidget: BlocProvider(
                    //       create: (context) => ThreadPostCubit(),
                    //       child: ViewThreadsPage(widget.activity),
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
            // SizedBox(
            //   width: 5,
            // ),
          ],
        )
      ],
    );
  }

  String calculateTime(DateTime endTime) {
    var now = DateTime.now();
    var duration = endTime.difference(now);
    if (duration.inDays <= 0) {
      if (duration.inHours <= 0) {
        if (duration.inMinutes <= 0) {
          return 'Time Over';
        }
        return '${duration.inMinutes} mins left';
      }
      return '${duration.inHours} hours left';
    }
    return '${duration.inDays} days left';
  }
}
