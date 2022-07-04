import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/bloc/attendance/attendance-cubit.dart';
import 'package:growonplus_teacher/bloc/attendance/attendance-state.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/model/attendance.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

import 'class_attendance_report.dart';

class SchoolAttendanceReport extends StatefulWidget {
  const SchoolAttendanceReport({Key key, this.date}) : super(key: key);

  final DateTime date;

  @override
  State<SchoolAttendanceReport> createState() => _SchoolAttendanceReportState();
}

class _SchoolAttendanceReportState extends State<SchoolAttendanceReport>
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
            title: Text('School Report'),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black),
        body: Container(
          child: Column(
            children: [
              TabBar(
                physics: NeverScrollableScrollPhysics(),
                controller: _tab,
                // onTap: null,
                // isScrollable: false,
                // physics: NeverScrollableScrollPhysics(),
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

  Widget buildMonthWiseReport(String date) {
    return FutureBuilder<List<AttendanceReportBySchoolModel>>(
        future:
            BlocProvider.of<AttendanceReportCubit>(context).getAttendanceReportBySchool(
          startDate: widget.date,
          endDate: widget.date,
          month: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              int total = snapshot.data
                  .fold(0, (previousValue, element) => previousValue += element.students);

              double presentAvg = snapshot.data.fold(0,
                      (previousValue, element) => previousValue += element.presentAvg) /
                  snapshot.data.length;
              double absentAvg = snapshot.data.fold(
                      0, (previousValue, element) => previousValue += element.absentAvg) /
                  snapshot.data.length;

              snapshot.data.sort(
                (a, b) => a.presentAvg.compareTo(b.presentAvg),
              );

              int monthCount = DateTime(widget.date.year, widget.date.month + 1, 0).day;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                              "present": presentAvg,
                              "absent": absentAvg,
                            },
                            colorList: [
                              Color(0xff6FCF97),
                              Color(0xffFF5A79),
                              Color(0xffdddddd)
                            ],
                            centerText:
                                '${presentAvg.toStringAsFixed(2)}/${absentAvg.toStringAsFixed(2)}',
                            centerTextStyle: buildTextStyle(size: 15),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularPercentIndicator(
                              radius: 12.5,
                              lineWidth: 6.0,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: (snapshot.data.isNotEmpty
                                      ? snapshot.data.last.presentAvg
                                      : 0) /
                                  100,
                              arcType: ArcType.FULL,
                              arcBackgroundColor: Color(0xffcceedb),
                              progressColor: Color(0xff6FCF97),
                              footer: Text(
                                '${snapshot.data.isNotEmpty ? snapshot.data.last.classId.name : ''}',
                                style: buildTextStyle(
                                  weight: FontWeight.w600,
                                  size: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircularPercentIndicator(
                              radius: 12.5,
                              lineWidth: 6.0,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: (snapshot.data.isNotEmpty
                                      ? snapshot.data.first.presentAvg
                                      : 0) /
                                  100,
                              // snapshot.data.reassign / snapshot.data.total,
                              arcType: ArcType.FULL,
                              progressColor: Color(0xffFF5A79),
                              arcBackgroundColor: Color(0xfff8dae0),
                              footer: Text(
                                '${snapshot.data.isNotEmpty ? snapshot.data.first.classId.name : ''}',
                                style: buildTextStyle(
                                  weight: FontWeight.w600,
                                  size: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                  '$total',
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
                                  '${presentAvg.toStringAsFixed(2)}%',
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
                                  '${absentAvg.toStringAsFixed(2)}%',
                                  style: buildTextStyle(
                                    weight: FontWeight.w600,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                      height: MediaQuery.of(context).size.height * 0.416,
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data[index].classId.name}',
                                      style: buildTextStyle(
                                        weight: FontWeight.w600,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${snapshot.data[index].presentAvg.toStringAsFixed(2)}%',
                                            style: buildTextStyle(
                                              weight: FontWeight.w500,
                                              size: 12,
                                              color: Color(0xff5ed08e),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${snapshot.data[index].absentAvg.toStringAsFixed(2)}%',
                                            style: buildTextStyle(
                                                weight: FontWeight.w500,
                                                size: 12,
                                                color: Colors.redAccent),
                                          ),
                                        ],
                                      ),
                                      LinearPercentIndicator(
                                        animation: false,
                                        lineHeight: 9.0,
                                        animationDuration: 2500,
                                        percent: snapshot.data[index].presentAvg / 100,
                                        alignment: MainAxisAlignment.start,
                                        progressColor: Color(0xff6fcf97),
                                        backgroundColor: Color(0xffffbfb9),
                                        barRadius: Radius.circular(10.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      ),
                    ),
                  ),
                  // )
                ],
              );
            } else {
              return Center(
                child: Text('There is No Report Available'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingBar;
          } else {
            return Center(
              child: Text('There is No Report Available'),
            );
          }
        });
  }

  Widget buildDayWiseReport() {
    return FutureBuilder<List<AttendanceReportBySchoolModel>>(
        future: BlocProvider.of<AttendanceReportCubit>(context)
            .getAttendanceReportBySchool(
                endDate: widget.date, startDate: widget.date, month: false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              int totalPresent =
                  snapshot.data.fold(0, (total, element) => total += element.present);
              int totalAbsent =
                  snapshot.data.fold(0, (total, element) => total += element.absent);
              int totalStudents =
                  snapshot.data.fold(0, (total, element) => total += element.students);

              double totalPresentAvg = (totalPresent / totalStudents) * 100;
              double totalAbsentAvg = (totalAbsent / totalStudents) * 100;

              snapshot.data.sort(
                (a, b) => a.presentAvg.compareTo(b.presentAvg),
              );
              // AttendanceReportBySchoolModel bestClass = snapshot.data.isNotEmpty ? snapshot.data[0] : [];
              // AttendanceReportBySchoolModel leastClass = snapshot.data.isNotEmpty ?  snapshot.data.last:[];

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
                            widget.date == DateTime.now()
                                ? 'Today'
                                : DateFormat('dd MMM yyyy').format(widget.date),
                            style: buildTextStyle(
                                color: Colors.grey, size: 20, weight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: PieChart(
                            chartRadius: 110,
                            dataMap: {
                              "present": totalPresentAvg,
                              "absent": totalAbsentAvg,
                            },
                            colorList: [
                              Color(0xff6FCF97),
                              Color(0xffFF5A79),
                              Color(0xffdddddd)
                            ],
                            centerText: '$totalPresent / $totalAbsent',
                            centerTextStyle: buildTextStyle(size: 15),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularPercentIndicator(
                              radius: 12.5,
                              lineWidth: 6.0,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: (snapshot.data.isNotEmpty
                                      ? snapshot.data.last.presentAvg
                                      : 0) /
                                  100,
                              arcType: ArcType.FULL,
                              arcBackgroundColor: Color(0xffcceedb),
                              progressColor: Color(0xff6FCF97),
                              footer: Text(
                                '${snapshot.data.isNotEmpty ? snapshot.data.last.classId.name : ''}',
                                style: buildTextStyle(
                                  weight: FontWeight.w600,
                                  size: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircularPercentIndicator(
                              radius: 12.5,
                              lineWidth: 6.0,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: (snapshot.data.isNotEmpty
                                      ? snapshot.data.first.presentAvg
                                      : 0) /
                                  100,
                              // snapshot.data.reassign / snapshot.data.total,
                              arcType: ArcType.FULL,
                              progressColor: Color(0xffFF5A79),
                              arcBackgroundColor: Color(0xfff8dae0),
                              footer: Text(
                                '${snapshot.data.isNotEmpty ? snapshot.data.first.classId.name : ''}',
                                style: buildTextStyle(
                                  weight: FontWeight.w600,
                                  size: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                  '$totalStudents',
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
                                  '${totalPresentAvg.toStringAsFixed(2)}%',
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
                                  '${totalAbsentAvg.toStringAsFixed(2)}%',
                                  style: buildTextStyle(
                                    weight: FontWeight.w600,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                      height: MediaQuery.of(context).size.height * 0.416,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data[index].classId.name}',
                                      style: buildTextStyle(
                                        weight: FontWeight.w600,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${snapshot.data[index].presentAvg.toStringAsFixed(2)}%',
                                            style: buildTextStyle(
                                              weight: FontWeight.w500,
                                              size: 12,
                                              color: Color(0xff5ed08e),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${snapshot.data[index].absentAvg.toStringAsFixed(2)}%',
                                            style: buildTextStyle(
                                                weight: FontWeight.w500,
                                                size: 12,
                                                color: Colors.redAccent),
                                          ),
                                        ],
                                      ),
                                      LinearPercentIndicator(
                                        animation: false,
                                        lineHeight: 9.0,
                                        animationDuration: 2500,
                                        percent: snapshot.data[index].presentAvg / 100,
                                        alignment: MainAxisAlignment.start,
                                        progressColor: Color(0xff6fcf97),
                                        backgroundColor: Color(0xffffbfb9),
                                        barRadius: Radius.circular(10.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
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

  Widget buildWeekWiseReport(String date) {
    return FutureBuilder<List<AttendanceReportBySchoolModel>>(
        future: BlocProvider.of<AttendanceReportCubit>(context)
            .getAttendanceReportBySchool(
                startDate: widget.date.subtract(Duration(days: 7)),
                endDate: widget.date,
                month: false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              int total = snapshot.data
                  .fold(0, (previousValue, element) => previousValue += element.students);

              double totalPresentAvg = snapshot.data.fold(0,
                      (previousValue, element) => previousValue += element.presentAvg) /
                  snapshot.data.length;
              double totalAbsentAvg = snapshot.data.fold(
                      0, (previousValue, element) => previousValue += element.absentAvg) /
                  snapshot.data.length;

              snapshot.data.sort(
                (a, b) => a.presentAvg.compareTo(b.presentAvg),
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
                              "present": totalPresentAvg,
                              "absent": totalAbsentAvg,
                            },
                            colorList: [
                              Color(0xff6FCF97),
                              Color(0xffFF5A79),
                              Color(0xffdddddd)
                            ],
                            centerText:
                                '${totalPresentAvg.toStringAsFixed(2)}/${totalAbsentAvg.toStringAsFixed(2)}',
                            centerTextStyle: buildTextStyle(size: 15),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularPercentIndicator(
                              radius: 12.5,
                              lineWidth: 6.0,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: (snapshot.data.isNotEmpty
                                      ? snapshot.data.last.presentAvg
                                      : 0) /
                                  100,
                              arcType: ArcType.FULL,
                              arcBackgroundColor: Color(0xffcceedb),
                              progressColor: Color(0xff6FCF97),
                              footer: Text(
                                '${snapshot.data.isNotEmpty ? snapshot.data.last.classId.name : ''}',
                                style: buildTextStyle(
                                  weight: FontWeight.w600,
                                  size: 10.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            CircularPercentIndicator(
                              radius: 12.5,
                              lineWidth: 6.0,
                              circularStrokeCap: CircularStrokeCap.round,
                              percent: (snapshot.data.isNotEmpty
                                      ? snapshot.data.first.presentAvg
                                      : 0) /
                                  100,
                              // snapshot.data.reassign / snapshot.data.total,
                              arcType: ArcType.FULL,
                              progressColor: Color(0xffFF5A79),
                              arcBackgroundColor: Color(0xfff8dae0),
                              footer: Text(
                                '${snapshot.data.isNotEmpty ? snapshot.data.first.classId.name : ''}',
                                style: buildTextStyle(
                                  weight: FontWeight.w600,
                                  size: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                  '$total',
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
                                  '${totalPresentAvg.toStringAsFixed(2)}%',
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
                                  '${totalAbsentAvg.toStringAsFixed(2)}%',
                                  style: buildTextStyle(
                                    weight: FontWeight.w600,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                      height: MediaQuery.of(context).size.height * 0.416,
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        itemBuilder: (context, index) {
                          // double percent = (snapshot.data[index].present/snapshot.data[index].students)*100;
                          return Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: Center(
                                    child: Text(
                                      '${snapshot.data[index].classId.name}',
                                      style: buildTextStyle(
                                        weight: FontWeight.w600,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${snapshot.data[index].presentAvg.toStringAsFixed(2)}%',
                                            style: buildTextStyle(
                                              weight: FontWeight.w500,
                                              size: 12,
                                              color: Color(0xff5ed08e),
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '${snapshot.data[index].absentAvg.toStringAsFixed(2)}%',
                                            style: buildTextStyle(
                                                weight: FontWeight.w500,
                                                size: 12,
                                                color: Colors.redAccent),
                                          ),
                                        ],
                                      ),
                                      LinearPercentIndicator(
                                        animation: false,
                                        lineHeight: 9.0,
                                        animationDuration: 2500,
                                        percent: snapshot.data[index].presentAvg / 100,
                                        alignment: MainAxisAlignment.start,
                                        progressColor: Color(0xff6fcf97),
                                        backgroundColor: Color(0xffffbfb9),
                                        barRadius: Radius.circular(10.0),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        itemCount: snapshot.data.length,
                      ),
                    ),
                  ),
                  // )
                ],
              );
            } else {
              return Center(
                child: Text('There is No Report Available'),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingBar;
          } else {
            return Center(
              child: Text('There is No Report Available'),
            );
          }
        });
  }
}
