import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/model/class-schedule.dart';
import '../../export.dart';

class SelectParents extends StatefulWidget {
  final task;
  final ClassSection section;
  final List<PlatformFile> files;
  // final File image;
  final String sectionId;
  final String classId;
  final String className;
  SelectParents({
    this.className,
    this.task,
    @required this.classId,
    @required this.sectionId,
    this.section,
    this.files,
    // this.image,
  });
  @override
  _SelectParentsState createState() => _SelectParentsState();
}

class _SelectParentsState extends State<SelectParents> {
  TextEditingController _textEditingControllerParent = TextEditingController();
  GlobalKey<FormState> _form = GlobalKey();
  ScrollController scrollController = ScrollController();
  LearningStudentsLoaded stateStudents;
  int page = 1;
  bool loading = false;
  String groupName = '';
  List<AssignToParent> assignedParents = [];
  final studentPagingController =
  PagingController<int, StudentInfo>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    studentPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      BlocProvider.of<LearningParentIdCubit>(context)
          .getStudentsId([widget.sectionId]);
    });

  }

  checkFunction(String name) {
    switch (name) {
      case 'Announcement':
        return context.read<ActivityCubit>().createAnnouncement(
              assignmentTask: widget.task,
              attachments: widget.files,
              // image: widget.image,
              students: [],
              teacher: [],
              parents: assignedParents,
            );
        break;
      case 'LivePoll':
        return context.read<ActivityCubit>().createLivePoll(
              assignmentTask: widget.task,
              attachments: widget.files,
              // image: widget.image,
              students: [],
              teacher: [],
              parents: assignedParents,
            );
        break;
      case 'Event':
        return context.read<ActivityCubit>().createEvent(
              assignmentTask: widget.task,
              attachments: widget.files,
              // image: widget.image,
              students: [],
              teacher: [],
              parents: assignedParents,
            );
        break;
      case 'Check List':
        return context.read<ActivityCubit>().createCheckList(
              assignmentTask: widget.task,
              attachments: widget.files,
              // image: widget.image,
              students: [],
              teacher: [],
              parents: assignedParents,
            );
        break;
      default:
        return;
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BlocBuilder<AuthCubit, AuthStates>(
        builder: (context, state) => CustomBottomBar(
          title: 'Select & Publish',
          onPressed: assignedParents.isEmpty
              ? null
              : () async {
                  await BlocProvider.of<AuthCubit>(context)
                      .checkAuthStatus();
                  checkFunction(widget.task.activityType);
                  showAssignedDialogue(context, 'Task');
                },
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Select Parents',
          style: buildTextStyle(weight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Form(
          key: _form,
          child: Column(
            children: [
              ListTile(
                title: Text('${widget.className} - ${widget.section.name}'),
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
              BlocBuilder<LearningParentIdCubit, LearningParentIdStates>(
                  builder: (context, snapshot) {
                if (snapshot is LearningParentIdLoaded) {
                  if(snapshot.students.isNotEmpty)
                  return CheckboxListTile(
                    title: Text(
                      'Select All',
                      style: buildTextStyle(),
                    ),
                    onChanged: (value) {
                      assignedParents.clear();
                      if (value) {
                        assignedParents.addAll(
                          snapshot.students.map(
                                (e) => AssignToParent(
                              parentId: e.parent.id,
                              studentId: e.id,
                            ),
                          ),
                        );
                      } else {
                        assignedParents.clear();
                      }
                      setState(() {});
                      log('select all '+assignedParents.length.toString());
                    },
                    value: snapshot.students.length ==
                        assignedParents.length,
                  );
                  else
                    return Container(height: 0,);
                } else {
                  return Center(child: loadingBar);
                }
              }),
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
                          return CheckListTile(
                            title:
                            Text('Parent of ${_student.name}'),
                            imageUrl:
                            _student.profileImage ?? 'test',
                            value: assignedParents
                                .map((e) => e.parentId)
                                .contains(_student.parent.id),
                            assignTo: StudentInfo(
                              id: _student.id,
                              name: _student.name,
                              profileImage: _student.profileImage,
                              parent: ParentInfo(
                                id: _student.parent.id,
                                fatherName:
                                _student.parent.fatherName,
                              ),
                            ),
                            onChanged: (stud, value) {
                              if (value)
                                assignedParents.add(
                                  AssignToParent(
                                    parentId: stud.parent.id,
                                    studentId: stud.id,
                                  ),
                                );
                              else
                                assignedParents.removeWhere(
                                        (element) => element.studentId == stud.id);
                              setState(() {});
                              log(assignedParents.length.toString());
                            },
                          );
                        })),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class CheckListTile extends StatelessWidget {
//   const CheckListTile({
//     this.assignTo,
//     this.onChanged,
//     this.title,
//     this.value,
//     this.imageUrl,
//     this.assigneeName,
//   });

//   final StudentInfo assignTo;
//   final Function(StudentInfo assign, bool value) onChanged;
//   final bool value;
//   final String assigneeName;
//   final String imageUrl;
//   final Widget title;
//   @override
//   Widget build(BuildContext context) {
//     return CheckboxListTile(
//       onChanged: (value) {
//         onChanged(assignTo, value);
//       },
//       value: value,
//       title: title ??
//           Text(
//             '$assigneeName',
//           ),
//       secondary: TeacherProfileAvatar(
//         imageUrl: imageUrl,
//       ),
//     );
//   }
// }
