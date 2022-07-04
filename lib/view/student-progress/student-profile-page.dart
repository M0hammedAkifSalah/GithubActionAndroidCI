
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growonplus_teacher/app-config.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

// import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart' as url;

import '../../model/session-report.dart';
import '/bloc/feed-action/feed-action-states.dart';
import '/export.dart';
import '/model/class-schedule.dart';
import '/model/feedback.dart';
import '/model/task-progress.dart';
import '/view/profile/upload-profile.dart';

class StudentProfilePage extends StatefulWidget {
  final StudentInfo student;
  final String className;
  final SessionReportStudent sessionReport;


  StudentProfilePage({this.student, this.className, this.sessionReport});

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage>
    with SingleTickerProviderStateMixin {
  PanelController _panelController = PanelController();
  TabController _tab;
  int light = 0;
  int star = 0;
  int coin = 0;
  int thunder = 0;



  @override
  void initState() {

    _tab = TabController(vsync: this, length: 2);
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'call',
            child: Icon(Icons.call),
            onPressed: () {
              url.launch('tel:${widget.student.username}');
            },
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: 'text',
            child: Icon(Icons.message),
            onPressed: () {
              url.launch('sms:${widget.student.username}');
            },
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
      appBar: AppBar(
        centerTitle: false,
        title: appMarker(),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SafeArea(
        child: SlidingUpPanel(
          controller: _panelController,
          defaultPanelState: PanelState.CLOSED,
          minHeight: 0,
          maxHeight: 350,
          backdropEnabled: true,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          panel: _panel(),
          body: SafeArea(
              child:

              // if (userState is AccountsLoaded)
              Container(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    // await _pickImage();
                                    // if (_file != null)
                                    //   Navigator.of(context).push(
                                    //     createRoute(
                                    //       pageWidget:
                                    //           UpdateProfileImage(this._file),
                                    //     ),
                                    //   );
                                  },
                                  child: InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //   createRoute(
                                      //     pageWidget: UpdateProfileImage(
                                      //       null,
                                      //       profileURL: widget.student
                                      //           .profileImage,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: '${widget.student
                                            .profileImage}',
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                            Container(
                                              color: Colors.grey[200],
                                              height: 49,
                                              width: 49,
                                            ),
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              color: Colors.grey[200],
                                              height: 49,
                                              width: 49,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 13,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${widget.student.name}',
                                      style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    Text(
                                      "Student",
                                      style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/points.png",
                                      height: 24,
                                      width: 24,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    BlocBuilder<RewardStudentCubit,
                                        RewardStudentStates>(
                                        builder: (context, state) {
                                          // BlocProvider.of<RewardStudentCubit>(context)
                                          //     .loadRewardStudent(widget.student.id);
                                          if (state is RewardStudentLoaded)
                                            return Text(
                                              "${getTotalReward(
                                                  state.rewardStudent)}",
                                              style: const TextStyle(
                                                color: const Color(0xff404ef3),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                              ),
                                            );
                                          else {
                                            // BlocProvider.of<RewardStudentCubit>(context)
                                            //     .loadRewardStudent(widget.student.id);
                                            return Text(
                                              '0',
                                              style: const TextStyle(
                                                color: const Color(0xff404ef3),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                              ),
                                            );
                                          }
                                        }),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "",
                                      style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      "${widget.className}",
                                      style: const TextStyle(
                                        color: const Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      TabBar(
                        controller: _tab,
                        indicatorColor: Color(0xff6FCF97),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle:
                        buildTextStyle(color: Color(0xff6fcf97), size: 14),
                        unselectedLabelStyle: buildTextStyle(size: 14),
                        labelColor: Color(0xff6fcf97),
                        unselectedLabelColor: Colors.black87,
                        tabs: [
                          Tab(
                            text: 'Feedback',
                          ),
                          Tab(
                            text: 'Progress',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.7,
                        child: TabBarView(
                          controller: _tab,
                          // physics: NeverScrollableScrollPhysics(),
                          children: [
                            SingleChildScrollView(
                              child: FeedBackWidget(
                                studentId: widget.student,
                              ),
                            ),
                            SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  studentProgress(),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  // instituteSessionProgress(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  assignmentProgress(),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  joinedClassProgress(),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  // testClassProgress(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff2CB9B0),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child:
                                    BlocBuilder<FeedBackCubit, FeedBackStates>(
                                        builder: (context, state) {
                                          if (state is FeedBacksLoaded)
                                            return Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Earned Badges',
                                                      style: buildTextStyle(
                                                        color: Colors.white,
                                                        size: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/badge1.png',
                                                          height: 60,
                                                          width: 60,
                                                        ),
                                                        Text(
                                                          'Light Blaster',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        Text(
                                                          '${calculateBadges(
                                                              state.feedback,
                                                              widget.student.id)
                                                              .light}',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/badge2.png',
                                                          height: 60,
                                                          width: 60,
                                                        ),
                                                        Text(
                                                          'Star Contributor',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        Text(
                                                          '${calculateBadges(
                                                              state.feedback,
                                                              widget.student.id)
                                                              .star}',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/badge3.png',
                                                          height: 60,
                                                          width: 60,
                                                        ),
                                                        Text(
                                                          'ThunderBolt',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        Text(
                                                          '${calculateBadges(
                                                              state.feedback,
                                                              widget.student.id)
                                                              .thunder}',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/badge4.png',
                                                          height: 60,
                                                          width: 60,
                                                        ),
                                                        Text(
                                                          'Coin Champion',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                        Text(
                                                          '${calculateBadges(
                                                              state.feedback,
                                                              widget.student.id)
                                                              .coin}',
                                                          style: buildTextStyle(
                                                              color: Colors
                                                                  .white),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          else {
                                            // BlocProvider.of<FeedBackCubit>(context,
                                            //         listen: false)
                                            //     .getFeedback();
                                            return Container();
                                          }
                                        }),
                                    height: 320,
                                    width: double.infinity,
                                  ),
                                  SizedBox(
                                    height: 100,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  _Badges calculateBadges(List<FeedBackStudent> feedbacks, String studentId) {
    var _feed = feedbacks.where((feed) => feed.studentId == studentId);
    int _coin = 0;
    int _star = 0;
    int _light = 0;
    int _thunder = 0;
    for (var i in _feed) {
      switch (i.awardBadge) {
        case 'Star Contributor':
          _star++;
          break;
        case 'Light Blaster':
          _light++;
          break;
        case 'Coin Champion':
          _coin++;
          break;
        case 'ThunderBolt':
          _thunder++;

          break;
        default:
      }
    }
    return _Badges(coin: _coin, star: _star, light: _light, thunder: _thunder);
  }

  Card testClassProgress() {
    return Card(
      elevation: 10,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        // margin: const EdgeInsets.only(top: 20, left: 20.0, right: 20),
        padding: EdgeInsets.only(top: 18, left: 15, right: 15, bottom: 18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x40000000),
                  offset: Offset(0, 0),
                  blurRadius: 12,
                  spreadRadius: 0)
            ],
            color: const Color(0xffffffff)),
        child: FutureBuilder<ActivityProgress>(
            future: BlocProvider.of<ActivityCubit>(context, listen: false)
                .testProgress(widget.student.id),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Test",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    '${snapshot.data.average.toStringAsFixed(1)}%',
                    // "50%",
                    // "${state.testProgress.average.toStringAsFixed(1)}%",
                    style: const TextStyle(
                        color: Color(0xff6fcf97),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: LinearPercentIndicator(
                          animation: false,
                          lineHeight: 6.0,
                          animationDuration: 2500,
                          // percent: 0.5,
                          percent: snapshot.data.average / 100,
                          // percent: state.testProgress.average / 100,
                          alignment: MainAxisAlignment.start,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                          progressColor: Color(0xff6fcf97),
                          backgroundColor: Color(0x40ff5a79),
                        ),
                      ),
                      Text('${snapshot.data.completed}/${snapshot.data.total}',
                          // "50/100",
                          // "${state.testProgress.completed}/${state.testProgress.total}",
                          style: const TextStyle(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontStyle: FontStyle.normal,
                              fontSize: 10.0),
                          textAlign: TextAlign.left)
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }

  Card joinedClassProgress() {
    return Card(
        elevation: 10,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          // margin: const EdgeInsets.only(top: 20, left: 20.0, right: 20),
          padding: EdgeInsets.only(top: 18, left: 15, right: 15, bottom: 18),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x40000000),
                    offset: Offset(0, 0),
                    blurRadius: 12,
                    spreadRadius: 0)
              ],
              color: const Color(0xffffffff)),
          child: FutureBuilder<AttendanceDetails>(
              future: BlocProvider.of<ActivityCubit>(context, listen: false)
                  .joinedClassProgress(widget.student.id),
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Joined Class",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      '${snapshot.data.average.toStringAsFixed(1)}%',
                      // "${state.joinClassProgress.average.toStringAsFixed(1)}%",
                      // "${(getClassPercent(state.allClassSchedules)[0])}%",
                      style: const TextStyle(
                          color: Color(0xff6fcf97),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LinearPercentIndicator(
                            animation: false,
                            lineHeight: 6.0,
                            animationDuration: 2500,
                            // percent: snapshot.data.attendClass / 10,
                            percent: double.tryParse(snapshot.data.average.toString()) / 100 ,
                            // getClassPercent(state.allClassSchedules)[0] / 100,
                            // percent: 50 / 100,
                            alignment: MainAxisAlignment.start,
                            barRadius: Radius.circular(5),
                            progressColor: Color(0xff6fcf97),
                            backgroundColor: Color(0x40ff5a79),
                          ),
                        ),
                        Text(
                            '${snapshot.data.attendClass}/${snapshot.data
                                .total}',
                            //  '${(getClassPercent(state.allClassSchedules)[0] * getClassPercent(state.allClassSchedules)[1])}/${getClassPercent(state.allClassSchedules)[1].toInt()}',
                            // "${state.joinClassProgress.completed}/${state.joinClassProgress.total}",
                            // '${(getClassPercent(state.allClassSchedules)[0] * getClassPercent(state.allClassSchedules)[1])}/${getClassPercent(state.allClassSchedules)[1].toInt()}'
                            style: const TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 10.0),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ],
                );
              }),
        )

      // Container(
      //   height: 120,
      //   padding: EdgeInsets.all(10),
      //   child: BlocBuilder<ScheduleClassCubit, ClassScheduleStates>(
      //       builder: (context, state) {
      //     if (state is ClassScheduleLoaded)
      //       return Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(left: 10, top: 10),
      //             child: Text(
      //               'Joined Classes',
      //               style: buildTextStyle(weight: FontWeight.bold),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Row(
      //             children: [
      //               buildLinearPercentBar(
      //                 percent: getClassPercent(state.allClassSchedules)[0],
      //                 color: Color(0xffFF5A79),
      //                 lineHeight: 15,
      //               ).expandFlex(4),
      //               Text(
      //                 '${(getClassPercent(state.allClassSchedules)[0] * getClassPercent(state.allClassSchedules)[1])}/${getClassPercent(state.allClassSchedules)[1].toInt()}',
      //                 style: buildTextStyle(size: 13),
      //                 textAlign: TextAlign.end,
      //               ).expand,
      //             ],
      //           ),
      //         ],
      //       );
      //     else {
      //       return Center(
      //         child: loadingBar,
      //       );
      //     }
      //   }),
      // ),
    );
  }

  Card instituteSessionProgress() {
    return Card(
        elevation: 10,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          // margin: const EdgeInsets.only(top: 20, left: 20.0, right: 20),
          padding: EdgeInsets.only(top: 18, left: 15, right: 15, bottom: 18),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x40000000),
                    offset: Offset(0, 0),
                    blurRadius: 12,
                    spreadRadius: 0)
              ],
              color: const Color(0xffffffff)),
          child: FutureBuilder<AttendanceDetails>(
              future: BlocProvider.of<ActivityCubit>(context, listen: false)
                  .joinedClassProgress(widget.student.id),
              builder: (context, snapshot) {
                if (snapshot.data == null ||
                    snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Joined Session",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      '${snapshot.data.average.toStringAsFixed(1)}%',
                      // "${state.joinClassProgress.average.toStringAsFixed(1)}%",
                      // "${(getClassPercent(state.allClassSchedules)[0])}%",
                      style: const TextStyle(
                          color: Color(0xff6fcf97),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LinearPercentIndicator(
                            animation: false,
                            lineHeight: 6.0,
                            animationDuration: 2500,
                            percent: snapshot.data.attendClass / 100,
                            // getClassPercent(state.allClassSchedules)[0] / 100,
                            // percent: 50 / 100,
                            alignment: MainAxisAlignment.start,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Color(0xff6fcf97),
                            backgroundColor: Color(0x40ff5a79),
                          ),
                        ),
                        Text(
                            '${snapshot.data.attendClass}/${snapshot.data
                                .total}',
                            //  '${(getClassPercent(state.allClassSchedules)[0] * getClassPercent(state.allClassSchedules)[1])}/${getClassPercent(state.allClassSchedules)[1].toInt()}',
                            // "${state.joinClassProgress.completed}/${state.joinClassProgress.total}",
                            // '${(getClassPercent(state.allClassSchedules)[0] * getClassPercent(state.allClassSchedules)[1])}/${getClassPercent(state.allClassSchedules)[1].toInt()}'
                            style: const TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontStyle: FontStyle.normal,
                                fontSize: 10.0),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ],
                );
              }),
        )

      // Container(
      //   height: 120,
      //   padding: EdgeInsets.all(10),
      //   child: BlocBuilder<ScheduleClassCubit, ClassScheduleStates>(
      //       builder: (context, state) {
      //     if (state is ClassScheduleLoaded)
      //       return Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: EdgeInsets.only(left: 10, top: 10),
      //             child: Text(
      //               'Joined Classes',
      //               style: buildTextStyle(weight: FontWeight.bold),
      //             ),
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Row(
      //             children: [
      //               buildLinearPercentBar(
      //                 percent: getClassPercent(state.allClassSchedules)[0],
      //                 color: Color(0xffFF5A79),
      //                 lineHeight: 15,
      //               ).expandFlex(4),
      //               Text(
      //                 '${(getClassPercent(state.allClassSchedules)[0] * getClassPercent(state.allClassSchedules)[1])}/${getClassPercent(state.allClassSchedules)[1].toInt()}',
      //                 style: buildTextStyle(size: 13),
      //                 textAlign: TextAlign.end,
      //               ).expand,
      //             ],
      //           ),
      //         ],
      //       );
      //     else {
      //       return Center(
      //         child: loadingBar,
      //       );
      //     }
      //   }),
      // ),
    );
  }

  Card assignmentProgress() {
    return Card(
      elevation: 10,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        // height: 370,
        child: FutureBuilder<ActivityProgress>(
            future: BlocProvider.of<ActivityCubit>(context, listen: false)
                .assignmentProgress(widget.student.id),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      "Assignment",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: PieChart(
                      chartRadius: 120,
                      dataMap: {
                        "Submitted":
                        snapshot.data.completed / snapshot.data.total,
                        "Pending": snapshot.data.pending / snapshot.data.total,
                        "Reassign":
                        snapshot.data.reassign / snapshot.data.total,
                      },
                      colorList: [
                        Color(0xff6FCF97),
                        Color(0xffFF5A79),
                        Color(0xffFDA429)
                      ],
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 10,
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.bottom,
                        showLegends: false,
                        legendShape: BoxShape.circle,
                        legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: false,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                      ),
                    ),
                  ),
                  // Center(
                  //   child: CircularPercentIndicator(
                  //     radius: 120,

                  //     animation: true,
                  //     animationDuration: 500,
                  //     // arcType: ArcType.FULL,
                  //     // curve: ,

                  //     // backgroundWidth: 0,
                  //     startAngle: 0,

                  //     backgroundColor: Color(0xffFF5A79),
                  //     // arcBackgroundColor: Color(0xffFF5A79),
                  //     progressColor: Color(0xff6FCF97),
                  //     // fillColor: ,
                  //     percent: snapshot.data.average / 100,
                  //     // getAssignmentProgress(widget.activity, widget.student) > 1
                  //     //     ? 1
                  //     //     : getAssignmentProgress(
                  //     //         widget.activity, widget.student),
                  //     // circularStrokeCap: CircularStrokeCap.round,
                  //     lineWidth: 10,
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          CircularPercentIndicator(

                            radius: 12.5,
                            lineWidth: 6.0,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent:
                            snapshot.data.pending / snapshot.data.total,
                            arcType: ArcType.FULL,
                            arcBackgroundColor: Color(0x40ff5a79),
                            progressColor: Color(0xffFF5A79),
                          ),
                          // CircleAvatar(
                          //   backgroundColor: Color(0xffFF5A79),
                          //   radius: 25,
                          //   child: CircleAvatar(
                          //     backgroundColor: Colors.white,
                          //     radius: 8,
                          //   ),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Pending \n ${((snapshot.data.pending /
                                snapshot.data.total) * 100).toStringAsFixed(
                                2)}%',
                            // 'Pending \n${(1 - (getAssignmentProgress(widget.activity, widget.student) > 1 ? 1 : getAssignmentProgress(widget.activity, widget.student))) * 100}%',
                            style: buildTextStyle(
                              weight: FontWeight.w600,
                              size: 10.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 12.5,
                            lineWidth: 6.0,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent:
                            snapshot.data.completed / snapshot.data.total,
                            arcType: ArcType.FULL,
                            arcBackgroundColor: Color(0x406fcf97),
                            progressColor: Color(0xff6FCF97),
                          ),
                          // CircleAvatar(
                          //   backgroundColor: Color(0xff6FCF97),
                          //   radius: 15,
                          //   child: CircleAvatar(
                          //     backgroundColor: Colors.white,
                          //     radius: 8,
                          //   ),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Submitted \n ${((snapshot.data.completed /
                                snapshot.data.total) * 100).toStringAsFixed(
                                2)}%',
                            // 'Actioned \n${(getAssignmentProgress(widget.activity, widget.student) > 1 ? 1 : getAssignmentProgress(widget.activity, widget.student)) * 100}%',
                            style: buildTextStyle(
                              weight: FontWeight.w600,
                              size: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 12.5,
                            lineWidth: 6.0,
                            circularStrokeCap: CircularStrokeCap.round,
                            percent:
                            snapshot.data.reassign / snapshot.data.total,
                            arcType: ArcType.FULL,
                            progressColor: Color(0xffFDA429),
                            arcBackgroundColor: Color(0xfffddfb4),
                          ),
                          // CircleAvatar(
                          //   backgroundColor: Color(0xffFDA429),
                          //   radius: 15,
                          //   child: CircleAvatar(
                          //     backgroundColor: Colors.white,
                          //     radius: 8,
                          //   ),
                          // ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Reassigned \n ${((snapshot.data.reassign /
                                snapshot.data.total) * 100).toStringAsFixed(
                                2)}%',
                            // 'Actioned \n${(getAssignmentProgress(widget.activity, widget.student) > 1 ? 1 : getAssignmentProgress(widget.activity, widget.student)) * 100}%',
                            style: buildTextStyle(
                              weight: FontWeight.w600,
                              size: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width - 70,
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Submit Status',
                          style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              LinearPercentIndicator(
                                  animation: false,
                                  lineHeight: 6.0,
                                  animationDuration: 2500,
                                  percent: snapshot.data.pending /
                                      snapshot.data.total,
                                  trailing: Text(
                                    // "${(assignmentProgress.total == 0 ? 0 : (assignmentProgress.pending / assignmentProgress.total) * 100).toStringAsFixed(1)}% not able to",
                                    " ${((snapshot.data.pending /
                                        snapshot.data.total) * 100)
                                        .toStringAsFixed(1)}% not able to",
                                    style: const TextStyle(
                                        color: const Color(0xffff5a79),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.0),
                                  ),
                                  alignment: MainAxisAlignment.start,
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Color(0xffff5a79),
                                  backgroundColor: Color(0x40ff5a79)),
                              SizedBox(
                                height: 8,
                              ),
                              LinearPercentIndicator(
                                  animation: false,
                                  lineHeight: 6.0,
                                  animationDuration: 2500,
                                  percent: snapshot.data.completed /
                                      snapshot.data.total,
                                  trailing: Text(
                                    // "${(assignmentProgress.total == 0 ? 0 : (assignmentProgress.completed / assignmentProgress.total) * 100).toStringAsFixed(1)}% Able to",
                                    "${((snapshot.data.completed /
                                        snapshot.data.total) * 100)
                                        .toStringAsFixed(1)}% Able to",
                                    style: const TextStyle(
                                        color: const Color(0xffff5a79),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.0),
                                  ),
                                  alignment: MainAxisAlignment.start,
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Color(0xff6fcf97),
                                  backgroundColor: Color(0x406fcf97)),
                            ],
                          ),
                        ),

                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     buildLinearPercentBar(
                        //       lineHeight: 15,
                        //       color: Color(0xffFF5A79),
                        //       percent:
                        //           snapshot.data.pending / snapshot.data.total,
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     buildLinearPercentBar(
                        //       lineHeight: 15,
                        //       percent:
                        //           snapshot.data.completed / snapshot.data.total,
                        //     ),
                        //   ],
                        // ).expandFlex(1),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'unable to',
                        //       style: buildTextStyle(size: 14),
                        //     ),
                        //     SizedBox(
                        //       height: 10,
                        //     ),
                        //     Text(
                        //       'able to',
                        //       style: buildTextStyle(size: 14),
                        //     )
                        //   ],
                        // ).expand
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Card studentProgress() {


    return Card(
      elevation: 10,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        // height: 220,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FutureBuilder<TotalActivityProgress>(
                future: BlocProvider.of<ActivityCubit>(context, listen: false)
                    .userTotalProgress(widget.student.id, student: true),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Tasks',
                          style: buildTextStyle(weight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    "${snapshot.hasData ? (snapshot.data.average != null ? snapshot.data.average.toStringAsFixed(2):0) : 0}%",
                                    style: const TextStyle(
                                        color: const Color(0xffeb5757),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.0),
                                  ),
                                ),
                                LinearPercentIndicator(
                                  // width: (MediaQuery.of(context).size.width - 70) * 0.70,
                                  // width: MediaQuery.of(context).size.width - 70,
                                  animation: false,
                                  lineHeight: 6.0,
                                  animationDuration: 2500,
                                  percent: snapshot.hasData ? (snapshot.data.average??0) / 100 : 0,
                                  alignment: MainAxisAlignment.start,
                                  // linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Color(0xffffa800),
                                  backgroundColor: Color(0x33ffa800),
                                  barRadius: Radius.circular(10.0),
                                ),
                              ],
                            )

                          // buildLinearPercentBar(
                          //   percent: widget.student.studentProgress / 100,
                          // ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
            SizedBox(
              height: 15.0,
            ),
            StreamBuilder<ActivityProgress>(
                stream: BlocProvider.of<ActivityCubit>(context, listen: false)
                    .announcementProgress(widget.student.id)
                    .asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    return Row(
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),

                        Container(
                            width:
                            (MediaQuery
                                .of(context)
                                .size
                                .width - 70) * 0.40,
                            child: Text('Announcement',
                                style: const TextStyle(
                                    color: Color(0xff494949),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.0))),

                        Expanded(
                          child: LinearPercentIndicator(
                            leading: Center(
                              child: Text(
                                '${snapshot.data.average.toStringAsFixed(1)}%',
                                //"${            widget.announcementProgress.average.toStringAsFixed(1) }%",
                                // "50.0%",
                                style: const TextStyle(
                                    color: const Color(0xffeb5757),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0),
                              ),
                            ),
                            trailing: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svg/smiley-negative.svg"),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 23.5743408203125,
                                        height: 17.525156021118164,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color: const Color(0xffff5a79)),
                                        child: Text(
                                          '${snapshot.data.total -
                                              snapshot.data.completed}',
                                          // '7',
                                          // "${state.announcementProgress.total - state.announcementProgress.completed}",
                                          style: TextStyle(
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svg/smiley-positive.svg"),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 23.5743408203125,
                                        height: 17.525156021118164,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color: const Color(0xff2cb9b0)),
                                        child: Text(
                                          '${snapshot.data.completed}',
                                          //'5',
                                          // state.announcementProgress.completed.toString(),
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            animation: false,
                            lineHeight: 6.0,
                            animationDuration: 2500,
                            percent: snapshot.data == null
                                ? ''
                                : snapshot.data == null
                                ? 0
                                : (snapshot.data.average ?? 0) / 100,
                            alignment: MainAxisAlignment.start,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Color(0xffa57eb4),
                            backgroundColor: Color(0x33a57eb4),
                          ),
                        ),

                        // buildLinearPercentBar(
                        //   lineHeight: 15,
                        //   percent: snapshot.data == null
                        //       ? ''
                        //       : snapshot.data == null
                        //           ? 0
                        //           : (snapshot.data.average ?? 0) / 100,
                        //   color: Color(0xffA57EB4),
                        // ).expandFlex(2),
                        // Container(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       _progressContainer(
                        //         text: snapshot.data == null
                        //             ? ''
                        //             : snapshot.data.completed.toString(),
                        //       ),
                        //       _progressContainer(
                        //         color: Color(0xffFF5A79),
                        //         text: snapshot.data == null
                        //             ? ''
                        //             : snapshot.data.pending.toString(),
                        //       ),
                        //     ],
                        //   ),
                        // ).expand
                      ],
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                }),
            if(features['livePoll']['isEnabled'])
            StreamBuilder<ActivityProgress>(
                stream: BlocProvider.of<ActivityCubit>(context)
                    .livePollActivityProgress(widget.student.id)
                    .asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                      return Row(
                        children: [
                          SizedBox(
                            height: 25.0,
                          ),
                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 70) * 0.40,
                            child: Text(
                              "Live Poll",
                              style: const TextStyle(
                                  color: const Color(0xff494949),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0),
                            ),
                          ),
                          Expanded(
                            child: LinearPercentIndicator(
                              leading: Center(
                                child: Text(
                                  '${snapshot.data != null ? snapshot.data.average.toStringAsFixed(1) : 'No Data'}%',
                                  // '50%',
                                  // "${state.livePollProgress.average.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                      color: const Color(0xffeb5757),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0),
                                ),
                              ),
                              trailing: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/svg/smiley-negative.svg"),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 23.5743408203125,
                                          height: 17.525156021118164,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                              color: const Color(0xffff5a79)),
                                          child: Text(
                                            '${snapshot.data != null ? snapshot.data.total - snapshot.data.completed : 'No Data'}',
                                            // "${state.livePollProgress.total - state.livePollProgress.completed}",
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/svg/smiley-positive.svg"),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 23.5743408203125,
                                          height: 17.525156021118164,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                              color: const Color(0xff2cb9b0)),
                                          child: Text(
                                            '${snapshot.data != null ? snapshot.data.completed : 'No Data'}',
                                            // state.livePollProgress.completed.toString(),
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.0),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              animation: false,
                              lineHeight: 6.0,
                              animationDuration: 2500,
                              percent: snapshot.data == null
                                  ? 0
                                  : (snapshot.data.average ?? 0) / 100,
                              alignment: MainAxisAlignment.start,
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Color(0xff8ca0c9),
                              backgroundColor: Color(0x33a57eb4),
                            ),
                          ),
                          // buildLinearPercentBar(
                          //   lineHeight: 15,
                          //   percent: snapshot.data == null
                          //       ? 0
                          //       : (snapshot.data.average ?? 0) / 100,
                          //   color: Color(0xff8CA0C9),
                          // ).expandFlex(2),
                          // Container(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: [
                          //       _progressContainer(
                          //           text: snapshot.data == null
                          //               ? ''
                          //               : snapshot.data.completed.toString()),
                          //       _progressContainer(
                          //         color: Color(0xffFF5A79),
                          //         text: snapshot.data == null
                          //             ? ''
                          //             : snapshot.data.pending.toString(),
                          //       ),
                          //     ],
                          //   ),
                          // ).expand
                        ],
                      );
                    }
                  else
                    {
                      return loadingBar;
                    }
                    // else {
                  //   print('livepool : ${snapshot.data}');
                  //   return Container(
                  //     child: Text('livepool : ${snapshot.data}'),
                  //   );
                  // }
                }),
            if(features['Event']['isEnabled'])
            FutureBuilder<ActivityProgress>(
                future: BlocProvider.of<ActivityCubit>(context)
                    .eventActivityProgress(widget.student.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    return Row(
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          width:
                              (MediaQuery.of(context).size.width - 70) * 0.40,
                          child: Text(
                            "Event",
                            style: const TextStyle(
                                color: const Color(0xff494949),
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                          child: LinearPercentIndicator(
                            leading: Center(
                              child: Text(
                                '${snapshot.data.average.toStringAsFixed(1)}%',
                                // '50%',
                                // "${state.eventProgress.average.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                    color: const Color(0xffeb5757),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0),
                              ),
                            ),
                            trailing: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svg/smiley-negative.svg"),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 23.5743408203125,
                                        height: 17.525156021118164,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color: const Color(0xffff5a79)),
                                        child: Text(
                                          '${snapshot.data.total - snapshot.data.completed}',
                                          // '5',
                                          // "${state.eventProgress.total - state.eventProgress.completed}",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svg/smiley-positive.svg"),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 23.5743408203125,
                                        height: 17.525156021118164,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color: const Color(0xff2cb9b0)),
                                        child: Text(
                                          '${snapshot.data.completed}',
                                          // '5',
                                          // "${state.eventProgress.completed}",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            animation: false,
                            lineHeight: 6.0,
                            animationDuration: 2500,
                            percent: snapshot.data == null
                                ? 0
                                : (snapshot.data.average ?? 0) / 100,
                            alignment: MainAxisAlignment.start,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Color(0xffc396ff),
                            backgroundColor: Color(0x33a57eb4),
                          ),
                        ),
                        // buildLinearPercentBar(
                        //   lineHeight: 15,
                        //   percent: snapshot.data == null
                        //       ? 0
                        //       : (snapshot.data.average ?? 0) / 100,
                        //   color: Color(0xffC396FF),
                        // ).expandFlex(2),
                        // Container(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       _progressContainer(
                        //         text: snapshot.data == null
                        //             ? ''
                        //             : snapshot.data.completed.toString(),
                        //       ),
                        //       _progressContainer(
                        //         color: Color(0xffFF5A79),
                        //         text: snapshot.data == null
                        //             ? ''
                        //             : snapshot.data.pending.toString(),
                        //       ),
                        //     ],
                        //   ),
                        // ).expand
                      ],
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                }),
            if(features['checkList']['isEnabled'])
            StreamBuilder<ActivityProgress>(
                stream: BlocProvider.of<ActivityCubit>(context)
                    .checkListActivityProgress(widget.student.id)
                    .asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                      return Row(
                        children: [

                          Container(
                            width:
                                (MediaQuery.of(context).size.width - 70) * 0.40,
                            child: Text(
                              "CheckList (to-do)",
                              style: const TextStyle(
                                  color: const Color(0xff494949),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0),
                            ),
                          ),
                          Expanded(
                            child: LinearPercentIndicator(
                              leading: Center(
                                child: Text(
                                  '${snapshot.data != null ? snapshot.data.average.toStringAsFixed(1) : 'No Data'}%',
                                  // "${state.checkListProgress.average.toStringAsFixed(1)}%",
                                  style: const TextStyle(
                                      color: const Color(0xffeb5757),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0),
                                ),
                              ),
                              trailing: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/svg/smiley-negative.svg"),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 23.5743408203125,
                                          height: 17.525156021118164,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                              color: const Color(0xffff5a79)),
                                          child: Text(
                                            '${snapshot.data != null ? snapshot.data.total - snapshot.data.completed : 'No Data'}',
                                            // "${state.checkListProgress.total - state.checkListProgress.completed}",
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 9,
                                    ),
                                    Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/svg/smiley-positive.svg"),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 23.5743408203125,
                                          height: 17.525156021118164,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2)),
                                              color: const Color(0xff2cb9b0)),
                                          child: Text(
                                            '${snapshot.data != null ? snapshot.data.completed : 'No Data'}',
                                            // "${state.checkListProgress.completed}",
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.0),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              animation: false,
                              lineHeight: 6.0,
                              animationDuration: 2500,
                              percent: snapshot.data == null
                                  ? 0
                                  : (snapshot.data.average ?? 0) / 100,
                              alignment: MainAxisAlignment.start,
                              linearStrokeCap: LinearStrokeCap.roundAll,
                              progressColor: Color(0xff2182c4),
                              backgroundColor: Color(0x33a57eb4),
                            ),
                          ),
                          // buildLinearPercentBar(
                          //   lineHeight: 15,
                          //   percent: snapshot.data == null
                          //       ? 0
                          //       : (snapshot.data.average ?? 0) / 100,
                          //   color: Color(0xff2182C4),
                          // ).expandFlex(2),
                          // Container(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //     children: [
                          //       _progressContainer(
                          //         text: snapshot.data == null
                          //             ? ''
                          //             : snapshot.data.completed.toString(),
                          //       ),
                          //       _progressContainer(
                          //         color: Color(0xffFF5A79),
                          //         text: snapshot.data == null
                          //             ? ''
                          //             : snapshot.data.pending.toString(),
                          //       ),
                          //     ],
                          //   ),
                          // ).expand
                        ],
                      );
                    }else{
                    return loadingBar;
                  }
                  }),

            FutureBuilder<ActivityProgress>(
                future: BlocProvider.of<ActivityCubit>(context)
                    .assignmentProgress(widget.student.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          width:
                          (MediaQuery
                              .of(context)
                              .size
                              .width - 70) * 0.40,
                          child: Text(
                            "Assignment",
                            style: const TextStyle(
                                color: const Color(0xff494949),
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0),
                          ),
                        ),
                        Expanded(
                          child: LinearPercentIndicator(
                            leading: Center(
                              child: Text(
                                '${snapshot.data.average.toStringAsFixed(1)}%',
                                // '50%',
                                // "${state.assignmentProgress.average.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                    color: const Color(0xffeb5757),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0),
                              ),
                            ),
                            trailing: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svg/smiley-negative.svg"),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 23.5743408203125,
                                        height: 17.525156021118164,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color: const Color(0xffff5a79)),
                                        child: Text(
                                          '${snapshot.data.total -
                                              snapshot.data.completed}',
                                          //'5',
                                          // "${state.assignmentProgress.total - state.assignmentProgress.completed}",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/svg/smiley-positive.svg"),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 23.5743408203125,
                                        height: 17.525156021118164,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2)),
                                            color: const Color(0xff2cb9b0)),
                                        child: Text(
                                          '${snapshot.data.completed}',
                                          // '5',
                                          // "${state.assignmentProgress.completed}",
                                          style: const TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10.0),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            animation: false,
                            lineHeight: 6.0,
                            animationDuration: 2500,
                            percent: snapshot.data.average / 100,
                            alignment: MainAxisAlignment.start,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Color(0xff2182c4),
                            backgroundColor: Color(0x33a57eb4),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      width: 0,
                      height: 0,
                    );
                  }
                }),
            if(widget.sessionReport != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  Container(
                    width:
                    (MediaQuery
                        .of(context)
                        .size
                        .width - 70) * 0.40,
                    child: Text(
                      "Live Session",
                      style: const TextStyle(
                          color: const Color(0xff494949),
                          fontWeight: FontWeight.w300,
                          fontSize: 12.0),
                    ),
                  ),
                  Expanded(
                    child: LinearPercentIndicator(
                      leading: Center(
                        child: Text(
                          '${widget.sessionReport.avg.toStringAsFixed(2)}%',
                          // '50%',
                          // "${state.assignmentProgress.average.toStringAsFixed(1)}%",
                          style: const TextStyle(
                              color: const Color(0xffeb5757),
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0),
                        ),
                      ),
                      trailing: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SvgPicture.asset(
                                    "assets/svg/smiley-negative.svg"),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 23.5743408203125,
                                  height: 17.525156021118164,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2)),
                                      color: const Color(0xffff5a79)),
                                  child: Text(
                                    '${widget.sessionReport.total - widget.sessionReport.attended}',
                                    //'5',
                                    // "${state.assignmentProgress.total - state.assignmentProgress.completed}",
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Column(
                              children: [
                                SvgPicture.asset(
                                    "assets/svg/smiley-positive.svg"),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 23.5743408203125,
                                  height: 17.525156021118164,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(2)),
                                      color: const Color(0xff2cb9b0)),
                                  child: Text(
                                    '${widget.sessionReport.attended}',
                                    // '5',
                                    // "${state.assignmentProgress.completed}",
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 10.0),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      animation: false,
                      lineHeight: 6.0,
                      animationDuration: 2500,
                      percent: widget.sessionReport.avg / 100,
                      alignment: MainAxisAlignment.start,
                      progressColor: Color(0xff2182c4),
                      backgroundColor: Color(0x33a57eb4),
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              // "Delayed Actions",
              "Late Submission",
              style: const TextStyle(
                color: const Color(0xff000000),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 70) * 0.50,
                  child: Column(
                    children: [

                      StreamBuilder<ActivityProgress>(
                          stream: BlocProvider.of<ActivityCubit>(context,
                              listen: false)
                              .announcementProgress(widget.student.id)
                              .asStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {

                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Announcement",
                                    style: TextStyle(
                                        color: Color(0xff494949),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12.0),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 23.5743408203125,
                                    height: 17.525156021118164,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2)),
                                        color: Color(0xffff5a79)),
                                    child: Text(
                                      '${snapshot.data.delayedSubmission}',
                                      //  '5',
                                      // "${state.announcementProgress.delayedSubmission}",
                                      style: const TextStyle(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.0),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Container(
                                height: 0,
                              );
                            }
                          }),
                      const SizedBox(
                        height: 10,
                      ),
                      if (features['livePoll']['isEnabled'])
                        StreamBuilder<ActivityProgress>(
                            stream: BlocProvider.of<ActivityCubit>(context,
                                listen: false)
                                .livePollActivityProgress(widget.student.id)
                                .asStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Live Poll",
                                      style: TextStyle(
                                          color: Color(0xff494949),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12.0),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 23.5743408203125,
                                      height: 17.525156021118164,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          color: Color(0xffff5a79)),
                                      child: Text(
                                        '${snapshot.data.delayedSubmission}',
                                        //'5',
                                        // "${state.livePollProgress.delayedSubmission}",
                                        style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10.0),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container(
                                  height: 0,
                                );
                              }
                            }),
                      const SizedBox(
                        height: 10,
                      ),
                      if (features['checkList']['isEnabled'])
                        StreamBuilder<ActivityProgress>(
                            stream: BlocProvider.of<ActivityCubit>(context,
                                listen: false)
                                .checkListActivityProgress(widget.student.id)
                                .asStream(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {

                                return Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "CheckList (to-do)",
                                      style: TextStyle(
                                          color: Color(0xff494949),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12.0),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 23.5743408203125,
                                      height: 17.525156021118164,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(2)),
                                          color: Color(0xffff5a79)),
                                      child: Text(
                                        '${snapshot.data.delayedSubmission}',
                                        // '5',
                                        // "${state.checkListProgress.delayedSubmission}",
                                        style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10.0),
                                      ),
                                    )
                                  ],
                                );
                              } else {
                                return Container(
                                  height: 0,
                                );
                              }
                            }),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //       "Assignment",
                      //       style: const TextStyle(
                      //           color: const Color(0xff494949),
                      //           fontWeight: FontWeight.w300,
                      //           fontSize: 12.0),
                      //     ),
                      //     Container(
                      //       alignment: Alignment.center,
                      //       width: 23.5743408203125,
                      //       height: 17.525156021118164,
                      //       decoration: BoxDecoration(
                      //           borderRadius:
                      //               BorderRadius.all(Radius.circular(2)),
                      //           color: const Color(0xffff5a79)),
                      //       child: Text(
                      //         "${state.assignmentProgress.delayedSubmission}",
                      //         style: const TextStyle(
                      //             color: const Color(0xffffffff),
                      //             fontWeight: FontWeight.w400,
                      //             fontSize: 10.0),
                      //       ),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width - 70) * 0.50,
                  child: StreamBuilder<ActivityProgress>(
                    stream:  BlocProvider.of<ActivityCubit>(context,
                        listen: false)
                        .lateSubmissionProgress(widget.student.id)
                        .asStream(),
                    builder: (context,snapshot) {
                      return CircularPercentIndicator(
                        radius: 40.0,
                        lineWidth: 8.0,
                        circularStrokeCap: CircularStrokeCap.round,
                        percent: snapshot.hasData ? ((snapshot.data.average??1) /100):0,

                        center:
                        // Text("${state.totalDelayPercentage.toStringAsFixed(2)}%"),
                        // Text('${lateAvg.toString()}%'),
                        Text('${snapshot.hasData ? snapshot.data.average != null ? snapshot.data.average.toStringAsFixed(2):0:0}%'),
                        progressColor: Color(0xffff5a79),
                      );
                    }
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }


  Container _progressContainer({String text, Color color}) {
    return Container(
      // padding: EdgeInsets.all(10),
      height: 25,
      width: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Color(0xff2CB9B0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '$text' ?? '7',
        style: buildTextStyle(color: Colors.white, size: 12),
      ),
    );
  }

  String _validator(String value) {
    if (value.isEmpty) return 'Please provide a value';
    return null;
  }

  Widget _panel() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _panelController.close();
                },
              )
            ],
          ),
          TextFormField(
            validator: _validator,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Add Title',
            ),
          ),
          TextFormField(
            maxLines: 4,
            validator: _validator,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Add Description',
            ),
          ),
          CustomRaisedButton(
            title: 'Save',
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // double getAllProgress(List<Activity> activity, StudentInfo student) {
  //   return (activity.getAnnouncementProgress(student).completed +
  //           activity.getEventProgress(student).going +
  //           activity.getLivePollProgress(student).completed +
  //           activity.getCheckListProgress(student).completed) /
  //       activity.length;
  // }

  // double getAssignmentProgress(List<Activity> activity, StudentInfo student) {
  //   return (activity
  //           .where((act) => act.activityType.toLowerCase() == 'assignment')
  //           .toList()
  //           .getAssignmentProgress(student)
  //           .completed) /
  //       getActivityLength('assignment');
  // }

  // double getAnnouncementProgress(List<Activity> activity, StudentInfo student) {
  //   return (activity.getAnnouncementProgress(student).completed /
  //       getActivityLength('announcement'));
  // }

  // double getEventProgress(List<Activity> activity, StudentInfo student) {
  //   return (activity.getEventProgress(student).going /
  //       getActivityLength('event'));
  // }

  // double getCheckListProgress(List<Activity> activity, StudentInfo student) {
  //   print(activity.getCheckListProgress(student).completed);
  //   return (activity.getCheckListProgress(student).completed /
  //       getActivityLength('checklist'));
  // }

  // double getLivePollProgress(List<Activity> activity, StudentInfo student) {
  //   return (activity.getLivePollProgress(student).completed /
  //       getActivityLength('livepoll'));
  // }

  // int getActivityLength(String activityName, {bool checkNan = true}) {
  //   return widget.activity
  //               .where((act) => act.activityType.toLowerCase() == activityName)
  //               .length ==
  //           0
  //       ? checkNan
  //           ? 1
  //           : 0
  //       : widget.activity
  //           .where((act) => act.activityType.toLowerCase() == activityName)
  //           .length;
  // }

  int getTotalReward(List<TotalRewardDetails> students) {
    return students.fold<int>(0, (currentValue, student) {
      return currentValue +
          student.studentDetails[0].coin +
          student.studentDetails[0].extraCoins;
      // return currentValue;
    });
  }

  List<double> getClassPercent(List<ScheduledClassTask> classes) {
    var joined = classes.where((stud) {
      bool present = false;
      for (var i in stud.studentJoin) {
        if (i.student.id == widget.student.id) {
          present = true;
          return present;
        }
      }
      return present;
    }).length;
    var total = classes.where((cls) {
      bool present = false;
      for (var i in cls.assignTo) {
        if (i.studentId.id == widget.student.id) {
          present = true;
          return present;
        }
      }
      return present;
    }).length;
    return [joined / total, total.toDouble()];
  }
}

