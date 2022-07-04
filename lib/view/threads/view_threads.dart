import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/bloc/feed-action/feed-action-cubit.dart';
import '/const.dart';
import '/model/activity.dart';
import '/view/threads/thread_utils.dart';
import '../../extensions/extension.dart';

class ViewThreadsPage extends StatefulWidget {
  final Activity activity;
  ViewThreadsPage(this.activity);

  @override
  _ViewThreadsPageState createState() => _ViewThreadsPageState();
}

class _ViewThreadsPageState extends State<ViewThreadsPage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar:
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'View Threads',
          style: buildTextStyle(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: double.infinity,
              padding: EdgeInsets.all(10),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemCount: widget.activity.comment.length,
                // reverse: true,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  if (widget.activity.comment[index].teacherId != null)
                    return ThreadBubbleTeacher(
                      comments: widget.activity.comment[index],
                    );
                  if (widget.activity.comment[index].otherTeacherId != null)
                    return ThreadBubbleTeacher(
                      other: true,
                      comments: widget.activity.comment[index],
                    );

                  return ThreadBubbleStudent(
                    comments: widget.activity.comment[index],
                  );
                },
              ),
            ).expand,
            Container(
              color: Colors.white,
              height: 100,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Message',
                    ),
                  ).expand,
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _controller.text.trim().isNotEmpty
                        ? () {
                            ThreadComments comment = ThreadComments(
                              text: _controller.text,
                              teacherId: ThreadProfile(
                              ),
                            );
                            widget.activity.comment.add(comment);
                            _controller.clear();
                            setState(() {});
                            BlocProvider.of<ThreadPostCubit>(context,
                                    listen: false)
                                .postThread(comment, widget.activity.id);
                          }
                        : () {
                            log("Message not working");
                          },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
