import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/view/assign-task/assign-group.dart';
import 'package:growonplus_teacher/view/test-module/TestUtils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/model/class-schedule.dart';
import '/view/assign-task/assign-section.dart';
import '../../export.dart';

class AssignTask extends StatefulWidget {
  final String title;
  final task;
  // final File image;
  final List<PlatformFile> files;
  final ScheduledClassTask classes;
  final Institute institute;
  final bool isJoinedClass;
  const AssignTask({
    this.title,
    this.files,
    // this.image,
    this.task,
    this.classes,
    this.isJoinedClass,
    this.institute,
  });

  @override
  _AssignTaskState createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask>
    with SingleTickerProviderStateMixin {
  TextEditingController _textEditingControllerStudent;
  List<StudentInfo> assignedStudents = [];
  List<String> assignedTeachers = [];
  List<StudentInfo> assignedParents = [];
  List<StudentInfo> _students = [];
  TabController _tabController;
  bool assignable = true;
  FocusNode focusNode = FocusNode();
  final teacherPagingController =
  PagingController<int, UserInfo>(firstPageKey: 1);
  String teacherId;

  final studentPagingController =
  PagingController<int, StudentInfo>(firstPageKey: 1);



  @override
  void initState() {
    super.initState();
    _textEditingControllerStudent = TextEditingController();

    teacherPagingController.addPageRequestListener((pageKey) {
      _fetchPageTeacher(pageKey);
    });
    studentPagingController.addPageRequestListener((pageKey) {
      _fetchPageStudent(pageKey);
    });

    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      // if (_tabController.index == 1 ||
      //     _tabController.index == 0 ||
      //     _tabController.index == 4) {
      //   assignable = true;
      // }
      assignable = true;
      if (assignedStudents.isNotEmpty &&
          _tabController.index == 3 &&
          _tabController.index == 2) {
        Fluttertoast.showToast(
          msg:
              'If you want to assign task to teacher, selected students will be cleared',
          timeInSecForIosWeb: 5,
        );
      }
      if (widget.task.activityType == 'Assignment' &&
          _tabController.index != 1 &&
          _tabController.index != 3 &&
          _tabController.index != 4 &&
          _tabController.index != 0) {
        assignable = false;
        Fluttertoast.showToast(
          msg: 'You can\'t assign Assignments',
          timeInSecForIosWeb: 5,
        );
      }
      // if (widget.task.activityType == 'class' &&
      //     _tabController.index != 1 &&
      //     _tabController.index != 4 &&
      //     _tabController.index != 0) {
      //   assignable = false;
      //   Fluttertoast.showToast(
      //     msg: 'You can\'t schedule Classes',
      //     timeInSecForIosWeb: 5,
      //   );
      // }
      setState(() {});

      _students.clear();

    });

