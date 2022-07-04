import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/activity/activity-cubit.dart';
import '/bloc/activity/activity-states.dart';
import '/const.dart';
import '/loader.dart';
import '/view/homepage/teachers_feed.dart';

class EvaluatePage extends StatefulWidget {
  @override
  _EvaluatePageState createState() => _EvaluatePageState();
}

class _EvaluatePageState extends State<EvaluatePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ActivityCubit>(context)
        .loadActivities('', {"status": "Evaluate"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          'Evaluate',
          style: buildTextStyle(),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: BlocBuilder<ActivityCubit, ActivityStates>(
            builder: (context, state) {
          if (state is ActivityLoaded) {
            return Container(
              // padding: EdgeInsets.all(10),
              child: TeachersFeed(
                state.allActivities.toList(),
                true,
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
