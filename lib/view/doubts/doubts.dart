import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/activity/activity-cubit.dart';
import '/bloc/activity/activity-states.dart';
import '/const.dart';
import '/loader.dart';
import '/model/activity.dart';
import '/view/announcements/announcement.dart';
import '/view/assignments/assignment.dart';
import '/view/check_list/checklist.dart';
import '/view/event/event.dart';
import '/view/livepoll/livepoll-pending.dart';

class DoubtsPage extends StatefulWidget {
  @override
  _DoubtsPageState createState() => _DoubtsPageState();
}

class _DoubtsPageState extends State<DoubtsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ActivityLoaded stateActivity;
  int page = 1;
  bool loading = false;
  bool activityLoad = false;
  ScrollController scrollController = ScrollController();
  Map<String, dynamic> body = {"activity_status": ''};
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !loading) {
        loading = true;
        page++;
        BlocProvider.of<ActivityCubit>(context)
            .loadMoreActivities(stateActivity, body, page)
            .then((value) {
          loading = false;
        });
      }
    });
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Doubts',
          style: buildTextStyle(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        automaticallyImplyLeading: false,
        bottom: TabBar(
          onTap: (value) async {
            setState(() {
              activityLoad = true;
            });
            if (value == 0) {
              body['activity_status'] = ['cleared', 'uncleared'];
            } else if (value == 1) {
              body['activity_status'] = 'cleared';
            } else
              body['activity_status'] = 'uncleared';
            await BlocProvider.of<ActivityCubit>(context)
                .loadActivities('doubts page', body);
            setState(() {
              activityLoad = false;
            });
          },

          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: [
              BoxShadow(
                color: const Color(0x40000000),
                offset: Offset(0, 0),
                blurRadius: 5,
                spreadRadius: 0,
              )
            ],
            color: const Color(0xffffffff),
          ),
          labelStyle: const TextStyle(
            color: const Color(0xff000000),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
          ),
          unselectedLabelStyle: const TextStyle(
            color: const Color(0xff8ca0c9),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontSize: 14.0,
          ),
          labelColor: const Color(0xff000000),
          unselectedLabelColor: const Color(0xff8ca0c9),
          tabs: [
            Tab(
              child: Text('All'),
            ),
            Tab(
              text: 'Cleared',
            ),
            Tab(
              text: 'Uncleared',
            ),
          ],
        ),
      ),
      body:
          BlocBuilder<ActivityCubit, ActivityStates>(builder: (context, state) {
        if (state is ActivityLoaded) {
          stateActivity = state;
          var _unclearedActivities = state.allActivities.where((activity) {
            if (activity.comment.length > 0)
              return true;
            else
              return false;
          }).toList();
          return TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: activityLoad
                      ? Center(
                          child: loadingBar,
                        )
                      : buildListActivityMethod(_unclearedActivities),
                ),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: activityLoad
                      ? Center(
                          child: loadingBar,
                        )
                      : buildListActivityMethod(_unclearedActivities),
                ),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: activityLoad
                      ? Center(
                          child: loadingBar,
                        )
                      : buildListActivityMethod(_unclearedActivities),
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: loadingBar,
          );
        }
      }),
    );
  }

  ListView buildListActivityMethod(List<Activity> _activities) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(0),
      physics: BouncingScrollPhysics(),
      itemCount: _activities.length,
      itemBuilder: (BuildContext context, int index) {
        var activity = _activities[index];
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
            // if (_activities[index].status == 'pending')
            return LivePollPending(activity, false, false);
          // return LivePollSubmitted(activity, false);
          case 'Event':
            return Event(activity, false, false);
          case 'Check List':
            return CheckList(activity, false, false);
          default:
            return Container(
              child: Text(activity.activityType),
            );
        }
      },
    );
  }
}
