import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../app-config.dart';
import '/export.dart';
import '/view/assign-task/add-student-group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditStudentGroupPage extends StatefulWidget {
  final SingleGroup group;

  const EditStudentGroupPage({Key key, this.group}) : super(key: key);

  @override
  _EditStudentGroupPageState createState() => _EditStudentGroupPageState();
}

class _EditStudentGroupPageState extends State<EditStudentGroupPage> {
  List<GroupStudents> modifiedStudents = [];
  String groupName = '';
  List<String> modifiedTeachers = [];

  final teacherPagingController =
  PagingController<int, UserInfo>(firstPageKey: 1);
  bool panel = false;
  PanelController teacherPanelController = PanelController();

  @override
  void initState() {
    super.initState();
    groupName = widget.group.name;
    modifiedStudents.addAll(widget.group.groupStudents);
    modifiedTeachers.addAll(widget.group.groupUsers.map((e) => e.id));
    teacherPagingController.addPageRequestListener((pageKey) {
      _fetchTeacherPage(pageKey);
    });
  }

  Future<void> _fetchTeacherPage(int pageKey) async {
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
      bottomNavigationBar: !panel ?Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CustomRaisedButton(
              height: MediaQuery.of(context).size.height * 0.05,
              // width: MediaQuery.of(context).size.width * 0.50,
              title: 'Save',
              check: (groupName.isNotEmpty && groupName != widget.group.name) ||
                  (modifiedStudents.isNotEmpty
                      // &&
                      // !(listEquals(modifiedStudents, widget.group.groupStudents))
                  ),
              onPressed: () async {

                teacherPanelController.open();
              //
              },
            ),
            FloatingActionButton(
              onPressed: () async {
                var stud = await Navigator.of(context).push<List<StudentInfo>>(
                  createRoute(
                      pageWidget: MultiBlocProvider(
                        providers: [
                          BlocProvider<StudentProfileCubit>(
                            create: (ctx) => StudentProfileCubit()..loadStudentProfile(page: 1,limit: 10),
                          ),
                          BlocProvider<TestModuleClassCubit>(
                            create: (ctx) => TestModuleClassCubit()..loadAllClasses(),
                          ),
                        ],
                        child: AddStudentGroupPage(
                          studentList: modifiedStudents.toList(),
                        ),
                      )),
                );
                if (stud != null) {
                  modifiedStudents = stud.map((e) => GroupStudents(
                    id: e.id,
                    profileImage: e.profileImage,
                    name: e.name,
                    className: e.className,
                    classId: e.userInfoClass,
                    sectionId: e.section,
                  )).toList();
                  // modifiedStudents.addAll(stud.map(
                  //   (e) => GroupStudents(
                  //     classId: e.userInfoClass,
                  //     className: e.className,
                  //     name: e.name,
                  //     // parentId: e.parent.id,
                  //     profileImage: e.profileImage,
                  //     sectionName: e.sectionName,
                  //     sectionId: e.section,
                  //     id: e.id,
                  //   ),
                  // ));

                  setState(() {});
                }
                setState(() {});
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ) : Container(height: 0,),
      // floatingActionButton: !panel ?  : Container(height: 0,),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.adaptive.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        title: Text(
          'Edit Group',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SlidingUpPanel(
        controller: teacherPanelController,
        defaultPanelState: PanelState.CLOSED,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.61,
        onPanelOpened: () {
          setState(() {
            panel = true;
          });
        },
        onPanelClosed: () {
          setState(() {
            panel = false;
          });
        },
        backdropEnabled: true,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        panel: teacherPanel(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: groupName,
                onChanged: (value) {
                  groupName = value.trim();
                  setState(() {});
                },
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText:
                      'Enter ${'Group'} Name',
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.71,
              child: ListView.separated(
                // padding:
                //     EdgeInsets.only(bottom: kFloatingActionButtonMargin + 56),
                itemCount: modifiedStudents.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (context, index) {
                  var student = modifiedStudents[index];
                  return ListTile(
                    onTap: () {},
                    leading: TeacherProfileAvatar(
                      imageUrl: student.profileImage??'text',
                    ),
                    title: Text('${student.name}'),
                    subtitle: Text(
                        "${student.className ?? ''} ${student.sectionName ?? ''}"),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        modifiedStudents.remove(student);
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget teacherPanel(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('You can Add a Teacher for Collaboration',style: buildTextStyle(size: 16,weight: FontWeight.w500,color: Colors.black),),
          ),
          // Padding(padding: EdgeInsets.only(top: 8,left: 8),
          //     child: Text('Teachers',style: buildTextStyle(
          //         color: Colors.grey
          //     ),)),
          Container(
            width: MediaQuery.of(context).size.width,
            height:  MediaQuery.of(context).size.height * 0.50,
            child: PagedListView<int, UserInfo>(
              // shrinkWrap: false,
                pagingController: teacherPagingController,
                builderDelegate:
                PagedChildBuilderDelegate<UserInfo>(
                    noItemsFoundIndicatorBuilder: (context){
                      return Center(child: Text('No Items'));
                    },
                    itemBuilder: (context, item, index) {
                      var teacherId = item.id;
                      return ListTile(
                        onTap: () {
                          if (!modifiedTeachers.contains(teacherId))
                            modifiedTeachers.add(teacherId);
                          else
                            modifiedTeachers.remove(teacherId);
                          setState(() {});
                        },
                        title: Text('${item.name}'),
                        subtitle: Text(
                            "${item.classId.className ?? ''}"),
                        leading: TeacherProfileAvatar(
                          imageUrl: item.profileImage ?? 'test',
                        ),
                        trailing: Container(
                          clipBehavior: Clip.antiAlias,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 7.5),
                          decoration: ShapeDecoration(
                            color: modifiedTeachers.contains(teacherId)
                                ? Colors.red
                                : Colors.green,
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            modifiedTeachers.contains(teacherId)
                                ? "Unselect"
                                : "Select",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      //     : ListTile(
                      //   onTap: () {
                      //     if (!assignedStudents.contains(student))
                      //       assignedStudents.add(student);
                      //     else
                      //       assignedStudents.remove(student);
                      //     setState(() {});
                      //   },
                      //   title: Text('${student.name}'),
                      //   subtitle: Text(
                      //       "${student.className ?? ''} ${student.sectionName ?? ''}"),
                      //   leading: TeacherProfileAvatar(
                      //     imageUrl: student.profileImage ?? 'test',
                      //   ),
                      //   trailing: Container(
                      //     clipBehavior: Clip.antiAlias,
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 20, vertical: 7.5),
                      //     decoration: ShapeDecoration(
                      //       color: assignedStudents.contains(student)
                      //           ? Colors.red
                      //           : Colors.green,
                      //       shape: StadiumBorder(),
                      //     ),
                      //     child: Text(
                      //       assignedStudents.contains(student)
                      //           ? "Unselect"
                      //           : "Select",
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //         color: Colors.white,
                      //       ),
                      //     ),
                      //   ),
                      // );

                    })),
          ),
          CustomRaisedButton(onPressed: () async {
            teacherPanelController.close();
            var group =
                  await BlocProvider.of<RewardStudentCubit>(context).updateGroup(
                widget.group.id,
                {
                  "group_name": groupName,
                  "students": modifiedStudents.map((e) => e.id).toList(),
                  "users":modifiedTeachers,
                },
              );
              if (group != null) {
                // widget.group.groupStudents.clear();
                // widget.group.groupStudents.addAll(modifiedStudents);
                Navigator.of(context).pop(group);
              }
          }, title: 'Create Group',
          check: modifiedStudents.length != 0,)
        ],
      ),
    );
  }
}
