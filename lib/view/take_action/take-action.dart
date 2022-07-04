import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/bloc/take-action/take-action-states.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/view/Institute/institute_homepage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../model/InstituteSessionModel.dart';
import '../Institute/InstituteCreateSession.dart';
import '../Institute/SessionSearch.dart';

class TakeActionPanel extends StatelessWidget {
  final BuildContext contextA;
  final UserInfo user;
  final PagingController<int, ReceivedSession> activityPagingController1;

  TakeActionPanel(this.contextA, {this.user, this.activityPagingController1});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 27.0, left: 19),
        child: SafeArea(
          top: false,
          child:
              BlocBuilder<TakeActionCubit, TakeActionStates>(builder: (context, state) {
            if (state is TakeActionInitialized) {
              return BlocBuilder<SessionCubit, DisplaySessionStates>(
                  builder: (context, sessionState) {
                if (sessionState is SessionLoaded) {

                  return Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            homeTakeActionPanelController.close();
                            // if(searchTakeActionPanelController.isAttached)
                            // searchTakeActionPanelController.close();
                            Navigator.of(context).push(
                              createRoute(
                                  pageWidget: CreateSession(
                                institute: user.schoolId.institute,
                                isEdit: true,
                                user: user,
                                receivedSession: state.session,
                              )),
                            );
                            // BlocProvider.of<SessionCubit>(context).deleteSession(state.session.id).then((value) {
                            //   activityPagingController1.refresh();
                            //
                            //     sessionState.session.removeWhere((element) => element.id == state.session.id);
                            //   log('true');
                            //   BlocProvider.of<SessionCubit>(context).emit(SessionLoaded(sessionState.session));
                            //   Fluttertoast.showToast(msg: value);
                            //     homeTakeActionPanelController.close();
                            //
                            //   // Navigator.of(context).pushReplacement( createRoute(
                            //   //     pageWidget: BlocProvider(
                            //   //       create: (context) {
                            //   //         return SessionCubit()
                            //   //           ..displaySessionForToday(
                            //   //             schoolId: user != null
                            //   //                 ? user.schoolId.id
                            //   //                 : null,
                            //   //             instituteId: user != null
                            //   //                 ? user.schoolId.institute.id
                            //   //                 : null,
                            //   //           );
                            //   //       },
                            //   //       child: InstituteHomePage(
                            //   //         user:user,
                            //   //       ),
                            //   //     )),);
                            // });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // height: 50,
                            child: Row(
                              children: [
                                // SvgPicture.asset("assets/svg/help-icon.svg"),
                                Icon(Icons.edit),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "Edit Session",
                                  style: const TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return  AlertDialog(
                                  title: Text(state.session.subjectName),
                                  content: Text('Are you sure!!\nDo you want to Delete this session'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),

                                    ),
                                    TextButton(
                                      onPressed: () {
                                        BlocProvider.of<SessionCubit>(context)
                                            .deleteSession(state.session.id)
                                            .then((value) {
                                          // activityPagingController1.refresh();

                                          sessionState.session.removeWhere(
                                              (element) => element.id == state.session.id);
                                          BlocProvider.of<SessionCubit>(context)
                                              .emit(SessionLoaded(sessionState.session));
                                          Fluttertoast.showToast(msg: value);
                                          homeTakeActionPanelController.close();
                                          // if(searchTakeActionPanelController.isAttached)
                                          //   searchTakeActionPanelController.close();
                                          Navigator.pop(context);
                                          activityPagingController1.refresh();
                                        });
                                      },
                                      child: Text('YES'),
                                    )
                                  ],
                                );
                              },
                            );

                            // BlocProvider.of<SessionCubit>(context)
                            //     .deleteSession(state.session.id)
                            //     .then((value) {
                            //   activityPagingController1.refresh();
                            //
                            //   sessionState.session.removeWhere(
                            //       (element) => element.id == state.session.id);
                            //   BlocProvider.of<SessionCubit>(context)
                            //       .emit(SessionLoaded(sessionState.session));
                            //   Fluttertoast.showToast(msg: value);
                            //   homeTakeActionPanelController.close();
                            //   if(searchTakeActionPanelController.isAttached)
                            //     searchTakeActionPanelController.close();
                            //
                            //
                            //   // searchTakeActionPanelController.close();
                            //   // Navigator.of(context).pushReplacement( createRoute(
                            //   //     pageWidget: BlocProvider(
                            //   //       create: (context) {
                            //   //         return SessionCubit()
                            //   //           ..displaySessionForToday(
                            //   //             schoolId: user != null
                            //   //                 ? user.schoolId.id
                            //   //                 : null,
                            //   //             instituteId: user != null
                            //   //                 ? user.schoolId.institute.id
                            //   //                 : null,
                            //   //           );
                            //   //       },
                            //   //       child: InstituteHomePage(
                            //   //         user:user,
                            //   //       ),
                            //   //     )),);
                            // });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // height: 50,
                            child: Row(
                              children: [
                                // SvgPicture.asset("assets/svg/help-icon.svg"),
                                Icon(Icons.delete),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  "Delete Session",
                                  style: const TextStyle(
                                      color: const Color(0xff000000),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0),
                                )
                              ],
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     // BlocProvider.of<FeedActionCubit>(context)
                        //     //     .updateFeedPanelContent(
                        //     //         state.activityType, state.activity);
                        //     // if (route == "/saved") {
                        //     //   savedTakeActionPanelController.close();
                        //     //   savedFeedActionPanelController.open();
                        //     // } else {
                        //     //   takeActionPanelController.close();
                        //     //   feedActionPanelController.open();
                        //     // }
                        //   },
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     height: 50,
                        //     child: Row(
                        //       children: [
                        //         SvgPicture.asset("assets/svg/take-icon.svg"),
                        //         SizedBox(
                        //           width: 16,
                        //         ),
                        //         Text(
                        //           "Take a Action",
                        //           style: const TextStyle(
                        //               color: const Color(0xff000000),
                        //               fontWeight: FontWeight.w400,
                        //               fontSize: 14.0),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // GestureDetector(
                        //   onTap: () {
                        //     // takeActionPanelController.close();
                        //     //
                        //     // Navigator.push(
                        //     //     context,
                        //     //     MaterialPageRoute(
                        //     //         builder: (context) => ConnectWithAuthor()));
                        //   },
                        //   child: Row(
                        //     children: [
                        //       SvgPicture.asset("assets/svg/connect.svg"),
                        //       SizedBox(
                        //         width: 16,
                        //       ),
                        //       Text(
                        //         "Connect With Author",
                        //         style: const TextStyle(
                        //             color: const Color(0xff000000),
                        //             fontWeight: FontWeight.w400,
                        //             fontSize: 14.0),
                        //       )
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  );
                }
                return Container();
              });
            }
            return Container(
              height: 0,
            );
          }),
        ),
      ),
    );
    //   return Container(child: loadingBar);
    // });
  }
}