class FeedBackWidget extends StatefulWidget {
  const FeedBackWidget({
    @required this.studentId,
  });

  final StudentInfo studentId;

  @override
  _FeedBackWidgetState createState() => _FeedBackWidgetState();
}

class _FeedBackWidgetState extends State<FeedBackWidget> {
  List<String> feedback = [
    'Academic feedback',
    'Health and fitness feedback',
    'Socio-emotional feedback',
    'Value and Intrapersonal feedback',
  ];
  TextEditingController _controller = TextEditingController();
  String badge;
  String feedType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBackCubit, FeedBackStates>(
        builder: (context, state) {
          if (state is FeedBacksLoaded) {
            // var _feed = state.feedback.toList();
            log('true');
            return Column(
              children: [
                KeyboardVisibilityBuilder(builder: (context, keyboardVisible) {
                  return Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.6,
                    child: ListView.separated(
                      // shrinkWrap: true,
                      itemCount: state.feedback.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 8,
                        );
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius: 3,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      TeacherProfileAvatar(
                                        imageUrl:
                                        state.feedback[index].teacherId.profileImage,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          Text(state.feedback[index].feedType),
                                          Text('${state.feedback[index].teacherId.name}'
                                              .toTitleCase()),
                                          Text(
                                            DateFormat('dd-MM-yyyy')
                                                .format(state.feedback[index].createdAt),
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/${state.feedback[index]
                                            .awardBadgeImage}',
                                        height: 25,
                                        width: 25,
                                      ),
                                      // Image.asset(
                                      //   'assets/images/points.png',
                                      //   height: 25,
                                      //   width: 25,
                                      // ),
                                      // Text('10'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(state.feedback[index].feed)
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
                KeyboardVisibilityBuilder(
                  builder: (context, isKeyboardVisible) {
                    return Padding(
                      padding: EdgeInsets.all(isKeyboardVisible ? 100 : 0),
                      child: SizedBox(
                        height: 20,
                      ),
                    );
                  },
                ),
                Center(
                  child: CustomRaisedButton(
                    title: 'Add Feedback',
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        elevation: 10,
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        builder: (context) {
                          return SubmitFeedWidget(widget.studentId, () {
                            BlocProvider.of<FeedBackCubit>(context)
                                .getFeedback(widget.studentId.id);
                            // setState(() {});
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return Container(
              child: Center(
                child: loadingBar,
              ),
            );
          }
        });
  }

  String teacherName(List<UserInfo> teachers, String teacherId) {
    print('teacher id == $teacherId');
    return teachers
        .firstWhere((teacher) => teacher.id == teacherId,
        orElse: () {
          return UserInfo(name: 'Not Found');
        })
        .name;
  }

  String teacherProfile(List<UserInfo> teachers, String teacherId) {
    print('teacher id == $teacherId');
    return teachers
        .firstWhere((teacher) => teacher.id == teacherId,
        orElse: () {
          return UserInfo(profileImage: 'Not Found');
        })
        .profileImage;
  }
}

class _Badges {
  int coin;
  int thunder;
  int star;
  int light;

  _Badges({this.coin, this.star, this.light, this.thunder});
}

class SubmitFeedWidget extends StatefulWidget {
  final StudentInfo studentId;
  final Function() onPressed;

  SubmitFeedWidget(this.studentId, this.onPressed);

  @override
  _SubmitFeedWidgetState createState() => _SubmitFeedWidgetState();
}

class _SubmitFeedWidgetState extends State<SubmitFeedWidget> {
  String feedType;
  String badge;
  List<String> feedback = [
    'Academic feedback',
    'Health and fitness feedback',
    'Socio-emotional feedback',
    'Value and Intrapersonal feedback',
  ];
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Container(
        child: Column(
          children: [
            Text(
              'FeedBack Type',
              style: buildTextStyle(),
            ),
            SizedBox(
              height: 3,
            ),
            PopupMenuButton(
              onSelected: (value) {
                feedType = value;
                setState(() {});
              },
              child: _dropdownMenu(feedType ?? 'Select FeedBack'),
              itemBuilder: (context) {
                return feedback.map((feed) {
                  return PopupMenuItem(
                    value: feed,
                    child: ListTile(
                      title: Text(
                        feed,
                        style: buildTextStyle(),
                      ),
                    ),
                  );
                }).toList();
              },
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              maxLines: 4,
              controller: _controller,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Feedback Description',
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        if (badge != null)
                          Image.asset(
                            'assets/images/${checkBadge(badge)}',
                            height: 20,
                            width: 20,
                          ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(badge ?? 'Select Badge'),
                      ],
                    ),
                    PopupMenuButton(
                      onSelected: (value) {
                        badge = value;
                        setState(() {});
                      },
                      child: _dropdownMenu('Badge'),
                      itemBuilder: (context) {
                        return [
                          'Star Contributor',
                          'Light Blaster',
                          'Coin Champion',
                          'ThunderBolt'
                        ].map((feed) {
                          return PopupMenuItem(
                            value: feed,
                            child: ListTile(
                              title: Text(
                                feed,
                                style: buildTextStyle(),
                              ),
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            CustomRaisedButton(
              title: 'Submit FeedBack',
              check: _controller.text
                  .trim()
                  .isNotEmpty &&
                  badge != null &&
                  feedType != null,
              onPressed: () async {
                FeedBackStudent feedBackStudent = FeedBackStudent(
                  awardBadge: badge,
                  awardBadgeImage: checkBadge(badge),
                  feed: _controller.text,
                  feedType: feedType,
                  studentId: widget.studentId.id,
                  repository: Repository(classId: widget.studentId.userInfoClass,branch: widget.studentId.branchId,id: widget.studentId.schoolId,schoolId: widget.studentId.schoolId)
                );
                await BlocProvider.of<FeedBackCubit>(context, listen: false)
                    .postFeedback(feedBackStudent).then((value) {
                   // BlocProvider.of<FeedBackCubit>(context).getFeedback(widget.studentId.id);
                  widget.onPressed();
                });

                Navigator.of(context).pop();
                // Navigator.of(context).push(
                //   createRoute(
                //     pageWidget: MultiBlocProvider(
                //       providers: [
                //         BlocProvider(
                //           create: (context) =>
                //           FeedBackCubit()
                //             ..getFeedback(state
                //                 .students[index].id),
                //         ),
                //         BlocProvider(
                //           create: (context) =>
                //           ScheduleClassCubit()
                //             ..getAllClass(
                //                 '', context),
                //         ),
                //         BlocProvider(
                //           create: (context) =>
                //           RewardStudentCubit()
                //             ..loadRewardStudent(state
                //                 .students[index].id),
                //         ),
                //       ],
                //       child: StudentProfilePage(
                //         student: state.students[index],
                //         className: widget.className,
                //       ),
                //     ),
                //   ),
                // );

              },
            )
          ],
        ),
      ),
    );
  }

  String checkBadge(String value) {
    switch (value) {
      case 'Light Blaster':
        return 'badge1.png';
      case 'Star Contributor':
        return 'badge2.png';
      case 'Coin Champion':
        return 'badge4.png';
      case 'ThunderBolt':
        return 'badge3.png';
      default:
        return '';
    }
  }

  Container _dropdownMenu(String title, {IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[500],
          ),
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon ?? Icons.expand_more),
          SizedBox(
            width: 40,
          ),
          Text(
            title,
            style: buildTextStyle(
              size: 12,
              color: Colors.grey[500],
            ),
          )
        ],
      ),
    );
  }
}
