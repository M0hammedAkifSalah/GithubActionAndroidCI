import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/view/test-module/constants.dart';
import 'package:intl/intl.dart';

import '../../bloc/attendance/attendance-cubit.dart';
import '../../bloc/class-schedule/class-schedule-cubit.dart';
import '../../const.dart';
import '../../extensions/utils.dart';
import '../../model/attendance.dart';
import '../../model/class-schedule.dart';
import '../homepage/home_sliver_appbar.dart';
import 'attendance_class_list.dart';

class EditAttendance extends StatefulWidget {
  final String classId;
  final String className;
  final ClassSection sections;
  final DateTime currentDate;
  String attendanceId;
  List<AttendanceDetail> attendanceDetails;
  final GetByDateAttendanceResponse response;

  EditAttendance(
      {this.classId,
      this.sections,
      this.className,
      this.currentDate,
      this.attendanceDetails,
      this.attendanceId,
      this.response});

  @override
  _EditAttendanceState createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  List<AttendanceDetail> list1 = [];
  ScrollController editScrollController = ScrollController();

  FocusNode focusNode = FocusNode();

  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    list1 = widget.attendanceDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Attendance',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: kBlackColor),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            color: Colors.white,
            // height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.className} (${widget.sections.name})',
                        style: buildTextStyle(
                            size: 18, weight: FontWeight.bold, color: kBlackColor),
                      ),
                      Text(
                          // 'Date - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                          DateFormat('dd MMM').format(widget.currentDate),
                          style: buildTextStyle(
                              size: 15, weight: FontWeight.bold, color: kGreyColor)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Total',
                            style: buildTextStyle(color: kBlackColor, size: 15),
                          ),
                          Text(
                            '${list1.length}',
                            style: buildTextStyle(
                              size: 20,
                              color: kBlackColor,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Present',
                            style: buildTextStyle(color: kBlackColor, size: 15),
                          ),
                          Text(
                            '${list1.where((element) => element.status.toLowerCase() == 'present').length}',
                            style: buildTextStyle(
                              size: 20,
                              color: Colors.green,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Absent',
                            style: buildTextStyle(color: kBlackColor, size: 15),
                          ),
                          Text(
                            '${list1.where((element) => element.status.toLowerCase() == 'absent').length}',
                            style: buildTextStyle(
                              size: 20,
                              color: Colors.red,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 36.0,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    focusNode: focusNode,
                    controller: searchTextController,
                    style: const TextStyle(fontSize: 13),
                    onChanged: (value) {
                      setState(() {});
                    },
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
                        contentPadding: const EdgeInsets.only(top: 6, bottom: 6, left: 8),
                        suffixIcon: searchTextController.text != ""
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {});
                                  searchTextController.clear();
                                })
                            : const Icon(
                                Icons.search,
                                size: 22,
                              ),
                        labelText: 'search title',
                        labelStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                        hintText: 'search title',
                        hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                        fillColor: Colors.white70),
                  ),
                ),
                Divider(
                  thickness: 1.5,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  // color: Colors.red,
                  height: MediaQuery.of(context).size.height * 0.62,
                  // height: 200,
                  child: ListView.builder(
                    controller: editScrollController,
                    // separatorBuilder:
                    //     (context,
                    //             index) =>
                    //         const SizedBox(
                    //   height: 15,
                    // ),
                    // shrinkWrap: true,
                    // itemCount: state.students.length,
                    itemCount: list1.length,
                    itemBuilder: (context, index) {
                      if (searchTextController.text.isNotEmpty) if (!(list1[index]
                          .studentId
                          .name
                          .toLowerCase()
                          .contains(searchTextController.text
                              .toString()
                              .trim()
                              .toLowerCase()))) {
                        return Container();
                      }
                      return ListTile(
                        leading: TeacherProfileAvatar(
                          imageUrl: list1[index].studentId.profileImage ?? 'text',
                        ),
                        title: Text(
                          list1[index].studentId.name,
                          style: buildTextStyle(size: 14),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            // editAttendanceDetails.add(
                            // StudentsAttendanceDetail(
                            //     studentId: widget
                            //         .response
                            //         .attendanceDetails[
                            //             index]
                            //         .studentId
                            //         .id,
                            //     status: widget
                            //         .response
                            //         .attendanceDetails[
                            //             index]
                            //         .status));

                            if (list1[index].status.toLowerCase() == 'present') {
                              list1[index].status = 'Absent';
                            } else {
                              list1[index].status = 'Present';
                            }
                            setState(() {
                              // if (state.students[index].status.toLowerCase() == 'present') {
                              //   state.students[index].status = 'Absent';
                              // } else {
                              //   state.students[index].status = 'Present';
                              // }
                            });
                          },
                          child: Container(
                            width: 70.0,
                            height: 30.0,
                            decoration: BoxDecoration(
                              color: list1[index].status.toLowerCase() == "present"
                                  ? Color(0xff6fcf97)
                                  : Color(0xffFB4D3D),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Center(
                                child: Text(
                              list1[index].status.toLowerCase() == "present"
                                  ? "Present"
                                  : "Absent",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CustomRaisedButton(
                  title: 'Update',
                  onPressed: () {
                    // attendanceDetailsList.addAll(editAttendanceDetails);
                    AttendanceModel attendanceModel = AttendanceModel();
                    DateTime currentDate = widget.currentDate;
                    attendanceModel.date =
                        DateTime(currentDate.year, currentDate.month, currentDate.day);
                    attendanceModel.classId = widget.classId;
                    attendanceModel.sectionId = widget.sections.id;
                    attendanceModel.classTeacher = widget.response.classTeacher.name;
                    log('id' + widget.attendanceId);
                    attendanceModel.attendanceTakenByTeacher =
                        widget.response.attendanceTakenByTeacher.name;
                    attendanceModel.schoolId = widget.response.schoolId.id;
                    attendanceModel.attendanceDetails =
                        List<StudentsAttendanceDetail>.from(list1.map((e) =>
                            StudentsAttendanceDetail(
                                status: e.status, studentId: e.studentId.id)));

                    // attendanceModel.attendanceDetails = List
                    // attendanceModel.attendanceDetails = attendanceDetailsList;
                    // attendanceModel.attendanceDetails = List<StudentsAttendanceDetail>.from(
                    //     editAttendanceDetails.students.map((e) => StudentsAttendanceDetail(
                    //       status: e.status,
                    //       studentId: e.id,
                    //     )));

                    BlocProvider.of<AttendanceCubit>(context)
                        .editAttendance(attendanceModel, widget.attendanceId);

                    Navigator.of(context).popUntil((route) => route.isFirst);

                    Navigator.of(context).push(
                      createRoute(
                        pageWidget:
                            // MultiBlocProvider(
                            //   providers: [
                            //     BlocProvider(
                            //       create: (context) =>
                            //       ClassDetailsCubit()
                            //         ..loadClassDetails(),
                            //     )
                            //     // BlocProvider(
                            //     //   create: (context) => AttendanceCubit()
                            //     //     ..editAttendance(attendanceModel,
                            //     //         widget.attendanceId),
                            //     // ),
                            //   ],
                            //   child: AttendanceClassList(date: widget.currentDate),
                            // ),

                            MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  ClassDetailsCubit()..loadClassDetails(),
                            ),
                            BlocProvider(
                              create: (context) => AttendanceCubit()
                                ..getAttendanceByDate(
                                    AttendanceByDate(date: widget.currentDate)),
                            ),
                          ],
                          child: AttendanceClassList(date: widget.currentDate),
                        ),
                      ),
                    );
                    Fluttertoast.showToast(
                        msg: "Attendance updated",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 2,
                        backgroundColor: Color(0xff6fcf97),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
