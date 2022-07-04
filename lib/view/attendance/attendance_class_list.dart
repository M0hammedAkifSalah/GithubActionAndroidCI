import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:growonplus_teacher/bloc/attendance/attendance-cubit.dart';
import 'package:growonplus_teacher/bloc/attendance/attendance-state.dart';
import 'package:growonplus_teacher/model/attendance.dart';
import 'package:growonplus_teacher/view/attached_files_and_url_slider.dart';
import 'package:growonplus_teacher/view/attendance/school_attendance_report.dart';
import 'package:intl/intl.dart';

import '/export.dart';
import '/view/schedule_class/custom-date-picker.dart';
import 'attendance_student_list.dart';
import 'class_attendance_report.dart';

class AttendanceClassList extends StatefulWidget {

  DateTime date;
  AttendanceClassList({this.date});

  @override
  _AttendanceClassListState createState() => _AttendanceClassListState();
}

class _AttendanceClassListState extends State<AttendanceClassList>
    with SingleTickerProviderStateMixin {
  DatePickerController _datePickerController;

  ScrollController controller = ScrollController();
  DateTime _currentDate;
  DateTime todayDate;
  int month = DateTime.now().month;
  int page = 1;
  bool loading = false;
  bool init = true;
  DateTime fromDate;
  DateTime toDate;
  TabController _tab;
  int _currentStep = 0;
  List<GetByDateAttendanceResponse> responseList = [];

  List<Step> markAttendanceList = [];

  // StepperType stepperType = StepperType.vertical;

  bool check;

  int _currentStep2 = 0;

  @override
  void initState() {
    super.initState();
    _datePickerController = DatePickerController();
    var currentDate = DateTime.now();
    todayDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
    _currentDate =
        // DateTime(currentDate.year, currentDate.month, currentDate.day);
        widget.date;
    _tab = TabController(vsync: this, length: 2);
    BlocProvider.of<AttendanceCubit>(context).getAttendanceByDate(AttendanceByDate(
        date: DateTime(_currentDate.year, _currentDate.month, _currentDate.day)));

    // animateDate();

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
    BlocProvider.of<AttendanceCubit>(context)
        .getAttendanceByDate(AttendanceByDate(date: _currentDate));
    animateDate(1500);
    // super.didChangeDependencies();
  }

  animateDate(int time) {
    Future.delayed(Duration(milliseconds: time)).then((value) {
      _datePickerController.animateToDate(
        widget.date.subtract(Duration(days: widget.date.day < 3 ? 0 : 3)),
        curve: Curves.easeInOutExpo,
        duration: Duration(milliseconds: 100),
      );
      setState(() {});
    });
  }

  int getDaysCount() {
    if (DateTime(todayDate.year, todayDate.month)
        .isAtSameMomentAs(DateTime(_currentDate.year, _currentDate.month))) {
      return todayDate.day;
    }
    if ([1, 3, 5, 7, 8, 10, 12].contains(_currentDate.month))
      return 31;
    else if (_currentDate.month == 2) {
      if (_currentDate.year % 4 == 0) return 29;
      return 28;
    } else
      return 30;
  }

  // int getDaysCount() {
  //   var day = _currentDate.day;
  // }

  // void onPress() {
  //   BlocProvider.of<ScheduleClassCubit>(context, listen: false)
  //       .getAllClass('', context);
  //   setState(() {});
  // }

  Future<DateTime> showDatePickerMethod({String title}) {
    return showDatePicker(
        context: context,
        currentDate: todayDate,
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
        initialDate: todayDate,
        firstDate: todayDate.subtract(Duration(days: 30)),
        lastDate: todayDate
        // .add(Duration(days: 30)),
        );
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    int dayCount = getDaysCount();
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
        title: Text(
          'Attendance',
          style: buildTextStyle(
            size: 15,
            weight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.99,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    DatePicker(
                      // _currentDate.subtract(
                      //   Duration(days: _currentDate.day - 1),
                      // ),
                      // DateTime(
                      //         dateFuture.year, dateFuture.month, dateFuture.day)
                      //     .subtract(Duration(days: dateFuture.day - 1)),
                      // DateTime(_currentDate.year, _currentDate.month, 1),
                      DateTime(widget.date.year, widget.date.month, 1),
                      deactivateFuture: true,
                      // restrictPrevious: true,
                      height: 105,
                      allClassDates: [],
                      width: 50,
                      controller: _datePickerController,
                      daysCount: dayCount,
                      // daysCount: 31,
                      initialSelectedDate: widget.date,
                      onMonthYearChange: (selectedDate) {
                        DateTime datetime = DateTime(
                            selectedDate.year, selectedDate.month, selectedDate.day);
                        setState(() {
                          _currentDate = datetime;
                          widget.date = datetime;
                        });
                        BlocProvider.of<AttendanceCubit>(context)
                            .getAttendanceByDate(AttendanceByDate(date: _currentDate));

                        animateDate(800);
                        setState(() {});

                        // if (selectedDate != null) {
                        //   _currentDate = selectedDate;
                        //   log('Changed-date: $selectedDate');
                        //   setState(() {});
                        //   animateDate();
                        //   page = 1;
                        //   BlocProvider.of<ScheduleClassIdCubit>(context,
                        //           listen: false)
                        //       .getAllClassId()
                        //       .then((value) {
                        //     BlocProvider.of<ScheduleClassCubit>(context,
                        //             listen: false)
                        //         .getAllClass(
                        //             DateFormat('yyyy-MM-dd')
                        //                 .format(_currentDate),
                        //             context);
                        //     log('Class-ids loaded');
                        //     setState(() {});
                        //   });
                        // }
                      },
                      monthTextStyle: buildTextStyle(
                        family: 'Poppins',
                        size: 14,
                      ),
                      selectionColor: Color(0xff8ca0c9),
                      selectedTextColor: Colors.white,
                      dayTextStyle: const TextStyle(
                        color: const Color(0xffbcc1cd),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0,
                      ),
                      dateTextStyle: const TextStyle(
                        color: const Color(0xff212525),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0,
                      ),
                      // inactiveDates: List<DateTime>.generate(31, (index) => ),
                      onDateChange: (date) {
                        DateTime datetime = DateTime(date.year, date.month, date.day);

                        setState(() {
                          _currentDate = datetime;
                          widget.date = datetime;
                          BlocProvider.of<AttendanceCubit>(context)
                              .getAttendanceByDate(AttendanceByDate(date: datetime));
                        });
                        animateDate(800);
                      },
                      // inactiveDates:
                    ),
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
                              fontSize: 10.0),
                        ),
                        Text(
                          // DateFormat('dd/MM/yyyy').format(DateTime.now()),
                          DateFormat('dd/MM/yyyy').format(_currentDate),

                          style: const TextStyle(
                              color: const Color(0xff737b7b),
                              fontWeight: FontWeight.w600,
                              fontSize: 10.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tab,
                  // onTap: null,
                  // isScrollable: false,
                  // physics: NeverScrollableScrollPhysics(),
                  indicatorColor: kColor,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: buildTextStyle(color: kColor, size: 14),
                  unselectedLabelStyle: buildTextStyle(size: 14),
                  labelColor: kColor,
                  unselectedLabelColor: Colors.black87,
                  onTap: (index) {
                    animateDate(800);
                  },
                  tabs: [
                    Tab(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kColor,
                            )),
                        child: Text('Mark Attendance',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      // text: 'Mark Attendance',
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kColor,
                            )),
                        child: Text('Attendance Report',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),

              // primary class with section**********************************************
              // BlocBuilder<AuthCubit, AuthStates>(builder: (context, state2) {
              //         if (state2 is AccountsLoaded) {
              //           var primaryClass = state2.user.classId;
              //           return  Stepper(
              //             controlsBuilder:
              //                 (BuildContext context, controls) {
              //               return SizedBox();
              //             },
              //             // type: StepperType.horizontal,
              //             physics: ScrollPhysics(),
              //             currentStep: _currentStep2,
              //             onStepTapped: (step) => tapped(step),
              //             onStepContinue: continued,
              //             onStepCancel: cancel,
              //             steps: [
              //               Step(
              //                 title: Text(primaryClass.className),
              //                 subtitle: Text('Primary'),
              //                 content: Container(
              //                     height: 50,
              //                     width: MediaQuery.of(context).size.width * 0.6,
              //                     child: ListView(
              //                       scrollDirection: Axis.horizontal,
              //                       // crossAxisAlignment: CrossAxisAlignment.start,
              //                       children: [
              //                         Text(primaryClass.sections.first.name.toString()),
              //                       ],
              //                     )),
              //               )
              //             ],
              //
              //           );
              //         }
              //         return Container();
              //       }),

              // other classes with section**********************************************

              BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
                  builder: (context, state) {
                if (state is ClassDetailsLoaded) {
                  return BlocBuilder<AttendanceCubit, AttendanceStates>(
                      builder: (context, attendanceState) {
                    if (attendanceState is AttendanceLoaded) {
                      responseList = attendanceState.getByDateAttendanceResponse;
                      if (state.classDetails.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.sadTear,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 50),
                            Center(
                              child: Text(
                                'No class is associated with your profile\n'
                                'Please check My School',
                                style: buildTextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }
                      // List<Step> mappedClassList = List<Step>.from(
                      //     state.mappedClassDetails.map((classObject) {
                      //   List<Widget> widgetList =
                      //       List<Widget>.from(classObject.sections.map(
                      //     (sectionObject) => TextButton(
                      //       onPressed: () {
                      //         Navigator.of(context).push(createRoute(
                      //             pageWidget: BlocProvider(
                      //                 create: (context) => LearningClassCubit()
                      //                   ..getStudents(classObject.classId,
                      //                       sectionObject.id),
                      //                 child: AttendanceStudentList(
                      //                   classId: classObject.classId,
                      //                   sections: sectionObject,
                      //                   className: classObject.className,
                      //                   currentDate: _currentDate,
                      //                 ))));
                      //       },
                      //       child: Container(
                      //           height: 35,
                      //           width: 43,
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(5),
                      //               color: attendanceState.getByDateAttendanceResponse.first.sectionId != null ? Color(0xff6fcf97) : Colors.red),
                      //           child: Center(
                      //               child: Text(
                      //             sectionObject.name,
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 16),
                      //           ))),
                      //     ),
                      //   ));
                      //   return Step(
                      //     title: Text(classObject.className),
                      //     subtitle: Text('Primary'),
                      //     content: Container(
                      //         height: 50,
                      //         width: MediaQuery.of(context).size.width * 0.6,
                      //         child: ListView(
                      //           scrollDirection: Axis.horizontal,
                      //           // crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: widgetList,
                      //         )),
                      //   );
                      // }));

                      markAttendanceList = List<Step>.from(state.classDetails.map((cls) {
                        List<Widget> widgetList = List<Widget>.from(cls.sections.map(
                          (sectionObject) => TextButton(
                            onPressed: () {
                              GetByDateAttendanceResponse response;
                              for (var i in responseList) {
                                if (i.classId.id == cls.classId &&
                                    i.sectionId.id == sectionObject.id) {
                                  response = i;
                                }
                              }

                              Navigator.of(context).push(createRoute(
                                  pageWidget: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (context) => LearningClassCubit()
                                      ..getStudents(
                                          page: 1,
                                          sectionId: sectionObject.id,
                                          classId: cls.classId,
                                          limit: 10),
                                  ),
                                  BlocProvider(
                                      create: (context) => LearningStudentIdCubit()
                                        ..getStudentsId([sectionObject.id]))
                                ],
                                child: AttendanceStudentList(
                                  classId: cls.classId,
                                  sections: sectionObject,
                                  className: cls.className,
                                  currentDate: _currentDate,
                                  response: response,
                                  // responseList.isNotEmpty ? responseList.singleWhere((element) => element.classId.id == classObject.classId && element.sectionId.id == sectionObject.id,orElse: null):null,
                                ),
                              )));
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                // height: 35,
                                // width: 43,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: attendanceState.getByDateAttendanceResponse
                                            .where((element) =>
                                                element.sectionId.id == sectionObject.id)
                                            .isNotEmpty
                                        ? Color(0xff6fcf97)
                                        : Colors.redAccent),
                                child: Center(
                                    child: Text(
                                  sectionObject.name,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ))),
                          ),
                        ));
                        return Step(
                            title: Text(cls.className),
                            content: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widgetList,
                                )),
                            isActive: true);
                      }));

                      List<Step> attendanceReportList =
                          List<Step>.from(state.classDetails.map((classObject) {
                        List<Widget> widgetList =
                            List<Widget>.from(classObject.sections.map(
                          (sectionObject) => TextButton(
                            onPressed: () {
                              GetByDateAttendanceResponse response;
                              for (var i in responseList) {
                                if (i.classId.id == classObject.classId &&
                                    i.sectionId.id == sectionObject.id) {
                                  response = i;
                                }
                              }
                              Navigator.push(
                                  context,
                                  createRoute(
                                    pageWidget: ClassAttendanceReport(
                                      title:
                                          '${classObject.className} (${sectionObject.name})',
                                      classId: classObject.classId,
                                      date: widget.date.toLocal(),
                                      response: response,
                                      sectionId: sectionObject.id,
                                    ),
                                  ));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                // height: 35,
                                // width: 43,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: attendanceState.getByDateAttendanceResponse
                                            .where((element) =>
                                                element.sectionId.id == sectionObject.id)
                                            .isNotEmpty
                                        ? Color(0xff6fcf97)
                                        : Colors.redAccent),

                                // : Colors.redAccent),
                                child: Center(
                                    child: Text(
                                  sectionObject.name,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ))),
                          ),
                        ));
                        return Step(
                          title: ListTile(
                            title: Text(classObject.className),
                            // trailing: Text('100%',style: buildTextStyle(),)
                          ),
                          state: StepState.indexed,
                          isActive: true,
                          content: Container(
                              height: 50,
                              // height: (50 * widgetList.length).toDouble(),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: widgetList,
                              )),
                        );
                      }));
                      return Container(
                        height: screenheight > 600 ? MediaQuery.of(context).size.height * 0.645 : MediaQuery.of(context).size.height * 0.66,
                        child: TabBarView(
                          controller: _tab,
                          // physics: NeverScrollableScrollPhysics(),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 1, bottom: 5, right: 8, left: 8),
                              child: Container(
                                child: Card(

                                  child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      child: Container(
                                        child: Theme(
                                          data: ThemeData(
                                              colorScheme: ColorScheme.light(
                                                  primary: Color(0xff6fcf97))),
                                          child: Column(
                                            children: [
                                              BlocBuilder<AuthCubit, AuthStates>(
                                                  builder: (context, state2) {
                                                if (state2 is AccountsLoaded) {
                                                  var primaryClass = state2.user.classId;
                                                  if (primaryClass.sections.isNotEmpty) {
                                                    if (primaryClass.sections.first.name
                                                            .toString() !=
                                                        "null")
                                                      return Stepper(
                                                        controlsBuilder:
                                                            (BuildContext context,
                                                                controls) {
                                                          return SizedBox();
                                                        },
                                                        // type: StepperType.horizontal,
                                                        physics: ScrollPhysics(),
                                                        currentStep: _currentStep2,
                                                        onStepTapped: (step) =>
                                                            tapped(step),
                                                        onStepContinue: continued,
                                                        onStepCancel: cancel,
                                                        steps: [
                                                          Step(
                                                            title: Text(
                                                                primaryClass.className),
                                                            subtitle: Text(
                                                              'Primary',
                                                              style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontWeight:
                                                                      FontWeight.bold),
                                                            ),
                                                            content: Container(
                                                                height: 50,
                                                                width:
                                                                    MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.6,
                                                                child: ListView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        GetByDateAttendanceResponse
                                                                            response;
                                                                        for (var i
                                                                            in responseList) {
                                                                          if (i.classId
                                                                                      .id ==
                                                                                  primaryClass
                                                                                      .classId &&
                                                                              i.sectionId
                                                                                      .id ==
                                                                                  primaryClass
                                                                                      .sections
                                                                                      .first
                                                                                      .id) {
                                                                            response = i;
                                                                          }
                                                                        }
                                                                        Navigator.of(
                                                                                context)
                                                                            .push(createRoute(
                                                                                pageWidget: MultiBlocProvider(
                                                                                    providers: [
                                                                              BlocProvider(
                                                                                create: (context) => LearningClassCubit()
                                                                                  ..getStudents(
                                                                                      limit:
                                                                                          10,
                                                                                      classId:
                                                                                          primaryClass.classId,
                                                                                      sectionId: primaryClass.sections.first.id,
                                                                                      page: 1),
                                                                              ),
                                                                            ],
                                                                                    child: AttendanceStudentList(
                                                                                      classId:
                                                                                          primaryClass.classId,
                                                                                      sections:
                                                                                          primaryClass.sections.first,
                                                                                      className:
                                                                                          primaryClass.className,
                                                                                      currentDate:
                                                                                          _currentDate,
                                                                                      response:
                                                                                          response,
                                                                                      // responseList.firstWhere((element) => element.classId.id == primaryClass.classId && element.sectionId.id == primaryClass.sections.first.id),
                                                                                    ))));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            35,
                                                                        width: 43,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius
                                                                                    .circular(
                                                                                        5),
                                                                            color: attendanceState
                                                                                    .getByDateAttendanceResponse
                                                                                    .where((element) =>
                                                                                        element.classId.id == primaryClass.classId &&
                                                                                        element.sectionId.id ==
                                                                                            primaryClass
                                                                                                .sections.first.id)
                                                                                    .isNotEmpty
                                                                                ? Color(
                                                                                    0xff6fcf97)
                                                                                : Colors
                                                                                    .redAccent),
                                                                        child: Center(
                                                                          child: Text(
                                                                            primaryClass
                                                                                .sections
                                                                                .first
                                                                                .name
                                                                                .toString(),
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize:
                                                                                    16),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          )
                                                        ],
                                                      );
                                                  } else
                                                    return Container();
                                                }
                                                return Container();
                                              }),
                                              Stepper(
                                                controlsBuilder:
                                                    (BuildContext context, controls) {
                                                  return SizedBox();
                                                },
                                                // type: StepperType.horizontal,
                                                physics: ScrollPhysics(),
                                                currentStep: _currentStep,
                                                onStepTapped: (step) => tapped(step),
                                                onStepContinue: continued,
                                                onStepCancel: cancel,
                                                steps: markAttendanceList,
                                                elevation: 10.0,
                                                type: StepperType.vertical,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                                height: MediaQuery.of(context).size.height * 0.50,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              child: Column(
                                children: [
                                  Card(
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0)),
                                      title: Text('School Report',
                                          style: buildTextStyle(size: 16)),
                                      trailing: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            createRoute(
                                                pageWidget: SchoolAttendanceReport(
                                                    date: widget.date.toLocal())));
                                      },
                                      tileColor: Colors.white,
                                    ),
                                  ),
                                  Card(
                                    child: Container(
                                      height: screenheight > 600 ? MediaQuery.of(context).size.height * 0.50 : MediaQuery.of(context).size.height * 0.57,
                                      child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          child: Container(
                                            child: Theme(
                                              data: ThemeData(
                                                  colorScheme: ColorScheme.light(
                                                      primary: Color(0xff6fcf97))),
                                              child: Column(
                                                children: [
                                                  BlocBuilder<AuthCubit, AuthStates>(
                                                      builder: (context, state2) {
                                                    if (state2 is AccountsLoaded) {
                                                      var primaryClass =
                                                          state2.user.classId;
                                                      //*******************for debugging************************
                                                      // for(var i in primaryClass.sections)
                                                      //   {
                                                      //     log(i.name.toString());
                                                      //     log(i.id.toString());
                                                      //     log(i.studentCount.toString());
                                                      //     log(i.progress.toString());
                                                      //   }
                                                      if (primaryClass
                                                          .sections.isNotEmpty) {
                                                        if (primaryClass
                                                                .sections.first.name
                                                                .toString() !=
                                                            "null")
                                                          return Stepper(
                                                            controlsBuilder:
                                                                (BuildContext context,
                                                                    controls) {
                                                              return SizedBox();
                                                            },
                                                            // type: StepperType.horizontal,
                                                            physics: ScrollPhysics(),
                                                            currentStep: _currentStep2,
                                                            onStepTapped: (step) =>
                                                                tapped(step),
                                                            onStepContinue: continued,
                                                            onStepCancel: cancel,
                                                            steps: [
                                                              Step(
                                                                title: Text(primaryClass
                                                                    .className),
                                                                subtitle: Text(
                                                                  'Primary',
                                                                  style: TextStyle(
                                                                      color: Colors.green,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                content: Container(
                                                                    height: 50,
                                                                    width: MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.6,
                                                                    child: ListView(
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed: () {
                                                                            GetByDateAttendanceResponse
                                                                                response;
                                                                            for (var i
                                                                                in responseList) {
                                                                              if (i.classId.id ==
                                                                                      primaryClass
                                                                                          .classId &&
                                                                                  i.sectionId.id ==
                                                                                      primaryClass.sections.first.id) {
                                                                                response =
                                                                                    i;
                                                                              }
                                                                            }
                                                                            Navigator.of(
                                                                                    context)
                                                                                .push(createRoute(
                                                                                    pageWidget: MultiBlocProvider(
                                                                                        providers: [
                                                                                  BlocProvider(
                                                                                    create: (context) => LearningClassCubit()
                                                                                      ..getStudents(
                                                                                          page: 1,
                                                                                          classId: primaryClass.classId,
                                                                                          sectionId: primaryClass.sections.first.id,
                                                                                          limit: 10),
                                                                                  ),
                                                                                ],
                                                                                        child: AttendanceStudentList(
                                                                                          classId: primaryClass.classId,
                                                                                          sections: primaryClass.sections.first,
                                                                                          className: primaryClass.className,
                                                                                          currentDate: _currentDate,
                                                                                          response: response,
                                                                                          // responseList.firstWhere((element) => element.classId.id == primaryClass.classId && element.sectionId.id == primaryClass.sections.first.id),
                                                                                        ))));
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height: 35,
                                                                            width: 43,
                                                                            decoration: BoxDecoration(
                                                                                borderRadius:
                                                                                    BorderRadius.circular(
                                                                                        5),
                                                                                color: attendanceState
                                                                                        .getByDateAttendanceResponse
                                                                                        .where((element) => element.classId.id == primaryClass.classId && element.sectionId.id == primaryClass.sections.first.id)
                                                                                        .isNotEmpty
                                                                                    ? Color(0xff6fcf97)
                                                                                    : Colors.redAccent),
                                                                            child: Center(
                                                                              child: Text(
                                                                                primaryClass
                                                                                    .sections
                                                                                    .first
                                                                                    .name
                                                                                    .toString(),
                                                                                style: TextStyle(
                                                                                    color: Colors
                                                                                        .white,
                                                                                    fontSize:
                                                                                        16),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )),
                                                              )
                                                            ],
                                                            type: StepperType.vertical,
                                                          );
                                                      } else
                                                        return Container();
                                                    }
                                                    return Container();
                                                  }),

                                                  // if(mappedClassList.isNotEmpty)
                                                  // Stepper(
                                                  //   controlsBuilder:
                                                  //       (BuildContext context, controls) {
                                                  //     return SizedBox();
                                                  //   },
                                                  //   // type: StepperType.horizontal,
                                                  //   physics: ScrollPhysics(),
                                                  //   currentStep: _currentStep2,
                                                  //   onStepTapped: (step) => tapped(step),
                                                  //   onStepContinue: continued,
                                                  //   onStepCancel: cancel,
                                                  //   steps: mappedClassList,
                                                  //
                                                  // ),
                                                  Stepper(
                                                    controlsBuilder:
                                                        (BuildContext context, controls) {
                                                      return SizedBox();
                                                    },
                                                    // type: StepperType.horizontal,
                                                    physics: ScrollPhysics(),
                                                    currentStep: _currentStep,
                                                    onStepTapped: (step) => tapped(step),
                                                    onStepContinue: continued,
                                                    onStepCancel: cancel,
                                                    steps: attendanceReportList,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ),

                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    }
                    return loadingBar;
                  });
                }
                return loadingBar;
              }),
            ],
          ),
        ),
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
