import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/app-config.dart';

import '/export.dart';
import '/view/assign-task/edit-group.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
           'Create Group',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {},
                    child: Container(

                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffFFC30A),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text('Student Group'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(child: buildGroupsList()),
              ],
            ),
          ),
        ));
  }

  BlocBuilder<GroupCubit, GroupStates> buildGroupsList() {
    return BlocBuilder<GroupCubit, GroupStates>(builder: (context, states) {
      if (states is StudentGroupsLoaded) {
        var _group = states.group.group;
        return Column(
          children: [
            ListTile(
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
                            StudentProfileCubit()..loadStudentProfile(limit: 10,page: 1),
                      ),
                      BlocProvider<ScheduleClassCubit>(
                        create: (ctx) => ScheduleClassCubit(),
                      ),
                      BlocProvider<TestModuleClassCubit>(
                        create: (ctx) =>
                            TestModuleClassCubit()..loadAllClasses(),
                      ),
                    ],
                    child: SelectStudents(
                      createNew: true,
                      readOnly: false,
                    ),
                  )),
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
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              child: ListView.builder(
                itemCount: _group.length,
                shrinkWrap: true,
                itemBuilder: (ctx, index) {
                  // if (index == _group.length) {
                  //   return ListTile(
                  //     onTap: () {
                  //       Navigator.of(context).push(
                  //         createRoute(
                  //             pageWidget: MultiBlocProvider(
                  //           providers: [
                  //             BlocProvider<GroupCubit>(
                  //               create: (ctx) => GroupCubit(),
                  //             ),
                  //             BlocProvider<StudentProfileCubit>(
                  //               create: (ctx) =>
                  //                   StudentProfileCubit()..loadStudentProfile(),
                  //             ),
                  //             BlocProvider<ScheduleClassCubit>(
                  //               create: (ctx) => ScheduleClassCubit(),
                  //             ),
                  //           ],
                  //           child: SelectStudents(
                  //             createNew: true,
                  //             readOnly: false,
                  //           ),
                  //         )),
                  //       );
                  //     },
                  //     title: Text('Create New Batch'),
                  //     leading: CircleAvatar(
                  //       backgroundColor: Color(0xffFFC30A),
                  //       child: Icon(
                  //         Icons.add,
                  //         color: Colors.black,
                  //       ),
                  //     ),
                  //     trailing: Icon(Icons.navigate_next),
                  //   );
                  // }
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
                            child:

                            SelectStudents(
                              createNew: false,
                              readOnly: true,
                              group: _group[index],
                            ),
                          ),
                        ),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            var group = await Navigator.of(context).push(
                              createRoute(
                                pageWidget: EditStudentGroupPage(
                                  group: _group[index],
                                ),
                              ),
                            );
                            if (group != null)
                              setState(() {
                                _group[index] = group;
                              });
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_forever),
                          onPressed: () {
                            showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      Text('Do you want to delete this group?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Yes'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                );
                              },
                            ).then((value) async {
                              if (value) {
                                await BlocProvider.of<RewardStudentCubit>(
                                        context)
                                    .deleteGroup(_group[index].id);
                                _group.remove(_group[index]);
                                setState(() {});
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    title: Text("${_group[index].name}"),
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
            ),
          ],
        );
      } else
        return Center(
          child: CircularProgressIndicator(),
        );
    });
  }
}
