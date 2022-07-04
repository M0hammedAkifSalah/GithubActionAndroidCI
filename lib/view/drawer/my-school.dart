// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import ' /bloc/teacher-school/teacher-school-cubit.dart';
// import ' /bloc/teacher-school/teacher-school-states.dart';
// import ' /const.dart';
// import ' /extensions/utils.dart';
// import ' /loader.dart';

// class MySchoolPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Progress',
//           style: buildTextStyle(),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Container(
//           // height: 500,
//           padding: EdgeInsets.all(15),
//           child: BlocBuilder<SchoolTeacherCubit, SchoolTeacherStates>(
//               builder: (context, state) {
//             if (state is SchoolTeacherLoaded)
//               return ListView.separated(
//                 separatorBuilder: (context, index) => SizedBox(
//                   height: 15,
//                 ),
//                 // shrinkWrap: true,
//                 itemCount: state.teachers.length,
//                 itemBuilder: (context, index) {
//                   return ClassProgressWidget(
//                     index: index,
//                     state: state,
//                   );
//                 },
//               );
//             else {
//               BlocProvider.of<SchoolTeacherCubit>(context).getAllTeachers();
//               return Center(
//                 child: loadingBar,
//               );
//             }
//           }),
//         ),
//       ),
//     );
//   }
//   // double getClassProgress(Student)
// }

// class ClassProgressWidget extends StatefulWidget {
//   final int index;
//   final SchoolTeacherLoaded state;
//   ClassProgressWidget({this.index, this.state});

//   @override
//   _ClassProgressWidgetState createState() => _ClassProgressWidgetState();
// }

// class _ClassProgressWidgetState extends State<ClassProgressWidget> {
//   double test = 0;
//   double task = 0;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         List _res = await Navigator.of(context).push<List<double>>(
//           createRoute(
//             pageWidget: BlocProvider(
//               create: (context) => SchoolTeacherCubit(),
//               child: StudentsProgressPage(
//                 classId: widget.state.classDetails[widget.index].id,
//                 className: widget.state.classDetails[widget.index].name,
//               ),
//             ),
//           ),
//         );
//         task = _res[0];
//         test = _res[1];
//         setState(() {});
//       },
//       child: Container(
//         height: 70,
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(5),
//               margin: EdgeInsets.only(right: 5),
//               decoration: BoxDecoration(
//                 color: Color(0xff6FCF97),
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                       blurRadius: 2, color: Color(0xff6FCF97), spreadRadius: 2),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     widget.state.classDetails[widget.index].name,
//                     style: buildTextStyle(size: 16),
//                   ),
//                   // Text(
//                   //   '27 Students',
//                   //   style: buildTextStyle(
//                   //       size: 13, color: Colors.white),
//                   // ),
//                 ],
//               ),
//             ).expandFlex(2),
//             Container(
//               padding: EdgeInsets.all(5),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(
//                         'Tasks',
//                         style:
//                             buildTextStyle(size: 13, weight: FontWeight.w200),
//                       ).expand,
//                       buildLinearPercentBar(
//                         percent: task,
//                         lineHeight: 15,
//                         color: task >= 0.7 ? null : Color(0xffEb5757),
//                       ).expandFlex(4)
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text(
//                         'Tests',
//                         style:
//                             buildTextStyle(size: 13, weight: FontWeight.w200),
//                       ).expand,
//                       buildLinearPercentBar(
//                         percent: test,
//                         lineHeight: 15,
//                         color: test >= 0.7 ? null : Color(0xffEb5757),
//                       ).expandFlex(4),
//                     ],
//                   ),
//                 ],
//               ),
//             ).expandFlex(5),
//             Container(
//               child: Icon(Icons.navigate_next),
//             ).expand,
//           ],
//         ),
//       ),
//     );
//   }
// }
