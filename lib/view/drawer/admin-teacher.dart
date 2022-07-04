import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../test-module/TestUtils.dart';
import '/export.dart';
import '/view/drawer/admin-activity.dart';

class SelectTeacherAdminPage extends StatefulWidget {
  const SelectTeacherAdminPage({Key key}) : super(key: key);

  @override
  _SelectTeacherAdminPageState createState() => _SelectTeacherAdminPageState();
}

class _SelectTeacherAdminPageState extends State<SelectTeacherAdminPage> {

  final teacherPagingController =
  PagingController<int, UserInfo>(firstPageKey: 1);
  String teacherId;


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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text('Select Teacher',style: buildTextStyle(),),
      ),
      body: buildTeachersList(),
    );
  }

  Widget buildTeachersList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.90,
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
                  return ListTile(
                            onTap: () {
                              BlocProvider.of<ActivityCubit>(context)
                                  .loadAdminActivities('drawer', {
                                "status": "Pending",
                                "teacher_id": teacher.id,
                                // "assignTo_you.status": "Pending",
                              });
                              Navigator.of(context).push(
                                createRoute(
                                    pageWidget: AdminActivityPage(
                                  school: false,
                                  teacherId: teacher.id,
                                )),
                              );
                            },
                            title: Text(
                              teacher.name??'',
                              style: buildTextStyle(),
                            ),
                            leading: TeacherProfileAvatar(
                              imageUrl: '${teacher.profileImage}',
                            ),
                          );
                }else{
                  return Container(height: 0,);
                }
              })),
    );
              // ListView.builder(
              //   controller: teacherController,
              //   itemCount: state.teachers.length + 1,
              //   itemBuilder: (context, index) {
              //     if (index == state.teachers.length) {
              //       return loadingTeacher
              //           ? Center(
              //               child: CupertinoActivityIndicator(),
              //             )
              //           : Container();
              //     }
              //     // if (!state.teachers[index - 1].name.toLowerCase().contains(
              //     //         _textEditingControllerTeacher.text.toLowerCase()) &&
              //     //     _textEditingControllerTeacher.text != '')
              //     //   return Container(
              //     //     height: 0,
              //     //   );
              //     // if (state.teachers[index - 1].id == state.teacherId)
              //     //   return Container(
              //     //     height: 0,
              //     //   );
              //     return ListTile(
              //       onTap: () {
              //         BlocProvider.of<ActivityCubit>(context)
              //             .loadAdminActivities('drawer', {
              //           "status": "Pending",
              //           "teacher_id": state.teachers[index].id,
              //           // "assignTo_you.status": "Pending",
              //         });
              //         Navigator.of(context).push(
              //           createRoute(
              //               pageWidget: AdminActivityPage(
              //             school: false,
              //             teacherId: state.teachers[index].id,
              //           )),
              //         );
              //       },
              //       title: Text(
              //         state.teachers[index].name + '',
              //         style: buildTextStyle(),
              //       ),
              //       leading: TeacherProfileAvatar(
              //         imageUrl: '${state.teachers[index].profileImage}',
              //       ),
              //     );
              //   },
              // )


  }
}
