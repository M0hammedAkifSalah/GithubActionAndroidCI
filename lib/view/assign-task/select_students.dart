import 'dart:developer';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/app-config.dart';
import 'package:growonplus_teacher/view/drawer/drawer_menu.dart';
import 'package:growonplus_teacher/view/test-module/TestUtils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../bloc/test-module/test-module-states.dart';
import '../../export.dart';
import '../../model/class-schedule.dart';
import '../test-module/constants.dart';
import 'selected_students.dart';

class SelectStudents extends StatefulWidget {

  final bool createNew;
  final SingleGroup group;
  final bool readOnly;
  SelectStudents({
    this.readOnly = false,
    this.createNew = false,
    this.group
  });

  @override
  _SelectStudentsState createState() => _SelectStudentsState();
}

class _SelectStudentsState extends State<SelectStudents> with TickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  TextEditingController _textEditingControllerStudent = TextEditingController();
  String groupName = '';
  List<StudentInfo> assignedStudents = [];
  List<String> assignedTeachers = [];
  SchoolClassDetails _class = SchoolClassDetails(className: 'None');
  ClassSection _section = ClassSection(name: "None");

  final studentPagingController =
  PagingController<int, StudentInfo>(firstPageKey: 1);

  FocusNode focusNode = FocusNode();
  final teacherPagingController =
  PagingController<int, UserInfo>(firstPageKey: 1);
  bool panel = false;
  PanelController teacherPanelController = PanelController();
  String userId;

  TabController _tabController;


  @override
  void dispose() {
    super.dispose();

  }

  @override
  void initState() {
    super.initState();
    studentPagingController.addPageRequestListener((pageKey) {
      _fetchPageStudent(pageKey);
    });
    teacherPagingController.addPageRequestListener((pageKey) {
      _fetchTeacherPage(pageKey);
    });

    getTeacherId().then((value) => {
      userId = value
    });

    _tabController = TabController(length: 2, vsync: this);


  }

  Future<void> _fetchPageStudent(int pageKey) async {
    // try {
    final newItems =
    await BlocProvider.of<StudentProfileCubit>(context).loadStudentProfile(
      searchText: _textEditingControllerStudent.text.toString(),
      sectionId: _section != null ? _section.id : null,
      classId: _class != null ? _class.classId: null,
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
      backgroundColor: Colors.white,
      bottomNavigationBar: widget.readOnly
          ? Container(
              height: 0,
            )
          :
               !panel ?   CustomBottomBar(
                    check: assignedStudents.isNotEmpty,
                title: 'Create ${'Group'}',
                onPressed:  () async {
                        if (widget.createNew) {
                          if (_form.currentState.validate()) {
                              teacherPanelController.open();

                            // if (widget.readOnly) {
                            //   Navigator.of(context).pushAndRemoveUntil(
                            //     createRoute(
                            //       pageWidget: TeacherHomePage(),
                            //     ),
                            //     (route) => false,
                            //   );
                            // }
                          }
                        }
                        },
              ) : Container(height: 0,),
            // ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          widget.readOnly ? '${widget.group.name.toTitleCase()}' : 'Select Students',
          style: buildTextStyle(weight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [

          if (widget.createNew)
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: SelectedStudent(
                      selectedStudents: assignedStudents,
                      onSelected: (selectedStudents) {
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.playlist_add_check_rounded),
            ),

        ],
      ),
      body: SlidingUpPanel(
        controller: teacherPanelController,
        defaultPanelState: PanelState.CLOSED,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.65,
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Form(
            key: _form,
            child: Column(
              children: [

                if (widget.createNew)
                  Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          groupName = value;
                          if (value.trim().isEmpty) return 'Please Provide a value';
                          return null;
                        },
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText:
                              'Enter ${'Group'} Name',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            classDropDown(context),
                            if (_class != null && _class.classId != null)
                              sectionDropDown(context),
                          ],
                        ),
                      ),
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
                        height:  MediaQuery.of(context).size.height * 0.52,
                        child: PagedListView<int, StudentInfo>(
                          // shrinkWrap: false,
                            pagingController: studentPagingController,
                            builderDelegate:
                            PagedChildBuilderDelegate<StudentInfo>(
                                noItemsFoundIndicatorBuilder: (context){
                                  return Center(child: Text('No Items'));
                                },
                                itemBuilder: (context, item, index) {
                                  var student =  item;
                                  return ListTile(
                                    onTap: () {
                                      if (!assignedStudents.contains(student))
                                        assignedStudents.add(student);
                                      else
                                        assignedStudents.remove(student);
                                      setState(() {});
                                    },
                                    title: Text('${student.name}'),
                                    subtitle: Text(
                                        "${student.className ?? ''} ${student.sectionName ?? ''}"),
                                    leading: TeacherProfileAvatar(
                                      imageUrl: student.profileImage ?? 'test',
                                    ),
                                    trailing: Container(
                                      clipBehavior: Clip.antiAlias,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 7.5),
                                      decoration: ShapeDecoration(
                                        color: assignedStudents.contains(student)
                                            ? Colors.red
                                            : Colors.green,
                                        shape: StadiumBorder(),
                                      ),
                                      child: Text(
                                        assignedStudents.contains(student)
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
                      )
                    ],
                  ),
               if(!widget.createNew)
                 Container(
                   height: MediaQuery.of(context).size.height * 0.9,
                   child: Column(
                     children: [
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
                               width: MediaQuery.of(context).size.width,
                               height: MediaQuery.of(context).size.height * 0.59,
                               child: ListView.builder(itemBuilder: (context, index) {
                                 var student = widget.group.groupStudents[index];
                                 return ListTile(
                                      title: Text('${student.name}'),
                                      subtitle: Text(
                                          "${student.className ?? ''} ${student.sectionName ?? ''}"),
                                      leading: TeacherProfileAvatar(
                                        imageUrl: student.profileImage ?? 'test',
                                      ),
                                    );

                               },
                                 itemCount: widget.group.groupStudents.length,),
                             ),
                             widget.group.groupUsers.isNotEmpty ?
                             Container(
                               width: MediaQuery.of(context).size.width,
                               height: MediaQuery.of(context).size.height * 0.59,
                               child: ListView.builder(itemBuilder: (context, index) {
                                 var teacher = widget.group.groupUsers[index];
                                 return ListTile(
                                             title: Text('${teacher.name}'),
                                             subtitle: Text(
                                                 "${teacher.profileType ?? ''}"),
                                             leading: TeacherProfileAvatar(
                                               imageUrl: teacher.profileImage ?? 'test',
                                             ),
                                           );

                               },
                                 itemCount: widget.group.groupUsers.length,),
                             ) : Container(child: Center(child: Text('No Teachers'),),)
                           ],
                         ),
                       )
                     ],
                   ),
                 ),

                 // Container(
                 //   width: MediaQuery.of(context).size.width,
                 //   height:   MediaQuery.of(context).size.height * 0.90,
                 //   child: ListView.builder(
                 //     physics: AlwaysScrollableScrollPhysics(),
                 //     itemBuilder: (context,index) {
                 //       return ListTile(
                 //         title: Text('${list[index].name}'),
                 //         subtitle: Text(
                 //             "${list[index].className ?? ''} ${list[index].sectionName ?? ''}"),
                 //         leading: TeacherProfileAvatar(
                 //           imageUrl: list[index].profileImage ?? 'test',
                 //         ),
                 //       );
                 //     },
                 //     itemCount: list.length,
                 //   ),
                 // ),

              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget teacherPanel(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                    child: Text('Teachers',style: buildTextStyle(size: 20,weight: FontWeight.bold,color: kBlackColor),)),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text('You can Add Teachers with the Students too ',style: buildTextStyle(size: 13,weight: FontWeight.w500,color: kGreyColor),)),
              ],
            ),
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
                      if(teacherId != userId)
                      {
                    return ListTile(
                      onTap: () {
                        if (!assignedTeachers.contains(teacherId))
                          assignedTeachers.add(teacherId);
                        else
                          assignedTeachers.remove(teacherId);
                        setState(() {});
                      },
                      title: Text('${item.name}'),
                      subtitle: Text("${item.classId.className ?? ''}"),
                      leading: TeacherProfileAvatar(
                        imageUrl: item.profileImage ?? 'test',
                      ),
                      trailing: Container(
                        clipBehavior: Clip.antiAlias,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
                        decoration: ShapeDecoration(
                          color: assignedTeachers.contains(teacherId)
                              ? Colors.red
                              : Colors.green,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          assignedTeachers.contains(teacherId)
                              ? "Unselect"
                              : "Select",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }
                      else{
                        return Container(height: 0,);
                      }
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
          CustomRaisedButton(onPressed: (){
            teacherPanelController.close();
            context.read<GroupCubit>().createGroup(
                groupName: groupName,
                students: List<String>.from(assignedStudents.map((e) => e.id)),
                users: assignedTeachers
            ).then((value) async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        '${'Group'} Created Successfully'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                },
              );
            });
          }, title: 'Create Group')
        ],
      ),
    );
  }

  Column classDropDown(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Class/Grade",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        const SizedBox(height: 2),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(color: kGreyColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child:
                      BlocBuilder<TestModuleClassCubit, TestModuleClassStates>(
                          builder: (context, state) {
                    if (state is TestClassesLoaded) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<SchoolClassDetails>(
                          onTap: () {
                            // _section = null;
                          },
                          focusColor: Colors.white,
                          value: _class,
                          //elevation: 5,
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: (state.classDetails.isEmpty
                                  ? [SchoolClassDetails(className: 'None')]
                                  : [
                                      SchoolClassDetails(className: 'None'),
                                      ...state.classDetails
                                    ])
                              .map<DropdownMenuItem<SchoolClassDetails>>(
                                  (SchoolClassDetails value) {
                            return DropdownMenuItem<SchoolClassDetails>(
                              value: value,
                              child: Text(
                                value.className ?? 'class',
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            "Class",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor),
                          ),
                          onChanged: (SchoolClassDetails value) {
                            if (_class != value) {
                              setState(() {
                                _class = value;
                                _section = null;
                              });
                              _textEditingControllerStudent.clear();
                              studentPagingController.refresh();
                              // loadStudents();
                            }
                          },
                        ),
                      );
                    } else {
                      BlocProvider.of<TestModuleClassCubit>(context)
                          .loadAllClasses();

                      return Container(
                        child: loadingBar,
                      );
                    }
                  }),
                ),
              ),
            ))
      ],
    );
  }

  Column sectionDropDown(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Section",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        const SizedBox(height: 2),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 42,
          decoration: BoxDecoration(
              border: Border.all(color: kGreyColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ClassSection>(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  focusColor: Colors.white,
                  isExpanded: true,
                  value: _section,
                  //elevation: 5,
                  style: const TextStyle(color: Colors.white),
                  iconEnabledColor: Colors.black,
                  items: (_class.sections.isEmpty
                          ? [ClassSection(name: 'None')]
                          : [ClassSection(name: 'None'), ..._class.sections])
                      .map<DropdownMenuItem<ClassSection>>(
                          (ClassSection value) {
                    return DropdownMenuItem<ClassSection>(
                      value: value,
                      child: Text(
                        value.name,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                  hint: const Text(
                    "Section",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kBlackColor,
                    ),
                  ),
                  onChanged: (ClassSection value) {
                    if (_section != value) {
                      setState(() {
                        _section = value;
                      });
                      _textEditingControllerStudent.clear();
                      studentPagingController.refresh();
                      // loadStudents();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // void loadStudents() {
  //   BlocProvider.of<StudentProfileCubit>(context)
  //       .loadStudentProfile(
  //           // text: _textEditingControllerStudent.text,
  //           classId: _class != null && _class.classId != null
  //               ? _class.classId
  //               : null,
  //           sectionId:
  //               _section != null && _section.id != null ? _section.id : null,
  //   limit: 10,page: 1)
  //       .then((value) {
  //     setState(() {
  //     });
  //   });
  // }
}

class CheckListTile extends StatelessWidget {
  const CheckListTile({
    this.assignTo,
    this.onChanged,
    this.title,
    this.value,
    this.imageUrl,
    this.assigneeName,
    this.subTitle,
  });

  final StudentInfo assignTo;
  final Function(StudentInfo assign, bool value) onChanged;
  final bool value;
  final String assigneeName;
  final String imageUrl;
  final String subTitle;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (value) {
        onChanged(assignTo, value);
      },
      value: value,
      subtitle: Text(subTitle ?? ''),
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
