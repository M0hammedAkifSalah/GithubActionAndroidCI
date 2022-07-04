import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../bloc/test-module/test-module-states.dart';
import '../../model/class-schedule.dart';
import '../test-module/constants.dart';
import '/export.dart';

class AddStudentGroupPage extends StatefulWidget {
  final List<GroupStudents> studentList;


  const AddStudentGroupPage({
    Key key,
    @required this.studentList,
  }) : super(key: key);

  @override
  _AddStudentGroupPageState createState() => _AddStudentGroupPageState();
}

class _AddStudentGroupPageState extends State<AddStudentGroupPage> {
  TextEditingController _textEditingControllerStudent = TextEditingController();
  List<StudentInfo> assignedStudents = [];

  SchoolClassDetails _class = SchoolClassDetails(className: 'None');
  ClassSection _section = ClassSection(name: "None");
  final studentPagingController =
  PagingController<int, StudentInfo>(firstPageKey: 1);
  FocusNode focusNode = FocusNode();



  @override
  void initState() {
    super.initState();

    studentPagingController.addPageRequestListener((pageKey) {
      _fetchPageStudent(pageKey);
    });


    assignedStudents.addAll(widget.studentList.map((e) => StudentInfo(
      className: e.className,
      name: e.name,
      profileImage: e.profileImage,
      id: e.id,
      section: e.sectionId,
      userInfoClass: e.classId,
    )));
  }

  Future<void> _fetchPageStudent(int pageKey) async {
    // try {
    final newItems =
    await BlocProvider.of<StudentProfileCubit>(context).loadStudentProfile(
      searchText: _textEditingControllerStudent.text.toString(),
      classId: _class != null ? _class.classId : null,
      sectionId: _section != null ?_section.id:null,
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
      bottomNavigationBar:  CustomBottomBar(
        title: 'Add Student',
        check: assignedStudents.isNotEmpty,
        onPressed: () {
          Navigator.of(context).pop(assignedStudents);
        },
      ) ,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Add Students',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: buildStudentsList(),
    );
  }



  Widget buildStudentsList() {
    return Column(
      children: [
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
        // BlocBuilder<StudentProfileCubit, StudentProfileStates>(
        //     builder: (context, state) {
        //   if (state is StudentProfileLoaded) {
        //     var _students = state.studentInfo;
        //     state.studentInfo.removeWhere(
        //         (element) => widget.studentList.contains(element.id));
        //     if(_students.isNotEmpty)
        //    return CheckboxListTile(
        //             title: Text(
        //               'Select All',
        //               style: buildTextStyle(),
        //             ),
        //             onChanged: (value) {
        //               if (value) {
        //                 for (final student in _students) {
        //                   if (!assignedStudents.contains(student))
        //                     assignedStudents.add(student);
        //                 }
        //               } else {
        //                 for (final student in _students) {
        //                   if (assignedStudents.contains(student))
        //                     assignedStudents.remove(student);
        //                 }
        //               }
        //               setState(() {});
        //             },
        //             value: assignedStudents
        //                     .where((element) => _students.contains(element))
        //                     .length ==
        //                 _students.length,
        //           );
        //     return loadingBar;
        //   } else {
        //     return loadingBar;
        //   }
        // }),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.60,
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
                    return ListTile(
                      onTap: () {
                        if (assignedStudents.contains(student))
                          assignedStudents.remove(student);
                        else
                          assignedStudents.add(student);
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
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
                        decoration: ShapeDecoration(
                          color: assignedStudents.contains(student) ? Colors.red : Colors.green,
                          shape: StadiumBorder(),
                        ),
                        child: Text(
                          assignedStudents.contains(student) ? "Unselect" : "Select",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );

                  })),
        )
      ],
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
  //     limit: 1,
  //     page: 10
  //   )
  //       .then((value) {
  //     setState(() {
  //
  //     });
  //   });
  // }
}
