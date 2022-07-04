import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '/bloc/activity/activity-states.dart';
import '/export.dart';
import '/view/student-progress/section-progress.dart';

class ClassProgressPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Progress',
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
          child: BlocBuilder<SectionProgressCubit, SectionProgressStates>(
              builder: (context, snapshot) {
            if (snapshot is SectionProgressLoaded)
              return BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
                  builder: (context, state) {
                if (state is ClassDetailsLoaded) {
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
                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 15,
                    ),
                    // shrinkWrap: true,
                    itemCount: state.classDetails.length,
                    itemBuilder: (context, index) {
                      if (snapshot.sectionProgress.isNotEmpty) {
                        snapshot.sectionProgress.forEach((element) {
                          state.classDetails[index].sections.forEach((sec) {
                            if (sec.id == element.sectionId) {
                              sec.progress = element.sectionProgress;
                            }
                          });
                        });
                      }
                      return ClassProgressWidget(
                        index: index,
                        state: state,
                      );
                    },
                  );
                } else {
                  BlocProvider.of<LearningClassCubit>(context).getClasses();
                  return Center(
                    child: loadingBar,
                  );
                }
              });
            else {
              BlocProvider.of<SectionProgressCubit>(context).sectionProgress();
              return Center(
                child: loadingBar,
              );
            }
          }),
        ),
      ),
    );
  }
  // double getClassProgress(Student)
}

class ClassProgressWidget extends StatelessWidget {
  final int index;
  final ClassDetailsLoaded state;
  ClassProgressWidget({this.index, this.state});

  @override
  Widget build(BuildContext context) {
    for (var i in state.classDetails[index].sections) {
      log(i.progress.toString());
    }
    double progress = state.classDetails[index].sections
        .fold(0, (previousValue, element) => element.progress + previousValue);

    return InkWell(
      onTap: () async {
        Navigator.of(context).push<List<double>>(
          createRoute(
            pageWidget: BlocProvider(
              create: (context) => LearningClassCubit(),
              child: SectionProgressPage(
                state.classDetails[index].classId,
                state.classDetails[index].sections,
                state.classDetails[index].className,
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
                    state.classDetails[index].className,
                    style: buildTextStyle(size: 16),
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
                        percent: (progress) / 100,
                        lineHeight: 15,
                        color: progress / 100 >= 0.7 ? null : Color(0xffEb5757),
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
                  //       percent: (0) / 100,
                  //       lineHeight: 15,
                  //       color: (0) >= 0.7 ? null : Color(0xffEb5757),
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
