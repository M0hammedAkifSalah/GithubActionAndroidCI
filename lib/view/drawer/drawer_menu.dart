
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/app-config.dart';
import 'package:growonplus_teacher/bloc/innovations/innovations-cubit.dart';
import 'package:growonplus_teacher/view/attendance/attendance_class_list.dart';
import 'package:growonplus_teacher/view/drawer/saved.dart';
import 'package:growonplus_teacher/view/innovations/innovations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../test-module/questions.dart';
import '/bloc/admin-mode/admin-mode-cubit.dart';

import '/export.dart';

import '/view/doubts/doubts.dart';
import '/view/drawer/admin-activity.dart';
import '/view/drawer/admin-teacher.dart';
import '/view/drawer/evaluate-teacher.dart';
import '/view/drawer/forwarded.dart';
import '/view/profile/teacher-profile-page.dart';
import '/view/schedule_class/class-schedule.dart';
import '/view/startup/pin-forgot-page.dart';
import '/view/startup/welcome-add-account-page.dart';
import '/view/student-progress/class-progress.dart';
import '/view/student-progress/school-progress.dart';

final PanelController panelController = PanelController();

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  bool init = true;


  @override
  void initState() {
    super.initState();

  }

  Future<String> getName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String name = _prefs.getString('user-name');
    return name ?? 'Name Not Found';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (init) {
    //   if (widget.user.profileType.toLowerCase() == 'principal') {
    //     _options.insert(1,_MenuOptions(
    //       imageUrl: 'assets/images/students.png',
    //       name: 'My School',
    //       onPressed: (context){}
    //     ),);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return SlidingUpPanel(
      controller: panelController,
      maxHeight: 300,
      minHeight: 0,
      backdropTapClosesPanel: true,
      backdropEnabled: true,
      backdropOpacity: 0.5,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      panel: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Admin Mode',
              style: buildTextStyle(
                color: Colors.black,
                weight: FontWeight.bold,
                size: 25,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              onPressed: () {
                BlocProvider.of<AdminModeCubit>(context).enableAdminMode();
                BlocProvider.of<ActivityCubit>(context)
                    .loadAdminActivities('drawer', {
                  "\$or": [
                    {"assignTo.status": "Pending"},
                    {"assignTo_you.status": "Pending"},
                    {"assignTo_parent.status": "Pending"}
                  ]
                });
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: AdminActivityPage(school: true),
                  ),
                );
              },
              child: ListTile(
                title: Text('School\'s Activity'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 2,
              height: 40,
            ),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              onPressed: () {
                BlocProvider.of<AdminModeCubit>(context).enableAdminMode();
                BlocProvider.of<SchoolTeacherCubit>(context)
                    .emit(SchoolTeacherLoading());
                Navigator.of(context).push(
                  createRoute(pageWidget: SelectTeacherAdminPage()),
                );
              },
              child: ListTile(
                leading: Image.asset('assets/images/students.png'),
                title: Text('My Teachers'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Scaffold(
        appBar: AppBar(
          title: appMarker(),
          automaticallyImplyLeading: false,
          centerTitle: false,
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
        ),
        body: SafeArea(
          child:
              BlocBuilder<AuthCubit, AuthStates>(builder: (context, snapshot) {
            if (snapshot is AccountsLoaded) {
              // var _index = 0;
              if (snapshot.users[0].profileType.roleName.toLowerCase() ==
                  'teacher')
                _options.removeWhere((menu) => menu.name == 'School');
              return Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menu',
                        style: buildTextStyle(
                          size: 24,
                          weight: FontWeight.w600,
                        ),
                      ),
                      FutureBuilder<String>(
                        future: getName(),
                        builder: (context, snapshot) => ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              createRoute(pageWidget: TeacherProfilePage()),
                            );
                          },
                          title: Text(
                            snapshot.hasData ? snapshot.data.toTitleCase() : '',
                            style: buildTextStyle(
                              size: 18,
                              weight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            'See your Profile',
                            style: buildTextStyle(
                              size: 14,
                            ),
                          ),
                          leading: TeacherProfileAvatar(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 3 / 2,
                            crossAxisCount: screenwidth > 600 ? 5 : 2,
                            mainAxisSpacing: 12,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                _options[index].onPressed(context);
                              },
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Image.asset(
                                        _options[index].imageUrl,
                                        height: 30,
                                      ),
                                      Text(
                                        _options[index].name,
                                        style: buildTextStyle(size: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          itemCount: _options.length,
                        ),
                      ),
                      // ListTile(
                      //   leading: CircleAvatar(
                      //     radius: 14,
                      //     backgroundColor: Colors.transparent,
                      //     child: Image.asset('assets/images/help.png'),
                      //   ),
                      //   title: Text(
                      //     'Help & Support',
                      //     style: buildTextStyle(
                      //       size: 16,
                      //       weight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              pageWidget: BlocProvider(
                                create: (context) =>
                                    AuthCubit()..sendOTP(snapshot.user),
                                child: SetupPinOtpPage(snapshot.user),
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/images/settings.png'),
                        ),
                        title: Text(
                          'Change Pin',
                          style: buildTextStyle(
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          BlocProvider.of<AuthCubit>(context, listen: false)
                              .logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => WelcomeAddAccountPage(),
                            ),
                            (route) => false,
                          );
                        },
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/images/logout.png'),
                        ),
                        title: Text(
                          'Log Out',
                          style: buildTextStyle(
                            size: 16,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                        ),
                        title: FutureBuilder<String>(
                          initialData: '',
                          future: getVersionNumber(),
                          builder: (context, snapshot) {
                            // TODO change version here
                            return Text(
                              'v ${snapshot.data}',
                              style: buildTextStyle(
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              BlocProvider.of<AuthCubit>(context).checkAuthStatus();
              return Center(
                child: loadingBar,
              );
            }
          }),
        ),
      ),
    );
  }

  final List<_MenuOptions> _options = [
    _MenuOptions(
      name: 'School',
      onPressed: (context) {
        Navigator.of(context).push(
          createRoute(
            pageWidget: BlocBuilder<AuthCubit,AuthStates>(
              builder: (context,state) {
                if(state is AccountsLoaded)
                  {
                    if(state.user.isAuthorized)
                    BlocProvider.of<SessionReportCubit>(context).getSchoolSessionReport( state.user.schoolId.institute.id).then((value) {

                    });
                  }
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                    create: (context) =>
                  ClassDetailsCubit()..loadClassDetails(removeCheck: true)),
                  BlocProvider(
                  create: (context) =>
                  AuthCubit()..checkAuthStatus()),

                  ],
                  child:SchoolProgressPage()
                );
              }
            ),
          ),
        );
      },
      imageUrl: 'assets/images/students.png',
    ),
    if(features['myStudents']['isEnabled'])
    _MenuOptions(
      name: 'My Students',
      onPressed: (context) {
        Navigator.of(context).push(
          createRoute(
            pageWidget: BlocProvider(
              create: (context) => ClassDetailsCubit()..loadClassDetails(),
              child: ClassProgressPage(),
            ),
          ),
        );
      },
      imageUrl: 'assets/images/students.png',
    ),
    if (features['attendance']['isEnabled'])
      _MenuOptions(
        name: 'Attendance',
        onPressed: (context) {
          DateTime currentdate = DateTime.now();
          Navigator.of(context).push(
            createRoute(
              pageWidget: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        ClassDetailsCubit()..loadClassDetails(),
                  ),
                  // BlocProvider(
                  //   create: (context) => AttendanceCubit()
                  //     ..getAttendanceByDate(AttendanceByDate(
                  //         date: DateTime(currentdate.year, currentdate.month,
                  //             currentdate.day))),
                  // ),
                ],
                child: AttendanceClassList(date: DateTime.now()),
              ),
            ),
          );
        }     ,
        imageUrl: 'assets/images/attendance.png',
      ),
    if(features['Test']['isEnabled'])
      _MenuOptions(
        name: 'Tests',
        imageUrl: 'assets/images/add_task.png',
        onPressed: (context) {
          Navigator.of(context).push(
            createRoute(pageWidget: MultiBlocProvider(child: QuestionPaperPage(),
            providers: [
              // BlocProvider(create: (context)=> QuestionPaperCubit()..loadAllQuestionPapers(isEvaluate: false,limit: 5,page: 1)),
              BlocProvider(create: (context)=> TestModuleClassCubit()..loadAllClasses()),

            ],
            )),
          );
        },
      ),

    _MenuOptions(
      name: 'Add Tasks',
      onPressed: (context) {
        Navigator.of(context).pop(true);
      },
      imageUrl: 'assets/images/add_task.png',
    ),
    if(features['doubts']['isEnabled'])
    _MenuOptions(
      name: 'Doubts',
      onPressed: (context) {
        BlocProvider.of<ActivityCubit>(context).loadActivities('doubts page', {
          "activity_status": ["cleared", "uncleared"]
        });
        Navigator.of(context).push(
          createRoute(
            pageWidget: DoubtsPage(),
          ),
        );
      },
      imageUrl: 'assets/images/doubts.png',
    ),

    if (features['innovation']['isEnabled'])
      _MenuOptions(
        name: 'Innovations',
        onPressed: (context) {
          Navigator.of(context).push(
            createRoute(
              pageWidget: MultiBlocProvider(providers: [
                BlocProvider(
                  create: (context) => InnovationCubit()..loadInnovations(),
                ),
                BlocProvider(
                  create: (context) => CurrentInnovationCubit(),
                ),
              ], child: Innovations()),
            ),
          );
        },
        imageUrl: 'assets/images/innovations.png',
      ),
    _MenuOptions(
      name: 'Create Class',
      onPressed: (context) {
        Navigator.of(context).push(
          createRoute(
            pageWidget: BlocProvider(
              create: (context) => ScheduleClassCubit(),
              child: ClassSchedule(),
            ),
          ),
        );
      },
      imageUrl: 'assets/images/create_class.png',
    ),

    if(features['learning']['isEnabled'])
      _MenuOptions(
        name: 'Learnings',
        onPressed: (context) {
          Navigator.of(context).push(
            createRoute(
              pageWidget: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => LearningClassCubit()..getClasses(),
                  ),
                  BlocProvider(
                    create: (context) => LearningDetailsCubit(),
                  ),
                ],
                child: LearningsPage(),
              ),
            ),
          );
        },
        imageUrl: 'assets/images/learnings.png',
      ),
    _MenuOptions(
      name: 'Evaluate',
      onPressed: (context) {
        Navigator.of(context).push(
          createRoute(pageWidget: EvaluatePage()),
        );
      },
      imageUrl: 'assets/images/evaluate.png',
    ),
    if(features['forwarded']['isEnabled'])
    _MenuOptions(
      name: 'Forwarded',
      onPressed: (BuildContext context) {
        Navigator.of(context).push(
          createRoute(
            pageWidget: ForwardedPage(),
          ),
        );
      },
      imageUrl: 'assets/images/forward.png',
    ),
    if (features['saved']['isEnabled'])
      _MenuOptions(
        name: 'Saved',
        onPressed: (context) {
          Navigator.of(context).push(
            createRoute(
              pageWidget: MultiBlocProvider(
                child: SavedActivitiesPage(),
                providers: [
                  BlocProvider(
                    create: (context) => AuthCubit()..checkAuthStatus(),),
                  BlocProvider<AssignedActivitiesCubit>(
                    create: (context) => AssignedActivitiesCubit()..getAssignedActivities(''),),
                ],
              ),
            ),
          );
        },
        imageUrl: 'assets/images/saved.png',
      ),
    if (features['adminMode']['isEnabled'])
      _MenuOptions(
        name: 'Admin Mode',
        onPressed: (context) {
          panelController.open();
        },
        imageUrl: 'assets/images/admin.png',
      ),
  ];
}

class _MenuOptions {
  final String name;
  final String imageUrl;
  final Function(BuildContext context) onPressed;

  _MenuOptions({this.imageUrl, this.name, this.onPressed});
}
