import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/bloc/take-action/take-action-cubit.dart';
import '/model/activity.dart';
import '/view/utils/utils.dart';

class AnnouncementActionPanel extends StatefulWidget {
  final Activity activity;

  final String route;

  AnnouncementActionPanel({this.route, this.activity});

  @override
  _AnnouncementActionPanelState createState() =>
      _AnnouncementActionPanelState();
}

class _AnnouncementActionPanelState extends State<AnnouncementActionPanel> {
  final ScrollController scrollController =  ScrollController();
  bool accepted = false;

  bool error = false;

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<FeedActionCubit, FeedActionStates>(
    //     builder: (context, state) {
    //   if (state is LoadAnnouncementFeed)
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // if (widget.route == "/saved")
                        //   savedFeedActionPanelController.close();
                        // else
                        //   feedActionPanelController.close();
                      },
                      child: Icon(Icons.close)),
                  Column(
                    children: [
                      Text(
                        "Announcement",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                      Text(
                        "Take Action",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/points.png",
                        height: 20,
                        width: 20,
                      ),
                      Text(widget.activity.coin.toString())
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                widget.activity.title,
                style: const TextStyle(
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
              Expanded(
                child: Scrollbar(
                  controller: scrollController,
                  trackVisibility: true,
                  thickness: 2,
                  child: ListView(controller: scrollController, children: [
                    Text(
                      widget.activity.description,
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0),
                      textAlign: TextAlign.justify,
                    )
                  ]),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FileListing(widget.activity.files),
              CheckboxListTile(
                  value: widget.activity.userReacted != null &&
                          widget.activity.userReacted
                      ? true
                      : accepted,
                  // value: true,
                  contentPadding: EdgeInsets.zero,
                  activeColor: Colors.grey[200],
                  checkColor: Color(0xff6fcf97),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: widget.activity.userReacted != null &&
                          widget.activity.userReacted
                      ? null
                      : (value) {
                          setState(() {
                            if (value) {
                              error = false;
                            }
                            accepted = value;
                          });
                        },
                  title: Text(
                    "I have read and understood the above announcement.",
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  )),
              Visibility(
                visible: error,
                child: Text(
                  "Please read and accept the contents",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: RaisedButton(
                      color: const Color(0xff6fcf97),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        handleAcknowledgment();
                      },
                      child: widget.activity.userReacted != null &&
                              widget.activity.userReacted
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Acknowledged",
                                  style: const TextStyle(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.0),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              ],
                            )
                          : Text(
                              "Acknowledge",
                              style: const TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                            )),
                ),
              )
            ],
          ),
        ),
      ),
    );
    //   else
    //     return Container();
    // });
  }

  Future<void> handleAcknowledgment() async {
    //   if (BlocProvider.of<AppModeCubic>(context).state is StudentMode) {
    if (!(widget.activity.userReacted != null && widget.activity.userReacted)) {
      if (!accepted) {
        setState(() {
          error = true;
        });
      } else {
        await BlocProvider.of<TakeActionCubit>(context)
            .updateAnnouncement(widget.activity.id);
        Navigator.of(context).pop();
      }
    } else {
      Fluttertoast.showToast(msg: "You have already acknowledged");
    }
  }
  //     Fluttertoast.showToast(msg: "You cannot perform this action");
  //   }
}
