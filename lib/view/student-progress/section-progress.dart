import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/export.dart';
import '/model/class-schedule.dart';
import '/view/student-progress/student-progress.dart';

class SectionProgressPage extends StatefulWidget {
  final String classId;
  final String className;
  final List<ClassSection> sections;

  SectionProgressPage(
    this.classId,
    this.sections,
    this.className,
  );

  @override
  _SectionProgressPageState createState() => _SectionProgressPageState();
}

class _SectionProgressPageState extends State<SectionProgressPage> {
  final ScrollController scrollController = ScrollController();
  LearningStudentsLoaded stateStudents;
  int page = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Progress - ${widget.className}',
          style: buildTextStyle(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          // height: 500,
          padding: EdgeInsets.all(10),
          child: ListView.separated(
            controller: scrollController,
            separatorBuilder: (context, index) => SizedBox(
              height: 15,
            ),
            // shrinkWrap: true,
            itemCount: widget.sections.length,
            itemBuilder: (context, index) {
              return FutureBuilder<List<SectionProgress>>(
                future: BlocProvider.of<SectionProgressCubit>(context).sectionProgress(),
                builder: (context,snapshot) {
                  return SectionProgressWidget(
                    // progress: widget.sections[index].progress,
                    section: widget.sections[index],
                    classId: widget.classId,
                    className: widget.className,
                    progress: snapshot.hasData ? snapshot.data.firstWhere((element) => element.sectionId == widget.sections[index].id,orElse: ()=>SectionProgress(sectionProgress: 0)).sectionProgress : 0.0
                     // progress: snapshot.hasData ? snapshot.data[index].sectionProgress : 0.0,
                  );
                },
                // initialData: [],
              );
            },
          ),
        ),
      ),
    );
  }

  List<StudentInfo> getSectionBasedStudents(
      String sectionId, List<StudentInfo> students) {
    return students
        .where((element) =>
            element.userInfoClass == widget.classId &&
            element.section == sectionId)
        .toList();
  }

  double calculateProgressSection(
      String sectionId, List<StudentInfo> students) {
    var stud = getSectionBasedStudents(sectionId, students);
    if (stud.length == 0) return 0;
    return stud.fold<double>(
            0,
            (previousValue, element) =>
                previousValue + element.studentProgress) /
        stud.length;
  }
}

class SectionProgressWidget extends StatelessWidget {
  final ClassSection section;
  final String className;
  final String classId;
  final double progress;
  SectionProgressWidget({
     this.section,
    @required this.progress,
    @required this.classId,
    @required this.className,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push<List<double>>(
          createRoute(
            pageWidget: BlocProvider(
              create: (context) =>
                  LearningClassCubit()..getStudents(classId: classId,sectionId:  section.id,limit: 10,page: 1),
              child: StudentsProgressPage(
                classId: classId,
                className: className,
                section: section,
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.only(left: 4, top: 4),
        child: Row(
          children: [
            Container(
              // padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: Color(0xff6FCF97),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 2, color: Color(0xff6FCF97), spreadRadius: 2),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    section != null ? section.name : 'Un-Mapped Students',
                    style: buildTextStyle(size: 12),
                  ),
                  Text(
                    '${section.studentCount} Students',
                    style: buildTextStyle(size: 13, color: Colors.white),
                  ),
                ],
              ),
            ).expandFlex(2),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Tasks',
                        style:
                            buildTextStyle(size: 12, weight: FontWeight.w200),
                      ).expand,
                      buildLinearPercentBar(
                        percent: progress/100,
                        lineHeight: 15,
                        color:
                            (progress/100) >= 0.7 ? null : Color(0xffEb5757),
                      ).expandFlex(4)
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //   children: [
                  //     Text(
                  //       'Tests',
                  //       style:
                  //           buildTextStyle(size: 13, weight: FontWeight.w200),
                  //     ).expand,
                  //     buildLinearPercentBar(
                  //       percent: 0,
                  //       lineHeight: 15,
                  //       color: 0 >= 70 ? null : Color(0xffEb5757),
                  //     ).expandFlex(4),
                  //   ],
                  // ),
                ],
              ),
            ).expandFlex(5),
            Container(
              child: Icon(Icons.navigate_next),
            ).expand,
          ],
        ),
      ),
    );
  }
}
