import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/bloc/feed-action/feed-action-cubit.dart';
import '/const.dart';
import '/extensions/extension.dart';
import '/extensions/utils.dart';
import '/model/activity.dart';
import '/view/homepage/home_sliver_appbar.dart';
import '/view/threads/view_threads.dart';

class ThreadWidget extends StatelessWidget {
  const ThreadWidget({
    this.id,
    this.teacherId,
    this.comments,
    @required this.activity,
  });
  final String id;
  final String teacherId;
  final Activity activity;
  final List<ThreadComments> comments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton(
            child: Text(
              'View Thread',
              style: buildTextStyle(size: 14),
            ),
            onPressed: () {
              Navigator.of(context).push(
                createRoute(
                  pageWidget: BlocProvider(
                    create: (context) => ThreadPostCubit(),
                    child: ViewThreadsPage(activity),
                  ),
                ),
              );
            },
          ),
          ListView.separated(
            shrinkWrap: true,
            reverse: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: comments.length >= 2 ? 2 : comments.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: 20);
            },
            itemBuilder: (context, index) {
              var _comments = comments.reversed.toList();
              if (_comments[index].studentId != null)
                return ThreadBubbleStudent(
                  comments: _comments[index],
                );
              if (_comments[index].teacherId != null)
                return ThreadBubbleTeacher(comments: _comments[index]);
              else
                return ThreadBubbleTeacher(
                  comments: _comments[index],
                  other: true,
                );
            },
          ),
        ],
      ),
      margin: EdgeInsets.only(left: 10, right: 10, top: 3),
      decoration: BoxDecoration(
        color: Color(0xffFAFFFC),
        borderRadius: BorderRadius.circular(15),
      ),
      // height: 150,
    );
  }
}

class ThreadBubbleTeacher extends StatelessWidget {
  const ThreadBubbleTeacher({
    Key key,
    this.other = false,
    @required this.comments,
  }) : super(key: key);
  final bool other;
  final ThreadComments comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          other ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          '${other ? comments.otherTeacherId.name ?? '' : comments.teacherId.name ?? ''}',
          style: buildTextStyle(size: 12, color: Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment:
              other ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (other)
              TeacherProfileAvatar(
                radius: 20,
                imageUrl: comments.otherTeacherId.profileImage,
              ),
            SizedBox(
              width: 5,
            ),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffFFC30A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(other ? 10 : 0),
                  bottomLeft: Radius.circular(other ? 0 : 10),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: LimitedBox(
                maxWidth: 200,
                child: Text(
                  comments.text,
                  style: buildTextStyle(
                    color: Colors.black,
                    size: 12,
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            if (!other)
              TeacherProfileAvatar(
                radius: 20,
              )
          ],
        ),
        Text(
          "${comments.commentDate.toDateTimeFormat(context) ?? ""}",
          style: buildTextStyle(
            size: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ThreadBubbleStudent extends StatelessWidget {
  const ThreadBubbleStudent({
    Key key,
    @required this.comments,
  }) : super(key: key);

  final ThreadComments comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${comments.studentId.name ?? ''}',
          style: buildTextStyle(size: 12, color: Colors.grey),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TeacherProfileAvatar(
              radius: 20,
              imageUrl: comments.studentId.profileImage,
            ),
            SizedBox(width: 5),
            Container(
              decoration: BoxDecoration(
                color: Color(0xff6FCF97),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: LimitedBox(
                maxWidth: 200,
                child: Text(
                  comments.text,
                  style: buildTextStyle(
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            )
          ],
        ),
        Text(
          "${comments.commentDate.toDateTimeFormat(context) ?? ""}",
          style: buildTextStyle(
            size: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
