import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/view/attendance/edit_attendance.dart';
import 'package:growonplus_teacher/view/test-module/constants.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '/export.dart';
import '/model/class-schedule.dart';
import '/view/schedule_class/custom-date-picker.dart';
import '../../bloc/attendance/attendance-cubit.dart';
import '../../model/attendance.dart';
import 'attendance_class_list.dart';

class AttendanceStudentList extends StatefulWidget {
  final String classId;
  final String className;
  final ClassSection sections;
  final DateTime currentDate;
  final GetByDateAttendanceResponse response;

  // final String sectionId;

  AttendanceStudentList({
    this.classId,
    // this.sectionId,
    this.response,
    this.sections,
    this.className,
    this.currentDate,
  });

  @override
  _AttendanceStudentListState createState() => _AttendanceStudentListState();
}

class _AttendanceStudentListState extends State<AttendanceStudentList>
    with SingleTickerProviderStateMixin {
  DatePickerController _datePickerController = DatePickerController();
  ScrollController controller = ScrollController();
  ScrollController scrollController = ScrollController();
  DateTime _currentDate = DateTime.now();
  int month = DateTime.now().month;
  int page = 1;
  bool loading = false;
  bool init = true;
  DateTime fromDate;
  DateTime toDate;
  TabController _tab;
  int _currentStep = 0;
  bool isAllPresent = true;
  List<StudentsAttendanceDetail> attendanceDetailsList = [];
  List presentList = [];
  List absentList = [];
  List<AttendanceDetail> editAttendanceDetails = [];
  final studentPagingController = PagingController<int, StudentInfo>(firstPageKey: 1);

  // StepperType stepperType = StepperType.vertical;

  bool check;

  // bool isEdit = false;
  int number = 0;

  @override
  void initState() {
    super.initState();
    studentPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _tab = TabController(vsync: this, length: 1);
    if (widget.response != null) {
      if (widget.response.attendanceDetails != null) {
        for (var i in widget.response.attendanceDetails) {
          if (i.status.toLowerCase() == 'present') {
            presentList.add(i.studentId);
          }
          if (i.status.toLowerCase() == 'absent') {
            absentList.add(i.studentId);
          }
        }
        widget.response.attendanceDetails.sort((a, b) {
          return a.status.compareTo(b.status);
        });
        // editAttendanceDetails.addAll(widget.response.attendanceDetails);
      }
    }
    // if (widget.response.attendanceDetails != null)
    //   editAttendanceDetails.addAll(widget.response.attendanceDetails);

    // page = 1;
    // BlocProvider.of<ScheduleClassIdCubit>(context, listen: false)
    //     .getAllClassId()
    //     .then((value) {
    //   log('Entered');
    //   BlocProvider.of<ScheduleClassCubit>(context, listen: false).getAllClass(
    //       DateFormat('yyyy-MM-dd').format(DateTime.now()), context);
    //   log('Class-ids loaded');
    //   setState(() {});
    // });
    // controller.addListener(() {
    //   if (controller.position.pixels == controller.position.maxScrollExtent &&
    //       classState.hasMore) {
    //     if (!loading) {
    //       loading = true;
    //       page++;
    //       BlocProvider.of<ScheduleClassCubit>(context, listen: false)
    //           .getMoreClass(
    //         DateFormat('yyyy-MM-dd').format(_currentDate),
    //         page,
    //         classState,
    //       )
    //           .then((value) {
    //         loading = false;
    //       });
    //     }
    //   }
    // });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // if (_currentDate.month == month) {
    // animateDate();
    // }
  }

  animateDate() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      _datePickerController.animateToDate(
        _currentDate.subtract(Duration(days: _currentDate.day < 3 ? 0 : 3)),
        curve: Curves.easeInOutExpo,
        duration: Duration(milliseconds: 100),
      );
      setState(() {});
    });
  }

  int getDaysCount() {
    if ([1, 3, 5, 7, 8, 10, 12].contains(_currentDate.month))
      return 31;
    else if (_currentDate.month == 2) {
      if (_currentDate.year % 4 == 0) return 29;
      return 28;
    } else
      return 30;
  }

  // void onPress() {
  //   BlocProvider.of<ScheduleClassCubit>(context, listen: false)
  //       .getAllClass('', context);
  //   setState(() {});
  // }

  Future<DateTime> showDatePickerMethod({String title}) {
    return showDatePicker(
      context: context,
      currentDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
      builder: (context, child) {
        return Material(
          color: Colors.black26,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? 'Select Start Date',
                  style: buildTextStyle(
                    color: Colors.white,
                  ),
                ),
                child,
              ],
            ),
          ),
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {
    final newItems = await BlocProvider.of<LearningClassCubit>(context).getStudents(
      classId: widget.classId,
      sectionId: widget.sections.id,
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
    // double progress = widget.state.classDetails[widget.index].sections
    //     .fold(0, (previousValue, element) => element.progress + previousValue);

    return Scaffold(
      // floatingActionButton: Column(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     // FloatingActionButton(
      //     //   heroTag: 'Add',
      //     //   child: Icon(Icons.add),
      //     //   backgroundColor: Color(0xffFFC30A),
      //     //   onPressed: () {
      //     //     Navigator.of(context).push(
      //     //       createRoute(pageWidget: ScheduleClass(isEdit: false,)),
      //     //     );
      //     //   },
      //     // ),
      //     // SizedBox(height: 10),
      //     // FloatingActionButton.extended(
      //     //   heroTag: 'tt',
      //     //   label: Text('Download Timetable'),
      //     //   icon: Icon(Icons.download),
      //     //   backgroundColor: Color(0xffFFC30A),
      //     //   onPressed: () async {
      //     //     fromDate = await showDatePickerMethod();
      //     //     if (fromDate == null) {
      //     //       return;
      //     //     }
      //     //     toDate = await showDatePickerMethod(title: 'Select End Date');
      //     //     if (toDate == null) {
      //     //       return;
      //     //     }
      //     //     Fluttertoast.showToast(msg: 'Getting your timetable');
      //     //     log('List is empty: ${allClassState.allClassSchedules.isEmpty}');
      //     //     await SyllabusPdf().createSyllabusPdf(context, fromDate, toDate,
      //     //         classes: allClassState.allClassSchedules);
      //     //     // Navigator.of(context).push(
      //     //     //   createRoute(pageWidget: ScheduleClass()),
      //     //     // );
      //     //   },
      //     // ),
      //   ],
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () async {
            // bool check = await showDialog<bool>(
            //   builder: (context) {
            //      AlertDialog(
            //       title: Text('Are you sure to go back?'),
            //       actions: [
            //         TextButton(
            //           onPressed: () {
            //             Navigator.of(context).pop(true);
            //           },
            //           child: Text('Yes'),
            //         ),
            //         TextButton(
            //           onPressed: () {
            //             Navigator.of(context).pop(false);
            //           },
            //           child: Text('No'),
            //         ),
            //       ],
            //     );
            // },
            // );
            // if (check) {
            Navigator.of(context).pop();
            // }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Attendance - ',
              style: buildTextStyle(
                size: 15,
                weight: FontWeight.bold,
              ),
            ),
            Text(
              ' ${widget.className} (${widget.sections.name})',
              style: buildTextStyle(size: 15, weight: FontWeight.bold, color: kColor),
            ),
          ],
        ),
        actions: [
          if (widget.response != null)
            InkWell(
              onTap: () {
                List<AttendanceDetail> list1 = [];
                for (var i in widget.response.attendanceDetails) {
                  list1.add(i.copy());
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditAttendance(
                            attendanceDetails: list1,
                            currentDate: widget.currentDate,
                            className: widget.className,
                            classId: widget.classId,
                            sections: widget.sections,
                            attendanceId: widget.response.id,
                            response: widget.response,
                          )),
                );
              },
              child: Container(
                height: 10,
                padding: EdgeInsets.symmetric(horizontal: 3),
                margin: EdgeInsets.symmetric(horizontal: 3),
                // decoration: BoxDecoration(
                //   color: Color(0xffFFC30A),
                //   borderRadius:
                //       BorderRadius.circular(20.0),
                // ),
                child: Center(
                    child: Row(
                  children: [
                    // Text(
                    //   'Edit ',
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 15),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ],
                )),
              ),
            ),
        ],
        centerTitle: true,
      ),
      body: Container(
        child: SafeArea(
            child: widget.response == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            // DatePicker(
                            //   _currentDate.subtract(
                            //     Duration(days: _currentDate.day - 1),
                            //   ),
                            //   height: 105,
                            //   allClassDates: [],
                            //   //state is ClassScheduleIdLoaded
                            //   //     ? state.allClassSchedules
                            //   //         .map((e) => e.startTime)
                            //   //         .toList()
                            //   //     : [],
                            //   width: 50,
                            //   controller: _datePickerController,
                            //   daysCount: getDaysCount(),
                            //   initialSelectedDate: _currentDate,
                            //   onMonthYearChange: (selectedDate) {
                            //     // if (selectedDate != null) {
                            //     //   _currentDate = selectedDate;
                            //     //   log('Changed-date: $selectedDate');
                            //     //   setState(() {});
                            //     //   animateDate();
                            //     //   page = 1;
                            //     //   BlocProvider.of<ScheduleClassIdCubit>(context,
                            //     //           listen: false)
                            //     //       .getAllClassId()
                            //     //       .then((value) {
                            //     //     BlocProvider.of<ScheduleClassCubit>(context,
                            //     //             listen: false)
                            //     //         .getAllClass(
                            //     //             DateFormat('yyyy-MM-dd')
                            //     //                 .format(_currentDate),
                            //     //             context);
                            //     //     log('Class-ids loaded');
                            //     //     setState(() {});
                            //     //   });
                            //     // }
                            //   },
                            //   monthTextStyle: buildTextStyle(
                            //     family: 'Poppins',
                            //     size: 14,
                            //   ),
                            //   selectionColor: Color(0xff8ca0c9),
                            //   selectedTextColor: Colors.white,
                            //   dayTextStyle: const TextStyle(
                            //     color: const Color(0xffbcc1cd),
                            //     fontWeight: FontWeight.w500,
                            //     fontFamily: "Poppins",
                            //     fontStyle: FontStyle.normal,
                            //     fontSize: 14.0,
                            //   ),
                            //   dateTextStyle: const TextStyle(
                            //     color: const Color(0xff212525),
                            //     fontWeight: FontWeight.w600,
                            //     fontFamily: "Poppins",
                            //     fontStyle: FontStyle.normal,
                            //     fontSize: 16.0,
                            //   ),
                            //   onDateChange: (date) {
                            //     // _currentDate = date;
                            //     // page = 1;
                            //     // if (!loading)
                            //     //   BlocProvider.of<ScheduleClassCubit>(context,
                            //     //           listen: false)
                            //     //       .getAllClass(
                            //     //     DateFormat('yyyy-MM-dd').format(_currentDate),
                            //     //     context,
                            //     //   )
                            //     //       .then((value) {
                            //     //     loading = false;
                            //     //     setState(() {});
                            //     //   });
                            //   },
                            // ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Date : ',
                                  style: const TextStyle(
                                      color: const Color(0xff737b7b),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0),
                                ),
                                Text(
                                  // widget.currentDate.toString(),
                                  DateFormat('dd MMM yyyy').format(widget.currentDate),
                                  style: const TextStyle(
                                      color: const Color(0xff737b7b),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        child: TabBar(
                          controller: _tab,
                          indicatorColor: kColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          labelStyle: buildTextStyle(color: kColor, size: 14),
                          unselectedLabelStyle: buildTextStyle(size: 14),
                          labelColor: kColor,
                          unselectedLabelColor: Colors.black87,
                          tabs: [
                            Tab(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: kColor,
                                    )),
                                child: Text('Mark by Day',
                                    style: TextStyle(fontWeight: FontWeight.w500)),
                              ),
                            ),
                            // Tab(
                            //   child: Container(
                            //     padding: EdgeInsets.all(5),
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(20),
                            //         border: Border.all(
                            //           color: Color(0xff6fcf97),
                            //         )),
                            //     child: Text('Mark by subject',
                            //         style:
                            //             TextStyle(fontWeight: FontWeight.w500)),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      BlocBuilder<LearningStudentIdCubit, LearningStudentIdStates>(
                          builder: (context, state) {
                        if (state is LearningStudentIdLoaded) {
                          // if (isAllPresent) {
                          attendanceDetailsList = List<StudentsAttendanceDetail>.from(
                              state.students.map((e) => StudentsAttendanceDetail(
                                  studentId: e.id,
                                  status: 'Present',
                                  profileImage: e.profileImage,
                                  name: e.name)));
                          // for(int i=0;i < state.students.length;i++){
                          //   state.students[i].status = 'Present';
                          // }
                          // }
                          // else{
                          //   attendanceDetailsList = List<StudentsAttendanceDetail>.from(state
                          //       .students
                          //       .map((e) => StudentsAttendanceDetail(
                          //       studentId: e
                          //           .id,
                          //       status:
                          //       'Present')));
                          // }
                          // if (!scrollController.hasListeners) {
                          //   scrollController.addListener(() {
                          //     if (scrollController.position.pixels ==
                          //         scrollController.position.maxScrollExtent) {
                          //       log("max extent: ${state.hasMoreData}");
                          //       if (state.hasMoreData) {
                          //         page++;
                          //         log("Page: $page");
                          //         BlocProvider.of<LearningClassCubit>(context)
                          //             .loadMoreStudents(widget.classId,
                          //             widget.sections.id, state, page);
                          //       }
                          //     }
                          //   });
                          // }
                          state.students.map((e) => e.status = 'Present');

                          return Container(
                            height: MediaQuery.of(context).size.height * 0.79,
                            child: TabBarView(
                              controller: _tab,
                              children: [
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.all(3),
                                  child: state.students.isEmpty
                                      ? const Center(
                                          child: Text('No Students are there!'),
                                        )
                                      : Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 12, vertical: 3),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                        'Total Students: ${state.students.length}'
                                                        //         '${state.students.firstWhere(
                                                        //   (element) => element.totalStudent != null,
                                                        //   orElse: () {
                                                        //     return StudentInfo(totalStudent: 0);
                                                        //   },
                                                        // ).totalStudent}'
                                                        ),
                                                    InkWell(
                                                      onTap: () {
                                                        attendanceDetailsList.clear();

                                                        setState(() {
                                                          if (isAllPresent) {
                                                            attendanceDetailsList = List<
                                                                    StudentsAttendanceDetail>.from(
                                                                state.students.map((e) =>
                                                                    StudentsAttendanceDetail(
                                                                        studentId: e.id,
                                                                        status:
                                                                            'Absent')));
                                                            for (int i = 0;
                                                                i < state.students.length;
                                                                i++) {
                                                              state.students[i].status =
                                                                  'absent';
                                                            }
                                                            isAllPresent = false;
                                                          } else {
                                                            attendanceDetailsList = List<
                                                                    StudentsAttendanceDetail>.from(
                                                                state.students.map((e) =>
                                                                    StudentsAttendanceDetail(
                                                                        studentId: e.id,
                                                                        status:
                                                                            'Present')));
                                                            for (int i = 0;
                                                                i < state.students.length;
                                                                i++) {
                                                              state.students[i].status =
                                                                  'present';
                                                            }
                                                            isAllPresent = true;
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                        ),
                                                        width: MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.45,
                                                        height: 40.0,
                                                        decoration: BoxDecoration(
                                                          color: isAllPresent
                                                              ? Color(0xffFB4D3D)
                                                              : Color(0xff6fcf97),
                                                          borderRadius:
                                                              BorderRadius.circular(20.0),
                                                          // border: Border.all(
                                                          //     color: isAllPresent
                                                          //         ? Color(0xffFB4D3D)
                                                          //         : Color(0xff6fcf97))
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              isAllPresent
                                                                  ? "Mark all Absent"
                                                                  : "Mark all Present",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  // color: isAllPresent
                                                                  //     ? Color(0xffFB4D3D)
                                                                  //     : Color(0xff6fcf97),
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            Icon(
                                                              Icons.checklist,
                                                              color: Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Divider(),
                                            Container(
                                              height: MediaQuery.of(context).size.height *
                                                  0.64,
                                              child: PagedListView<int, StudentInfo>(
                                                  // shrinkWrap: false,
                                                  pagingController:
                                                      studentPagingController,
                                                  builderDelegate:
                                                      PagedChildBuilderDelegate<
                                                              StudentInfo>(
                                                          noItemsFoundIndicatorBuilder:
                                                              (context) {
                                                    return Text('No Items');
                                                  }, itemBuilder: (context, item, index) {
                                                    var _student = item;
                                                    _student.section = widget.sections.id;
                                                    _student.userInfoClass =
                                                        widget.classId;
                                                    return ListTile(
                                                      leading: TeacherProfileAvatar(
                                                        imageUrl: _student.profileImage ??
                                                            'text',
                                                      ),
                                                      title: Text(
                                                        '${_student.name}',
                                                        style: buildTextStyle(size: 16),
                                                      ),
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          if (state.students[index].status
                                                                  .toLowerCase() ==
                                                              'present') {
                                                            state.students[index].status =
                                                                'Absent';
                                                          } else {
                                                            state.students[index].status =
                                                                'Present';
                                                          }
                                                          // if (_student.status.toLowerCase() == 'present') {
                                                          //   _student.status = 'Absent';
                                                          // } else {
                                                          //   _student.status = 'Present';
                                                          // }

                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          width: 80,
                                                          height: 30.0,
                                                          decoration: BoxDecoration(
                                                            color: state.students[index]
                                                                        .status
                                                                        .toLowerCase() ==
                                                                    'present'
                                                                // _student.status.toLowerCase() == 'present'
                                                                ? Color(0xff6fcf97)
                                                                : Color(0xffFB4D3D),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20.0),
                                                            // border: Border.all(
                                                            //     color: state.students[index].attendanceType ==
                                                            //             AttendanceType.
                                                            //         ? Colors.black54
                                                            //         : Colors.transparent)
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            state.students[index].status
                                                                .toTitleCase(),
                                                            // state.students[index].status.toLowerCase() == 'present'
                                                            // // _student.status.toLowerCase() == 'present'
                                                            //     ? "Present"
                                                            //     : "Absent",
                                                            style: TextStyle(
                                                                color:
                                                                    // state.students[index].attendanceType ==
                                                                    //         AttendanceType.
                                                                    //     ? Colors.black54
                                                                    //     :
                                                                    Colors.white,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          )),
                                                        ),
                                                      ),
                                                    );
                                                  })),
                                            ),
                                            // Container(
                                            //   decoration: BoxDecoration(
                                            //       boxShadow: [
                                            //         BoxShadow(
                                            //           color: Colors.black26,
                                            //           blurRadius: 20.0,
                                            //         ),
                                            //       ],
                                            //       color: Colors.white.withOpacity(0.8),
                                            //       borderRadius: BorderRadius.only(
                                            //           topLeft: Radius.circular(10),
                                            //           topRight: Radius.circular(10))),
                                            //   height: 55,
                                            //   padding: EdgeInsets.symmetric(
                                            //       horizontal: 95, vertical: 7),
                                            //   child:
                                            CustomRaisedButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    barrierColor:
                                                        Colors.blueGrey.withOpacity(0.2),
                                                    backgroundColor: Colors.white,
                                                    elevation: 5,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.vertical(
                                                          top: Radius.circular(20.0)),
                                                    ),
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return buildAttendanceReport(
                                                          context, state);
                                                    });
                                              },
                                              title: 'Submit Attendance',
                                              width:
                                                  MediaQuery.of(context).size.width * 0.5,
                                              // child: Container(
                                              //   // width: 65,
                                              //   height: 40.0,
                                              //   decoration: BoxDecoration(
                                              //     color: Color(0xff6fcf97),
                                              //     borderRadius:
                                              //         BorderRadius.circular(20.0),
                                              //     // border: Border.all(color: Colors.black54),
                                              //     boxShadow: [
                                              //       BoxShadow(
                                              //         color:
                                              //             Colors.grey.withOpacity(0.5),
                                              //         spreadRadius: 5,
                                              //         blurRadius: 10,
                                              //       ),
                                              //     ],
                                              //   ),
                                              //   child: Center(
                                              //       child: Text(
                                              //     'Submit Attendance',
                                              //     style: TextStyle(
                                              //         color: Colors.white,
                                              //         fontWeight: FontWeight.bold),
                                              //   )),
                                              // ),
                                            ),
                                            // )
                                          ],
                                        ),
                                ),
                                // Container(
                                //   child: Center(
                                //     child: Text(
                                //         'Mark by subject is under progress'),
                                //   ),
                                // )
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            child: Center(
                              child: loadingBar,
                            ),
                          );
                        }
                      })
                    ],
                  )
                : Column(
                    children: [
                      Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.height * 0.887,
                          child: Column(
                            children: [
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // PreferredSize(
                              //     child: AppBar(
                              //       backgroundColor: Colors.white,
                              //       automaticallyImplyLeading: false,
                              //       centerTitle: true,
                              //       title: Text(
                              //         'Attendance Report',
                              //         style: TextStyle(
                              //             fontSize: 15,
                              //             fontWeight: FontWeight.bold,
                              //             color: Colors.blue),
                              //       ),
                              //       actions: [
                              //
                              //
                              //       ],
                              //     ),
                              //     preferredSize: Size.fromHeight(0)),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Text(
                              //   'Class - ${widget.className} (${widget.sections.name})',
                              //   style: buildTextStyle(
                              //       size: 14,
                              //       weight: FontWeight.bold,
                              //       color: Color(0xff6FCF97)),
                              // ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        TeacherProfileAvatar(
                                          imageUrl: widget
                                                  .response
                                                  .attendanceTakenByTeacher
                                                  .profileImage ??
                                              'text',
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Taken by",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: kBlackColor),
                                              ),
                                              Text(
                                                widget.response.attendanceTakenByTeacher
                                                    .name
                                                    .toTitleCase(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: kBlackColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        '${DateFormat('dd MMM').format(widget.currentDate) + ' ' + DateFormat('hh:mm a').format(widget.response.createdAt)}',
                                        style: buildTextStyle(
                                            size: 15,
                                            weight: FontWeight.bold,
                                            color: kGreyColor)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Total',
                                          style: buildTextStyle(
                                            color: kBlackColor,
                                            size: 15,
                                          ),
                                        ),
                                        Text(
                                          '${widget.response.attendanceDetails.length}',
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
                                          style: buildTextStyle(
                                              color: kBlackColor, size: 15),
                                        ),
                                        Text(
                                          '${presentList.length}',
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
                                          style: buildTextStyle(
                                              color: kBlackColor, size: 15),
                                        ),
                                        Text(
                                          '${absentList.length}',
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // SizedBox(
                                    //   height: 15.0,
                                    // ),
                                    Divider(
                                      thickness: 1.5,
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      height: MediaQuery.of(context).size.height * 0.7,
                                      child: ListView.builder(
                                        controller: scrollController,
                                        // separatorBuilder:
                                        //     (context,
                                        //             index) =>
                                        //         const SizedBox(
                                        //   height: 15,
                                        // ),
                                        // shrinkWrap: true,
                                        // itemCount: state.students.length,
                                        itemCount:
                                            widget.response.attendanceDetails.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            leading: TeacherProfileAvatar(
                                              imageUrl: widget
                                                      .response
                                                      .attendanceDetails[index]
                                                      .studentId
                                                      .profileImage ??
                                                  'text',
                                            ),
                                            title: Text(
                                              widget.response.attendanceDetails[index]
                                                  .studentId.name,
                                              style: buildTextStyle(size: 14),
                                            ),
                                            trailing: Container(
                                              width: 70.0,
                                              height: 30.0,
                                              decoration: BoxDecoration(
                                                color: widget
                                                            .response
                                                            .attendanceDetails[index]
                                                            .status
                                                            .toLowerCase() ==
                                                        "present"
                                                    ? Color(0xff6fcf97)
                                                    : Color(0xffFB4D3D),
                                                borderRadius: BorderRadius.circular(20.0),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                widget.response.attendanceDetails[index]
                                                            .status
                                                            .toLowerCase() ==
                                                        "present"
                                                    ? "Present"
                                                    : "Absent",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),

                      // Container(child: Center(child: Text(widget.response.toJson().toString())),),
                      // Container(child:
                      // Text(widget.response.attendanceDetails.first.studentId.id.reduce(0, (previousValue, element) => previousValue + (element.attendanceType == AttendanceType.present ? 1 : 0))),)
                    ],
                  )),
      ),
    );
  }

  Container buildAttendanceReport(BuildContext context, LearningStudentIdLoaded state) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.815,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            'Summary',
            style:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kDarkColor),
          ),
          SizedBox(
            height: 10,
          ),
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
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Total',
                      style: buildTextStyle(
                        color: kBlackColor,
                        size: 15,
                      ),
                    ),
                    Text(
                      '${state.students.length}',
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
                      '${state.students.where((element) => element.status.toLowerCase() == 'present').length}',
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
                      '${state.students.where((element) => element.status.toLowerCase() == 'absent').length}',
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
          Divider(
            thickness: 1.5,
            endIndent: 10,
            indent: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            height: MediaQuery.of(context).size.height * 0.55,
            child: ListView.builder(
              controller: scrollController,
              // separatorBuilder:
              //     (context,
              //             index) =>
              //         const SizedBox(
              //   height: 15,
              // ),
              // shrinkWrap: true,
              itemCount: state.students.length,
              itemBuilder: (context, index) {
                if (state.students[index].status.toLowerCase() == 'absent') {
                  log(state.students[index].profileImage.toString());
                  return ListTile(
                    leading: TeacherProfileAvatar(
                      imageUrl: state.students[index].profileImage ?? 'text',
                    ),
                    title: Text(
                      '${state.students[index].name}',
                      style: buildTextStyle(size: 14),
                    ),
                    trailing: Container(
                      width: 70.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: state.students[index].status.toLowerCase() == 'present'
                            ? Color(0xff6fcf97)
                            : Color(0xffFB4D3D),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                          child: Text(
                        state.students[index].status.toTitleCase(),
                        // attendanceDetailsList[index].status,
                        // state.students[index].attendanceType ==
                        //         AttendanceType.present
                        //     ? "Present"
                        //     : "Absent",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 0,
                  );
                }
              },
            ),
          ),
          CustomRaisedButton(
            title: 'Confirm',
            onPressed: () {
              AttendanceModel attendanceModel = AttendanceModel();
              DateTime currentDate = widget.currentDate;
              attendanceModel.date =
                  DateTime(currentDate.year, currentDate.month, currentDate.day);
              attendanceModel.classId = widget.classId;
              attendanceModel.sectionId = widget.sections.id;
              // attendanceModel.attendanceDetails = attendanceDetailsList;
              attendanceModel.attendanceDetails = List<StudentsAttendanceDetail>.from(
                  state.students.map((e) => StudentsAttendanceDetail(
                        status: e.status,
                        studentId: e.id,
                      )));
              log(attendanceModel.toJson().toString());

              BlocProvider.of<AttendanceCubit>(context).createAttendance(attendanceModel);

              Navigator.of(context).popUntil((route) => route.isFirst);

              Navigator.of(context).push(
                createRoute(
                  pageWidget: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => ClassDetailsCubit()..loadClassDetails(),
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
                  msg: "Attendance submitted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 2,
                  backgroundColor: Color(0xff6fcf97),
                  textColor: Colors.white,
                  fontSize: 16.0);

              // Navigator.of(
              //         context)
              //     .pop();
              // Navigator.of(
              //         context)
              //     .pop();
            },
          ),
        ],
      ),
    );
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
