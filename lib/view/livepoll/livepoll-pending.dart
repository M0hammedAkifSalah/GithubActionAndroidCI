import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '/export.dart';
import '/view/livepoll/editLivepoll.dart';
import '/view/take_action/live-poll-action-panel.dart';

class LivePollPending extends StatefulWidget {
  final Activity activity;
  final bool saved;
  final bool showAssigned;

  LivePollPending(this.activity, this.saved, this.showAssigned);

  @override
  _LivePollPendingState createState() => _LivePollPendingState();
}

class _LivePollPendingState extends State<LivePollPending> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // String choice;
    return InkWell(
      onTap: () {
        if (widget.activity.assigned == Assigned.teacher &&
            widget.activity.status.toLowerCase() != 'pending')
          Navigator.of(context).push(
            createRoute(
              pageWidget: BlocProvider<GroupCubit>(
                create: (context) => GroupCubit(),
                child: LivePollActionPanel(activity: widget.activity),
              ),
            ),
          );
        else if (widget.activity.assigned != Assigned.teacher)
          Navigator.of(context).push(
            createRoute(
              pageWidget: BlocProvider<GroupCubit>(
                create: (context) => GroupCubit(),
                child: EvaluateTask(
                    widget.activity, widget.activity.status == 'Evaluate'),
              ),
            ),
          );
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      // BlocProvider.of<FeedActionCubit>(context)
                      //     .updateFeedPanelContent("LivePoll", activity);
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
                                imageUrl: widget
                                        .activity.teacherProfile.profileImage ??
                                    'text',
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 90,
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
                                              widget.activity.status[0]
                                                      .toUpperCase() +
                                                  widget.activity.status
                                                      .substring(1),
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
                                              "Live Poll",
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff1c4587),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 12.0),
                                            ),
                                            PopUpMenuWidget(
                                              showEdit: widget
                                                      .activity
                                                      .selectedLivePoll
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
                                                            value: 'Evaluate',
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
                                              topRight: Radius.circular(10)),
                                          color: const Color(0xffc9daf8),
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
                                                  color:
                                                      const Color(0xff828282),
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 11.0),
                                              text:
                                                  "${DateFormat('d MMM').format(widget.activity.publishedDate)} ",
                                            ),
                                            TextSpan(
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xffff5a79),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.0),
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
                        Text(
                          widget.activity.title,
                          style: TextStyle(
                            color: Color(0xff000000),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(right: 14.0),
                          shrinkWrap: true,
                          itemCount: widget.activity.options.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  (widget.activity.options[index].getPercent(
                                                  widget.activity
                                                      .selectedLivePoll) *
                                              100)
                                          .toStringAsFixed(2) +
                                      '%',
                                  style: const TextStyle(
                                    color: const Color(0xff8ca0c9),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10.0,
                                  ),
                                ),
                                LinearPercentIndicator(
                                  //  width: MediaQuery.of(context).size.width - 50,
                                  animation: true,
                                  lineHeight: 20.0,
                                  animationDuration: 2500,
                                  percent: widget.activity.options[index]
                                      .getPercent(
                                          widget.activity.selectedLivePoll),
                                  alignment: MainAxisAlignment.start,
                                  center: Text(
                                    widget.activity.options[index].text,
                                    style: const TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 11.0,
                                    ),
                                  ),

                                  // linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Color(0xff8ca0c9),
                                  backgroundColor: Color(0xfff0f4fc),
                                  barRadius: Radius.circular(20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
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
            child: LivePollActionPanel(activity: widget.activity),
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
            .push(createRoute(
          pageWidget: EditLivePollPage(
            activity: widget.activity,
          ),
        ))
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
