
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/model/session-report.dart';
import 'package:growonplus_teacher/view/test-module/constants.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'InstituteStudentTeacher.dart';

class InstituteSchoolsProgress extends StatefulWidget {
  const InstituteSchoolsProgress({Key key, this.schoolReport})
      : super(key: key);
  final List<SessionSchoolReport> schoolReport;

  @override
  State<InstituteSchoolsProgress> createState() =>
      _InstituteSchoolsProgressState();
}

class _InstituteSchoolsProgressState extends State<InstituteSchoolsProgress> {
  bool _hasMore;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text('Progress - ${widget.schoolReport.first.state.stateName}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            )),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close, color: Colors.black),
            ),
          )
        ],
      ),
      backgroundColor: kWhiteColor,
      body: Container(
        child: ListView.builder(
            itemBuilder: (context, index) {
              double avg = (widget.schoolReport[index].attendedUsers/widget.schoolReport[index].totalUsers);
              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return MultiBlocProvider(
                        child: InstituteStudentTeacher(
                            sessionSchoolReport: widget.schoolReport[index]),
                        providers: [
                          BlocProvider(
                              create: (context) => SessionReportStudentCubit()
                                ..getSessionReportStudents(
                                    schoolId:
                                        widget.schoolReport[index].schoolId,
                                    isStudent: true,
                                    limit: 10,
                                    page: 0)),
                          BlocProvider(
                              create: (context) => SessionReportTeacherCubit()
                                ..getSessionReportTeachers(
                                    schoolId:
                                        widget.schoolReport[index].schoolId,
                                    isStudent: false,
                                    limit: 10,
                                    page: 0)),
                        ],
                      );
                    }),
                  );
                },
                title: Text(
                  widget.schoolReport[index].schoolName.toTitleCase(),
                ),
                subtitle: Text(widget.schoolReport[index].city.cityName),
                leading: CircularPercentIndicator(
                  radius: 28,
                  backgroundColor: Colors.blueGrey.shade50,
                  animateFromLastPercent: true,
                  animation: true,
                  lineWidth: 4.0,
                  circularStrokeCap: CircularStrokeCap.round,
                  // arcBackgroundColor: kColor,
                  progressColor: (avg ?? 0) / 100 >= 0.7 ? null : kColor,
                  // arcType: ArcType.FULL,
                  // backgroundWidth: 10,
                  // percent: 0.1,
                  percent: avg / 100,
                  center: TeacherProfileAvatar(
                    imageUrl: widget.schoolReport[index].schoolImage,
                    radius: 22,
                  ),
                ),
                trailing: Container(
                  width: MediaQuery.of(context).size.width * 0.18,
                  child: Row(
                    children: [
                      Text(
                        '${avg.toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: kColor, overflow: TextOverflow.ellipsis),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        size: 18,
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: widget.schoolReport.length
        ),
      ),
    );
  }
}
