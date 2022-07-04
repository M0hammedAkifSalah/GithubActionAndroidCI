import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/model/session-report.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../profile/teacher-profile-page.dart';
import '../../student-progress/student-profile-page.dart';

class InstituteStudentTeacher extends StatefulWidget {
  const InstituteStudentTeacher({Key key, this.sessionSchoolReport})
      : super(key: key);
  final SessionSchoolReport sessionSchoolReport;

  @override
  _InstituteStudentTeacherState createState() =>
      _InstituteStudentTeacherState();
}

class _InstituteStudentTeacherState extends State<InstituteStudentTeacher>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool loadingTeacher = false;
  bool loadingStudent = false;
  // ScrollController teacherController = ScrollController();
  ScrollController studentController = ScrollController();
  int studentPage = 0;
  int teacherPage = 0;
  SchoolTeacherLoaded stateTeacher;
  SessionReportLoadedStudent stateStudents;
  final sessionPagingController1 =
  PagingController<int, SessionReportStudent>(firstPageKey: 0);
  final sessionPagingController2 =
  PagingController<int, SessionReportStudent>(firstPageKey: 0);


  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sessionSchoolReport.schoolName,
              style: buildTextStyle(size: 17.0),
            ),
            Text(
              'Session Progress',
              style: buildTextStyle(size: 12, color: Colors.black87),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 50),
          child: BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
            return TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: buildTextStyle(size: 15),
              isScrollable: true,
              indicator: BoxDecoration(
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     spreadRadius: 3,
                //     blurRadius: 3,
                //   )
                // ],
                color: Color(0xffFFC30A),
                borderRadius: BorderRadius.circular(5),
              ),
              tabs: [
                Tab(
                  text: 'Students',
                ),
                Tab(
                  text: 'Teachers',
                ),
              ],
            );
          }),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: TabBarView(
              controller: _tabController,
              children: [
                StudentListing(schoolId: widget.sessionSchoolReport.schoolId,
                sessionPagingController: sessionPagingController1,),
               TeacherListing(
                 schoolId: widget.sessionSchoolReport.schoolId,
                 sessionPagingController: sessionPagingController2,
               )

              ],
            )
        ),
      ),
    );
  }




  // Widget buildTeacherProgress() {
  //   return StreamBuilder<List<SessionReportStudent>>(
  //       stream: BlocProvider.of<SessionReportTeacherCubit>(context)
  //           .getSessionReportTeachers(schoolId: widget.sessionSchoolReport.schoolId,
  //         isStudent: false,).asStream(),
  //       builder: (context, snapshot) {
  //         return ListView.builder(
  //           itemBuilder: (context,index) {
  //             return ListTile(
  //               onTap: () {
  //                 Navigator.of(context).push(
  //                   createRoute(
  //                     pageWidget: TeacherProfilePage(
  //                       // user: snapshot.data[index],
  //                       sessionReport: snapshot.data[index],
  //                     ),
  //                   ),
  //                 );
  //               },
  //               leading: TeacherProfileAvatar(
  //                 imageUrl: snapshot.data[index].profileImage ?? 'text',
  //               ),
  //               title: Text(
  //                 '${snapshot.data[index].name}',
  //                 style: buildTextStyle(size: 16),
  //               ),
  //               subtitle: RichText(
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text:
  //                       'Tasks ${snapshot.hasData ? snapshot.data[index].avg : 0}%',
  //                       style: buildTextStyle(
  //                         size: 13,
  //                         color: (snapshot.hasData
  //                             ? snapshot.data[index].avg
  //                             : 0) <=
  //                             70
  //                             ? Color(0xffff5a79)
  //                             : Color(0xff4DC591),
  //                       ),
  //                     ),
  //                     // TextSpan(
  //                     //   text: ' | ',
  //                     //   style: buildTextStyle(color: Color(0xffFFC30A)),
  //                     // ),
  //                     // TextSpan(
  //                     //   text: 'Tests 0%',
  //                     //   style: buildTextStyle(
  //                     //     size: 13,
  //                     //     color: 0 <= 70
  //                     //         ? Color(0xffff5a79)
  //                     //         : Color(0xff4DC591),
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               ),
  //               trailing: Icon(Icons.navigate_next),
  //             );
  //           },
  //           itemCount: snapshot.hasData ? snapshot.data.length : 0,
  //         );
  //       });
  //     // // BlocBuilder<SchoolTeacherCubit, SchoolTeacherStates>(
  //     // //   builder: (context, state) {
  //     //     if (state is SchoolTeacherLoaded) {
  //     //       stateTeacher = state;
  //     //       return ListView.separated(
  //     //           controller: teacherController,
  //     //           separatorBuilder: (context, index) => SizedBox(
  //     //             height: 15,
  //     //           ),
  //     //           // shrinkWrap: true,
  //     //           itemCount: state.teachers.length,
  //     //           itemBuilder: (context, index) {
  //     //             return FutureBuilder<List<SessionReportStudent>>(
  //     //                 future: BlocProvider.of<SessionReportTeacherCubit>(context)
  //     //                     .getSessionReportTeachers(schoolId: state.teachers.first.schoolId.id,
  //     //                 isStudent: false,),
  //     //                 builder: (context, snapshot) {
  //     //                   return ListTile(
  //     //                     onTap: () {
  //     //                       Navigator.of(context).push(
  //     //                         createRoute(
  //     //                           pageWidget: TeacherProfilePage(
  //     //                             user: state.teachers[index],
  //     //                             sessionReport: snapshot.data[index],
  //     //                           ),
  //     //                         ),
  //     //                       );
  //     //                     },
  //     //                     leading: TeacherProfileAvatar(
  //     //                       imageUrl: state.teachers[index].profileImage ?? 'text',
  //     //                     ),
  //     //                     title: Text(
  //     //                       '${state.teachers[index].name}',
  //     //                       style: buildTextStyle(size: 16),
  //     //                     ),
  //     //                     // subtitle: RichText(
  //     //                     //   text: TextSpan(
  //     //                     //     children: [
  //     //                     //       TextSpan(
  //     //                     //         text:
  //     //                     //         'Tasks ${snapshot.hasData ? snapshot.data[index].avg : 0}%',
  //     //                     //         style: buildTextStyle(
  //     //                     //           size: 13,
  //     //                     //           color: (snapshot.hasData
  //     //                     //               ? snapshot.data[index].avg
  //     //                     //               : 0) <=
  //     //                     //               70
  //     //                     //               ? Color(0xffff5a79)
  //     //                     //               : Color(0xff4DC591),
  //     //                     //         ),
  //     //                     //       ),
  //     //                     //       // TextSpan(
  //     //                     //       //   text: ' | ',
  //     //                     //       //   style: buildTextStyle(color: Color(0xffFFC30A)),
  //     //                     //       // ),
  //     //                     //       // TextSpan(
  //     //                     //       //   text: 'Tests 0%',
  //     //                     //       //   style: buildTextStyle(
  //     //                     //       //     size: 13,
  //     //                     //       //     color: 0 <= 70
  //     //                     //       //         ? Color(0xffff5a79)
  //     //                     //       //         : Color(0xff4DC591),
  //     //                     //       //   ),
  //     //                     //       // ),
  //     //                     //     ],
  //     //                     //   ),
  //     //                     // ),
  //     //                     trailing: Icon(Icons.navigate_next),
  //     //                   );
  //     //                 });
  //     //           });
  //     //     } else {
  //     //       BlocProvider.of<SchoolTeacherCubit>(context).getAllTeachers();
  //     //       return Container();
  //     //     }
  //     //   // });
  // }
  //
  // Widget buildStudentsProgress() {
  //   return StreamBuilder<List<SessionReportStudent>>(
  //       stream: BlocProvider.of<SessionReportStudentCubit>(context)
  //           .getSessionReportStudents(schoolId: widget.sessionSchoolReport.schoolId,
  //         isStudent: true,).asStream(),
  //       builder: (context, snapshot) {
  //         return ListView.builder(
  //           itemBuilder: (context,index) {
  //             return ListTile(
  //               onTap: () {
  //                 Navigator.of(context).push(
  //                   createRoute(
  //                     pageWidget: TeacherProfilePage(
  //                       // user: snapshot.data[index],
  //                       sessionReport: snapshot.data[index],
  //                     ),
  //                   ),
  //                 );
  //               },
  //               leading: TeacherProfileAvatar(
  //                 imageUrl: snapshot.data[index].profileImage ?? 'text',
  //               ),
  //               title: Text(
  //                 '${snapshot.data[index].name}',
  //                 style: buildTextStyle(size: 16),
  //               ),
  //               subtitle: RichText(
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text:
  //                       'Tasks ${snapshot.hasData ? snapshot.data[index].avg : 0}%',
  //                       style: buildTextStyle(
  //                         size: 13,
  //                         color: (snapshot.hasData
  //                             ? snapshot.data[index].avg
  //                             : 0) <=
  //                             70
  //                             ? Color(0xffff5a79)
  //                             : Color(0xff4DC591),
  //                       ),
  //                     ),
  //                     // TextSpan(
  //                     //   text: ' | ',
  //                     //   style: buildTextStyle(color: Color(0xffFFC30A)),
  //                     // ),
  //                     // TextSpan(
  //                     //   text: 'Tests 0%',
  //                     //   style: buildTextStyle(
  //                     //     size: 13,
  //                     //     color: 0 <= 70
  //                     //         ? Color(0xffff5a79)
  //                     //         : Color(0xff4DC591),
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               ),
  //               trailing: Icon(Icons.navigate_next),
  //             );
  //           },
  //           itemCount: snapshot.hasData ? snapshot.data.length : 0,
  //         );
  //       });
  //
  //   // return BlocBuilder<SessionReportStudentCubit, SessionReportStudentStates>(
  //   //     builder: (context, state) {
  //   //   if (state is SessionReportLoadedStudent) {
  //   //     // if (!studentController.hasListeners)
  //   //       studentController.addListener(() {
  //   //         if (studentController.position.pixels ==
  //   //                 studentController.position.maxScrollExtent &&
  //   //             !loadingStudent) {
  //   //           loadingStudent = true;
  //   //           setState(() {});
  //   //           studentPage += 1;
  //   //           if (state.hasMore) {
  //   //             BlocProvider.of<SessionReportStudentCubit>(context)
  //   //                 .getMoreSessionReportStudents(
  //   //                     state: state,
  //   //                     page: studentPage,
  //   //                     limit: 10,
  //   //                     isStudent: true,
  //   //                     schoolId: widget.sessionSchoolReport.schoolId)
  //   //                 .then((value) {
  //   //               loadingStudent = false;
  //   //               setState(() {});
  //   //             });
  //   //           }
  //   //         }
  //   //       });
  //   //     stateStudents = state;
  //   //     // return Container();
  //   //     return ListView.separated(
  //   //         controller: studentController,
  //   //         separatorBuilder: (context, index) => SizedBox(
  //   //               height: 15,
  //   //             ),
  //   //         // shrinkWrap: true,
  //   //         itemCount: stateStudents.studentsReport.length,
  //   //         itemBuilder: (context, index) {
  //   //           return ListTile(
  //   //             onTap: () async {
  //   //               List<StudentInfo> studentInfo;
  //   //               studentInfo =
  //   //                   await BlocProvider.of<SessionReportTeacherCubit>(context)
  //   //                       .getStudentDetailes(
  //   //                           studentId:
  //   //                               stateStudents.studentsReport[index].id);
  //   //               Navigator.of(context).push(
  //   //                 createRoute(
  //   //                   pageWidget: MultiBlocProvider(
  //   //                     providers: [
  //   //                       BlocProvider(
  //   //                         create: (context) => FeedBackCubit()
  //   //                           ..getFeedback(
  //   //                               stateStudents.studentsReport[index].id),
  //   //                       ),
  //   //                       BlocProvider(
  //   //                         create: (context) =>
  //   //                             ScheduleClassCubit()..getAllClass('', context),
  //   //                       ),
  //   //                       BlocProvider(
  //   //                         create: (context) => RewardStudentCubit()
  //   //                           ..loadRewardStudent(
  //   //                               stateStudents.studentsReport[index].id),
  //   //                       ),
  //   //                     ],
  //   //                     child: StudentProfilePage(
  //   //                       className: studentInfo != null
  //   //                           ? studentInfo[0].className
  //   //                           : null,
  //   //                       student: studentInfo[0],
  //   //                       sessionReport: stateStudents.studentsReport[index],
  //   //                     ),
  //   //                   ),
  //   //                 ),
  //   //               );
  //   //             },
  //   //             leading: TeacherProfileAvatar(
  //   //               imageUrl: stateStudents.studentsReport[index].profileImage ??
  //   //                   'text',
  //   //             ),
  //   //             title: Text(
  //   //               '${stateStudents.studentsReport[index].name}',
  //   //               style: buildTextStyle(size: 16),
  //   //             ),
  //   //             subtitle: RichText(
  //   //               text: TextSpan(
  //   //                 children: [
  //   //                   TextSpan(
  //   //                     text:
  //   //                         'Tasks ${stateStudents.studentsReport[index].avg.toStringAsFixed(2)}%',
  //   //                     style: buildTextStyle(
  //   //                       size: 13,
  //   //                       color: (stateStudents.studentsReport[index]
  //   //                                       .avg ??
  //   //                                   0) <=
  //   //                               70
  //   //                           ? Color(0xffff5a79)
  //   //                           : Color(0xff4DC591),
  //   //                     ),
  //   //                   ),
  //   //                   // TextSpan(
  //   //                   //   text: ' | ',
  //   //                   //   style: buildTextStyle(color: Color(0xffFFC30A)),
  //   //                   // ),
  //   //                   // TextSpan(
  //   //                   //   text: 'Tests 0%',
  //   //                   //   style: buildTextStyle(
  //   //                   //     size: 13,
  //   //                   //     color: 0 <= 70
  //   //                   //         ? Color(0xffff5a79)
  //   //                   //         : Color(0xff4DC591),
  //   //                   //   ),
  //   //                   // ),
  //   //                 ],
  //   //               ),
  //   //             ),
  //   //             trailing: Icon(Icons.navigate_next),
  //   //           );
  //   //         });
  //   //   } else {
  //   //     // BlocProvider.of<SessionReportCubit>(context)..getSessionReportStudents(page: 1,limit: 10,isStudent: true,schoolId: widget.sessionSchoolReport.schoolId);
  //   //     return Container();
  //   //   }
  //   // });
  // }

  Widget noProgress() {
    return Center(
      child: Text('No Data'),
    );
  }
}

