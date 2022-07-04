import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '/export.dart';
import '/model/class-schedule.dart';

import '/view/schedule_class/class-details-pop-up.dart';
import '/view/schedule_class/custom-date-picker.dart';
import '/view/schedule_class/syllabus-pdf.dart';

class ClassSchedule extends StatefulWidget {
  @override
  _ClassScheduleState createState() => _ClassScheduleState();
}

class _ClassScheduleState extends State<ClassSchedule> {
  DatePickerController _datePickerController = DatePickerController();
  ScrollController controller = ScrollController();
  DateTime _currentDate = DateTime.now();
  int month = DateTime.now().month;
  int page = 1;
  bool loading = false;
  bool init = true;
  DateTime fromDate;
  DateTime toDate;
  ClassScheduleLoaded classState;
  ClassScheduleIdLoaded allClassState;

  bool check;
  @override
  void initState() {
    super.initState();

    page = 1;
    BlocProvider.of<ScheduleClassIdCubit>(context, listen: false)
        .getAllClassId()
        .then((value) {
      BlocProvider.of<ScheduleClassCubit>(context, listen: false).getAllClass(
          DateFormat('yyyy-MM-dd').format(DateTime.now()), context);
      setState(() {});
    });
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent &&
          classState.hasMore) {
        if (!loading) {
          loading = true;
          page++;
          BlocProvider.of<ScheduleClassCubit>(context, listen: false)
              .getMoreClass(
            DateFormat('yyyy-MM-dd').format(_currentDate),
            page,
            classState,
          )
              .then((value) {
            loading = false;
          });
        }
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    animateDate();
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

  void onPress() {
    BlocProvider.of<ScheduleClassCubit>(context, listen: false)
        .getAllClass('', context);
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'Add',
            child: Icon(Icons.add),
            backgroundColor: Color(0xffFFC30A),
            onPressed: () {
              Navigator.of(context).push(
                createRoute(pageWidget: ScheduleClass(isEdit: false,)),
              );
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'tt',
            label: Text('Download Timetable'),
            icon: Icon(Icons.download),
            backgroundColor: Color(0xffFFC30A),
            onPressed: () async {
              fromDate = await showDatePickerMethod();
              if (fromDate == null) {
                return;
              }
              toDate = await showDatePickerMethod(title: 'Select End Date');
              if (toDate == null) {
                return;
              }
              Fluttertoast.showToast(msg: 'Getting your timetable');
              log('List is empty: ${allClassState.allClassSchedules.isEmpty}');
              await SyllabusPdf().createSyllabusPdf(context, fromDate, toDate,
                  classes: allClassState.allClassSchedules);
              // Navigator.of(context).push(
              //   createRoute(pageWidget: ScheduleClass()),
              // );
            },
          ),
        ],
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 21.0, right: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appMarker(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.clear))
                  ],
                ),
              ),
              SizedBox(
                height: 21,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 21.0, right: 21),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Join Class",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          fontSize: 24.0),
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('d').format(DateTime.now()),
                          style: const TextStyle(
                              color: const Color(0xff212525),
                              fontWeight: FontWeight.w500,
                              fontSize: 44.0),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEE').format(DateTime.now()),
                              style: const TextStyle(
                                  color: const Color(0xffbcc1cd),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0),
                            ),
                            Text(
                              DateFormat('MMM yyyy').format(DateTime.now()),
                              style: const TextStyle(
                                  color: const Color(0xffbcc1cd),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<ScheduleClassIdCubit, ClassScheduleIdStates>(
                          builder: (context, state) {
                        if (state is ClassScheduleIdLoaded) {
                          allClassState = state;
                        }
                        return DatePicker(
                          _currentDate.subtract(
                            Duration(days: _currentDate.day - 1),
                          ),
                          height: 105,
                          allClassDates: state is ClassScheduleIdLoaded
                              ? state.allClassSchedules != null  ?  state.allClassSchedules
                                  .map((e) => e.startTime)
                                  .toList()
                              : []:[],
                          width: 50,
                          controller: _datePickerController,
                          daysCount: getDaysCount(),
                          initialSelectedDate: _currentDate,
                          onMonthYearChange: (selectedDate) {
                            if (selectedDate != null) {
                              _currentDate = selectedDate;
                              setState(() {});
                              animateDate();
                              page = 1;
                              BlocProvider.of<ScheduleClassIdCubit>(context,
                                      listen: false)
                                  .getAllClassId()
                                  .then((value) {
                                BlocProvider.of<ScheduleClassCubit>(context,
                                        listen: false)
                                    .getAllClass(
                                        DateFormat('yyyy-MM-dd')
                                            .format(_currentDate),
                                        context);
                                setState(() {});
                              });
                            }
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
                          onDateChange: (date) {
                            _currentDate = date;
                            page = 1;
                            if (!loading)
                              BlocProvider.of<ScheduleClassCubit>(context,
                                      listen: false)
                                  .getAllClass(
                                DateFormat('yyyy-MM-dd').format(_currentDate),
                                context,
                              )
                                  .then((value) {
                                loading = false;
                                setState(() {});
                              });
                          },
                        );
                      }),
                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Time",
                                    style: const TextStyle(
                                      color: const Color(0xffbcc1cd),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.70,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      "Classes",
                                      style: const TextStyle(
                                          color: const Color(0xffbcc1cd),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 19,
                            ),
                            BlocBuilder<ScheduleClassCubit,
                                ClassScheduleStates>(
                              builder: (context, state) {
                                if (state is ClassScheduleLoaded) {
                                  classState = state;
                                  var _class = state.allClassSchedules;

                                  return Expanded(
                                    child: ListView.separated(
                                        controller: controller,
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 10,
                                          );
                                        },
                                        itemCount:
                                            state.allClassSchedules.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _class[index].startTime !=
                                                              null
                                                          ? TimeOfDay.fromDateTime(
                                                                  _class[index]
                                                                      .startTime)
                                                              .format(context)
                                                          : '',
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff212525),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16.0),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      _class[index].endTime !=
                                                              null
                                                          ? TimeOfDay.fromDateTime(
                                                                  _class[index]
                                                                      .endTime)
                                                              .format(context)
                                                          : _class[index]
                                                              .endTime,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xffbcc1cd),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 2,
                                                height: 145,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xfffaf9f9),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              ClassCard(
                                                  classes: _class[index],
                                                  index: index,
                                                  onPressed: () async {

                                                    BlocProvider.of<
                                                                ScheduleClassCubit>(
                                                            context,
                                                            listen: false)
                                                        .getAllClass(
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(_currentDate),
                                                      context,
                                                    );
                                                    BlocProvider.of<
                                                                ScheduleClassIdCubit>(
                                                            context,
                                                            listen: false)
                                                        .getAllClassId();
                                                    setState(() {});
                                                  }),
                                              SizedBox(
                                                width: 16,
                                              ),
                                            ],
                                          );
                                        }),
                                  );
                                } else {


                                  return Container(
                                    child: Center(
                                      child: loadingBar,
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container noClassWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Text(
              'No Class for Day',
              style: buildTextStyle(),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  const ClassCard({
    this.classes,
    this.index,
    this.onPressed,
  });
  final ScheduledClassTask classes;
  final int index;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    bool check = classes.linkedId != null;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                ClassDetailsDialog(context, classes),
          );
        },
        child: Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: classes.onGoing
                ? Theme.of(context).primaryColor
                : Color(0xffF6F6F5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LimitedBox(
                      maxWidth: MediaQuery.of(context).size.width * 0.39,
                      child: Text(
                        classes.subjectName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      iconSize: 18,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          builder: (context) {
                            return Container(
                              height: 200,
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      check
                                          ? 'This event is repeating in future.'
                                          : 'Do you want to delete this event?',
                                      style: buildTextStyle(),
                                    ),
                                    CustomRaisedButton(
                                      height: 50,
                                      onPressed: () async {
                                        if (check) {
                                          await BlocProvider.of<
                                                  ScheduleClassCubit>(context)
                                              .deleteClassLinked(
                                            classes.linkedId,
                                            DateFormat('yyyy-MM-dd')
                                                .format(classes.startTime),
                                          );
                                          onPressed();
                                        } else {
                                          await BlocProvider.of<
                                                  ScheduleClassCubit>(context)
                                              .deleteClass(
                                            classes.id,
                                            {},
                                          );
                                          onPressed();
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      width: 250,
                                      title: check
                                          ? 'Delete all future events.'
                                          : 'Yes',
                                    ),
                                    CustomRaisedButton(
                                      height: 50,
                                      onPressed: () async {
                                        if (check) {
                                          await BlocProvider.of<
                                                  ScheduleClassCubit>(context)
                                              .deleteClass(
                                            classes.id,
                                            {},
                                          );
                                          onPressed();
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      width: 250,
                                      title: check
                                          ? 'Delete this event only.'
                                          : 'No',
                                    ),
                                  ],
                                ),
                              ),
                              margin: EdgeInsets.only(bottom: 20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                LimitedBox(
                  maxWidth: MediaQuery.of(context).size.width * 0.47,
                  child: Text(
                    classes.chapterName,
                    style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/svg/class-loc.svg",
                      color: const Color(0xff000000),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    LimitedBox(
                      maxWidth: MediaQuery.of(context).size.width * 0.47,
                      child: Text(
                        classes.meetingLink,
                        softWrap: true,
                        style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TeacherProfileAvatar(
                      radius: 8,
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text(
                      classes.teacherName ?? '',
                      style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
