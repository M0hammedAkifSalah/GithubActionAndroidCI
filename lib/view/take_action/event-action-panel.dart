import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/bloc/take-action/take-action-cubit.dart';
import '/model/activity.dart';
import '/view/utils/utils.dart';

class EventActionPanel extends StatelessWidget {
  final Activity activity;

  final String route;

  EventActionPanel({this.route, this.activity});

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<FeedActionCubit, FeedActionStates>(
    //     builder: (context, state) {
    //   if (state is LoadEventFeed)
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 22, left: 22, right: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // if (route == "/saved")
                        //   savedFeedActionPanelController.close();
                        // else
                        //   feedActionPanelController.close();
                      },
                      child: Icon(Icons.close)),
                  Column(
                    children: [
                      Text(
                        "Event",
                        style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        "Take Action",
                        style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                        ),
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
                      Text(activity.coin.toString())
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 22.0, right: 22),
            //   child: CachedNetworkImage(
            //     height: 150,
            //     width: MediaQuery.of(context).size.width,
            //     fit: BoxFit.cover,
            //     imageUrl: activity.image == null
            //         ? "test.png"
            //         : "${GlobalConfiguration().get("imageBaseURL")}/" +
            //             activity.image,
            //     progressIndicatorBuilder: (context, url, downloadProgress) =>
            //         Container(
            //       color: Colors.grey[200],
            //       height: 150,
            //     ),
            //     errorWidget: (context, url, error) => Container(
            //       color: Colors.grey[200],
            //       height: 150,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, right: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Location",
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Montserrat",
                        fontSize: 14.0),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      Text(
                        activity.locations,
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontSize: 14.0),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 23,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(left: 22.0, right: 22),
                children: [
                  Text(
                    activity.description,
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            FileListing(activity.files),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 22),
                      child: Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  handleEventGoing(context);
                                },
                                child: Container(
                                    width: 300,
                                    alignment: Alignment.center,
                                    height: 33,
                                    decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff219653),
                                            Color(0xff2d9cdb)
                                          ],
                                          stops: [0, 1],
                                          begin: Alignment(-1.00, 0.00),
                                          end: Alignment(1.00, -0.00),
                                          // angle: 0,
                                          // scale: undefined,
                                        )),
                                    // child: activity.eventAction == "going"
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Going",
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
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      ],
                                    )
                                    // : Text(
                                    //     "Going",
                                    //     style: const TextStyle(
                                    //         color: const Color(0xffffffff),
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: 14.0),
                                    //   ),
                                    )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: RaisedButton(
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {
                                handleEventNotGoing(context);
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 300,
                                  height: 33,
                                  decoration:  BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xffed3269),
                                          Color(0xfff05f3e)
                                        ],
                                        stops: [0, 1],
                                        begin: Alignment(-1.00, 0.00),
                                        end: Alignment(1.00, -0.00),
                                        // angle: 0,
                                        // scale: undefined,
                                      )),
                                  // child: activity.eventAction == "not-going"
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Not Going",
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
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    ],
                                  )
                                  // : Text(
                                  //     "Not Going",
                                  //     style: const TextStyle(
                                  //         color: const Color(0xffffffff),
                                  //         fontWeight: FontWeight.w600,
                                  //         fontSize: 14.0),
                                  //   ))),
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
    //   else
    //     return Container();
    // });
  }

  void handleEventGoing(context) {
    // if (BlocProvider.of<AppModeCubic>(context).state is StudentMode) {
    if (!activity.userReacted) {
      BlocProvider.of<TakeActionCubit>(context).updateEventGoing(activity.id);
      // BlocProvider.of<ActivityCubit>(context)
      //     .loadActivities('handle event going');
      Fluttertoast.showToast(msg: 'Action is recorded');
      activity.userReacted = true;
      // }

      //   feedActionPanelController.close();
    } else {
      Fluttertoast.showToast(msg: "You cannot perform this action");
    }
  }

  void handleEventNotGoing(context) {
    // if (BlocProvider.of<AppModeCubic>(context).state is StudentMode) {
    if (!activity.userReacted) {
      BlocProvider.of<TakeActionCubit>(context)
          .updateEventNotGoing(activity.id);
      // BlocProvider.of<ActivityCubit>(context)
      //     .loadActivities('handle event not going');
      Fluttertoast.showToast(msg: 'Action is recorded');
      activity.userReacted = true;

      //   feedActionPanelController.close();
    } else {
      Fluttertoast.showToast(msg: "You cannot perform this action");
    }
  }
}
