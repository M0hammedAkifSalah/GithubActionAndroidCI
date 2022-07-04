import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:new_version/new_version.dart';
import 'package:open_file/open_file.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../test-module/questions.dart';
import '/app-config.dart';
import '/bloc/activity/activity-states.dart';
import '/export.dart';
import '/view/announcements/create_announcement.dart';
import '/view/assign-task/create-groups.dart';
import '/view/event/create_event.dart';
import '/view/homepage/teachers_feed.dart';
import '/view/livepoll/create_livepoll.dart';
import '/view/schedule_class/class-schedule.dart';
import '/view/test-module/test-listing.dart';


PanelController askADoubtPanelController = PanelController();

// StreamController<List<Activity>> activityController;

Future<void> _firebaseMessagingBackgroundHandler(dynamic message) async {
  if(!kIsWeb)
  await Firebase.initializeApp();
  print('Handling a background message ${message.toString()}');
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel;

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  ScrollController scrollController2 = ScrollController();
  PanelController addTaskPanelController = PanelController();
  StreamController<bool> _controller;
  final ScrollController _scrollController = ScrollController();
  bool init = false;
  int page = 1;
  int currentIndex = 1;
  bool panelOpen = false;
  bool loading = false;
  bool toYou = false;
  int count = 0;
  Map<String, Map<String, dynamic>> filterValue = {};
  Map<String, Map<String, dynamic>> filterValueByYou = {
    "Assigned": {"color": Color(0xff56CCF2), "count": 0},
    "Evaluated": {"color": Color(0xff2F80ED), "count": 0},
    "Evaluate": {"color": Color(0xff9B51E0), "count": 0},
    // "Forwarded": {"color": Color(0xffEB5757), "count": 0},
  };
  Map<String, Map<String, dynamic>> filterValueToYou = {
    "Pending": {"color": Color(0xffEB5757), "count": 0},
    "Evaluated": {"color": Color(0xff2F80ED), "count": 0},
    "Submitted": {"color": Color(0xff27AE60), "count": 0},
    "Delayed Submission": {"color": Color(0xffEB5757), "count": 0},
    "Reassigned": {"color": Color(0xffEB5757), "count": 0},
    "Going Events": {"color": Color(0xff9B51E0), "count": 0},
    "Not Going Events": {"color": Color(0xff9B51E0), "count": 0},
    // "Forwarded": {"color": Color(0xffEB5757), "count": 0},
  };

  @override
  void initState() {
    filterValue = filterValueByYou;
    // filterValueByYou["Assigned"]["count"]=5;
    _controller = StreamController<bool>.broadcast();
    // if (Platform.isAndroid) {

    // }
    // if (toYou)
    //   getAssignedActivities(context);
    // else
    //   loadActivities(context);
    // activityController = StreamController<List<Activity>>.broadcast();
    // TODO: implement initState
    super.initState();

    initiate();
    // _checkVersion();
  }


  initiate() async {
    if(!kIsWeb)
    {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/growon'),
        iOS: IOSInitializationSettings(),
      ),
      onSelectNotification: (payload) async {
        print(payload);
        var type = payload.split('==,==');
        if (type[0] == 'download') {
          OpenFile.open(type[1]);
        } else {
          OpenFile.open(type[1], type: "application/pdf");
        }
      },
    );
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      // description
      importance: Importance.high,
    );
    if(!kIsWeb) {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage message) {
        if (message != null) {
          print(message.data.toString());
          _openPage(context, message.data["type"]);
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
            1,
            notification.title,
            notification.body,
            const NotificationDetails(
              iOS: IOSNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
              android: AndroidNotificationDetails(
                'high_importance_channel', // id
                'High Importance Notifications', // title
                channelDescription:
                'This channel is used for important notifications.',
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
              ),
            ),
          );
        }
      });

      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print(
            'A new onMessageOpenedApp event was published!: ${message.data
                .toString()}');
        _openPage(context, message.data["type"]);
      });


      getToken();
    }


  }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken(vapidKey: 'BL22HUNttQ1E7zayOPgqL7WtzW_74iC0U1yUVGmiO7vEiaoz18S1_WGBmnzu1LwZvOrIs6ykwNIHB03xkuzQQ4w');
    AuthCubit().updateDeviceToken(token);
  }
  static void _openPage(BuildContext context, String type) {
    switch (type) {
      case "test":
        Navigator.pushNamed(context, "/test_notification");
        break;
      case "class":
        Navigator.pushNamed(context, "/class_notification");
        break;
      case "innovation":
        Navigator.pushNamed(context, "/innovation_notification");
        break;
      case "session":
        Navigator.pushNamed(context, "/session");
        break;
    }
  }

  get close {
    // activityController.close();
    _controller.close();
  }

  @override
  void didChangeDependencies() {
    if (toYou) {
      getAssignedActivities(context);
    } else {
      loadActivities(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;

    // BlocProvider.of<AuthCubit>(context, listen: false)
    //     .checkAuthStatus('homepage');
    return WillPopScope(
        onWillPop: () async {
          if (addTaskPanelController.isPanelOpen) {
            addTaskPanelController.close();

            return false;
          } else {
            // Navigator.of(context).popUntil((route) => false);
            return true;
          }
        },
        child: Scaffold(
            floatingActionButton: panelOpen
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      addTaskPanelController.open();
                    },
                    backgroundColor: kColor,
                    child: Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: SlidingUpPanel(
                controller: addTaskPanelController,
                defaultPanelState: PanelState.CLOSED,
                minHeight: 0,
                maxHeight: 400,
                onPanelOpened: () {
                  setState(() {
                    panelOpen = true;
                  });
                },
                onPanelClosed: () {
                  setState(() {
                    panelOpen = false;
                  });
                },
                backdropEnabled: true,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                panel: AddTaskPanel(),
                body: Container(
                  child: NestedScrollView(
                    // physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                    // controller: ScrollController(keepScrollOffset: true),
                    // controller: toYou ? scrollController2 : scrollController,
                    controller: _scrollController,
                    floatHeaderSlivers: false,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          pinned: true,
                          floating: true,
                          expandedHeight: 150,
                          elevation: 0,
                          shadowColor: Colors.black38,
                          forceElevated: true,
                          flexibleSpace: FlexibleSpaceBar(
                            background: BlocProvider(
                                create: (context) =>
                                    AuthCubit()..checkAuthStatus(),
                                child:
                                    HomeSliverAppBar(addTaskPanelController)),
                          ),
                          bottom: PreferredSize(
                            preferredSize: Size(double.infinity, 50),
                            child: AppBarBottomSwitch(
                              _controller,
                              onChanged: (value) async {
                                toYou = value;
                                currentIndex = 0;
                                page = 1;
                                if (toYou) {
                                  await getAssignedActivities(context);
                                } else {
                                  await loadActivities(context);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          page = 1;
                          await getAssignedActivities(context);
                          await loadActivities(context);
                          BlocProvider.of<AuthCubit>(context, listen: false)
                              .checkAuthStatus();

                          return Future.delayed(Duration(seconds: 1));
                        },
                        child: SingleChildScrollView(
                          controller:
                              toYou ? scrollController2 : scrollController,
                          // physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              StreamBuilder<bool>(
                                  stream: _controller.stream,
                                  initialData: false,
                                  builder: (context, snapshot) {
                                    if (snapshot.data) {
                                      filterValue = filterValueToYou;
                                    } else {
                                      filterValue = filterValueByYou;
                                    }
                                    return Container(
                                      // color: Colors.amber,
                                      margin: EdgeInsets.only(top: 5),
                                      padding: EdgeInsets.all(8),
                                      child: SingleChildScrollView(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            for (var i = 0;
                                                i < filterValue.length;
                                                i++)
                                              homePageFilterCard(
                                                values: filterValue.values
                                                    .toList()[i],
                                                title: filterValue.keys
                                                    .toList()[i],
                                                value: i,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                              BlocBuilder<ActivityCubit, ActivityStates>(
                                buildWhen: (previous, current) {
                                  if (previous is ActivityLoaded &&
                                      current is ActivityLoaded) {
                                  }
                                  return true;
                                },
                                builder: (context, stateAllActivities) {
                                  return StreamBuilder<bool>(
                                    initialData: false,
                                    stream: _controller.stream,
                                    builder: (context, snapshot) {
                                      toYou = snapshot.data;
                                      if (!snapshot.data) if (stateAllActivities
                                          is ActivityLoaded) {
                                        count = stateAllActivities
                                            .allActivities.length;
                                        // if (!scrollController.hasListeners)
                                        //   scrollController.addListener(() {
                                        //     if (scrollController.position.pixels ==
                                        //         scrollController
                                        //             .position.maxScrollExtent) {
                                        //       page++;
                                        //       if (stateAllActivities.hasMoreData &&
                                        //           !loading) {
                                        //         loading = true;
                                        //         ScaffoldMessenger.of(context)
                                        //             .showSnackBar(
                                        //           SnackBar(
                                        //             duration:
                                        //                 Duration(milliseconds: 500),
                                        //             content: Text(
                                        //                 'Loading more activities...'),
                                        //           ),
                                        //         );
                                        //         BlocProvider.of<ActivityCubit>(
                                        //                 context)
                                        //             .loadMoreActivities(
                                        //                 stateAllActivities,
                                        //                 {
                                        //                   "status": filterValue.keys
                                        //                                   .toList()[
                                        //                               currentIndex] ==
                                        //                           "Assigned"
                                        //                       ? "pending"
                                        //                       : filterValue.keys
                                        //                               .toList()[
                                        //                           currentIndex]
                                        //                 },
                                        //                 page)
                                        //             .then((value) {
                                        //           // scrollController.jumpTo(0);
                                        //           setState(() {
                                        //             loading = false;
                                        //           });
                                        //         });
                                        //       } else if (!stateAllActivities
                                        //           .hasMoreData) {
                                        //         ScaffoldMessenger.of(context)
                                        //             .showSnackBar(
                                        //           SnackBar(
                                        //             duration:
                                        //                 Duration(milliseconds: 500),
                                        //             content: Text(
                                        //                 'All activities are loaded.'),
                                        //           ),
                                        //         );
                                        //       }
                                        //     }
                                        //   });
                                        return TeachersFeed(
                                          stateAllActivities.allActivities
                                              .toList(),
                                          false,
                                          saved: true,
                                        );
                                      } else {
                                        if (stateAllActivities
                                            is ActivityFilterLoading) {
                                          return Center(child: loadingBar);
                                        } else {
                                          BlocProvider.of<ActivityCubit>(
                                                  context,
                                                  listen: false)
                                              .loadActivities('homepage', {
                                            "status": filterValue.keys.toList()[
                                                        currentIndex] ==
                                                    "Assigned"
                                                ? "pending"
                                                : filterValue.keys
                                                    .toList()[currentIndex]
                                          });
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }
                                      else {
                                        return BlocBuilder<
                                            AssignedActivitiesCubit,
                                            AssignToYouStates>(
                                          builder: (context, state) {
                                            if (state
                                                is AssignedActivitiesLoaded) {
                                              // if (!scrollController2.hasListeners)
                                              //   scrollController2.addListener(() {
                                              //     if (scrollController2
                                              //             .position.pixels ==
                                              //         scrollController2.position
                                              //             .maxScrollExtent) {
                                              //       page++;
                                              //       if (state.hasMoreData &&
                                              //           !loading) {
                                              //         loading = true;
                                              //         ScaffoldMessenger.of(context)
                                              //             .showSnackBar(
                                              //           SnackBar(
                                              //             duration: Duration(
                                              //                 milliseconds: 500),
                                              //             content: Text(
                                              //                 'Loading more activities...'),
                                              //           ),
                                              //         );
                                              //         BlocProvider.of<
                                              //                     AssignedActivitiesCubit>(
                                              //                 context)
                                              //             .loadMoreAssignedActivities(
                                              //                 state,
                                              //                 filterValue.keys.toList()[
                                              //                             currentIndex] ==
                                              //                         "Assigned"
                                              //                     ? "pending"
                                              //                     : filterValue.keys
                                              //                             .toList()[
                                              //                         currentIndex],
                                              //                 page)
                                              //             .then((value) {
                                              //           // scrollController.jumpTo(0);
                                              //           setState(() {
                                              //             loading = false;
                                              //           });
                                              //         });
                                              //       } else if (!state.hasMoreData) {
                                              //         ScaffoldMessenger.of(context)
                                              //             .showSnackBar(
                                              //           SnackBar(
                                              //             duration: Duration(
                                              //                 milliseconds: 500),
                                              //             content: Text(
                                              //                 'All activities are loaded.'),
                                              //           ),
                                              //         );
                                              //       }
                                              //     }
                                              //   });
                                              // // activityController.add(_activities);
                                              return TeachersFeed(
                                                state.activities,
                                                true,
                                                saved: true,
                                              );
                                            } else if (stateAllActivities
                                                is ActivityFilterLoading) {
                                              return Center(child: loadingBar);
                                            } else {
                                              // getAssignedActivities(context);
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // body: Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   margin: EdgeInsets.only(top: 10),
                    //   child: SingleChildScrollView(
                    //     child: Column(
                    //       children: [
                    //         Container(
                    //           // height: 40,
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               TextField(
                    //                 decoration: InputDecoration(
                    //                   contentPadding: EdgeInsets.only(left: 20),
                    //                   border: OutlineInputBorder(
                    //                     borderRadius: BorderRadius.circular(50),
                    //                   ),
                    //                   prefixIcon: Icon(Icons.search),
                    //                   // labelText: 'Search',
                    //                   // helperText: 'Search',
                    //                   hintText: 'Search',
                    //                 ),
                    //               ).expandFlex(4),
                    //               SvgPicture.asset(
                    //                 'assets/svg/menu-feed.svg',
                    //                 color: Color(0xffFF5A79),
                    //               ).expand,
                    //             ],
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ),
                ),
              ),
            )
        )
    );

  }

  Future<void> loadActivities(BuildContext context) {
    return BlocProvider.of<ActivityCubit>(context, listen: false)
        .loadActivities(
      'refresh',
      {
        "status": ["Assigned", "Pending"]
                .contains(filterValue.keys.toList()[currentIndex])
            ? "Pending"
            : filterValue.keys.toList()[currentIndex]
      },
    );
  }

  Future<void> getAssignedActivities(BuildContext context) {
    var status = filterValue.keys.toList()[currentIndex].split(' ');
    if (status.length >= 2) status.removeLast();
    var _status = status.join(' ');
    return BlocProvider.of<AssignedActivitiesCubit>(context, listen: false)
        .getAssignedActivities(["Assigned", "Pending"]
                .contains(filterValue.keys.toList()[currentIndex])
            ? "Pending"
            : _status.toLowerCase().toTitleCase());
  }

  Widget homePageFilterCard({
    String title,
    Map<String, dynamic> values,
    int value,
  }) {
    Color color = values["color"];
    int count = values["count"];
    return InkWell(
      onTap: () {
        log(filterValue.toString());
        page = 1;
        setState(() {
          currentIndex = value;
        });
        if (!toYou) {
          loadActivities(context);
        } else {
          getAssignedActivities(context);
        }
      },
      child: Container(

        margin: EdgeInsets.only(right: 4),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          '${title ?? 'Pending'}${count == null || count == 0 ? '' : '($count)'}',
          style: buildTextStyle(
            size: 14,
            color: value == currentIndex
                ? Colors.white
                : color ?? Color(0xffEB5757),
          ),
        ),
        decoration: BoxDecoration(
          color: value == currentIndex ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color ?? Color(0xffEB5757)),
        ),
      ),
    );
  }

  void _checkVersion() async {
    var newVersion;

      newVersion = NewVersion(
        androidId: "com.snapchat.android",
      );

    var  status;
    try {
      status = await newVersion.getVersionStatus();
    }  catch (e) {
      log('error new versioin'+e.toString());
    }
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: "UPDATE!!!",
      dismissButtonText: "Skip",
      dialogText: "Please update the app from " + "${'status.localVersion'}" + " to " + "${"status.storeVersion"}",
      dismissAction: () {
        SystemNavigator.pop();
      },
      updateButtonText: "Lets update",
    );

  }

}

class AddTaskPanel extends StatefulWidget {
  const AddTaskPanel({
    Key key,this.institute,
  }) : super(key: key);

  final Institute institute;

  @override
  State<AddTaskPanel> createState() => _AddTaskPanelState();
}

class _AddTaskPanelState extends State<AddTaskPanel> {
  static double height = 500;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          // height: 650,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  'Add Task',
                  style: buildTextStyle(),
                ),
              ),
              CreateTask(
                name: 'Announcement',
                svgUrl: 'assets/svg/promotion.svg',
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(pageWidget: CreateAnnouncement()),
                  );
                },
              ),
              if (features['livePoll']['isEnabled'])
                 CreateTask(
                   onCreate: (){
                     height+=55;
                     setState(() {

                     });
                   },
                  name: 'Live Poll',
                  svgUrl: 'assets/svg/polling.svg',
                  onPressed: () {
                    Navigator.of(context).push(
                      createRoute(pageWidget: CreateLivePoll()),
                    );
                  },
                ),
              if(features['Test']['isEnabled'])
              CreateTask(
                onCreate: (){
                  height+=55;
                  setState(() {

                  });
                },
                name: 'Event',
                svgUrl: 'assets/svg/add-event.svg',
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(pageWidget: CreateEvent()),
                  );
                },
              ),
              if(features['Test']['isEnabled'])
              CreateTask(
                name: 'Test/Question Paper',
                svgUrl: 'assets/svg/question.svg',
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(pageWidget: MultiBlocProvider(child: QuestionPaperPage(),
                    providers: [
                      // BlocProvider(create: (context)=> QuestionPaperCubit()..loadAllQuestionPapers(limit: 5,page: 1,isEvaluate: false)),
                      BlocProvider(create: (context)=> TestModuleClassCubit()..loadAllClasses()),

                    ],
                    )),
                  );
                },
              ),
              if(features['assignment']['isEnabled'])
              CreateTask(
                name: 'Assignment',
                svgUrl: 'assets/svg/assignment.svg',
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: MultiBlocProvider(
                        providers: [
                          BlocProvider<ClassDetailsCubit>(
                            create: (context) =>
                                ClassDetailsCubit()..loadClassDetails(),
                          ),
                          BlocProvider<SubjectDetailsCubit>(
                            create: (context) => SubjectDetailsCubit()
                              ..loadAssignmentSubjectDetails(),
                          ),
                        ],
                        child: CreateAssignment(),
                      ),
                    ),
                  );
                },
              ),
              if (features['checkList']['isEnabled'])
                CreateTask(
                  name: 'Check list (To Do)',
                  svgUrl: 'assets/svg/checklist.svg',
                  onPressed: () {
                    Navigator.of(context).push(
                      createRoute(pageWidget: CreateCheckList()),
                    );
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Quick Access',
                      style: buildTextStyle(
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              CreateTask(
                name:  'Create Group',
                onPressed: () {
                  BlocProvider.of<GroupCubit>(context).loadGroups();
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: CreateGroupPage(),
                    ),
                  );
                },
              ),
              CreateTask(
                name: 'Join Class',
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: BlocProvider(
                          create: (context) => ScheduleClassCubit()
                            ..getAllClass(
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                context),
                          child: ClassSchedule()),
                    ),
                  );
                },
              ),
              if(features['Test']['isEnabled'])
              CreateTask(
                name: 'Evaluate Test',
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: TestListingPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateTask extends StatelessWidget {
  const CreateTask({
    @required this.name,
    @required this.onPressed,
    this.svgUrl,
    this.imageUrl,
    this.onCreate,
  });

  final String name;
  final String svgUrl;
  final String imageUrl;
  final Function onPressed;
  final Function onCreate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (svgUrl == null && imageUrl == null) Spacer(),
            if (svgUrl != null) SvgPicture.asset(svgUrl),
            if (imageUrl != null) Image.asset(imageUrl),
            Text(
              name,
              style: buildTextStyle(weight: FontWeight.w600),
            )
          ],
        ),
        color: Color(0xffF0F4FC),
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        margin: EdgeInsets.symmetric(vertical: 5),
        height: 55,
      ),
    );
  }
}