import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:growonplus_teacher/view/Institute/institute_homepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '/export.dart';
import '/view/drawer/drawer_menu.dart';
import '/view/profile/teacher-profile-page.dart';

class HomeSliverAppBar extends StatelessWidget {
  final PanelController panelController;

  HomeSliverAppBar(this.panelController);

  Future<String> getName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String name = _prefs.getString('user-name');
    return name ?? 'Name Not Found';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
      if (state is AccountsLoaded || state is LoginSuccess) {
        return Container(
          // margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    appMarker(),
                    Spacer(),
                    // IconButton(
                    //     icon: SvgPicture.asset('assets/svg/notification.svg'),
                    //
                    //    onPressed: () {}),
                    if (state is AccountsLoaded
                        ? state.user.schoolId.institute != null &&
                            state.user.schoolId.institute.id != null
                        : false)
                      Container(
                        width: 75,
                        height: 52,
                        padding: const EdgeInsets.only(top: 6, right: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              createRoute(
                                  pageWidget: BlocProvider(
                                create: (context) {
                                  UserInfo user = state is AccountsLoaded
                                      ? state.user
                                      : null;
                                  return SessionCubit()
                                    ..displaySessionForToday(
                                      schoolId: user != null
                                          ? user.schoolId.id
                                          : null,
                                      instituteId: user != null
                                          ? user.schoolId.institute.id
                                          : null,
                                    );
                                },
                                child: InstituteHomePage(
                                  user: state is AccountsLoaded
                                      ? state.user
                                      : null,
                                ),
                              )),
                            );
                          },
                          child: TeacherProfileAvatar(
                            imageUrl: state is AccountsLoaded
                                ? state.user.schoolId.institute.profileImage
                                : 'Text',
                          ),
                        ),
                      ),
                    IconButton(
                      onPressed: () async {
                        bool open = await Navigator.of(context).push<bool>(
                          createRoute(pageWidget: DrawerMenu()),
                        );
                        if (open != null) {
                          if (open) {
                            panelController.open();
                          }
                        }
                        // Scaffold.of(context).openDrawer();
                      },
                      icon: Container(
                        height: 25,
                        width: 28,
                        child: SvgPicture.asset(
                          "assets/svg/menu.svg",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(pageWidget: TeacherProfilePage()),
                          );
                        },
                        child: TeacherProfileAvatar(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state is LoginSuccess
                                ? ''
                                : state is AccountsLoaded
                                    ? state.user.name.toTitleCase()
                                    : '',
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            state is AccountsLoaded
                                ? state.user.profileType.roleName.toTitleCase()
                                : '',
                            // state is LoginSuccess
                            //     ? state.loginResponse.userInfo[0].profileType
                            //         .toTitleCase()
                            //     : state is AccountsLoaded
                            //         ? state.user.profileType.toTitleCase()
                            //         : '',
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      // SizedBox(
                      //   height: 30,
                      //   width: 140,
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       Navigator.of(context).push(
                      //         createRoute(
                      //           pageWidget: MultiBlocProvider(
                      //             providers: [
                      //               BlocProvider(
                      //                 create: (context) => QuestionPaperCubit()
                      //                   ..loadAllQuestionPapers(),
                      //               ),
                      //             ],
                      //             child: TestListingPage(),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           'Evaluate Test',
                      //           style: buildTextStyle(
                      //             color: Color(0xff2F80ED),
                      //             size: 12,
                      //           ),
                      //         ),
                      //         Icon(
                      //           Icons.open_in_new,
                      //           size: 20,
                      //           color: Color(0xff2F80ED),
                      //         )
                      //       ],
                      //     ),
                      //     style: ButtonStyle(
                      //       elevation: MaterialStateProperty.all(0),
                      //       shape: MaterialStateProperty.all(
                      //         RoundedRectangleBorder(
                      //             side: BorderSide(
                      //           color: Color(0xff2F80ED),
                      //         )),
                      //       ),
                      //       fixedSize: MaterialStateProperty.all(Size(140, 8)),
                      //       backgroundColor:
                      //           MaterialStateProperty.all(Colors.white),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        width: 10,
                      ),
                      // Image.asset(
                      //   'assets/images/teacher.png',
                      //   height: 30,
                      //   width: 30,
                      // )
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //       createRoute(pageWidget: TeacherProfilePage()),
                      //     );
                      //   },
                      //   child: TeacherProfileAvatar(),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // Future.delayed(Duration(seconds: 10));
        // BlocProvider.of<AuthCubit>(context, listen: false)
        //     .checkAuthStatus('from app bar homepage');
        return Container();
      }
    });
  }
}

class TeacherProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final double radius;
  final bool fill;
  final Color bgColor;

  TeacherProfileAvatar({
    this.imageUrl,
    this.radius = 25,
    this.fill = false,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    // return CircleAvatar(
    //   radius: radius,
    //   child: Container(
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(radius),
    //       color: Colors.grey[100],
    //     ),
    //     alignment: Alignment.center,
    //     child: FaIcon(FontAwesomeIcons.userAlt,
    //         size: radius * 1, color: Theme.of(context).primaryColor),
    //     height: 50,
    //     width: 50,
    //   ),
    // );
    try {
      return BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
        try {
          return Container(
            padding: EdgeInsets.all(fill ? 3 : 0),
            decoration: BoxDecoration(
              color: fill ? bgColor : null,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: state is AccountsLoaded
                    ? imageUrl ?? state.user.profileImage ?? 'https://'
                    : '',
                //state.userInfo.profileImage,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CupertinoActivityIndicator(),
                ),
                fit: BoxFit.cover,
                width: radius * 2,
                height: radius * 2,
                placeholderFadeInDuration: Duration(seconds: 1),
                useOldImageOnUrlChange: true,
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[100],
                  alignment: Alignment.center,
                  child: FaIcon(FontAwesomeIcons.userAlt,
                      color: Theme.of(context).primaryColor),
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          );
        } catch (error) {
          return Container(
            color: Colors.grey[100],
            alignment: Alignment.center,
            child: FaIcon(FontAwesomeIcons.userAlt,
                color: Theme.of(context).primaryColor),
            height: 40,
            width: 40,
          );
        }
      });
    } catch (error) {
      return Container(
        color: Colors.grey[100],
        alignment: Alignment.center,
        child: FaIcon(FontAwesomeIcons.userAlt,
            color: Theme.of(context).primaryColor),
        height: 40,
        width: 40,
      );
    }
  }
}

class AppBarBottomSwitch extends StatelessWidget {
  final StreamController<bool> streamController;
  final Function(bool value) onChanged;

  AppBarBottomSwitch(
    this.streamController, {
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      width: double.infinity,

      child: Container(
        padding: EdgeInsets.all(0),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Assigned By You',
                    style: buildTextStyle(
                      color: Colors.grey[600],
                      size: 14,
                    ),
                  ),
                  StreamBuilder<bool>(
                      initialData: false,
                      stream: streamController.stream,
                      builder: (context, snapshot) {
                        return Switch(
                          value: snapshot.data ?? false,
                          dragStartBehavior: DragStartBehavior.down,
                          activeTrackColor: Color(0xff261739),
                          inactiveThumbColor: Colors.yellow,
                          inactiveTrackColor: Color(0xff261739),
                          focusColor: Colors.yellow,
                          onChanged: (value) {
                            Provider.of<AssignmentFilter>(context,
                                    listen: false)
                                .resetFilter();
                            Provider.of<EventFilter>(context, listen: false)
                                .resetFilter();
                            Provider.of<Doubts>(context, listen: false)
                                .resetFilter();
                            Provider.of<TasksFilter>(context, listen: false)
                                .resetFilter();
                            streamController.add(value);
                            if (onChanged != null) {
                              onChanged(value);
                            }
                          },
                          activeColor: Colors.yellow,
                        );
                      }),
                  Text(
                    'Assigned to You',
                    style: buildTextStyle(
                      size: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
