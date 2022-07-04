import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/activity/activity-cubit.dart';
import '/bloc/activity/activity-states.dart';
import '/const.dart';
import '/loader.dart';
import '/view/homepage/teachers_feed.dart';

class ForwardedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        title: Text(
          'Forwarded',
          style: buildTextStyle(
            weight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ActivityCubit, ActivityStates>(
            builder: (context, state) {
          if (state is ActivityLoaded) {
            var _activities =
                state.allActivities.where((act) => act.forwarded).toList();
            if (_activities.isEmpty)
              return Center(
                child: Text('No Activity'),
              );

            return Container(
              child: TeachersFeed(
                _activities,
                false,
                removeTopBar: true,
              ),
            );
          } else {
            return Center(
              child: loadingBar,
            );
          }
        }),
      ),
    );
  }
}
