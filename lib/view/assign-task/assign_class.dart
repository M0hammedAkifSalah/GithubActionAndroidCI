import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/app-config.dart';
import 'package:growonplus_teacher/view/assign-task/assign-group.dart';

import '/view/assign-task/assign-section.dart';
import '../../export.dart';
import '../../model/class-schedule.dart';

class AssignClass extends StatefulWidget {
  final ScheduledClassTask classes;
  final QuestionPaper questionPaper;
  final List<PlatformFile> files;
  final bool createGroup;
  final dynamic task;
  AssignClass({
    this.classes,
    this.createGroup = false,
    this.task,
    this.files,
    this.questionPaper,
  });
  @override
  _AssignClassState createState() => _AssignClassState();
}

class _AssignClassState extends State<AssignClass> {
  int currentIndex = 0;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100)).then((value) async {
      await BlocProvider.of<GroupCubit>(context).loadGroups();
      await BlocProvider.of<ClassDetailsCubit>(context).loadClassDetails();
      BlocProvider.of<AuthCubit>(context).checkAuthStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Assign To Class',
          style: buildTextStyle(weight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      currentIndex = 0;
                      setState(() {});
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: currentIndex != 0
                            ? Colors.white
                            : Color(0xffFFC30A),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text('Class'),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      currentIndex = 1;
                      setState(() {});
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: currentIndex != 1
                            ? Colors.white
                            : Color(0xffFFC30A),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                          'Group'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              currentIndex == 0
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: buildClassList(),
                    )
                  : BlocBuilder<GroupCubit, GroupStates>(
                      builder: (context, states) {
                      if (states is StudentGroupsLoaded) {
                        var _group = states.group.group;
                        return Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _group.length + 1,
                            itemExtent: 60,
                            itemBuilder: (ctx, index) {
                              if (index == _group.length) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      createRoute(
                                        pageWidget: MultiBlocProvider(
                                          providers: [
                                            BlocProvider<GroupCubit>(
                                              create: (ctx) => GroupCubit(),
                                            ),
                                            BlocProvider<StudentProfileCubit>(
                                              create: (ctx) =>
                                                  StudentProfileCubit()
                                                    ..loadStudentProfile(page: 1,limit: 10),
                                            ),
                                            BlocProvider<ScheduleClassCubit>(
                                              create: (ctx) =>
                                                  ScheduleClassCubit(),
                                            ),
                                          ],
                                          child:
                                          SelectStudents(
                                            createNew: true,
                                            readOnly: false,
                                            // questionPaper: widget.questionPaper,
                                            // files: widget.files,
                                            // task: widget.classes,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  title: Text(
                                      'Create New ${'Group'}'),
                                  leading: const CircleAvatar(
                                    backgroundColor: Color(0xffFFC30A),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: Icon(Icons.navigate_next),
                                );
                              }
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).push(
                                    createRoute(
                                      pageWidget: MultiBlocProvider(
                                          providers: [
                                            BlocProvider<GroupCubit>(
                                              create: (context) => GroupCubit(),
                                            ),
                                          ],
                                          child: AssignToGroupView(
                                            files: widget.files,
                                            group: _group[index],
                                            questionPaper: widget.questionPaper,
                                            task: widget.classes,
                                          )
                                          // SelectStudents(
                                          //   createNew: false,
                                          //   files: widget.files,
                                          //   questionPaper: widget.questionPaper,
                                          //   group: _group[index],
                                          //   students:
                                          //       _group[index].groupPersons,
                                          //   task: widget.classes,
                                          // )
                                      ),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {},
                                ),
                                title: Text(_group[index].name),
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      'assets/images/group-Class.png',
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildClassList() {
    return BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
        builder: (context, state) {
      if (state is ClassDetailsLoaded) {
        print('assign-class: Loading all classes');
        return BlocBuilder<AuthCubit, AuthStates>(builder: (context, state2) {
          if (state2 is AccountsLoaded) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Your mapped classes',
                      style: TextStyle(
                        color: Color(0xffBDBDBD),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  ListView.separated(
                    itemCount: state.classDetails.length +
                        state2.user.secondaryClass.length +
                        1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      if (index == state2.user.secondaryClass.length) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'All classes',
                            style: TextStyle(
                              color: Color(0xffBDBDBD),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        );
                      }
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      var primaryClass = state2.user.classId;
                      var secondaryClass = state2.user.secondaryClass;

                      if (index < secondaryClass.length + 1) {
                        if ((primaryClass.sections[0].id == null ||
                                primaryClass.sections[0].id.isEmpty) &&
                            index == 0) {
                          return ListTile(
                            leading: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(radius: 13, child: Text("!")),
                            ),
                            title: Text(
                              "Primary class or section is not mapped for you.",
                              style: buildTextStyle(
                                color: Colors.grey,
                                size: 12,
                              ),
                            ),
                          );
                        }
                        if ((primaryClass.sections[0].id == null ||
                            primaryClass.sections[0].id.isEmpty)) {
                          return Container();
                        }
                        if ((primaryClass.sections[0].id != null &&
                                primaryClass.sections[0].id.isNotEmpty) &&
                            index == 0) {
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                createRoute(
                                  pageWidget: MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                          create: (context) =>
                                              LearningClassCubit()),
                                      BlocProvider(
                                        create: (context) =>
                                            LearningStudentIdCubit(),
                                      ),
                                    ],
                                    child: SelectStudentForClass(
                                      className: primaryClass.className,
                                      classId: primaryClass.classId,
                                      sectionId: primaryClass.sections[0].id,
                                      sectionName:
                                          primaryClass.sections[0].name,
                                      task: widget.task,
                                      classes: widget.classes,
                                      files: widget.files,
                                      questionPaper: widget.questionPaper,
                                    ),
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                'assets/images/sample.png',
                              ),
                            ),
                            title: Text(
                              "${primaryClass.className} - ${primaryClass.sections[0].name}",
                              style: buildTextStyle(
                                color: Color(0xff3b3b3b),
                              ),
                            ),
                            subtitle: Text(
                              "Primary",
                              style: buildTextStyle(
                                size: 12,
                                color: Colors.green,
                              ),
                            ),
                          );
                        } else if ((primaryClass.classId == null ||
                                primaryClass.classId.isEmpty) &&
                            index == 0) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(radius: 13, child: Text("!")),
                            ),
                            title: Text(
                              "Primary class or section is not mapped for you.",
                              style: buildTextStyle(
                                color: Colors.grey,
                                size: 12,
                              ),
                            ),
                          );
                        } else if (index < secondaryClass.length + 1) {
                          var _secClass = secondaryClass[index - 1];
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                createRoute(
                                  pageWidget: MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                          create: (context) =>
                                              LearningClassCubit()),
                                      BlocProvider(
                                        create: (context) =>
                                            LearningStudentIdCubit(),
                                      ),
                                    ],
                                    child: SelectStudentForClass(
                                      className: _secClass.className,
                                      classId: _secClass.classId,
                                      sectionId: _secClass.sectionId,
                                      sectionName: _secClass.sectionName,
                                      task: widget.task,
                                      classes: widget.classes,
                                      files: widget.files,
                                      questionPaper: widget.questionPaper,
                                    ),
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/sample.png'),
                            ),
                            subtitle: Text(
                              "Secondary",
                              style: buildTextStyle(
                                size: 12,
                                color: Colors.green,
                              ),
                            ),
                            title: Text(
                              "${_secClass.className} - ${_secClass.sectionName}",
                              style: buildTextStyle(
                                color: Color(0xff3b3b3b),
                              ),
                            ),
                          );
                        }
                      }
                      var _class =
                          state.classDetails[index - secondaryClass.length - 1];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              pageWidget: BlocProvider(
                                create: (context) => LearningStudentIdCubit(),
                                child: AssignSection(
                                  sections: _class.sections,
                                  classId: _class.classId,
                                  className: _class.className,
                                  task: widget.task,
                                  classes: widget.classes,
                                  files: widget.files,
                                  questionPaper: widget.questionPaper,
                                ),
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/sample.png'),
                        ),
                        title: Text(
                          _class.className,
                          style: buildTextStyle(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: loadingBar,
            );
          }
        });
        return ListView.separated(
          itemCount: state.classDetails.length,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
          itemBuilder: (context, index) {
            var _class = state.classDetails[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  createRoute(
                      pageWidget: BlocProvider(
                    create: (context) => LearningClassCubit(),
                    child: AssignSection(
                      sections: _class.sections,
                      classId: _class.classId,
                      className: _class.className,
                      classes: null,
                      files: widget.files,
                      questionPaper: null,
                      task: widget.task,
                    ),
                  )),
                );
              },
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/sample.png'),
              ),
              title: Text(
                _class.className,
                style: buildTextStyle(),
              ),
            );
          },
        );
      } else {
        BlocProvider.of<LearningClassCubit>(context).getClasses();
        return Center(
          child: loadingBar,
        );
      }
    });
  }
}

class CheckListTile extends StatelessWidget {
  const CheckListTile({
    this.assignTo,
    this.onChanged,
    this.title,
    this.value,
    this.imageUrl,
    this.assigneeName,
  });

  final StudentInfo assignTo;
  final Function(StudentInfo assign, bool value) onChanged;
  final bool value;
  final String assigneeName;
  final String imageUrl;
  final Widget title;
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (value) {
        onChanged(assignTo, value);
      },
      value: value,
      title: title ??
          Text(
            '$assigneeName',
          ),
      secondary: TeacherProfileAvatar(
        imageUrl: imageUrl,
      ),
    );
  }
}
