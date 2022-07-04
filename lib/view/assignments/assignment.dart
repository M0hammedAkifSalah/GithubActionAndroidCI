import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/bloc/activity/assignment-cubit.dart';
import '/view/assignments/editAssignment.dart';
import '../../export.dart';

class Assignment extends StatefulWidget {
  final Activity activity;
  final bool saved;
  final bool showAssigned;

  Assignment(this.activity, this.saved, this.showAssigned);

  @override
  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  double height;
  GlobalKey<PopupMenuButtonState> buttonStateAssignment;

  @override
  void initState() {
    height = widget.activity.description.length > 240 ? 90 : null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    log(widget.activity.startDate);
    return InkWell(
      onTap: () {
        BlocProvider.of<AssignmentSubmissionCubit>(context)
            .addData(widget.activity.submitedBy, widget.activity.assignTo);
        // if (activity.status.toLowerCase() == 'evaluate' ||
        //     activity.status.toLowerCase() == 'evaluated')
        Navigator.of(context).push(
          createRoute(
            pageWidget: MultiBlocProvider(
              providers: [
                BlocProvider<GroupCubit>(
                  create: (context) => GroupCubit(),
                ),
                BlocProvider<AssignmentSubmissionCubit>(
                  create: (context) => AssignmentSubmissionCubit()
                    ..addData(
                        widget.activity.submitedBy, widget.activity.assignTo),
                ),
              ],
              child: EvaluateTask(
                  widget.activity, widget.activity.status == 'Evaluate'),
            ),
          ),
        );
        // onTapTaskPanel();
        //
        // buildDetailsMethod();
      },
      // child: PopUpMenuWidget(
      //   showEdit: widget
      //       .activity.submitedBy.isEmpty && widget.activity.editable,
      //   onSelected: (value) async {
      //     handleOnSelected(value, context);
      //   },
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
                  color: widget.activity.partiallyEvaluated
                      ? Color(0xffffecb5)
                      : widget.activity.status == 'Evaluated'
                          ? const Color(0xffEEFFF5)
                          : const Color(0xffffffff)),
              padding: EdgeInsets.only(left: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // BlocProvider.of<FeedActionCubit>(context).updateFeedPanelContent("Assignment", activity);
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
                                    widget.activity.teacherProfile.profileImage,
                              ),
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Container(
                              width:  MediaQuery.of(context).size.width - 121,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          alignment: Alignment.center,
                                          child: LimitedBox(
                                            child: Text(
                                              widget.activity.status
                                                  .toTitleCase(),
                                              style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                          height: 22.778032302856445,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            color: widget.activity.forwarded
                                                ? Color(0xff5458EA)
                                                : widget.activity.status
                                                            .toLowerCase() ==
                                                        'pending'
                                                    ? const Color(0xffeb5757)
                                                    : widget.activity.status ==
                                                            'Evaluated'
                                                        ? Color(0xff6FCF97)
                                                        : Color(0xff5458EA),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 150,
                                        height: 29,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 7),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Assignment",
                                              style: const TextStyle(
                                                color: const Color(0xff822111),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            PopUpMenuWidget(
                                              showEdit: widget.activity
                                                      .submitedBy.isEmpty &&
                                                  widget.activity.editable,
                                              onSelected: (value) async {
                                                handleOnSelected(
                                                    value, context);
                                              },
                                            )
                                          ],
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
                                          '${widget.activity.teacherProfile.name}'
                                              .toTitleCase(),
                                          style: const TextStyle(
                                            color: const Color(0xff828282),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Spacer(),
                                        Image.asset(
                                          'assets/images/points.png',
                                          height: 20,
                                          width: 20,
                                        ),
                                        Text(
                                          widget.activity.coin.toString(),
                                          style: buildTextStyle(size: 12),
                                        ),
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
                                            const TextSpan(
                                              style: TextStyle(
                                                  color: Color(0xff828282),
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
                                                  widget.activity
                                                          .publishedDate ??
                                                      widget
                                                          .activity.createdAt),
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
                        Container(
                          // height: widget.activity.description.length > 240
                          //     ? height
                          //     : null,
                          // color: Colors.black,
                          child:
                          // height != null
                          //     ? Text(
                          //         '${widget.activity.title} ',
                          //         softWrap: true,
                          //         overflow: TextOverflow.clip,
                          //         style: const TextStyle(
                          //           color: const Color(0xff000000),
                          //           fontWeight: FontWeight.w400,
                          //           fontSize: 12.0,
                          //         ),
                          //       )
                          //     :
                          widget.activity.title.convertToHyperLink,
                        ),
                        // if (widget.activity.description.length > 240)
                        //   Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: TextButton(
                        //       child: Text(
                        //           height != null ? 'View more' : 'View less'),
                        //       onPressed: () {
                        //         setState(() {
                        //           if (height != null) {
                        //             height = null;
                        //             log('Height - null');
                        //           } else {
                        //             log('Height - not null');
                        //             height = 90;
                        //           }
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // showActivityLinks(context, widget.activity),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Subject: ${widget.activity.subject}',
                          softWrap: true,
                          style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(
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
                                    'Start : ${widget.activity.startDate != null && widget.activity.startDate != 'null' ? DateTime.parse(widget.activity.startDate).toLocal().toDateTimeFormatInLine(context) : ''}',
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    'End : ${widget.activity.endDateTime.toDateTimeFormatInLine(context)}',
                                    softWrap: true,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              // Column(
                              //   children: [
                              //     Text(
                              //       'Total Marks\n ${questionPaper.totalMarks.toInt()}',
                              //       softWrap: true,
                              //       textAlign: TextAlign.center,
                              //       style: const TextStyle(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 14.0,
                              //       ),
                              //     ),
                              //     Container(
                              //       height: 2,
                              //       color: Colors.black,
                              //       width: 80,
                              //     ),
                              //     Text(
                              //       'Duration\n ${secondsToHours(questionPaper.duration)}',
                              //       softWrap: true,
                              //       textAlign: TextAlign.center,
                              //       style: const TextStyle(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w500,
                              //         fontSize: 14.0,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  // if (activity.status != 'Evaluated')
                  BottomWidgetTasks(
                    activity: widget.activity,
                    addSaved: widget.saved,
                    toYou: widget.showAssigned,
                  ),
                  SizedBox(
                    height: 11,
                  ),
                ],
              ),
            ),
            if (widget.activity.comment.isNotEmpty)
              ThreadWidget(
                comments: widget.activity.comment,
                teacherId: widget.activity.teacherProfile.id,
                activity: widget.activity,
              ),
          ],
        ),
      ),
      // ),
    );
  }

  void handleOnSelected(String value, BuildContext context) async {
    if (value == 'Evaluate') {
      BlocProvider.of<AssignmentSubmissionCubit>(context)
          .addData(widget.activity.submitedBy, widget.activity.assignTo);
      Navigator.of(context).push(
        createRoute(
          pageWidget: MultiBlocProvider(
            providers: [
              BlocProvider<GroupCubit>(
                create: (context) => GroupCubit(),
              ),
              BlocProvider<AssignmentSubmissionCubit>(
                create: (context) => AssignmentSubmissionCubit()
                  ..addData(
                      widget.activity.submitedBy, widget.activity.assignTo),
              ),
            ],
            child: EvaluateTask(
                widget.activity, widget.activity.status == 'Evaluate'),
          ),
        ),
      );

      // BlocProvider.of<AssignmentSubmissionCubit>(context)
      //     .addData(widget.activity.submitedBy, widget.activity.assignTo);
      // // if (activity.status.toLowerCase() == 'evaluate' ||
      // //     activity.status.toLowerCase() == 'evaluated')
      // Navigator.of(context).push(
      //   createRoute(
      //     pageWidget: MultiBlocProvider(
      //       providers: [
      //         BlocProvider<GroupCubit>(
      //           create: (context) => GroupCubit(),
      //         ),
      //         BlocProvider<AssignmentSubmissionCubit>(
      //           create: (context) => AssignmentSubmissionCubit()
      //             ..addData(
      //                 widget.activity.submitedBy, widget.activity.assignTo),
      //         ),
      //       ],
      //       child: EvaluateTask(
      //           widget.activity, widget.activity.status == 'Evaluate'),
      //     ),
      //   ),
      // );

    } else if (value == 'Edit') {
      Navigator.of(context)
          .push(
        createRoute(
          pageWidget: EditAssignmentPage(
            activity: widget.activity,
          ),
        ),
      )
          .then((value) {
        setState(() {});
      });
    } else {
      bool delete = false;
      delete = await showDeleteDialogue(context);
      if (delete) {
        await BlocProvider.of<ActivityCubit>(context, listen: false)
            .deleteActivity(widget.activity.id).then((value) {

        });

        // Navigator.of(context)
        //     .pushReplacement(createRoute(pageWidget: TeacherHomePage()));
        Fluttertoast.showToast(msg: 'Deleted! Please refresh the page.');
        setState(() {});
      }
    }
  }

  // Widget buildDetailsMethod() {
  //   showGeneralDialog(
  //       barrierLabel: "Barrier",
  //       barrierDismissible: true,
  //       barrierColor: Colors.black.withOpacity(0.5),
  //       transitionDuration: Duration(milliseconds: 300),
  //       transitionBuilder: (_, anim, __, child) {
  //         return SlideTransition(
  //           position:
  //           Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
  //           child: child,
  //         );
  //       },
  //       context: context,
  //       pageBuilder: (_, __, ___) {
  //         return
  //           PopupMenuButton(
  //           // onSelected: onSelected,
  //           itemBuilder: children != null
  //               ? children
  //               : (context) {
  //             return [
  //               // if(children!=null) ...children,
  //               // if(children==null)
  //               PopupMenuItem(
  //                 height: 30,
  //                 value:  'Evaluate',
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   // width: 20,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         'Evaluate',
  //                         style: buildTextStyle(size: 15),
  //                       ),
  //                       SizedBox(
  //                         width: 5,
  //                       ),
  //                       SvgPicture.asset('assets/svg/evaluate.svg'),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               PopupMenuItem(
  //                 height: 30,
  //                 value:  'Delete',
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   // width: 20,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         'Delete',
  //                         style: buildTextStyle(size: 15),
  //                       ),
  //                       SizedBox(
  //                         width: 15,
  //                       ),
  //                       Icon(Icons.delete)
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               // if (showEdit)
  //               //   PopupMenuItem<T>(
  //               //     height: 30,
  //               //     value: value ?? 'Edit',
  //               //     child: Container(
  //               //       decoration: BoxDecoration(
  //               //         borderRadius: BorderRadius.circular(10),
  //               //       ),
  //               //       // width: 20,
  //               //       child: Row(
  //               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               //         children: [
  //               //           Text(
  //               //             'Edit',
  //               //             style: buildTextStyle(size: 15),
  //               //           ),
  //               //           SizedBox(
  //               //             width: 15,
  //               //           ),
  //               //           Icon(Icons.edit)
  //               //         ],
  //               //       ),
  //               //     ),
  //               //   )
  //             ];
  //           },
  //           // child: child ??
  //           //     Container(
  //           //       height: 15,
  //           //       width: 20,
  //           //       child: SvgPicture.asset("assets/svg/mask.svg"),
  //           //     ),
  //         );
  //       });
  // }
}

// class onTapTaskPanel extends StatelessWidget {
//   const onTapTaskPanel({Key key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SlidingUpPanel(
//         panel: Center(
//           child: Column(
//             children: [
//               Text('jksf'),
//               Text('jksf'),
//               Text('jksf'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

getAssignedList(List<String> groups) {
  String assignedTo = ' ';

  for (final group in groups) assignedTo = assignedTo + group + "or ";

  return assignedTo.substring(0, assignedTo.length - 3);
}
