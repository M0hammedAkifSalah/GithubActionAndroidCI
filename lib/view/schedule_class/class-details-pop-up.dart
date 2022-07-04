import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:growonplus_teacher/bloc/class-schedule/class-schedule-cubit.dart';
// import 'package:growon/bloc/class-schedule/class-schedule-cubit.dart';
// import 'package:growon/bloc/class-schedule/class-schedule-states.dart';
// import 'package:growon/bloc/class-schedule/join-class-cubit.dart';
// import 'package:growon/bloc/class-schedule/join-class-states.dart';
// import 'package:growon/loader.dart';
// import 'package:growon/model/class-schedule.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '/extensions/extension.dart';
import '/extensions/utils.dart';
import '/model/class-schedule.dart';
import '/view/homepage/home_sliver_appbar.dart';
import '/view/utils/utils.dart';
import 'create_class.dart';

class ClassDetailsDialog extends StatelessWidget {
  final BuildContext contextA;
  final ScheduledClassTask classDetails;

  ClassDetailsDialog(this.contextA, this.classDetails);

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Container(
        width: screenwidth > 600 ? 600 : 300,
        padding: EdgeInsets.only(top: 14, right: 17, left: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Text(
                    "Join Class",
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      if (classDetails.editable)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(createRoute(
                                pageWidget: ScheduleClass(
                              classTask: classDetails,
                              isEdit: true,
                            )));
                          },
                          child: Icon(Icons.edit),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 33,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 38,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: const Color(0x806fcf97)),
                        child: SvgPicture.asset("assets/svg/heading.svg"),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LimitedBox(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                            child: Text(classDetails.subjectName,
                                softWrap: true,
                                style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0,
                                ),
                                textAlign: TextAlign.left),
                          ),
                          LimitedBox(
                            maxWidth: MediaQuery.of(context).size.width * 0.50,
                            child: Text(
                              classDetails.chapterName,
                              softWrap: true,
                              style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 38,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: const Color(0x803aa2eb)),
                        child: SvgPicture.asset("assets/svg/zoom-location.svg"),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Meeting Link',
                            style: const TextStyle(
                                color: const Color(0xffc4c4c4),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0),
                          ),
                          LimitedBox(
                            maxWidth: MediaQuery.of(context).size.width * 0.50,
                            child: Text(
                              classDetails.meetingLink,
                              softWrap: true,
                              style: const TextStyle(
                                  color: const Color(0xff168de2),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.0),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 38,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: const Color(0x809188e5)),
                        child:
                            SvgPicture.asset("assets/svg/class-calendar.svg"),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${DateFormat('MMM dd').format(classDetails.startDate)}th",
                            style: const TextStyle(
                                color: const Color(0xffc4c4c4),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0),
                          ),
                          Text(
                            "${classDetails.startTime != null ? TimeOfDay.fromDateTime(classDetails.startTime).format(context) : classDetails.startTime} ",
                            style: const TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text("DESCRIPTION",
                      style: const TextStyle(
                          color: const Color(0xff828282),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.normal,
                          fontSize: 13.0),
                      textAlign: TextAlign.left),
                  Text(
                    classDetails.description == "null"
                        ? ''
                        : classDetails.description ?? '',
                    style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "ATTACHMENTS",
                    style: const TextStyle(
                      color: const Color(0xff828282),
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  if(classDetails.files.isNotEmpty)
                  FileListing(classDetails.files),
                  // ListView.builder(
                  //   padding: EdgeInsets.all(0),
                  //   shrinkWrap: true,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemCount: classDetails.files.length,
                  //   itemBuilder: (BuildContext context, int index) => InkWell(
                  //
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(top: 8.0),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           LimitedBox(
                  //             child: Row(
                  //               children: [
                  //                 FaIcon(checkIcon(classDetails.files[index]
                  //                     .substring(
                  //                         classDetails.files[index].length - 3))),
                  //                 Container(
                  //                   height: 50,
                  //                   width: 180,
                  //                   child: Text(
                  //                     classDetails.files[index].split('/').last,
                  //                     style: const TextStyle(
                  //                       color: const Color(0xff000000),
                  //                       fontWeight: FontWeight.w400,
                  //                       fontFamily: "Poppins",
                  //                       fontStyle: FontStyle.normal,
                  //                       fontSize: 10.0,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           IconButton(
                  //               icon: Icon(
                  //                 FontAwesomeIcons.eye,
                  //                 size: 18,
                  //               ),
                  //               onPressed: () {
                  //
                  //               })
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 18,
                  ),
                  // Text(
                  //   "${classDetails.createdAt.difference(classDetails.startTime).inSeconds}",
                  //   style: const TextStyle(
                  //       color: const Color(0xff000000),
                  //       fontWeight: FontWeight.w600,
                  //       fontSize: 13.0),
                  // ),

                  Text(
                    "Attendees  (${classDetails.studentJoin.length}/${classDetails.assignTo.isNotEmpty ? classDetails.assignTo.length : classDetails.assignTo_you.length})",
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: classDetails.assignTo.isNotEmpty
                          ? classDetails.studentJoin.length
                          : classDetails.assignTo_you.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var joined = classDetails.studentJoin.toList();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              TeacherProfileAvatar(
                                imageUrl: joined[index].student.profileImage??'text',
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    joined[index].student.name,
                                    style: const TextStyle(
                                      color: const Color(0xff1b1a57),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    joined[index]
                                        .joinDate.toLocal()
                                        .toDateTimeFormat(context),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w200,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    height: 42,
                    width: MediaQuery.of(context).size.width - 100,
                    child: RaisedButton(
                      color: const Color(0xffFFC30A),
                      onPressed: classDetails.onGoing
                          ? () {
                              BlocProvider.of<ScheduleClassCubit>(context)
                                  .joinClassForTeacher(
                                      scheduleClassId: classDetails.id);
                              launch(classDetails.meetingLink);
                              // BlocProvider.of<JoinClassCubit>(contextA)
                              //     .joinClass(state.classDetail.id);
                            }
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Join Now",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                fontSize: 14.0,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // getFileTypeWidget(String type) {
  //   switch (type) {
  //     case "jpg":
  //     case "png":
  //     case "jpeg":
  //       return SvgPicture.asset("assets/svg/image.svg");
  //       break;
  //     case "mp4":
  //       return SvgPicture.asset("assets/svg/vid.svg");
  //       break;
  //     case "mp3":
  //       return SvgPicture.asset("assets/svg/audio.svg");
  //       break;
  //     case "doc":
  //     case "docx":
  //       return SvgPicture.asset("assets/svg/doc.svg");

  //       break;
  //     case "xlsx":
  //     case "xls":
  //       return SvgPicture.asset("assets/svg/excel.svg");
  //       break;
  //     case "pptx":
  //     case "ppt":
  //       return SvgPicture.asset("assets/svg/ppt.svg");
  //       break;
  //     case "pdf":
  //       return SvgPicture.asset("assets/svg/pdf.svg");
  //       break;
  //     default:
  //       return Container();
  //       break;
  //   }
  // }
}