class StudentListing extends StatefulWidget {
  const StudentListing({Key key,this.schoolId,this.sessionPagingController}) : super(key: key);
  final String schoolId;
  final PagingController<int, SessionReportStudent> sessionPagingController;

  @override
  State<StudentListing> createState() => _StudentListingState();
}

class _StudentListingState extends State<StudentListing> {


  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await BlocProvider.of<SessionReportStudentCubit>(context)
          .getSessionReportStudents(
        isStudent: true,
        schoolId: widget.schoolId,
        limit: 10,
        page: pageKey,
      );
      final isLastPage = newItems.length < 10;
      if (isLastPage) {
        widget.sessionPagingController.appendLastPage(newItems);
      } else {

        final nextPageKey = pageKey + 1;
        widget.sessionPagingController.appendPage(newItems, nextPageKey);
      }
    }catch(e){
      log(e.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    widget.sessionPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return  PagedListView<int, SessionReportStudent>(
        pagingController: widget.sessionPagingController,
        builderDelegate: PagedChildBuilderDelegate<SessionReportStudent>(
        itemBuilder: (context, item, index) => ListTile(
          onTap: () async {
            List<StudentInfo> studentInfo =  await BlocProvider.of<SessionReportTeacherCubit>(context)
                .getStudentDetailes(
                studentId:item.id);
            Navigator.of(context).push(
              createRoute(
                pageWidget: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                      FeedBackCubit()
                        ..getFeedback(item.id),
                    ),
                    BlocProvider(
                      create: (context) =>
                      ScheduleClassCubit()
                        ..getAllClass(
                            '', context),
                    ),
                    BlocProvider(
                      create: (context) =>
                      RewardStudentCubit()
                        ..loadRewardStudent(item.id),
                    ),
                  ],
                  child: StudentProfilePage(
                    className: studentInfo != null
                        ? studentInfo[0].className
                        : null,
                    student: studentInfo[0],
                    sessionReport: item,
                  ),
                ),
              ),
            );
          },
          leading: TeacherProfileAvatar(
            imageUrl: item.profileImage ?? 'text',
          ),
          title: Text(
            '${item.name}',
            style: buildTextStyle(size: 16),
          ),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                  'Tasks ${item.avg.toStringAsFixed(2) ?? 0}%',
                  style: buildTextStyle(
                    size: 13,
                    color:
                    (item.avg ?? 0 ) <= 70
                        ? Color(0xffff5a79)
                        : Color(0xff4DC591),
                  ),
                ),
                // TextSpan(
                //   text: ' | ',
                //   style: buildTextStyle(color: Color(0xffFFC30A)),
                // ),
                // TextSpan(
                //   text: 'Tests 0%',
                //   style: buildTextStyle(
                //     size: 13,
                //     color: 0 <= 70
                //         ? Color(0xffff5a79)
                //         : Color(0xff4DC591),
                //   ),
                // ),
              ],
            ),
          ),
          trailing: Icon(Icons.navigate_next),
        ),
    ));
  }
}

