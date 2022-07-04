import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';
import 'package:growonplus_teacher/view/Institute/institute_homepage.dart';

class AssignSession extends StatefulWidget {
  const AssignSession(
      {Key key, this.session, this.user, this.files, this.title, this.isEdit})
      : super(key: key);
  final String title;
  final List<PlatformFile> files;
  final UserInfo user;
  final Session session;
  final bool isEdit;

  @override
  State<AssignSession> createState() => _AssignSessionState();
}

class _AssignSessionState extends State<AssignSession> {
  ExpandedTileController expandedTileController =
      ExpandedTileController(isExpanded: false);

  List<SchoolList> schoolIds = [];

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<InstituteCubit>(context)
    //     .getInstitute(widget.user.schoolId.institute.id);
    widget.session.schools = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: buildSchoolsList(),
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size(100, 30),
          child: Container(
            width: 200,
            // height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xffFFC30A),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              widget.user.schoolId.institute.name.toUpperCase(),
              style: buildTextStyle(),
            ),
          ),
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
      bottomNavigationBar: CustomBottomBar(
        title: 'Assign',
        onPressed: () {
          widget.session.schools.addAll(schoolIds.map((e) => e.id).toList());
          widget.session.instituteId = widget.user.schoolId.institute.id;

          if (!widget.isEdit) {
            log('Session created Successfully! ' + widget.isEdit.toString());
            BlocProvider.of<InstituteCubit>(context)
                .postSession(widget.session, widget.files)
                .whenComplete(() {
              // showAssignedDialogue(context, 'Session',destination: InstituteHomePage(user: widget.user,));
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text('Session assigned Successfully!'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.of(context).push(createRoute(
                                  pageWidget: BlocProvider(
                                create: (context) {
                                  return SessionCubit()
                                    ..displaySessionForToday(
                                      schoolId: widget.user != null
                                          ? widget.user.schoolId.id
                                          : null,
                                      instituteId: widget.user != null
                                          ? widget.user.schoolId.institute.id
                                          : null,
                                    );
                                },
                                child: InstituteHomePage(
                                  user: widget.user,
                                ),
                              )));
                            },
                            child: Text('Ok')),
                      ]);
                },
              );
            });
          }

          if (widget.isEdit) {
            log('Session edited Successfully! ' + widget.isEdit.toString());
            BlocProvider.of<InstituteCubit>(context)
                .updateSession(widget.session, widget.session.id)
                .whenComplete(() {
              // showAssignedDialogue(context, 'Session',destination: InstituteHomePage(user: widget.user,));
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text('Session edited Successfully!'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.of(context).push(createRoute(
                                  pageWidget: BlocProvider(
                                create: (context) {
                                  return SessionCubit()
                                    ..displaySessionForToday(
                                      schoolId: widget.user != null
                                          ? widget.user.schoolId.id
                                          : null,
                                      instituteId: widget.user != null
                                          ? widget.user.schoolId.institute.id
                                          : null,
                                    );
                                },
                                child: InstituteHomePage(
                                  user: widget.user,
                                ),
                              )));
                            },
                            child: Text('Ok')),
                      ]);
                },
              );
            });
          }
        },
        check: schoolIds.isNotEmpty,
      ),
    );
  }

  buildSchoolsList() {
    return BlocBuilder<InstituteCubit, InstituteStates>(builder: (context, state) {
      if (state is InstituteLoaded) {
        List<SchoolList> schoolList = state.instituteModel.schoolList;
        Map<SchoolListState, List<SchoolList>> x =
            groupBy(schoolList, (obj) => obj.state);

        return Column(
          children: [
            ListTile(
              trailing: InkWell(
                onTap: () {
                  if (schoolIds.length == schoolList.length) {
                    schoolIds.clear();
                  } else {
                    schoolIds.clear();
                    schoolIds.addAll(schoolList);
                  }
                  setState(() {});
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: schoolIds.length == schoolList.length
                          ? Colors.yellow
                          : Colors.white,
                      border: Border.all(
                          width: 4.0,
                          color: schoolIds.length == schoolList.length
                              ? Colors.white
                              : Colors.yellowAccent),
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  // decoration: ShapeDecoration(
                  //   color: schoolIds.contains(schoolId)
                  //       ? Colors.yellow
                  //       : Colors.yellowAccent,
                  //   shape: StadiumBorder(),
                  // ),
                  child: Text(
                    schoolIds.length == schoolList.length ? 'Deselect All' : 'Select All',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: x.length,
                  itemBuilder: (BuildContext context, int index) {
                    SchoolListState key = x.keys.elementAt(index);
                    List<SchoolList> stateSchoolList = x[key];
                    var selectedSchoolList =
                        schoolIds.where((element) => element.state == key).length;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Card(
                        child: ExpansionTile(
                          trailing: InkWell(
                            onTap: () {
                              if (selectedSchoolList == stateSchoolList.length) {
                                schoolIds.removeWhere((element) => element.state == key);
                              } else {
                                schoolIds.removeWhere((element) => element.state == key);
                                schoolIds.addAll(stateSchoolList);
                              }
                              setState(() {});
                            },
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: selectedSchoolList == stateSchoolList.length
                                      ? Colors.yellow
                                      : Colors.white,
                                  // schoolIds.contains(schoolId)
                                  //     ? Colors.yellow
                                  //     : Colors.white,
                                  border: Border.all(
                                    width: 4.0,
                                    color: selectedSchoolList == stateSchoolList.length
                                        ? Colors.white
                                        : Colors.yellow,
                                    // schoolIds.contains(schoolId)
                                    //     ? Colors.white
                                    //     : Colors.yellowAccent
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
                              // decoration: ShapeDecoration(
                              //   color: schoolIds.contains(schoolId)
                              //       ? Colors.yellow
                              //       : Colors.yellowAccent,
                              //   shape: StadiumBorder(),
                              // ),
                              child: Text(
                                selectedSchoolList == stateSchoolList.length
                                    ? "Deselect All"
                                    : "Select All",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            key.stateName,
                            style: buildTextStyle(
                              color: Color(0xff3b3b3b),
                            ),
                          ),
                          children: [
                            for (var e in stateSchoolList)
                              ListTile(
                                onTap: () {
                                  if (schoolIds.contains(e)) {
                                    schoolIds.remove(e);
                                  } else {
                                    schoolIds.add(e);
                                  }
                                  setState(() {});
                                },
                                title: Text(e.schoolName),
                                leading: TeacherProfileAvatar(
                                  imageUrl: e.schoolImage,
                                ),
                                subtitle: Text(e.city.cityName),
                                trailing: Container(
                                  clipBehavior: Clip.antiAlias,
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      color: schoolIds.contains(e)
                                          ? Colors.yellow
                                          : Colors.white,
                                      border: Border.all(
                                          width: 4.0,
                                          color: schoolIds.contains(e)
                                              ? Colors.white
                                              : Colors.yellowAccent),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12.0))),
                                  // decoration: ShapeDecoration(
                                  //   color: schoolIds.contains(schoolId)
                                  //       ? Colors.yellow
                                  //       : Colors.yellowAccent,
                                  //   shape: StadiumBorder(),
                                  // ),
                                  child: Text(
                                    schoolIds.contains(e) ? "Deselect" : "Select",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                )),
          ],
        );
      } else {
        // BlocProvider.of<InstituteCubit>(context)
        //     .getInstitute(widget.user.schoolId.institute.id);
        return loadingBar;
      }
    });
  }
}
