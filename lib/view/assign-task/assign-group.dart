import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/view/attached_files_and_url_slider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../bloc/activity/activity-cubit.dart';
import '../../bloc/class-schedule/class-schedule-cubit.dart';
import '../../bloc/test-module/test-module-cubit.dart';
import '../../const.dart';
import '../../model/test-model.dart';
import '../../model/user.dart';
import 'package:flutter/material.dart';

import '../utils/bottom_bar.dart';
import '../utils/utils.dart';

class AssignToGroupView extends StatefulWidget {
  const AssignToGroupView(
      {Key key, this.files, this.questionPaper, this.task, this.group})
      : super(key: key);

  final task;
  final QuestionPaper questionPaper;
  final List<PlatformFile> files;
  final SingleGroup group;

  @override
  State<AssignToGroupView> createState() => _AssignToGroupViewState();
}

class _AssignToGroupViewState extends State<AssignToGroupView> with SingleTickerProviderStateMixin{

  List<StudentInfo> assignedStudents = [];
  List<String> assignedTeachers = [];
  TabController _tabController;
  bool assignable = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (widget.task.activityType == 'Assignment' || widget.questionPaper != null &&
          _tabController.index != 0) {
        assignable = false;
        Fluttertoast.showToast(
          msg: 'You can\'t assign Assignments',
          timeInSecForIosWeb: 5,
        );
      }
      if(_tabController.index == 0){
        assignable = true;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: assignable ? CustomBottomBar(
            title: 'Select & Publish',
            onPressed: assignedStudents.isEmpty
                ? null
                : () async {
              if(widget.task != null) {
                      checkFunction(widget.task.activityType);
                      await showAssignedDialogue(
                          context, '${widget.task.activityType}');
                    }
                    if (widget.questionPaper != null) {
                checkFunction('');
                await showAssignedDialogue(
                    context, widget.questionPaper.activityType);
              }
              //       else {
              //   checkFunction(widget.task.activityType);
              //   await showAssignedDialogue(
              //       context, '${widget.task.activityType}');
              // }

            }
        )  : Container(height: 0,),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Select Students',
            style: buildTextStyle(weight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
          // bottom: TabBar(
          //   controller: _tabController,
          //   onTap: (value) {
          //   },
          //   // indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
          //   labelColor: Colors.black,
          //   unselectedLabelColor: Colors.grey,
          //   labelStyle: buildTextStyle(size: 15),
          //   isScrollable: true,
          //   indicator: BoxDecoration(
          //     color: Color(0xffFFC30A),
          //     borderRadius: BorderRadius.circular(5),
          //   ),
          //   tabs: [
          //     Container(
          //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //       child: Text('Students'),
          //     ),
          //     Container(
          //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          //       child: Text('Teachers'),
          //     ),
          //   ],
          // ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text(widget.group.name.toTitleCase()),
                leading: CircleAvatar(
                  radius: 20,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/sample.png',
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                onTap: (value) {
                },
                // indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                labelStyle: buildTextStyle(size: 15),
                isScrollable: true,
                indicator: BoxDecoration(
                  color: Color(0xffFFC30A),
                  borderRadius: BorderRadius.circular(5),
                ),
                tabs: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text('Students'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text('Teachers'),
                  ),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: widget.group.groupStudents.isNotEmpty ?
                        Column(
                          children: [
                            CheckboxListTile(
                              title: Text('Select All'),
                              onChanged: (value) {
                                assignedStudents.clear();
                                if (value) {
                                  assignedStudents.addAll(widget.group.groupStudents.map((e) =>
                                      StudentInfo(
                                        name: e.name,
                                        profileImage: e.profileImage,
                                        id: e.id,
                                        parentId: e.parentId,
                                        userInfoClass: e.classId,
                                        section: e.sectionId,
                                        schoolId: widget.group.schoolId
                                      )).toList());
                                } else {
                                  assignedStudents.clear();
                                }
                                setState(() {});
                              },
                              value:
                              widget.group.groupStudents.length == assignedStudents.length,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.59,
                              child: ListView.builder(itemBuilder: (context, index) {

                               StudentInfo student = StudentInfo(
                                 name: widget.group.groupStudents[index].name,
                                 profileImage: widget.group.groupStudents[index].profileImage,
                                 id: widget.group.groupStudents[index].id,
                                 parentId: widget.group.groupStudents[index].parentId,
                                 userInfoClass: widget.group.groupStudents[index].classId,
                                 section: widget.group.groupStudents[index].sectionId,
                                 schoolId: widget.group.schoolId
                               );



                                return CheckboxListTile(
                                  value: assignedStudents.contains(student),
                                  title: Text(
                                    student.name ?? '',
                                    style: buildTextStyle(),
                                  ),
                                  secondary: TeacherProfileAvatar(
                                    imageUrl: '${student.profileImage}',
                                  ),
                                  onChanged:  (value) {
                                    if (value)
                                      assignedStudents.add(student);
                                    else
                                      assignedStudents.removeWhere((e)=>e == student);
                                    setState(() {});
                                  }
                                );

                              },
                              itemCount: widget.group.groupStudents.length,),
                            ),
                          ],
                        ) : Container(height: 0,),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: widget.group.groupUsers.isNotEmpty ?
                        Column(
                          children: [
                            CheckboxListTile(
                              title: Text('Select All'),
                              onChanged: assignable ? (value) {
                                assignedTeachers.clear();
                                if (value) {
                                  assignedTeachers.addAll(widget.group.groupUsers.map((e) =>e.id).toList());
                                } else {
                                  assignedTeachers.clear();
                                }
                                setState(() {});
                              } : null,
                              value:
                              widget.group.groupUsers.length == assignedTeachers.length,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.59,
                              child: ListView.builder(itemBuilder: (context, index) {
                                var teacher = widget.group.groupUsers[index];
                                return CheckboxListTile(
                                    value: assignedTeachers.contains(teacher.id),
                                    title: Text(
                                      teacher.name ?? '',
                                      style: buildTextStyle(),
                                    ),
                                    secondary: TeacherProfileAvatar(
                                      imageUrl: '${teacher.profileImage}',
                                    ),
                                    onChanged: assignable ?  (value) {
                                      if (value)
                                        assignedTeachers.add(teacher.id);
                                      else
                                        assignedTeachers.removeWhere((e)=>e == teacher.id);
                                      setState(() {});
                                    } : null
                                );

                              },
                                itemCount: widget.group.groupUsers.length,),
                            ),
                          ],
                        ) : Container(height: 0,),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  checkFunction(String name) {
    if (widget.questionPaper != null) {
      widget.questionPaper.assignTo = assignedStudents
          .map((e) =>
          TestAssignTo(
            // branch: e.branchId,
            classId: e.userInfoClass,
            schoolId: e.schoolId,
            sectionId: e.section,
            studentId: e.id,
          ))
          .toList();
      BlocProvider.of<QuestionPaperCubit>(context).createQuestionPaper(
        widget.questionPaper,
        Provider
            .of<TimePicker>(context, listen: false)
            .getTimeInSeconds,
      );
      return;
    }
    switch (name) {
      case 'Assignment':
        return context.read<ActivityCubit>().createAssignment(
          assignmentTask: widget.task,
          attachments: widget.files,
          students: assignedStudents,
          teacher: [],
          parents: [],
        );
        break;
      case 'Announcement':
        return context.read<ActivityCubit>().createAnnouncement(
          assignmentTask: widget.task,
          attachments: widget.files,
          students: assignedStudents,
          teacher: assignedTeachers,
          parents: [],
        );
        break;
      case 'LivePoll':
        return context.read<ActivityCubit>().createLivePoll(
          assignmentTask: widget.task,
          attachments: widget.files,
          students: assignedStudents,
          teacher: assignedTeachers,
          parents: [],
        );
        break;
      case 'Event':
        return context.read<ActivityCubit>().createEvent(
          assignmentTask: widget.task,
          attachments: widget.files,
          students: assignedStudents,
          teacher: assignedTeachers,
          parents: [],
        );
        break;
      case 'Check List':

        return context.read<ActivityCubit>().createCheckList(
          assignmentTask: widget.task,
          attachments: widget.files,
          students: assignedStudents,
          teacher: assignedTeachers,
          parents: [],
        );
        break;
      case 'class':

        return context.read<ScheduleClassCubit>().createClass(
          widget.task,
          assignedStudents: assignedStudents,
          files: widget.files,
          teacher: [],
        );
      case 'question':
        return BlocProvider.of<QuestionPaperCubit>(context).createQuestionPaper(
          widget.task,
          Provider
              .of<TimePicker>(context, listen: false)
              .getTime,
        );
    }
  }
}