class TeacherListing extends StatefulWidget {
  const TeacherListing({Key key,this.sessionPagingController,this.schoolId}) : super(key: key);
  final String schoolId;
  final PagingController<int, SessionReportStudent> sessionPagingController;

  @override
  State<TeacherListing> createState() => _TeacherListingState();
}

class _TeacherListingState extends State<TeacherListing> {
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, SessionReportStudent>(
        pagingController: widget.sessionPagingController,
        builderDelegate: PagedChildBuilderDelegate<SessionReportStudent>(
          itemBuilder: (context, item, index) => ListTile(
            onTap: () async{
              UserInfo userInfo = await BlocProvider.of<SchoolTeacherCubit>(context).getUser(item.id);
              Navigator.of(context).push(
                createRoute(
                  pageWidget: TeacherProfilePage(
                    user: userInfo,
                    sessionReport: item,
                  ),
                ),
              );
            },
            leading: TeacherProfileAvatar(
              imageUrl: item.profileImage ?? 'text',
            ),
            title: Text(
              '${item.name}',
              style: buildTextStyle(size: 16),
            ),
            subtitle: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                    'Tasks ${item.avg.toStringAsFixed(2) ?? 0}%',
                    style: buildTextStyle(
                      size: 13,
                      color: (item.avg ?? 0) <=
                          70
                          ? Color(0xffff5a79)
                          : Color(0xff4DC591),
                    ),
                  ),
                  // TextSpan(
                  //   text: ' | ',
                  //   style: buildTextStyle(color: Color(0xffFFC30A)),
                  // ),
                  // TextSpan(
                  //   text: 'Tests 0%',
                  //   style: buildTextStyle(
                  //     size: 13,
                  //     color: 0 <= 70
                  //         ? Color(0xffff5a79)
                  //         : Color(0xff4DC591),
                  //   ),
                  // ),
                ],
              ),
            ),
            trailing: Icon(Icons.navigate_next),
          ),
        ));
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await BlocProvider.of<SessionReportStudentCubit>(context)
          .getSessionReportStudents(
        isStudent: false,
        schoolId: widget.schoolId,
        limit: 10,
        page: pageKey,
      );
      final isLastPage = newItems.length < 10;
      if (isLastPage) {
        widget.sessionPagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        widget.sessionPagingController.appendPage(newItems, nextPageKey);
      }
    }catch(e){
      log(e.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    widget.sessionPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }
}


