import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/export.dart';
import '/view/event/editevent.dart';
import '/view/take_action/event-action-panel.dart';

class Event extends StatefulWidget {
  final Activity activity;
  final bool saved;
  final bool showAssigned;

  Event(this.activity, this.saved, this.showAssigned);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.activity.assigned == Assigned.teacher &&
            widget.activity.status.toLowerCase() == 'pending') {
          Navigator.of(context).push(
            createRoute(
              pageWidget: BlocProvider<GroupCubit>(
                create: (context) => GroupCubit(),
                child: EventActionPanel(activity: widget.activity),
              ),
            ),
          );
        } else if (widget.activity.assigned != Assigned.teacher) {
          Navigator.of(context).push(
            createRoute(
              pageWidget: BlocProvider<GroupCubit>(
                create: (context) => GroupCubit(),
                child: EvaluateTask(
                    widget.activity, widget.activity.status == 'Evaluate'),
              ),
            ),
          );
        }
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
                color: widget.activity.status == 'Evaluated'
                    ? const Color(0xffEEFFF5)
                    : const Color(0xffffffff),
              ),
              padding: EdgeInsets.only(left: 14),
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
                                imageUrl: widget
                                        .activity.teacherProfile.profileImage ??
                                    'test',
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
                              width: MediaQuery.of(context).size.width - 91,
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
                                              0.3,
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
                                              "Event",
                                              style: const TextStyle(
                                                color: const Color(0xff887fdc),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            PopUpMenuWidget(
                                              showEdit:
                                                  widget.activity.going.isEmpty &&
                                                      widget
                                                          .activity
                                                          .goingByParent
                                                          .isEmpty &&
                                                      widget
                                                          .activity
                                                          .goingByTeacher
                                                          .isEmpty &&
                                                      widget.activity.notGoing
                                                          .isEmpty &&
                                                      widget
                                                          .activity
                                                          .notGoingByParent
                                                          .isEmpty &&
                                                      widget
                                                          .activity
                                                          .notGoingByTeacher
                                                          .isEmpty &&
                                                      widget.activity.editable,
                                              children: widget
                                                          .activity.assigned !=
                                                      Assigned.teacher
                                                  ? null
                                                  : (context) => [
                                                        if (widget
                                                                .activity.status
                                                                .toLowerCase() ==
                                                            'pending')
                                                          PopupMenuItem<String>(
                                                            height: 30,
                                                            value:
                                                                'Take action',
                                                            child: Container(
                                                              // width: 20,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    'Take Action',
                                                                    style: buildTextStyle(
                                                                        size:
                                                                            15),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  SvgPicture.asset(
                                                                      'assets/svg/take-icon.svg'),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                              onSelected: (value) async {
                                                handleOnSelected(
                                                    context, value);
                                              },
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                          ),
                                          color: const Color(0xffe4d7f5),
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
                                            TextSpan(
                                              style: const TextStyle(
                                                color: const Color(0xff828282),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11.0,
                                              ),
                                              text:
                                                  "${DateFormat('d MMM').format(widget.activity.publishedDate ?? widget.activity.createdAt)} ",
                                            ),
                                            TextSpan(
                                              style: const TextStyle(
                                                color: const Color(0xffff5a79),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.0,
                                              ),
                                              text: widget.showAssigned
                                                  ? checkAssignedTo(
                                                      widget.activity.assigned)
                                                  : '',
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
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Container(
                            height: 105,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                              padding: const EdgeInsets.only(
                                  left: 7.0, top: 19, bottom: 19),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(
                                                widget.activity.dueDate)),
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
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(
                                                widget.activity.startDate)),
                                        style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(
                                                widget.activity.endDate)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // width: 245,
                                        child: Text(
                                          widget.activity.title,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      LimitedBox(
                                        maxHeight: 20,
                                        maxWidth: 245,
                                        child: Text(
                                          widget.activity.locations,
                                          style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                          ),
                                          softWrap: true,
                                        ),
                                      ),
                                      Text(
                                        "${widget.activity.assigned == Assigned.student ? widget.activity.going.length : widget.activity.assigned == Assigned.faculty ? widget.activity.goingByTeacher.length : widget.activity.assigned == Assigned.teacher ? widget.activity.goingByTeacher.length : widget.activity.goingByParent.length} ${widget.activity.assigned == Assigned.student ? 'students' : widget.activity.assigned == Assigned.parent ? 'parents' : 'teachers'} are Going",
                                        style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
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
    );
  }

  void handleOnSelected(BuildContext context, String value) async {
    if (widget.activity.assigned == Assigned.teacher)
      Navigator.of(context).push(
        createRoute(
          pageWidget: BlocProvider<GroupCubit>(
            create: (context) => GroupCubit(),
            child: EventActionPanel(activity: widget.activity),
          ),
        ),
      );
    else {
      if (value == 'Evaluate') {
        Navigator.of(context).push(
          createRoute(
            pageWidget: BlocProvider<GroupCubit>(
              create: (context) => GroupCubit(),
              child: EvaluateTask(
                widget.activity,
                widget.activity.status != 'Evaluated',
              ),
            ),
          ),
        );
      } else if (value == 'Edit') {
        Navigator.of(context)
            .push(
          createRoute(
            pageWidget: EditEventPage(
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
              .deleteActivity(widget.activity.id);
          Fluttertoast.showToast(msg: 'Deleted! Please refresh the page.');
          setState(() {});
        }
      }
    }
  }
}
