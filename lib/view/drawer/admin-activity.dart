import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/activity/activity-states.dart';
import '/export.dart';
import '/view/announcements/announcement.dart';
import '/view/event/event.dart';
import '/view/livepoll/livepoll-pending.dart';

class AdminActivityPage extends StatefulWidget {
  final bool school;
  final String teacherId;
  AdminActivityPage({
    @required this.school,
    this.teacherId,
  });

  @override
  _AdminActivityPageState createState() => _AdminActivityPageState();
}

class _AdminActivityPageState extends State<AdminActivityPage> {
  int currentIndex = 0;
  int page = 1;
  bool activityLoading = false;
  AdminActivityLoaded stateAdmin;
  ScrollController activityController = ScrollController();

  @override
  void initState() {


    super.initState();
  }

  Map<String, Color> filterValueToYou = {
    "Pending": Color(0xffEB5757),
    "Evaluated": Color(0xff2F80ED),
    "Submitted": Color(0xff27AE60),
    "Delayed Submission": Color(0xffEB5757),
    "Reassigned": Color(0xffEB5757),
    "Going Events": Color(0xff9B51E0),
    "Not Going Events": Color(0xff9B51E0),
    "Forwarded": Color(0xffEB5757),
  };
  @override
  Widget build(BuildContext context) {
    activityController.addListener(() {
      if (activityController.position.pixels ==
          activityController.position.maxScrollExtent &&
          !activityLoading) {
        setState(() {
          activityLoading = true;
        });
        var status = filterValueToYou.keys.toList()[currentIndex].split(' ');
        if (status.length >= 2) status.removeLast();
        var _status = status.join(' ');
        page++;
        log('Loading more activities $page: admin-activity');
        BlocProvider.of<ActivityCubit>(context)
            .loadMoreActivities(
          ActivityLoaded(
            allActivities: stateAdmin.allActivities,
            hasMoreData: stateAdmin.hasMoreData,
          ),
          {}..addAll(widget.school
              ? {"status": _status}
              : {
            "teacher_id": "${widget.teacherId}",
            "assignTo_you.status": "Pending",
          }),
          page,
        )
            .then((value) {
          activityLoading = false;
          setState(() {

          });
        });
      }
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
            color: Colors.black,
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Mode',
              style: buildTextStyle(
                weight: FontWeight.w600,
              ),
            ),
            Text(widget.school ? 'School View' : 'Teacher View'),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              padding: EdgeInsets.all(8),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < filterValueToYou.length; i++)
                      homePageFilterCard(
                        color: filterValueToYou.values.toList()[i],
                        title: filterValueToYou.keys.toList()[i],
                        value: i,
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ActivityCubit, ActivityStates>(
                  builder: (context, state) {
                if (state is AdminActivityLoaded) {
                  stateAdmin = state;

                  return ListView.separated(
                      controller: activityController,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      // controller: _scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      itemCount: state.allActivities.length,
                      itemBuilder: (BuildContext context, int index) {
                        var activity = state.allActivities[index];
                        return getRespectiveActivity(activity);
                        // if (index == 0) return Assignment();
                        // if (index == 1) return Event();
                        // if (index == 2) return LivePollSubmitted();
                        // if (index == 3) return LivePollPending();
                        // if (index == 4) return Announcement();
                        // return Container(
                        //   child: Text('index $index'),
                        // );
                      });
                }
                if(state is ActivityLoading) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                return Center(child: Text('No Activities'),);
              }),
            ),
            if (activityLoading) Center(child: CupertinoActivityIndicator()),
          ],
        ),
      ),
    );
  }

  Widget getRespectiveActivity(Activity activity) {
    switch (activity.activityType) {
      case 'Assignment':
        return Assignment(activity, false, false);
      case 'Announcement':
        return Announcement(
          false,
          false,
          activity: activity,
        );
      case 'LivePoll':
        return LivePollPending(activity, false, false);

      case 'Event':
        return Event(activity, false, false);
      case 'Check List':
        return CheckList(activity, false, false);
      default:
        return Container(
          child: Text(activity.activityType),
        );
    }
  }

  Future<void> getAssignedActivities(BuildContext context) {
    var status = filterValueToYou.keys.toList()[currentIndex].split(' ');
    if (status.length >= 2) status.removeLast();
    var _status = status.join(' ');
    return BlocProvider.of<ActivityCubit>(context, listen: false)
        .loadAdminActivities(
      'function',
      {}..addAll(widget.school
          ? {
              "\$or": [
                {"assignTo.status": "Pending"},
                {"assignTo_you.status": "Pending"},
                {"assignTo_parent.status": "Pending"}
              ]
            }
          : {
              "teacher_id": "${widget.teacherId}",
              "assignTo_you.status": _status
            }),
    );
  }

  Widget homePageFilterCard({
    String title,
    Color color,
    int value,
  }) {
    return InkWell(
      onTap: () {
        log(filterValueToYou.toString());
        page = 1;
        setState(() {
          currentIndex = value;
        });
        log('Filter: ${filterValueToYou.keys.toList()[currentIndex] == "Assigned" ? "pending" : filterValueToYou.keys.toList()[currentIndex].split(' ')[0]}');
        getAssignedActivities(context);
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          title ?? 'Pending',
          style: buildTextStyle(
            size: 14,
            color: value == currentIndex
                ? Colors.white
                : color ?? Color(0xffEB5757),
          ),
        ),
        decoration: BoxDecoration(
          color: value == currentIndex ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color ?? Color(0xffEB5757)),
        ),
      ),
    );
  }
}