    getTeacherId().then((value) {
      teacherId = value;
    });

  }

  Future<void> _fetchPageTeacher(int pageKey) async {
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
  Future<void> _fetchPageStudent(int pageKey) async {
    // try {
    final newItems =
    await BlocProvider.of<StudentProfileCubit>(context).loadStudentProfile(
      searchText: _textEditingControllerStudent.text.toString(),
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
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
      // context.watch<AuthCubit>().checkAuthStatus();
      return Scaffold(
        bottomNavigationBar: assignable
            //  ? _tabController.index != 1 && _tabController.index != 3
            ? CustomBottomBar(
                check: assignedParents.isNotEmpty ||
                    assignedStudents.isNotEmpty ||
                    assignedTeachers.isNotEmpty,
                title: 'Assign',
                onPressed: () async {
                  !widget.isJoinedClass
                      ? widget.task.publishedWith = 'You'
                      : null;

                  try {
                    await checkFunction(
                      context,
                      widget.isJoinedClass
                          ? 'joinedClass'
                          : widget.task.activityType,
                      classes: widget.isJoinedClass ? widget.classes : null,
                      questionPaper: null,
                      task: !widget.isJoinedClass ? widget.task : null,
                      files: widget.files,
                      assignedParents: assignedParents,
                      assignedStudents: assignedStudents,
                      assignedTeachers: assignedTeachers,
                    );
                  }  catch (e) {
                    log('Error Aga'+ e.toString());
                  }
                  // showAssignedDialogue(context, 'Task');
                },
              )
            : Container(
                height: 0,
              ),
        // : Container(
        //     height: 0,
        //   ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          bottom: TabBar(
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
                child: Text('Class'),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text('Group'),
              ),
              Container(
                child: Text('Teachers & Management'),
              ),
              Container(
                child: Text('Parents/Guardians'),
              ),
              Container(
                child: Text('School'),
              ),
              // if (widget.institute != null)
              //   Container(
              //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              //     child: Text(widget.institute.name),
              //   ),
            ],
          ),
          title: Text(
            widget.title,
            style: buildTextStyle(
              size: 15,
              weight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              buildClassList(),
              buildGroupsList(),
              buildTeachersList(),
              buildClassList(parent: true),
              buildStudentsList()

              // if (widget.institute != null) buildSchoolsList(),
            ],
          ),
        ),
      );
    });
  }

  Widget buildClassList({bool parent = false}) {
    return BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
        builder: (context, state) {
      if (state is ClassDetailsLoaded) {
        return BlocBuilder<AuthCubit, AuthStates>(builder: (context, state2) {
          if (state2 is AccountsLoaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Your mapped classes',
                      style: TextStyle(
                        color: Color(0xffBDBDBD),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.classDetails.length +
                        state2.user.secondaryClass.length +
                        1,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      if (index == state2.user.secondaryClass.length) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          padding: EdgeInsets.all(10),
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
                          return Container(
                            height: 0,
                          );
                        }
                        if ((primaryClass.classId != null &&
                                primaryClass.classId.isNotEmpty) &&
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
                                      BlocProvider(
                                        create: (context) =>
                                            LearningParentIdCubit(),
                                      ),
                                    ],
                                    child: parent
                                        ? SelectParents(
                                      className: primaryClass.className,
                                            sectionId:
                                                primaryClass.sections[0].id,
                                            classId: primaryClass.classId,
                                            task: widget.task,
                                            files: widget.files,
                                            section: primaryClass.sections[0],
                                          )
                                        : SelectStudentForClass(
                                      className: primaryClass.className,
                                            classId: primaryClass.classId,
                                            sectionId:
                                                primaryClass.sections.first.id,
                                            parent: parent,
                                            sectionName:
                                                primaryClass.sections[0].name,
                                            task: widget.task,
                                            classes: widget.classes,
                                            files: widget.files,
                                            questionPaper: null,
                                          ),
                                  ),
                                ),
                              );
                            },
                            leading: const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/sample.png'),
                            ),
                            title: Text(
                              "${primaryClass.className} ${primaryClass.sections[0].name ?? ''}",
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
                                              LearningStudentIdCubit()),
                                      BlocProvider(
                                          create: (context) =>
                                              LearningParentIdCubit())
                                    ],
                                    child: parent
                                        ? SelectParents(
                                      className: _secClass.className,
                                            sectionId: _secClass.sectionId,
                                            classId: _secClass.classId,
                                            files: widget.files,
                                            section: ClassSection(
                                              id: _secClass.sectionId,
                                              name: _secClass.sectionName,
                                            ),
                                          )
                                        : SelectStudentForClass(
                                      className: _secClass.className,
                                            classId: _secClass.classId,
                                            sectionId: _secClass.sectionId,
                                            sectionName: _secClass.sectionName,
                                            task: widget.task,
                                            parent: parent,
                                            classes: widget.classes,
                                            files: widget.files,
                                            questionPaper: null,
                                          ),
                                  ),
                                ),
                              );
                            },
                            leading: const CircleAvatar(
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
                              "${_secClass.className} ${_secClass.sectionName ?? ''}",
                              style: buildTextStyle(
                                color: const Color(0xff3b3b3b),
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
                              pageWidget: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => LearningClassCubit(),
                                  ),
                                ],
                                child: AssignSection(
                                  sections: _class.sections,
                                  classId: _class.classId,
                                  className: _class.className,
                                  task: widget.task,
                                  parents: parent,
                                  classes: widget.classes,
                                  files: widget.files,
                                  questionPaper: null,
                                ),
                              ),
                            ),
                          );
                        },
                        leading: const CircleAvatar(
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
            BlocProvider.of<AuthCubit>(context).checkAuthStatus();
            BlocProvider.of<ClassDetailsCubit>(context).loadClassDetails();
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

  BlocBuilder<GroupCubit, GroupStates> buildGroupsList() {
    return BlocBuilder<GroupCubit, GroupStates>(builder: (context, states) {
      if (states is StudentGroupsLoaded) {
        var _group = states.group.group;
        return Container(
          child: ListView.builder(
            itemCount: _group.length,
            itemExtent: 60,
            itemBuilder: (ctx, index) {
              // if (index == _group.length) return Container();
              // return ListTile(
              //   onTap: () {
              //     Navigator.of(context).push(
              //       createRoute(
              //           pageWidget: MultiBlocProvider(
              //         providers: [
              //           BlocProvider<GroupCubit>(
              //             create: (ctx) => GroupCubit(),
              //           ),
              //           BlocProvider<StudentProfileCubit>(
              //             create: (ctx) =>
              //                 StudentProfileCubit()..loadStudentProfile(),
              //           ),
              //           BlocProvider<ScheduleClassCubit>(
              //             create: (ctx) => ScheduleClassCubit(),
              //           ),
              //         ],
              //         child: SelectStudents(
              //           createNew: true,
              //           files: widget.files,
              //           task: widget.task,
              //         ),
              //       )),
              //     );
              //   },
              //   title: Text('Create New Group'),
              //   leading: CircleAvatar(
              //     backgroundColor: Color(0xffFFC30A),
              //     child: Icon(
              //       Icons.add,
              //       color: Colors.black,
              //     ),
              //   ),
              //   trailing: Icon(Icons.navigate_next),
              // );
              return ListTile(
                onTap: () {
                  widget.task.publishedWith = 'Group or Class';
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: MultiBlocProvider(
                        providers: [
                          BlocProvider<GroupCubit>(
                            create: (context) => GroupCubit(),
                          ),
                        ],
                        child:
                          AssignToGroupView(
                            files: widget.files,
                            task: widget.task,
                            group: _group[index],
                          )
                        // SelectStudents(
                        //   createNew: false,
                        //   files: widget.files,
                        //   group: _group[index],
                        //   students: _group[index].groupPersons,
                        //   task: widget.task,
                        // ),
                      ),
                    ),
                  );
                },
                // trailing: IconButton(
                //   icon: Icon(Icons.delete_forever),
                //   onPressed: () {
                //     showDialog<bool>(
                //       context: context,
                //       builder: (context) {
                //         return AlertDialog(
                //           title: Text('Do you want to delete this group?'),
                //           actions: [
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop(true);
                //               },
                //               child: Text('Yes'),
                //             ),
                //             TextButton(
                //               onPressed: () {
                //                 Navigator.of(context).pop(false);
                //               },
                //               child: Text('No'),
                //             ),
                //           ],
                //         );
                //       },
                //     ).then((value) {
                //       if (value) {
                //         BlocProvider.of<RewardStudentCubit>(context)
                //             .deleteGroup(_group[index].id);
                //         _group.removeWhere(
                //             (element) => element.id == _group[index].id);
                //         setState(() {});
                //       }
                //     });
                //   },
                // ),
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
      } else
        return Center(
          child: CircularProgressIndicator(),
        );
    });
  }

  Widget buildStudentsList() {

    return Column(
      children: [
        //Todo Implement Select All Button
        // Container(
        //   child: BlocBuilder<StudentProfileCubit, StudentProfileStates>(
        //     builder: (context, state) {
        //       if (state is StudentProfileLoaded) {
        //         if (_tabController.index == 4) {
        //           return Padding(
        //             padding: const EdgeInsets.all(10.0),
        //             child: TextFormField(
        //               onChanged: (val) {
        //               },
        //               onFieldSubmitted: (value) {
        //                 // setState(() {
        //                 //   searching = true;
        //                 // });
        //                 // BlocProvider.of<StudentProfileCubit>(context)
        //                 //     .loadStudentProfile(text: value)
        //                 //     .then((value) {
        //                 //       _students = value.students;
        //                 //   setState(() {
        //                 //     searching = false;
        //                 //   });
        //                 // });
        //               },
        //               focusNode: focusNode,
        //               // controller: searchTextController,
        //               style: const TextStyle(fontSize: 13),
        //               textInputAction: TextInputAction.search,
        //               controller: _textEditingControllerStudent,
        //               decoration: InputDecoration(
        //                   border: OutlineInputBorder(
        //                       borderRadius: BorderRadius.circular(20.0),
        //                       borderSide: const BorderSide(
        //                         color: Color(0xffc4c4c4),
        //                       )),
        //                   enabledBorder: OutlineInputBorder(
        //                       borderRadius: BorderRadius.circular(20.0),
        //                       borderSide: const BorderSide(
        //                         color: Color(0xffc4c4c4),
        //                       )),
        //                   filled: true,
        //                   floatingLabelBehavior: FloatingLabelBehavior.never,
        //                   contentPadding:
        //                   const EdgeInsets.only(top: 6, bottom: 6, left: 8),
        //                   suffixIcon: _textEditingControllerStudent.text != ""
        //                       ? IconButton(
        //                       icon: const Icon(Icons.clear),
        //                       onPressed: () {
        //                         setState(() {
        //                           // _students.addAll(x);
        //                         });
        //                         _textEditingControllerStudent.clear();
        //                       })
        //                       : const Icon(
        //                     Icons.search,
        //                     size: 22,
        //                   ),
        //                   labelText: 'search title',
        //                   labelStyle:
        //                   const TextStyle(fontSize: 11, color: Colors.grey),
        //                   hintText: 'search title',
        //                   hintStyle:
        //                   const TextStyle(fontSize: 11, color: Colors.grey),
        //                   fillColor: Colors.white70),
        //             ),
        //           );
        //         }
        //       }
        //       return loadingBar;
        //     }
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            focusNode: focusNode,
            controller: _textEditingControllerStudent,
            style: const TextStyle(fontSize: 13),
            onChanged: (value) {
              setState(() {});
              studentPagingController.refresh();

              if(value.isEmpty)
                focusNode.unfocus();
            },
            onSubmitted: (val){
              setState(() {});
              studentPagingController.refresh();
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color(0xffc4c4c4),
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color(0xffc4c4c4),
                    )),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding:
                const EdgeInsets.only(top: 6, bottom: 6, left: 8),
                suffixIcon: _textEditingControllerStudent.text != ""
                    ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {});
                      if(focusNode.hasFocus)
                        focusNode.unfocus();
                      _textEditingControllerStudent.clear();
                      // _textEditingControllerStudent.sink.add(null);
                      studentPagingController.refresh();
                    })
                    : const Icon(
                  Icons.search,
                  size: 22,
                ),
                labelText: 'search Name',
                labelStyle:
                const TextStyle(fontSize: 11, color: Colors.grey),
                hintText: 'search Name',
                hintStyle:
                const TextStyle(fontSize: 11, color: Colors.grey),
                fillColor: Colors.white70),
          ),

        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.64,
          child: PagedListView<int, StudentInfo>(
            // shrinkWrap: false,
              pagingController: studentPagingController,
              builderDelegate:
              PagedChildBuilderDelegate<StudentInfo>(
                  noItemsFoundIndicatorBuilder: (context){
                    return Text('No Items');
                  },
                  itemBuilder: (context, item, index) {
                    var student =  item;
                    return CheckListTile(
                        subTitle:
                        "Class : ${student.className ?? ''} ${student.sectionName ?? ''}",
                        value: assignedStudents.contains(
                          student,
                        ),
                        assignTo: student,
                        assigneeName: student.name,
                        imageUrl: student.profileImage ?? 'text',
                        onChanged: (stud, value) {
                          assignedParents.clear();
                          assignedTeachers.clear();
                          if (value)
                            assignedStudents.add(stud);
                          else
                            assignedStudents.remove(stud);
                          setState(() {});
                        },
                      );

                  })),
        )
      ],
    );
  }

  Widget buildTeachersList() {



    return Column(
      children: [
        Container(
          child: BlocBuilder<LearningTeacherIdCubit, LearningTeacherIdStates>(
              builder: (context, snapshot) {
            if (snapshot is LearningTeacherIdLoaded) {
              if(snapshot.teachers.isNotEmpty){
                return CheckboxListTile(
                  title: Text('Select All'),
                  onChanged: assignable
                      ? (value) {
                    assignedTeachers.clear();
                    if (value) {
                      assignedTeachers.addAll(snapshot.teachers);
                    } else {
                      assignedTeachers.clear();
                    }
                    setState(() {});
                  }:null,
                  value:
                  snapshot.teachers.length == assignedTeachers.length,
                );
              }
              return loadingBar;
              //   BlocBuilder<SchoolTeacherCubit, SchoolTeacherStates>(
              //     builder: (context, state) {
              //   if (state is SchoolTeacherLoaded) {
              //     List<UserInfo> list = [];
              //     for (var i in state.teachers) {
              //       if (i.name != teacherName) {
              //         list.add(i);
              //       }
              //     }
              //     stateTeacher = state;
              //
              //     return ListView.builder(
              //       controller: teacherController,
              //       itemCount: list.length + 1,
              //       itemBuilder: (context, index) {
              //         // if (!state.teachers[index - 1].name.toLowerCase().contains(
              //         //         _textEditingControllerTeacher.text.toLowerCase()) &&
              //         //     _textEditingControllerTeacher.text != '')
              //         //   return Container(
              //         //     height: 0,
              //         //   );
              //         // if (state.teachers[index - 1].id == state.teacherId)
              //         //   return Container(
              //         //     height: 0,
              //         //   );
              //         return CheckboxListTile(
              //           value: assignedTeachers.contains(list[index - 1].id),
              //           title: Text(
              //             list[index - 1].name ?? '' + '',
              //             style: buildTextStyle(),
              //           ),
              //           secondary: TeacherProfileAvatar(
              //             imageUrl: '${list[index - 1].profileImage}',
              //           ),
              //           onChanged: assignable
              //               ? (value) {
              //                   assignedStudents.clear();
              //                   assignedParents.clear();
              //                   if (value)
              //                     assignedTeachers.add(list[index - 1].id);
              //                   else
              //                     assignedTeachers.remove(list[index - 1].id);
              //                   setState(() {});
              //                 }
              //               : null,
              //         );
              //       },
              //     );
              //   } else {
              //     BlocProvider.of<SchoolTeacherCubit>(context).getAllTeachers();
              //     return Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   }
              // });

            } else {
              BlocProvider.of<LearningTeacherIdCubit>(context).getTeacherId();
              return Center(child: loadingBar);
            }
          }),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.66,
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
                  return CheckboxListTile(
                    value: assignedTeachers.contains(teacher.id),
                    title: Text(
                      teacher.name ?? '',
                      style: buildTextStyle(),
                    ),
                    secondary: TeacherProfileAvatar(
                      imageUrl: '${teacher.profileImage}',
                    ),
                    onChanged: assignable
                        ? (value) {
                            assignedStudents.clear();
                            assignedParents.clear();
                            if (value)
                              assignedTeachers.add(teacher.id);
                            else
                              assignedTeachers.remove(teacher.id);
                            setState(() {});
                          }
                        : null,
                  );
                }else{
                      return Container(height: 0,);
                    }
              })),
        )
      ],
    );
  }

  BlocBuilder<GroupCubit, GroupStates> buildParentList() {
    return BlocBuilder<GroupCubit, GroupStates>(builder: (context, states) {
      // BlocProvider.of<GroupCubit>(context).loadGroups();
      if (states is StudentGroupsLoaded) {
        var _group = states.group.group;
        return Container(
          child: ListView.builder(
            itemCount: _group.length,
            itemExtent: 60,
            itemBuilder: (ctx, index) {
              return ListTile(
                onTap: () {
                  widget.task.publishedWith = 'Parents';
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: MultiBlocProvider(
                        providers: [
                          BlocProvider<GroupCubit>(
                            create: (context) => GroupCubit()..loadGroups(),
                          ),
                        ],
                        child: SelectParents(
                          className: "",
                          sectionId: '',
                          classId: '',
                          files: widget.files,
                          // image: widget.image,
                          task: widget.task,
                        ),
                      ),
                    ),
                  );
                },
                title: Text(
                  'Parents of Group ' + _group[index].name,
                ),
                leading: CircleAvatar(
                  radius: 20,
                  child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset(
                      'assets/images/Group-Parents.png',
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
      } else
        return Center(
          child: CircularProgressIndicator(),
        );
    });
  }

  // buildSchoolsList() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: MediaQuery.of(context).size.height * 0.80,
  //     child: ExpandedTileList.builder(
  //       itemCount: 4,
  //       itemBuilder: (BuildContext context, int index,
  //           ExpandedTileController controller) {
  //         return ExpandedTile(
  //           theme: ExpandedTileThemeData(
  //             contentBackgroundColor: Colors.white,
  //           ),
  //           expansionDuration: Duration(milliseconds: 750),
  //           trailing: Icon(Icons.play_circle_fill),
  //           trailingRotation: 90,
  //           title: Text(
  //             'Karnataka',
  //             style: buildTextStyle(
  //               color: Color(0xff3b3b3b),
  //             ),
  //           ),
  //           content: Container(
  //             height: MediaQuery.of(context).size.height * 0.32,
  //             child: ListView.builder(
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   title: Text('Huda School'),
  //                   leading: TeacherProfileAvatar(),
  //                   subtitle: Text('Bengaluru'),
  //                   trailing: ElevatedButton(
  //                     onPressed: () {},
  //                     child: Text('Select'),
  //                   ),
  //                 );
  //               },
  //               itemCount: 5,
  //             ),
  //           ),
  //           controller: expandedTileController,
  //         );
  //       },
  //     ),
  //   );
  // }
}
//
