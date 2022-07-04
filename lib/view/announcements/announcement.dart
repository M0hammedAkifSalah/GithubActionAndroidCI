import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/view/announcements/editannouncement.dart';
import '../../export.dart';
import '../../view/take_action/announcement-action-panel.dart';

class Announcement extends StatefulWidget {
  final Activity activity;
  final bool saved;
  final bool showAssigned;

  Announcement(this.saved, this.showAssigned, {this.activity});

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  double height;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    height = widget.activity.description.length > 240 ? 90 : null;
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // if (activity.status.toLowerCase() == 'evaluate' ||
        //     activity.status.toLowerCase() == 'evaluated')
        if (widget.activity.assigned == Assigned.teacher &&
            widget.activity.status.toLowerCase() != 'submitted')
          Navigator.of(context).push(
            createRoute(
              pageWidget: BlocProvider<GroupCubit>(
                create: (context) => GroupCubit(),
                child: AnnouncementActionPanel(activity: widget.activity),
              ),
            ),
          );
        else if (widget.activity.assigned != Assigned.teacher)
          Navigator.of(context).push(
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
      },
      child: Column(
        // fit: StackFit.loose,
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
                color: widget.activity.status == 'Evaluated'
                    ? const Color(0xffEEFFF5)
                    : const Color(0xffffffff)),
            padding: EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    //   BlocProvider.of<FeedActionCubit>(context)
                    //       .updateFeedPanelContent("Announcement", activity);
                    //   feedActionPanelController.open();
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
                                  widget.activity.teacherProfile.profileImage ??
                                      'text',
                            ),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 121,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        alignment: Alignment.center,
                                        child: LimitedBox(
                                          child: Text(
                                            widget.activity.status
                                                .toTitleCase(),
                                            softWrap: true,
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
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Announcement",
                                            style: const TextStyle(
                                              color: const Color(0xff83334c),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          PopUpMenuWidget(
                                            showEdit:
                                                widget.activity.acknowledgeBy
                                                        .isEmpty &&
                                                    widget
                                                        .activity
                                                        .acknowledgeByParent
                                                        .isEmpty &&
                                                    widget
                                                        .activity
                                                        .acknowledgeByTeacher
                                                        .isEmpty &&
                                                    widget.activity.editable,
                                            children: widget
                                                        .activity.assigned !=
                                                    Assigned.teacher
                                                ? null
                                                : (context) => [
                                                      if (widget.activity.status
                                                              .toLowerCase() ==
                                                          'pending')
                                                        PopupMenuItem<String>(
                                                          height: 30,
                                                          value: 'Evaluate',
                                                          child: Container(
                                                             //width: 220,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Text(
                                                                  'Take Action',
                                                                  style:
                                                                      buildTextStyle(
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
                                              handleOnSelected(context, value);
                                            },
                                          )
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10)),
                                        color: const Color(0xfffcdee8),
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
                                            "${DateFormat('d MMM').format(widget.activity.publishedDate ?? widget.activity.createdAt)}  ",
                                      ),
                                      TextSpan(
                                        style: const TextStyle(
                                            color: const Color(0xffff5a79),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.0),
                                        text: widget.showAssigned
                                            ? checkAssignedTo(
                                                widget.activity.assigned)
                                            : '',
                                      )
                                    ],
                                  ),
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
                        height: widget.activity.description.length > 240
                            ? height
                            : null,
                        // color: Colors.black,
                        padding: EdgeInsets.only(right: 15),
                        child: height != null
                            ? Text(
                                '${widget.activity.description} ',
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0,
                                ),
                              )
                            : widget.activity.description.convertToHyperLink,
                      ),
                      if (widget.activity.description.length > 240)
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            child: Text(
                                height != null ? 'View more' : 'View less'),
                            onPressed: () {
                              setState(() {
                                if (height != null) {
                                  height = null;
                                } else {
                                  height = 90;
                                }
                              });
                            },
                          ),
                        ),
                      // showActivityLinks(context, widget.activity),
                      SizedBox(
                        height: 11,
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
    );
  }

  void handleOnSelected(BuildContext context, String value) async {
    if (widget.activity.assigned == Assigned.teacher)
      Navigator.of(context).push(
        createRoute(
          pageWidget: BlocProvider<GroupCubit>(
            create: (context) => GroupCubit(),
            child: AnnouncementActionPanel(activity: widget.activity),
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
            pageWidget: EditAnnouncementPage(
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
          // Navigator.of(context)
          //     .pushReplacement(createRoute(pageWidget: TeacherHomePage()));
          Fluttertoast.showToast(msg: 'Deleted! Please refresh the page.');
          setState(() {});
        }
      }
    }
  }
}
