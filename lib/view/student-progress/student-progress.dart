import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/model/class-schedule.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/export.dart';
import '/view/student-progress/student-profile-page.dart';

class StudentsProgressPage extends StatefulWidget {
  final String classId;
  final String className;
  final ClassSection section;
  StudentsProgressPage({
    this.classId,
    this.section,
    this.className,
  });

  @override
  _StudentsProgressPageState createState() => _StudentsProgressPageState();
}

class _StudentsProgressPageState extends State<StudentsProgressPage> {
  double totalTaskProgress = 0;
  int studentsLength = 0;
  double totalTestProgress = 0;
  int page = 1;
  ScrollController scrollController = ScrollController();
  List<Activity> activity;
  final studentPagingController =
  PagingController<int, StudentInfo>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    studentPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    final newItems =
    await BlocProvider.of<LearningClassCubit>(context).getStudents(
      classId: widget.classId,
      sectionId: widget.section.id,
      limit: 10,
      page: pageKey,
    );
    final isLastPage = newItems.length < 10;
    if (isLastPage) {
      studentPagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + 1;
      studentPagingController.appendPage(newItems, nextPageKey);
    }
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                color: Colors.black,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text(
              'Progress - ${widget.className} - ${widget.section.name}',
              style: buildTextStyle(),
            ),
          ),
          body: SafeArea(
            child:  Container(
              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text(
                                      'Total Students: ${widget.section.studentCount}'
                                      //         '${state.students.firstWhere(
                                      //   (element) => element.totalStudent != null,
                                      //   orElse: () {
                                      //     return StudentInfo(totalStudent: 0);
                                      //   },
                                      // ).totalStudent}'
                                      )),
                              // Expanded(
                              //   child: ListView.separated(
                              //     controller: scrollController,
                              //     separatorBuilder: (context, index) =>
                              //         const SizedBox(
                              //       height: 15,
                              //     ),
                              //     // shrinkWrap: true,
                              //     itemCount: state.students.length,
                              //     itemBuilder: (context, index) {
                              //       // var studentProgress = getAllProgress(
                              //       //         activityState.allActivities,
                              //       //         state.students[index]) *
                              //       //     100;
                              //
                              //       // var studentTestProgress = getTestProgress(
                              //       //         activityState.allActivities,
                              //       //         state.students[index]) *
                              //       //     100;
                              //
                              //       return ListTile(
                              //         onTap: () {
                              //           Navigator.of(context).push(
                              //             createRoute(
                              //               pageWidget: MultiBlocProvider(
                              //                 providers: [
                              //                   BlocProvider(
                              //                     create: (context) =>
                              //                         FeedBackCubit()
                              //                           ..getFeedback(state
                              //                               .students[index].id),
                              //                   ),
                              //                   BlocProvider(
                              //                     create: (context) =>
                              //                         ScheduleClassCubit()
                              //                           ..getAllClass(
                              //                               '', context),
                              //                   ),
                              //                   BlocProvider(
                              //                     create: (context) =>
                              //                         RewardStudentCubit()
                              //                           ..loadRewardStudent(state
                              //                               .students[index].id),
                              //                   ),
                              //                 ],
                              //                 child: StudentProfilePage(
                              //                   student: state.students[index],
                              //                   className: widget.className,
                              //                 ),
                              //               ),
                              //             ),
                              //           );
                              //         },
                              //         leading: TeacherProfileAvatar(
                              //           imageUrl:
                              //               state.students[index].profileImage ??
                              //                   'text',
                              //         ),
                              //         title: Text(
                              //           '${state.students[index].name}',
                              //           style: buildTextStyle(size: 16),
                              //         ),
                              //         subtitle: RichText(
                              //           text: TextSpan(
                              //             children: [
                              //               TextSpan(
                              //                 text:
                              //                     'Tasks ${state.students[index].studentProgress.toStringAsFixed(2)}%',
                              //                 style: buildTextStyle(
                              //                   size: 13,
                              //                   color: state.students[index]
                              //                               .studentProgress <=
                              //                           70
                              //                       ? Color(0xffff5a79)
                              //                       : Color(0xff4DC591),
                              //                 ),
                              //               ),
                              //               // TextSpan(
                              //               //   text: ' | ',
                              //               //   style: buildTextStyle(
                              //               //       color: Color(0xffFFC30A)),
                              //               // ),
                              //               // TextSpan(
                              //               //   text: 'Tests 0%',
                              //               //   style: buildTextStyle(
                              //               //     size: 13,
                              //               //     color: 0 <= 70
                              //               //         ? Color(0xffff5a79)
                              //               //         : Color(0xff4DC591),
                              //               //   ),
                              //               // ),
                              //             ],
                              //           ),
                              //         ),
                              //         trailing: Icon(Icons.navigate_next),
                              //       );
                              //
                              //       // return Container(
                              //       //   height: 70,
                              //       //   child: Row(
                              //       //     children: [
                              //       //       Container(
                              //       //         padding: EdgeInsets.all(5),
                              //       //         margin: EdgeInsets.only(right: 5),
                              //       //         decoration: BoxDecoration(
                              //       //             color: Color(0xff6FCF97),
                              //       //             borderRadius: BorderRadius.circular(10),
                              //       //             boxShadow: [
                              //       //               BoxShadow(
                              //       //                   blurRadius: 2,
                              //       //                   color: Color(0xff6FCF97),
                              //       //                   spreadRadius: 2),
                              //       //             ]),
                              //       //         child: Column(
                              //       //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //       //           children: [
                              //       //             Text(
                              //       //               'Class 7A',
                              //       //               style: buildTextStyle(size: 16),
                              //       //             ),
                              //       //             Text(
                              //       //               '27 state.students',
                              //       //               style:
                              //       //                   buildTextStyle(size: 13, color: Colors.white),
                              //       //             ),
                              //       //           ],
                              //       //         ),
                              //       //       ).expandFlex(2),
                              //       //       Container(
                              //       //         padding: EdgeInsets.all(5),
                              //       //         child: Column(
                              //       //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //       //           crossAxisAlignment: CrossAxisAlignment.start,
                              //       //           children: [
                              //       //             Row(
                              //       //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //       //               children: [
                              //       //                 Text(
                              //       //                   'Tasks',
                              //       //                   style: buildTextStyle(
                              //       //                       size: 13, weight: FontWeight.w200),
                              //       //                 ).expand,
                              //       //                 buildLinearPercentBar(
                              //       //                   percent: 0.7,
                              //       //                 ).expandFlex(4)
                              //       //               ],
                              //       //             ),
                              //       //             Row(
                              //       //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                              //       //               children: [
                              //       //                 Text(
                              //       //                   'Tasks',
                              //       //                   style: buildTextStyle(
                              //       //                       size: 13, weight: FontWeight.w200),
                              //       //                 ).expand,
                              //       //                 buildLinearPercentBar(
                              //       //                         percent: 0.7, color: Color(0xffEB5757))
                              //       //                     .expandFlex(4),
                              //       //               ],
                              //       //             ),
                              //       //           ],
                              //       //         ),
                              //       //       ).expandFlex(5),
                              //       //       Container(
                              //       //         child: Icon(Icons.navigate_next),
                              //       //       ).expand,
                              //       //     ],
                              //       //   ),
                              //       // );
                              //     },
                              //   ),
                              // ),
                              Expanded(child:  Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.635,
                                child: PagedListView<int, StudentInfo>(
                                  // shrinkWrap: false,
                                    pagingController: studentPagingController,
                                    builderDelegate:
                                    PagedChildBuilderDelegate<StudentInfo>(
                                        noItemsFoundIndicatorBuilder: (context){
                                          return Text('No Items');
                                        },
                                        itemBuilder: (context, item, index) {
                                          var _student =  item;
                                          _student.section = widget.section.id;
                                          _student.userInfoClass = widget.classId;
                                          return ListTile(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                createRoute(
                                                  pageWidget: MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                        FeedBackCubit()
                                                          ..getFeedback(
                                                              _student.id),
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
                                                          ..loadRewardStudent(
                                                              _student.id),
                                                      ),
                                                    ],
                                                    child: StudentProfilePage(
                                                      student: _student,
                                                      className: widget.className,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            leading: TeacherProfileAvatar(
                                              imageUrl:
                                             _student.profileImage ??
                                                  'text',
                                            ),
                                            title: Text(
                                              '${_student.name}',
                                              style: buildTextStyle(size: 16),
                                            ),
                                            subtitle: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                    'Tasks ${_student.studentProgress.toStringAsFixed(2)}%',
                                                    style: buildTextStyle(
                                                      size: 13,
                                                      color: _student
                                                          .studentProgress <=
                                                          70
                                                          ? Color(0xffff5a79)
                                                          : Color(0xff4DC591),
                                                    ),
                                                  ),
                                                  // TextSpan(
                                                  //   text: ' | ',
                                                  //   style: buildTextStyle(
                                                  //       color: Color(0xffFFC30A)),
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
                                        })),
                              ))
                            ],
                          ),
            ),
          )),
    );
  }

  // double getAllProgress(List<Activity> activity, StudentInfo student) {
  //   return (activity.getAnnouncementProgress(student).completed +
  //           activity.getEventProgress(student).going +
  //           activity.getLivePollProgress(student).completed +
  //           activity.getCheckListProgress(student).completed) /
  //       activity.length;
  // }

  // double getTestProgress(List<Activity> activity, StudentInfo student) {
  //   return (activity
  //           .where((act) => act.activityType.toLowerCase() == 'assignment')
  //           .toList()
  //           .getAssignmentProgress(student)
  //           .completed) /
  //       activity.length;
  // }

  // getClassProgress() {
  //   state.students.forEach((stud) {
  //     totalTaskProgress += getAllProgress(activity, stud);
  //     totalTestProgress += getTestProgress(activity, stud);
  //   });
  //   Navigator.of(context).pop([
  //     totalTaskProgress / state.studentsLength,
  //     totalTestProgress / state.studentsLength
  //   ]);
  // }
}
