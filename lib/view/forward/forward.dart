import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../bloc/activity/activity-cubit.dart';
import '../../extensions/utils.dart';
import '../../model/user.dart';
import '../drawer/admin-activity.dart';
import '../test-module/TestUtils.dart';
import '/bloc/teacher-school/teacher-school-cubit.dart';
import '/bloc/teacher-school/teacher-school-states.dart';
import '/const.dart';
import '/loader.dart';
import '/view/homepage/home_sliver_appbar.dart';
import '../../model/activity.dart';

class ForwardTaskPage extends StatefulWidget {
  final Activity activity;
  ForwardTaskPage(this.activity);

  @override
  State<ForwardTaskPage> createState() => _ForwardTaskPageState();
}

class _ForwardTaskPageState extends State<ForwardTaskPage> {
  final teacherPagingController =
  PagingController<int, UserInfo>(firstPageKey: 1);
  String teacherId;


  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Forward Task To Teacher',
          style: buildTextStyle(),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SafeArea(
        child: buildTeachersList(),
        // Container(
        //   child: BlocBuilder<SchoolTeacherCubit, SchoolTeacherStates>(
        //       builder: (context, state) {
        //     if (state is SchoolTeacherLoaded)
        //       return ListView.builder(
        //         itemCount: state.teachers.length,
        //         itemBuilder: (context, index) {
        //           return ListTile(
        //             title: Text(
        //               state.teachers[index].name,
        //               style: buildTextStyle(),
        //             ),
        //             leading: TeacherProfileAvatar(
        //               imageUrl: '${state.teachers[index].profileImage}',
        //             ),
        //             onTap: () {
        //               BlocProvider.of<SchoolTeacherCubit>(context,
        //                       listen: false)
        //                   .forwardAssignment(
        //                 AssignTeacher(
        //                   activityId: widget.activity.id,
        //                   teacherId: state.teachers[index].id,
        //                 ),
        //               );
        //               Navigator.of(context).pop();
        //               Navigator.of(context).pop();
        //             },
        //           );
        //         },
        //       );
        //     else {
        //       BlocProvider.of<SchoolTeacherCubit>(context).getAllTeachers();
        //       return Center(
        //         child: loadingBar,
        //       );
        //     }
        //   }),
        // ),
      ),
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
