import 'package:flutter/material.dart';

import '/view/take_action/announcement-action-panel.dart';

class FeedActionPanel extends StatelessWidget {
  final String route;
  final ScrollController scrollController;
  FeedActionPanel(this.route, this.scrollController);
  @override
  Widget build(BuildContext context) {
    return Container(
      // child: BlocBuilder<FeedActionCubit, FeedActionStates>(
      // builder: (context, state) {
      // if (state is LoadAnnouncementFeed)
      child: AnnouncementActionPanel(),
      // else if (state is LoadAssignmentFeed)
      //   return AssignmentActionPanel(
      //       route, state.activity, scrollController);
      // else if (state is LoadEventFeed)
      //   return EventActionPanel(route, state.activity);
      // else if (state is LoadLivePollFeed)
      //   return LivePollActionPanel(route, state.activity);
      // else if (state is LoadCheckListFeed)
      //   return CheckListPanel(route, state.activity);
      // else
      //   return Container(child: loadingBar);
      // },
      // ),
    );
  }
}
