import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/activity/activity-cubit.dart';
import '/bloc/activity/activity-states.dart';
import '/bloc/teacher-school/teacher-school-cubit.dart';
import '/bloc/teacher-school/teacher-school-states.dart';
import '/const.dart';
import '/model/activity.dart';
import '/view/homepage/teachers_feed.dart';

class SavedActivitiesPage extends StatefulWidget {
  @override
  _SavedActivitiesPageState createState() => _SavedActivitiesPageState();
}

class _SavedActivitiesPageState extends State<SavedActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Saved',
          style: buildTextStyle(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            // BlocProvider.of<AssignedActivitiesCubit>(context, listen: false)
            //     .getAssignedActivities();
            // BlocProvider.of<ActivityCubit>(context, listen: false)
            //     .loadActivities();
            setState(() {});
            return Future.delayed(Duration(seconds: 1));
          },
          child: BlocBuilder<ActivityCubit, ActivityStates>(
            // stream: null,
            builder: (context, stateAllActivities) {
              return BlocBuilder<AssignedActivitiesCubit, AssignToYouStates>(
                builder: (context, state) {
                  if (state is AssignedActivitiesLoaded &&
                      stateAllActivities is ActivityLoaded) {
                    // BlocProvider.of<AssignedActivitiesCubit>(context,
                    //         listen: false)
                    //     .getAssignedActivities();
                    // BlocProvider.of<ActivityCubit>(context, listen: false)
                    //     .loadActivities();
                    var _activities = <Activity>[];
                    _activities.addAll(state.activities);
                    _activities.addAll(
                      stateAllActivities.allActivities.where((activity) =>
                          activity.status.toLowerCase() == 'evaluate'),
                    );

                    // activityController.add(_activities);
                    if (_activities.isNotEmpty) {
                      return TeachersFeed(
                        _activities.where((activity) {
                          return activity.saved;
                        }).toList(),
                        true,
                        saved: true,
                        removeTopBar: true,
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No Saved Activities',
                          style: buildTextStyle(),
                        ),
                      );
                    }
                  } else {
                    BlocProvider.of<AssignedActivitiesCubit>(context,
                            listen: false)
                        .getAssignedActivities('');
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
