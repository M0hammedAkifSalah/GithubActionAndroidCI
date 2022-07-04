import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/app-config.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/view/Institute/Institute%20Progress/school_progress.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


import '../../main.dart';
import '../test-module/TestUtils.dart';
import '/model/task-progress.dart';
import '/view/profile/teacher-profile-page.dart';
import '/view/student-progress/section-progress.dart';
import '/model/session-report.dart';

class SchoolProgressPage extends StatefulWidget {
  const SchoolProgressPage({Key key}) : super(key: key);


  @override
  _SchoolProgressPageState createState() => _SchoolProgressPageState();


}

class _SchoolProgressPageState extends State<SchoolProgressPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int studentPage = 1;


  final teacherPagingController =
  PagingController<int, UserInfo>(firstPageKey: 1);
  String teacherId;


  @override
  void didChangeDependencies() {
      super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // if (!teacherController.hasListeners)
    //   teacherController.addListener(() {
    //     if (teacherController.position.pixels ==
    //             teacherController.position.maxScrollExtent &&
    //         !loadingTeacher) {
    //       loadingTeacher = true;
    //       setState(() {});
    //       studentPage += 1;
    //       log('teacher-current-page: $studentPage');
    //       BlocProvider.of<SchoolTeacherCubit>(context)
    //           .getMoreTeachers(stateTeacher, studentPage.toString())
    //           .then((value) {
    //         loadingTeacher = false;
    //         setState(() {});
    //       });
    //     }
    //   });
    teacherPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    getTeacherId().then((value) {
      teacherId = value;
    });

    _tabController = TabController(vsync: this, length: 3);
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    final newItems =
    await BlocProvider.of<SchoolTeacherCubit>(context).getAllTeachers(
      limit: 10,
      page: pageKey,
    );
    final isLastPage = newItems.length < 10;
    if (isLastPage) {
      teacherPagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + 1;
      teacherPagingController.appendPage(newItems, nextPageKey);
    }
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
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
        title: Text(
          'Progress',
          style: buildTextStyle(),
        ),
        bottom: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width,50),
          child: BlocBuilder<AuthCubit,AuthStates>(
            builder: (context,state) {
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
                 // if(isAuthorized)
                  if(state is AccountsLoaded && state.user.schoolId.institute != null)
                    Tab(text: state.user.schoolId.institute.name,)
                  else
                    Tab(text: '',)
                ],
              );
            }
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: BlocBuilder<AuthCubit,AuthStates>(
            builder: (context,state) {
              return TabBarView(
                controller: _tabController,
                children: [
                  buildStudentsProgress(),
                  buildTeachersList(),
                  // if(isAuthorized)
                  if(state is AccountsLoaded)
                  buildInstituteProgress()
                  else
                    noProgress()
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget buildTeachersList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.635,
      child: PagedListView<int, UserInfo>(
        // shrinkWrap: false,
          pagingController: teacherPagingController,
          builderDelegate:
          PagedChildBuilderDelegate<UserInfo>(
              noItemsFoundIndicatorBuilder: (context){
                return Text('No Items');
              },
              itemBuilder: (context, item, index) {
                var teacher =  item;

                if(teacher.id != teacherId){
                  return StreamBuilder<TotalActivityProgress>(
                      stream: BlocProvider.of<ActivityCubit>(context)
                          .userTotalProgress(teacher.id,
                          teacher: true)
                          .asStream(),
                      builder: (context, snapshot) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              createRoute(
                                pageWidget: TeacherProfilePage(
                                  user: teacher,
                                ),
                              ),
                            );
                          },
                          leading: TeacherProfileAvatar(
                            imageUrl: teacher.profileImage ?? 'text',
                          ),
                          title: Text(
                            '${teacher.name}',
                            style: buildTextStyle(size: 16),
                          ),
                          subtitle: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  'Tasks ${snapshot.hasData ? (snapshot.data.average??0) : 0}%',
                                  style: buildTextStyle(
                                    size: 13,
                                    color: (snapshot.hasData
                                        ? (snapshot.data.average ?? 0)
                                        : 0) <=
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
                        );
                      });
                }else{
                  return Container(height: 0,);
                }
              }),

      ),
    );



  }

  Widget buildStudentsProgress() {
    return BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
      builder: (context, state) {
        if (state is ClassDetailsLoaded)
          return ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: state.classDetails.length,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (context, index) {
              return FutureBuilder<TotalActivityProgress>(
                  future: BlocProvider.of<ActivityCubit>(context)
                      .userTotalProgress(state.classDetails[index].classId,
                          classes: true),
                  builder: (context, snapshot) {
                    return InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                          createRoute(
                            pageWidget: BlocProvider(
                              create: (context) => LearningClassCubit(),
                              child: SectionProgressPage(
                                state.classDetails[index].classId,
                                state.classDetails[index].sections,
                                state.classDetails[index].className,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 70,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: Color(0xff6FCF97),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: Color(0xff6FCF97),
                                      spreadRadius: 2),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    state.classDetails[index].className,
                                    style: buildTextStyle(size: 16),
                                  ),
                                  // Text(
                                  //   '27 Students',
                                  //   style: buildTextStyle(
                                  //       size: 13, color: Colors.white),
                                  // ),
                                ],
                              ),
                            ).expandFlex(2),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Tasks',
                                        style: buildTextStyle(
                                            size: 13, weight: FontWeight.w200),
                                      ).expand,
                                      buildLinearPercentBar(
                                        percent: (snapshot.hasData
                                                ? ((snapshot.data.average??0)/100)
                                                : 0)
                                            ,
                                        lineHeight: 15,
                                        color: (snapshot.hasData
                                                ? ((snapshot.data.average??0) / 100)
                                                : 0 ) >=
                                                0.7
                                            ? null
                                            : Color(0xffEb5757),
                                      ).expandFlex(4)
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceAround,
                                  //   children: [
                                  //     Text(
                                  //       'Tests',
                                  //       style: buildTextStyle(
                                  //           size: 13, weight: FontWeight.w200),
                                  //     ).expand,
                                  //     buildLinearPercentBar(
                                  //       percent: 0,
                                  //       lineHeight: 15,
                                  //       color:
                                  //           0 >= 0.7 ? null : Color(0xffEb5757),
                                  //     ).expandFlex(4),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ).expandFlex(5),
                            Container(
                              child: Icon(Icons.navigate_next),
                            ).expand,
                          ],
                        ),
                      ),
                    );
                  });
            },
          );
        else {
          BlocProvider.of<ClassDetailsCubit>(context)
              .loadClassDetails(removeCheck: true);
          return Center(
            child: loadingBar,
          );
        }
      },
    );
  }

  Widget buildInstituteProgress() {
    return BlocBuilder<SessionReportCubit, SessionReportStates>(
      builder: (BuildContext context, state) {
        if (state is SessionReportLoaded) {
          Map<String, List<SessionSchoolReport>> x =
          groupBy(state.sessionSchoolReport, (obj) => obj.state.stateName);
          // log(x.length.toString());
          x.forEach((key, value) {
            // log(key);
          });
          return ListView.separated(
            padding: EdgeInsets.all(10),
            itemCount: x.length,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (context, index) {
              String key = x.keys.elementAt(index);
              List<SessionSchoolReport> stateSchoolList = x[key];
             var totalAttendedUsers = stateSchoolList.fold(0, (sum, element) => sum + element.attendedUsers);
            var totalSessions = stateSchoolList.fold(0, (sum, element) => sum + element.totalSessions);
            var totalUsers = stateSchoolList.fold(0, (previousValue, element) => previousValue += element.totalUsers);

             var avg = (totalAttendedUsers/totalUsers);
             log(avg.toString()+'avg  ');
                    return InkWell(
                      onTap: () async {
                        Navigator.of(context).push(
                          createRoute(
                            pageWidget: InstituteSchoolsProgress(schoolReport: stateSchoolList),
                          ),
                        );
                      },
                      child: Container(
                        // height: 70,

                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              padding: EdgeInsets.all(5),
                              // margin: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: kColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: kColor,
                                      spreadRadius: 2),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                   key,
                                    style: buildTextStyle(size: 15),
                                  ),
                                  Text(
                                    '${stateSchoolList.length} Schools',
                                    style: buildTextStyle(
                                        size: 13, color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                                .expandFlex(2),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        'Tasks',
                                        style: buildTextStyle(
                                            size: 13, weight: FontWeight.w200),
                                      ).expand,
                                      buildLinearPercentBar(
                                        percent: (avg
                                            ?? 0) /
                                            100,
                                        lineHeight: 15,
                                        color: (avg?? 0) /
                                            100 >=
                                            0.7
                                            ? null
                                            : kColor,
                                      ).expandFlex(4)
                                    ],
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceAround,
                                  //   children: [
                                  //     Text(
                                  //       'Tests',
                                  //       style: buildTextStyle(
                                  //           size: 13, weight: FontWeight.w200),
                                  //     ).expand,
                                  //     buildLinearPercentBar(
                                  //       percent: 0,
                                  //       lineHeight: 15,
                                  //       color:
                                  //           0 >= 0.7 ? null : Color(0xffEb5757),
                                  //     ).expandFlex(4),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ).expandFlex(4),
                            Container(
                              child: Icon(Icons.navigate_next),
                            ).expandFlex(0),
                          ],
                        ),
                      ),
                    );

            },
          );
        } else {

          return Center(
            child: loadingBar,
          );
        }
      },
    );
  }

  Widget noProgress(){
    return Center(
      child: Text('No Data'),
    );
  }
}
