import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../export.dart';
import '../../model/class-schedule.dart';

class AssignSection extends StatefulWidget {
  final ScheduledClassTask classes;
  final QuestionPaper questionPaper;
  final List<ClassSection> sections;
  final String className;
  final String classId;
  final dynamic task;
  final bool parents;
  final List<PlatformFile> files;
  final bool createGroup;

  AssignSection({
    this.classes,
    this.task,
    this.parents = false,
    this.createGroup,
    this.className,
    @required this.classId,
    @required this.sections,
    this.files,
    this.questionPaper,
  });

  @override
  _AssignSectionState createState() => _AssignSectionState();
}

class _AssignSectionState extends State<AssignSection> {
  int currentIndex = 0;
  List<String> sections = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomBottomBar(
        title: 'Select & Publish',
        onPressed: sections.isEmpty
            ? null
            : () async {
                await showLoadingDialogue(context);
              },
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.className ?? 'Class',
          style: buildTextStyle(weight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   children: [
              //     // InkWell(
              //     //   onTap: () {
              //     //     currentIndex = 0;
              //     //     setState(() {});
              //     //   },
              //     //   child: Container(
              //     //     padding:
              //     //         EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //     //     decoration: BoxDecoration(
              //     //       color: currentIndex != 0
              //     //           ? Colors.white
              //     //           : Color(0xffFFC30A),
              //     //       borderRadius: BorderRadius.circular(5),
              //     //     ),
              //     //     child: Text('${widget.className}'),
              //     //   ),
              //     // ),
              //     // SizedBox(
              //     //   width: 15,
              //     // ),
              //     // InkWell(
              //     //   onTap: () {
              //     //     currentIndex = 1;
              //     //     setState(() {});
              //     //   },
              //     //   child: Container(
              //     //     padding:
              //     //         EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //     //     decoration: BoxDecoration(
              //     //       color: currentIndex != 1
              //     //           ? Colors.white
              //     //           : Color(0xffFFC30A),
              //     //       borderRadius: BorderRadius.circular(5),
              //     //     ),
              //     //     child: Text('Group'),
              //     //   ),
              //     // ),
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  child: ListView.separated(
                    itemCount: widget.sections.length + 1,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return CheckboxListTile(
                          value: sections.length == widget.sections.length,
                          onChanged: (value) async {
                            sections.clear();
                            if (value) {
                              sections.addAll(widget.sections.map((e) => e.id));
                            } else {
                              sections.clear();
                            }
                            setState(() {});
                            // if (sections.isNotEmpty)
                            //   await showLoadingDialogue(context);
                            // log("${state.students.map((e) => e.id)}");
                            // if (value) {
                            //   sections
                            //       .addAll(state.students.map((e) => e.id));
                            // } else
                            //   sections.clear();
                            //
                            // leading: CircleAvatar(
                            //   backgroundImage: AssetImage('assets/images/sample.png'),
                            // );
                          },
                          title: Text(
                            "Select All",
                            style: buildTextStyle(),
                          ),
                        );
                      }
                      return ListTile(
                        trailing: Checkbox(
                          value:
                              sections.contains(widget.sections[index - 1].id),
                          onChanged: (value) {
                            if (value) {
                              sections.add(widget.sections[index - 1].id);
                            } else {
                              sections.removeWhere((element) =>
                                  element == widget.sections[index - 1].id);
                            }
                            setState(() {});
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              pageWidget: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => LearningClassCubit(),
                                  ),
                                ],
                                child: widget.parents
                                    ? SelectParents(
                                  className: widget.className,
                                        sectionId:
                                            widget.sections[index - 1].id,
                                        classId: widget.classId,
                                        files: widget.files,
                                        task: widget.task,
                                        section: widget.sections[index - 1],
                                      )
                                    : BlocProvider(
                                  create: (context)=>LearningClassCubit()..getStudents(
                                    limit: 10,page: 1,
                                    sectionId: widget.sections[index-1].id,
                                    classId: widget.classId
                                  ),
                                      child: SelectStudentForClass(
                                          className: widget.className,
                                          classId: widget.classId,
                                          sectionId:
                                              widget.sections[index - 1].id,
                                          sectionName:
                                              widget.sections[index - 1].name,
                                          task: widget.task,
                                          classes: widget.classes,
                                          files: widget.files,
                                          questionPaper: widget.questionPaper,
                                        ),
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
                          widget.sections[index - 1].name,
                          style: buildTextStyle(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showLoadingDialogue(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        bool assign = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: assign
                  ? Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                  : const Text(
                      'You are about to select all users in the selection.\nAre you sure you would like to assign this task to all?'),
              content: assign
                  ? const Text('Note: Please don\'t press back button.')
                  : const Text(''),
              actions: assign
                  ? []
                  : [
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              assign = true;
                            });
                            List<StudentInfo> student = [];
                            if (!widget.parents) {
                              student =
                                  await BlocProvider.of<LearningStudentIdCubit>(
                                          context)
                                      .getStudentsId(sections);
                              // List<StudentInfo> studentInfo = student.map((e) => StudentInfo(id: e,)).toList();

                              // await checkFunction(
                              //   context,
                              //   widget.task != null
                              //       ? widget.task.activityType
                              //       : widget.classes != null
                              //           ? 'Class'
                              //           : 'Question Paper',
                              //   task: widget.task,
                              //   files: widget.files,
                              //   classes: widget.classes,
                              //   questionPaper: widget.questionPaper,
                              //   assignedStudents: student,
                              //   assignedTeachers: [],
                              //   assignedParents: [],
                              // );
                            } else {
                              student =
                                  await BlocProvider.of<LearningStudentIdCubit>(
                                          context)
                                      .getStudentsId(sections);

                              // await checkFunction(
                              //   context,
                              //   widget.task != null
                              //       ? widget.task.activityType
                              //       : widget.classes != null
                              //           ? 'Class'
                              //           : 'Question Paper',
                              //   task: widget.task,
                              //   files: widget.files,
                              //   classes: widget.classes,
                              //   questionPaper: widget.questionPaper,
                              //   assignedStudents: [],
                              //   assignedTeachers: [],
                              //   assignedParents: student,
                              // );
                            }
                            Navigator.of(context).pop();
                            showAssignedDialogue(
                              context,
                              widget.task != null
                                  ? widget.task.activityType
                                  : widget.classes != null
                                      ? 'Class'
                                      : 'Question Paper',
                            );
                          },
                          child: Text('Yes')),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('No'),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  List<StudentInfo> getStudentList(LearningStudentsLoaded state, int index) {
    List<StudentInfo> stud = [];
    for (var i in state.students) {
      if (i.section == widget.sections[index].id) {
        stud.add(i);
      }
    }
    return stud;
  }
}

class SelectStudentForClass extends StatefulWidget {
  final List<PlatformFile> files;
  final ScheduledClassTask classes;
  final QuestionPaper questionPaper;
  final dynamic task;
  final String sectionName;
  final bool parent;
  final String sectionId;
  final String classId;
  final String className;

  SelectStudentForClass(
      {@required this.files,
      this.parent = false,
      @required this.classId,
      @required this.sectionName,
      @required this.sectionId,
      @required this.task,
      @required this.classes,
      @required this.questionPaper,
      this.className});

  @override
  _SelectStudentsState createState() => _SelectStudentsState();
}

class _SelectStudentsState extends State<SelectStudentForClass> {
  List<StudentInfo> assignedStudents = [];
  ScrollController scrollController = ScrollController();
  bool creating = false;
  bool loading = false;
  bool init = true;
  final studentPagingController =
      PagingController<int, StudentInfo>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    assignedStudents = [];
    studentPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    Future.delayed(Duration(milliseconds: 300)).then((value) async {
      await BlocProvider.of<LearningStudentIdCubit>(context)
          .getStudentsId([widget.sectionId]);
      setState(() {});
    });



  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
      final newItems =
          await BlocProvider.of<LearningClassCubit>(context).getStudents(
        classId: widget.classId,
        sectionId: widget.sectionId,
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
    if (init) {
      BlocProvider.of<LearningStudentIdCubit>(context)
          .getStudentsId([widget.sectionId]);
      init = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
        return CustomBottomBar(
          title: creating ? 'Creating..' : 'Select & Publish',
          onPressed: assignedStudents.isEmpty
              ? null
              : creating
                  ? null
                  : () async {
                      if (widget.task != null) {
                        log('true');
                        setState(() {
                          creating = true;
                        });

                        checkFunction(
                          context,
                          widget.task.activityType,
                          classes: widget.classes,
                          questionPaper: widget.questionPaper,
                          task: widget.task,
                          files: widget.files,
                          assignedStudents: assignedStudents,
                          assignedTeachers: [],
                          assignedParents: [],
                        );
                        showAssignedDialogue(context, 'Task');
                      } else if (widget.classes != null) {
                        setState(() {
                          creating = true;
                        });
                        widget.classes.files =
                            await BlocProvider.of<ActivityCubit>(context)
                                .uploadFile(widget.files);
                        BlocProvider.of<ScheduleClassCubit>(context)
                            .createClass(
                          widget.classes,
                          assignedStudents: assignedStudents,
                          teacher: [],
                          files: widget.files,
                          assignedTeachers: [],
                        );
                        creating = false;
                        showAssignedDialogue(context, 'Class');
                      } else if (widget.questionPaper != null) {
                        widget.questionPaper.assignDate = DateTime.now();
                        widget.questionPaper.assignTo =
                            assignedStudents.map((e) {
                          return TestAssignTo(
                              sectionId: e.section,
                              classId: e.userInfoClass,
                              studentId: e.id,
                              schoolId: e.schoolId);
                        }).toList();
                        int hour =
                            Provider.of<TimePicker>(context, listen: false)
                                .getHours;
                        int mins =
                            Provider.of<TimePicker>(context, listen: false)
                                .getMins;
                        //Hiding the code of Test Assign Api
                        // if(widget.questionPaper.isCreated)
                        //   {
                        //     TestAssign assign = TestAssign();
                        //     assign.duration = ((hour * 60 + mins) * 60).toString();
                        //     assign.award = widget.questionPaper.award;
                        //     assign.startDate = widget.questionPaper.startDate.toString();
                        //     assign.dueDate = widget.questionPaper.dueDate.toString();
                        //
                        //     assign.assignTo = assignedStudents.map((e) => AssignTo(
                        //       branch: e.branchId,
                        //       classId: e.userInfoClass,
                        //       schoolId: e.schoolId,
                        //       studentId: e.id,
                        //     )).toList();
                        //     log('during assign '+assign.assignTo.first.classId.toString());
                        //     BlocProvider.of<QuestionPaperCubit>(context)
                        //         .assignQuestionPaper(assign, widget.questionPaper.id);
                        //   }
                        // els
                        BlocProvider.of<QuestionPaperCubit>(context)
                            .createQuestionPaper(widget.questionPaper,
                                ((hour * 60 + mins) * 60).toString());

                        showAssignedDialogue(context, 'Question Paper');
                      }
                    },
        );
      }),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Select Students',
          style: buildTextStyle(weight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.97,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          children: [
            ListTile(
              title: Text('${widget.className} - ${widget.sectionName}'),
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
            Container(
              child:  BlocBuilder<LearningStudentIdCubit,
                      LearningStudentIdStates>(builder: (context, snapshot) {
                    if (snapshot is LearningStudentIdLoaded) {
                      for (var i in snapshot.students) {
                        i.userInfoClass = widget.classId;
                        i.section = widget.sectionId;
                      }
                      return CheckboxListTile(
                        value: assignedStudents.length ==
                            snapshot.students.length,
                        onChanged: (value) {
                          assignedStudents.clear();
                          if (!value) {
                            assignedStudents.clear();
                          } else {
                            assignedStudents.addAll(snapshot.students);
                          }
                          setState(() {});
                          log(assignedStudents.length.toString());
                        },
                        title: Text(
                          'Select All',
                          style: buildTextStyle(size: 16),
                        ),
                      );
                    }
                   else{
                     return loadingBar;
                    }
                    //   ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   separatorBuilder: (context, index) => const SizedBox(
                    //     height: 15,
                    //   ),
                    //   // shrinkWrap: true,
                    //   itemCount: state.students.length + 1,
                    //   itemBuilder: (context, index) {
                    //     if (index == 0 &&
                    //         snapshot is LearningStudentIdLoaded) {
                    //       for (var i in snapshot.students) {
                    //         i.userInfoClass = widget.classId;
                    //         i.section = widget.sectionId;
                    //       }
                    //       return CheckboxListTile(
                    //         value: assignedStudents.length ==
                    //             snapshot.students.length,
                    //         onChanged: (value) {
                    //           assignedStudents.clear();
                    //           if (!value) {
                    //             assignedStudents.clear();
                    //           } else {
                    //             assignedStudents.addAll(snapshot.students);
                    //           }
                    //           setState(() {});
                    //           log(assignedStudents.length.toString());
                    //         },
                    //         title: Text(
                    //           'Select All',
                    //           style: buildTextStyle(size: 16),
                    //         ),
                    //       );
                    //     } else if (index == 0) {
                    //       return Container();
                    //     }
                    //     var _student = state.students[index - 1];
                    //     _student.section = widget.sectionId;
                    //     _student.userInfoClass = widget.classId;
                    //     if (widget.sectionId ==
                    //         state.students[index - 1].section) {
                    //       return CheckboxListTile(
                    //         value: assignedStudents
                    //             .map((e) => e.id)
                    //             .contains(_student.id),
                    //         onChanged: (value) {
                    //           try {
                    //             if (value)
                    //               assignedStudents.add(_student);
                    //             else
                    //               assignedStudents.remove(_student);
                    //           }  catch (e) {
                    //             log(e.runtimeType.toString());// TODO
                    //           }
                    //
                    //           setState(() {});
                    //         },
                    //         secondary: TeacherProfileAvatar(
                    //           imageUrl: _student.profileImage ?? 'text',
                    //         ),
                    //         title: Text(
                    //           '${_student.name}',
                    //           style: buildTextStyle(size: 16),
                    //         ),
                    //       );
                    //     } else {
                    //       log('section: ${_student.section}, ${_student.name}, }');
                    //       return Container(
                    //         height: 0,
                    //         child: Text(_student.name),
                    //         color: Colors.yellow,
                    //       );
                    //     }
                    //   },
                    // );
              }),
            ),
            Container(
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
                        _student.section = widget.sectionId;
                        _student.userInfoClass = widget.classId;
                        return CheckboxListTile(
                          value: assignedStudents
                              .map((e) => e.id)
                              .contains(_student.id),
                          onChanged: (value) {
                            try {
                              if (value)
                                assignedStudents.add(_student);
                              else
                                assignedStudents.remove(_student);
                            } catch (e) {
                              log(e.runtimeType.toString()); // TODO
                            }

                            setState(() {});
                          },
                          secondary: TeacherProfileAvatar(
                            imageUrl: _student.profileImage ?? 'text',
                          ),
                          title: Text(
                            '${_student.name}',
                            style: buildTextStyle(size: 16),
                          ),
                        );
                      })),
            )
          ],
        ),
      ),
    );
  }
}
