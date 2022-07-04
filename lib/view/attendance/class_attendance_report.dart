import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../bloc/attendance/attendance-cubit.dart';
import '../../const.dart';
import '../../loader.dart';
import '../../model/attendance.dart';
import '../homepage/home_sliver_appbar.dart';

class ClassAttendanceReport extends StatefulWidget {
  const ClassAttendanceReport(
      {Key key, this.classId, this.title, this.date, this.response, this.sectionId})
      : super(key: key);

  final String title;
  final String classId;
  final DateTime date;
  final String sectionId;
  final GetByDateAttendanceResponse response;

  @override
  State<ClassAttendanceReport> createState() => _ClassAttendanceReportState();
}

class _ClassAttendanceReportState extends State<ClassAttendanceReport>
    with SingleTickerProviderStateMixin {
  TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title ?? 'School Report'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black),
        body: Container(
          child: Column(
            children: [
              TabBar(
                physics: NeverScrollableScrollPhysics(),
                controller: _tab,
                indicatorColor: Color(0xff6FCF97),
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: buildTextStyle(color: Color(0xff6fcf97), size: 14),
                unselectedLabelStyle: buildTextStyle(size: 14),
                labelColor: Color(0xff6fcf97),
                unselectedLabelColor: Colors.black87,
                tabs: [
                  Tab(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xff6fcf97),
                          )),
                      child: Text('Daily', style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    // text: 'Mark Attendance',
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xff6fcf97),
                          )),
                      child:
                          Text('Weekly', style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Tab(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(0xff6fcf97),
                          )),
                      child:
                          Text('Monthly', style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.82,
                child: TabBarView(
                  controller: _tab,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildDayWiseReport(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildWeekWiseReport(returnWeek(widget.date)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildMonthWiseReport('${returnMonth(widget.date)}'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildDayWiseReport() {
    return FutureBuilder<AttendanceReportByStudentModel>(
        future: BlocProvider.of<AttendanceReportByStudentCubit>(context)
            .getAttendanceReportByStudent(
          classId: widget.classId,
          sectionId: widget.sectionId,
          startDate: widget.date,
          endDate: widget.date,
          month: false,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              var student = snapshot.data.attendanceDetails;
              student.sort(
                  (a, b) => a.absentCount.compareTo(b.absentCount)
              );
              return Column(
                children: [
                  Card(
                      elevation: 10,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Today',
                            style: buildTextStyle(
                                color: Colors.grey, size: 20, weight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: PieChart(
                            chartRadius: 110,
                            dataMap: {
                              "present": snapshot.data.presentAvg,
                              "absent": snapshot.data.absentAvg,
                            },
                            colorList: [
                              Color(0xff6FCF97),
                              Color(0xffFF5A79),
                              Color(0xffdddddd)
                            ],
                            centerText:
                                '${snapshot.data.present} / ${snapshot.data.absent}',
                            centerTextStyle: buildTextStyle(),
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 10,
                            legendOptions: LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.bottom,
                              showLegends: false,
                              legendShape: BoxShape.circle,
                              legendTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: false,
                              showChartValuesInPercentage: true,
                              showChartValuesOutside: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Total',
                                    style: buildTextStyle(
                                      weight: FontWeight.w500,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.students}',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Present',
                                    style: buildTextStyle(
                                      weight: FontWeight.w500,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.presentAvg.toStringAsFixed(2)}%',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Absent',
                                    style: buildTextStyle(
                                      weight: FontWeight.w500,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.absentAvg.toStringAsFixed(2)}%',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ])),
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.46,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          widget.response.attendanceDetails.sort(
                            (a, b) {
                              return a.status.compareTo(b.status);
                            },
                          );
                          return ListTile(
                            leading: TeacherProfileAvatar(
                              imageUrl: widget.response.attendanceDetails[index].studentId
                                      .profileImage ??
                                  'text',
                            ),
                            title: Text(
                              widget.response.attendanceDetails[index].studentId.name,
                              style: buildTextStyle(size: 14),
                            ),
                            trailing: Container(
                              width: 70.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: widget.response.attendanceDetails[index].status
                                            .toLowerCase() ==
                                        "present"
                                    ? Color(0xff6fcf97)
                                    : Color(0xffFB4D3D),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                  child: Text(
                                widget.response.attendanceDetails[index].status
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
                        itemCount: widget.response.attendanceDetails.length,
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: Text('No Reports Available'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingBar;
          } else {
            return Center(
              child: Text('No Reports Available'),
            );
          }
        });
  }

  Widget buildWeekWiseReport(String date) {
    return FutureBuilder<AttendanceReportByStudentModel>(
        future: BlocProvider.of<AttendanceReportByStudentCubit>(context)
            .getAttendanceReportByStudent(
          classId: widget.classId,
          sectionId: widget.sectionId,
          startDate: widget.date.subtract(Duration(days: 7)),
          endDate: widget.date,
          month: false,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              var student = snapshot.data.attendanceDetails;
              student.sort(
                (a, b) => a.presentCount.compareTo(b.presentCount),
              );
              return Column(
                children: [
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date,
                            style: buildTextStyle(
                                color: Colors.grey, size: 20, weight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: PieChart(
                            chartRadius: 110,
                            dataMap: {
                              "present": snapshot.data.presentAvg,
                              "absent": snapshot.data.absentAvg,
                            },
                            colorList: [
                              Color(0xff6FCF97),
                              Color(0xffFF5A79),
                              Color(0xffdddddd)
                            ],
                            centerText:
                                '${snapshot.data.present} / ${snapshot.data.absent}',
                            centerTextStyle: buildTextStyle(),
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 10,
                            legendOptions: LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.bottom,
                              showLegends: false,
                              legendShape: BoxShape.circle,
                              legendTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: false,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Total',
                                        style: buildTextStyle(
                                          weight: FontWeight.w500,
                                          size: 15,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data.students}',
                                        style: buildTextStyle(
                                          weight: FontWeight.w600,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Present',
                                        style: buildTextStyle(
                                          weight: FontWeight.w500,
                                          size: 15,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data.presentAvg.toStringAsFixed(2)}%',
                                        style: buildTextStyle(
                                          weight: FontWeight.w600,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Absent',
                                        style: buildTextStyle(
                                          weight: FontWeight.w500,
                                          size: 15,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data.absentAvg.toStringAsFixed(2)}%',
                                        style: buildTextStyle(
                                          weight: FontWeight.w600,
                                          size: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ),
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.46,
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          double percent = (student[index].presentCount / 7) * 100;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    '${student[index].studentId.name}',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: LinearPercentIndicator(
                                    animation: false,
                                    lineHeight: 13.0,
                                    animationDuration: 2500,
                                    percent: percent / 100,
                                    alignment: MainAxisAlignment.start,
                                    progressColor: Color(0xff6fcf97),
                                    backgroundColor: Color(0xffffbfb9),
                                    barRadius: Radius.circular(10.0),
                                    trailing: Text(
                                      '${student[index].presentCount}/7',
                                      style: buildTextStyle(
                                        weight: FontWeight.w500,
                                        size: 13,
                                      ),
                                    ),
                                    center: Text(
                                      '${percent.toStringAsFixed(2)}%',
                                      style: buildTextStyle(
                                        weight: FontWeight.w500,
                                        size: 11,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: student.length,
                      ),
                    ),
                  ),
                  // )
                ],
              );
            } else {
              return Center(
                child: Text('No Report Available'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingBar;
          } else {
            return Center(
              child: Text('No Report Available'),
            );
          }
        });
  }

  Widget buildMonthWiseReport(String date) {
    return FutureBuilder<AttendanceReportByStudentModel>(
        future: BlocProvider.of<AttendanceReportByStudentCubit>(context)
            .getAttendanceReportByStudent(
          classId: widget.classId,
          sectionId: widget.sectionId,
          startDate: widget.date,
          endDate: widget.date,
          month: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              int monthCount = DateTime(widget.date.year, widget.date.month + 1, 0).day;
              var student = snapshot.data.attendanceDetails;
              student.sort(
                (a, b) => a.presentCount.compareTo(b.presentCount),
              );
              return Column(
                children: [
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date,
                            style: buildTextStyle(
                                color: Colors.grey, size: 20, weight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: PieChart(
                            chartRadius: 110,
                            dataMap: {
                              "present": snapshot.data.presentAvg,
                              "absent": snapshot.data.absentAvg,
                            },
                            colorList: [
                              Color(0xff6FCF97),
                              Color(0xffFF5A79),
                              Color(0xffdddddd)
                            ],
                            centerText:
                                '${snapshot.data.present} / ${snapshot.data.absent}',
                            centerTextStyle: buildTextStyle(),
                            initialAngleInDegree: 0,
                            chartType: ChartType.ring,
                            ringStrokeWidth: 10,
                            legendOptions: LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.bottom,
                              showLegends: false,
                              legendShape: BoxShape.circle,
                              legendTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: false,
                              showChartValues: false,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Total',
                                    style: buildTextStyle(
                                      weight: FontWeight.w500,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.students}',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Present',
                                    style: buildTextStyle(
                                      weight: FontWeight.w500,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.presentAvg.toStringAsFixed(2)}%',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Absent',
                                    style: buildTextStyle(
                                      weight: FontWeight.w500,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    '${snapshot.data.absentAvg.toStringAsFixed(2)}%',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 10,
                    shadowColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.46,
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          double percent =
                              (student[index].presentCount / monthCount) * 100;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  child: Text(
                                    '${student[index].studentId.name}',
                                    style: buildTextStyle(
                                      weight: FontWeight.w600,
                                      size: 15,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: LinearPercentIndicator(
                                    animation: false,
                                    lineHeight: 13.0,
                                    animationDuration: 2500,
                                    percent: percent / 100,
                                    alignment: MainAxisAlignment.start,
                                    progressColor: Color(0xff6fcf97),
                                    backgroundColor: Color(0xffffbfb9),
                                    barRadius: Radius.circular(10.0),
                                    trailing: Text(
                                      '${student[index].presentCount}/$monthCount',
                                      style: buildTextStyle(
                                        weight: FontWeight.w500,
                                        size: 13,
                                      ),
                                    ),
                                    center: Text(
                                      '${percent.toStringAsFixed(2)}%',
                                      style: buildTextStyle(
                                        weight: FontWeight.w500,
                                        size: 11,
                                      ),
                                    ),
                                  ),
                                ),
                                // Text(
                                //   '${student[index].presentCount}/$monthCount',
                                //   style: buildTextStyle(
                                //     weight: FontWeight.w600,
                                //     size: 15,
                                //   ),
                                // ),
                                // Text(
                                //   '${percent.toStringAsFixed(2)}%',
                                //   style: buildTextStyle(
                                //     weight: FontWeight.w600,
                                //     size: 15,
                                //   ),
                                // )
                              ],
                            ),
                          );
                        },
                        itemCount: student.length,
                      ),
                    ),
                  ),
                  // )
                ],
              );
            } else {
              return Center(
                child: Text('No Report Available'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingBar;
          } else {
            return Center(
              child: Text('No Report Available'),
            );
          }
        });
  }
}

String returnWeek(DateTime date) {
  DateTime sd = date.subtract(Duration(days: 7));
  return '${DateFormat('dd MMM').format(sd)} - ${DateFormat('dd MMM yyyy').format(date)}';
}

String returnMonth(DateTime date) {
  return new DateFormat.MMMM().add_y().format(date);
}
