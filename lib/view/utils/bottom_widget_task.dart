import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';

import '/bloc/activity/activity-cubit.dart';
import '/bloc/feed-action/feed-action-cubit.dart';
import '/const.dart';
import '/extensions/utils.dart';
import '/model/activity.dart';
import '/view/action/actioned_by.dart';
import '/view/threads/view_threads.dart';

class BottomWidgetTasks extends StatefulWidget {
  const BottomWidgetTasks({
    Key key,
    @required this.activity,
    this.addSaved = false,
    this.toYou,
  }) : super(key: key);
  final bool addSaved;
  final Activity activity;
  final bool toYou;

  @override
  _BottomWidgetTasksState createState() => _BottomWidgetTasksState();
}

class _BottomWidgetTasksState extends State<BottomWidgetTasks> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Row(
              children: [
                if (widget.activity.assigned != Assigned.teacher)
                  SvgPicture.asset(
                    "assets/svg/likes.svg",
                    height: 18,
                    width: 18,
                    color: Color(0xffFF5A79),
                  ),
                if (widget.activity.assigned == Assigned.teacher)
                  LikeButton(
                    size: 18,
                    circleColor: CircleColor(
                        start: Color(0xffFF5A79).withOpacity(0.1),
                        end: Color(0xffFF5A79)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xffFF5A79).withOpacity(0.1),
                      dotSecondaryColor: Color(0xffFF5A79),
                    ),
                    likeBuilder: (bool isLiked) {
                      return SvgPicture.asset(
                        "assets/svg/likes.svg",
                        height: 30,
                        width: 30,
                        color: isLiked ? Color(0xffFF5A79) : Colors.grey,
                      );
                    },
                    isLiked: widget.activity.liked,
                    onTap: (isLiked) async {
                      log('$isLiked function liked - ${widget.activity.liked} activity liked.');

                      /// send your request here
                      widget.activity.liked = !widget.activity.liked;
                      if (isLiked) {
                        widget.activity.like -= 1;
                        BlocProvider.of<ActivityCubit>(context)
                            .disLikeActivity(widget.activity.id);
                      } else {
                        widget.activity.like += 1;
                        BlocProvider.of<ActivityCubit>(context)
                            .likeActivity(widget.activity.id);
                      }
                      setState(() {});
                      // return;
                      // /// if failed, you can do nothing
                      return widget.activity.liked;
                    },
                    likeCount: widget.activity.like,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color = isLiked ? Color(0xffff5a79) : Colors.grey;
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          "Like",
                          style: TextStyle(color: color),
                        );
                      } else
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                      return result;
                    },
                  ),
                SizedBox(
                  width: 4,
                ),
                if (widget.activity.assigned != Assigned.teacher)
                  Text(
                    widget.activity.like.toString(),
                    style: TextStyle(
                      color: Color(0xffff5a79),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            // Row(
            //   children: [
            //     SvgPicture.asset(
            //       "assets/svg/views.svg",
            //       height: 16,
            //       width: 16,
            //     ),
            //     SizedBox(
            //       width: 2,
            //     ),
            //     Text(
            //       widget.activity.view.toString(),
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 11,
            //         fontWeight: FontWeight.w400,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(
              width: 5,
            ),
            if (widget.addSaved)
              // SvgPicture.asset("assets/svg/assigned.svg"),
              IconButton(
                icon: SvgPicture.asset(
                  'assets/svg/bookmark.svg',
                  height: 16,
                  width: 16,
                  color:
                      widget.activity.saved ? Color(0xffFF5A79) : Colors.black,
                ),
                onPressed: () {
                  widget.activity.saved = !widget.activity.saved;
                  BlocProvider.of<ActivityCubit>(context).saveActivity(
                      widget.activity.id,
                      remove: !widget.activity.saved);
                  setState(() {});
                },
              ),
            SizedBox(width: 5),
            IconButton(
              icon: Icon(
                Icons.message,
                color: Color(0xffFF715A),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: BlocProvider(
                      create: (context) => ThreadPostCubit(),
                      child: ViewThreadsPage(widget.activity),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        Row(
          children: [
            if(widget.activity.status.toLowerCase() != 'evaluated')
            Text(
              calculateTime(widget.activity.endDateTime),
              style: buildTextStyle(
                size: 12,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            if (widget.toYou)
              IconButton(
                icon: SvgPicture.asset("assets/svg/assigned.svg"),
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: ActionByWidget(widget.activity),
                    ),
                  );
                },
              ),
            SizedBox(
              width: 5,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/views.svg",
                  height: 16,
                  width: 16,
                ),
                SizedBox(
                  width: 2,
                ),
                Text(
                  widget.activity.view.toString() ?? 0,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 18,
            ),
          ],
        )
      ],
    );
  }

  String calculateTime(DateTime endTime) {
    var now = DateTime.now();
    var duration = endTime.difference(now);
    if (duration.inDays <= 0) {
      if (duration.inHours <= 0) {
        if (duration.inMinutes <= 0) {
          return 'Time Over';
        }
        return '${duration.inMinutes} mins left';
      }
      return '${duration.inHours} hours left';
    }
    return '${duration.inDays} days left';
  }
}
