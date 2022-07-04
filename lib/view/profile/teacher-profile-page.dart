import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../model/session-report.dart';
import '../file_viewer.dart';
import '/bloc/activity/activity-states.dart';
import '/bloc/teacher-profile/teacher-profile-states.dart';
import '/export.dart';
import '/model/task-progress.dart';
import '/model/teacher-profile.dart';
import '/view/profile/upload-profile.dart';


class TeacherProfilePage extends StatefulWidget {
  final UserInfo user;
  final SessionReportStudent sessionReport;

  TeacherProfilePage({this.user, this.sessionReport});
  @override
  _TeacherProfilePageState createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  PanelController _panelController = PanelController();

  bool _skills = false;
  bool update = false;
  bool updating = false;
  String about = '';
  XFile _file;
  PageController _pageController = PageController();
  TeacherAchievements teacherAchievements;
  bool edit = false;

  @override
  void initState() {
    // BlocProvider.of<ActivityCubit>(context, listen: false)
    //     .loadActivities('teacher profile page', {"status": "Evaluated"});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_panelController.isPanelOpen) {
          _panelController.close();
          return false;
        }
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: appMarker(),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              color: Colors.black,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
        body: SlidingUpPanel(
          controller: _panelController,
          defaultPanelState: PanelState.CLOSED,
          minHeight: 0,
          maxHeight: 350,
          backdropEnabled: true,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          panel: _panel(teacherAchievements),
          body: BlocBuilder<AssignedActivitiesCubit, AssignToYouStates>(
              builder: (context, state) {
            if (state is AssignedActivitiesLoaded) {
              return BlocBuilder<AuthCubit, AuthStates>(
                  builder: (context, userState) {
                if (userState is AccountsLoaded) {
                  return SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if(widget.user == null)
                                        showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            useRootNavigator: true,
                                            builder: (BuildContext contextA) {
                                              return SimpleDialog(
                                                title:
                                                    const Text('Select Option'),
                                                clipBehavior: Clip.antiAlias,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                ),
                                                children: <Widget>[
                                                  SimpleDialogOption(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 0.0,
                                                            horizontal: 24.0),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      if (userState.user
                                                              .profileImage !=
                                                          null) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (context) => FileViewer(
                                                                    type: "jpg",
                                                                    resourceType: MediaResourceType.url,
                                                                    url: userState
                                                                            .user
                                                                            .profileImage,
                                                                )));
                                                      }
                                                    },
                                                    child: const ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading: const Icon(
                                                          Icons.image),
                                                      title: const Text('View'),
                                                    ),
                                                  ),
                                                  SimpleDialogOption(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 0.0,
                                                            horizontal: 24.0),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      final pickedFile =
                                                          await ImagePicker()
                                                              .pickImage(
                                                                  source: ImageSource
                                                                      .gallery);
                                                      if (pickedFile != null) {
                                                        // final croppedFile = await ImageCropper
                                                        //     .cropImage(
                                                        //     sourcePath:
                                                        //     pickedFile
                                                        //         .path,
                                                        //     aspectRatioPresets: [
                                                        //       CropAspectRatioPreset
                                                        //           .square,
                                                        //     ],
                                                        //     // androidUiSettings: AndroidUiSettings(
                                                        //     //     toolbarTitle:
                                                        //     //     'Crop',
                                                        //     //     toolbarColor:
                                                        //     //     backColor,
                                                        //     //     toolbarWidgetColor: Color(
                                                        //     //         0xff6fcf97),
                                                        //     //     activeControlsWidgetColor: Color(
                                                        //     //         0xff6fcf97),
                                                        //     //     initAspectRatio: CropAspectRatioPreset
                                                        //     //         .original,
                                                        //     //     lockAspectRatio:
                                                        //     //     true),
                                                        //    // iosUiSettings:
                                                        //     // IOSUiSettings(
                                                        //     //   minimumAspectRatio:
                                                        //     //   1.0,
                                                        //     // )
                                                        // );
                                                        // if (croppedFile !=
                                                        //     null) {
                                                        setState(() {
                                                          _file =
                                                              pickedFile;
                                                          log('Entered');
                                                          log(_file.toString());
                                                          Navigator.of(context)
                                                              .push(
                                                            createRoute(
                                                              pageWidget:
                                                                  UpdateProfileImage(
                                                                      this._file),
                                                            ),
                                                          );
                                                        });
                                                        // }
                                                        // else {
                                                        //   print(
                                                        //       'Crop cancelled.');
                                                        // }
                                                      } else {
                                                        print(
                                                            'No image selected.');
                                                      }
                                                    },
                                                    child: const ListTile(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      leading: const Icon(
                                                          Icons.edit),
                                                      title: const Text('Edit'),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: Container(
                                        height: 54,
                                        width: 54,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: _file != null
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      child:FutureBuilder<Uint8List>(
                                                          future: _file.readAsBytes(),
                                                          builder: (context,snapshot) {
                                                            if(snapshot.hasData) {
                                                              return Container(child: Image.memory(snapshot.data));
                                                            } else{
                                                              return loadingBar;
                                                            }
                                                          }
                                                      ),
                                                    )
                                                  : (widget.user !=
                                                          null || userState.user.profileImage != null)
                                                      ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: widget.user != null ? widget.user.profileImage:userState.user.profileImage,
                                                            fit: BoxFit.cover,
                                                            height: 49,
                                                            width: 49,
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              child: Container(
                                                                color: Colors
                                                                    .grey[200],
                                                                height: 49,
                                                                width: 49,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/svg/avatar.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                              child: Container(
                                                                color: Colors
                                                                    .grey[200],
                                                                height: 49,
                                                                width: 49,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/svg/avatar.svg"),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          child: Container(
                                                            color: Colors
                                                                .grey[200],
                                                            height: 49,
                                                            width: 49,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/svg/avatar.svg"),
                                                            ),
                                                          ),
                                                        ),
                                            ),
                                            if(widget.user == null)
                                            Positioned(
                                                top: 0,
                                                right: 0,
                                                child: SvgPicture.asset(
                                                    "assets/svg/camera.svg"))
                                          ],
                                        ),
                                      ),
                                    ),

                                    // InkWell(
                                    //   onTap: widget.user != null
                                    //       ? null
                                    //       : () async {
                                    //           await _pickImage();
                                    //           if (_file != null)
                                    //             Navigator.of(context).push(
                                    //               createRoute(
                                    //                 pageWidget:
                                    //                 UpdateProfileImage(
                                    //                         this._file),
                                    //               ),
                                    //             );
                                    //         },
                                    //   child: Stack(
                                    //     children: [
                                    //       ClipRRect(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //         child: CachedNetworkImage(
                                    //           imageUrl:
                                    //               '${widget.user != null ? widget.user.profileImage : userState.user.profileImage}',
                                    //           progressIndicatorBuilder:
                                    //               (context, url,
                                    //                       downloadProgress) =>
                                    //                   Container(
                                    //             color: Colors.grey[200],
                                    //             height: 49,
                                    //             width: 49,
                                    //           ),
                                    //           fit: BoxFit.cover,
                                    //           height: 50,
                                    //           width: 50,
                                    //           errorWidget:
                                    //               (context, url, error) =>
                                    //                   Container(
                                    //             color: Colors.grey[200],
                                    //             height: 49,
                                    //             width: 49,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       if (widget.user == null)
                                    //         Positioned(
                                    //           top: 0,
                                    //           right: 0,
                                    //           child: SvgPicture.asset(
                                    //             "assets/svg/camera.svg",
                                    //           ),
                                    //         )
                                    //     ],
                                    //   ),
                                    // ),
                                    SizedBox(
                                      width: 13,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.user != null ? widget.user.name : userState.user.name}',
                                          style: const TextStyle(
                                            color: const Color(0xff000000),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        Text(
                                          widget.user != null
                                              ? "${widget.user.profileType.roleName ?? ''}"
                                              : userState
                                                  .user.profileType.roleName
                                                  .toTitleCase(),
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/points.png",
                                          height: 24,
                                          width: 24,
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        BlocBuilder<RewardTeacherCubit,
                                                RewardTeacherStates>(
                                            builder: (context, state) {
                                          // BlocProvider.of<RewardTeacherCubit>(
                                          //         context)
                                          //     .loadRewardTeacher(
                                          //         teacherId: widget.user != null
                                          //             ? widget.user.id
                                          //             : null);
                                          if (state is RewardTeacherLoaded)
                                            return Text(
                                              "${getTotalReward(state.rewardTeachers)}",
                                              style: const TextStyle(
                                                color: const Color(0xff404ef3),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                              ),
                                            );
                                          else {
                                            BlocProvider.of<RewardTeacherCubit>(
                                                    context)
                                                .loadRewardTeacher(
                                                    teacherId:
                                                        widget.user != null
                                                            ? widget.user.id
                                                            : null);
                                            return Text(
                                              '0',
                                              style: const TextStyle(
                                                color: const Color(0xff404ef3),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12.0,
                                              ),
                                            );
                                          }
                                        }),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Class",
                                    //       style: const TextStyle(
                                    //         color: const Color(0xff000000),
                                    //         fontWeight: FontWeight.w400,
                                    //         fontSize: 12.0,
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 7,
                                    //     ),
                                    //     Text(
                                    //       "",
                                    //       style: const TextStyle(
                                    //         color: const Color(0xff000000),
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: 18.0,
                                    //       ),
                                    //     )
                                    //   ],
                                    // )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Spacer(),
                                      if (widget.user == null)
                                        TextButton(
                                          child: Text(
                                            !edit ? 'Edit' : 'Save',
                                            style: buildTextStyle(
                                                size: 13,
                                                color: Color(0xff2892FC)),
                                          ),
                                          onPressed: () async {
                                            edit = !edit;
                                            if (!edit) {
                                              await BlocProvider.of<
                                                          TeacherSkillsCubit>(
                                                      context,
                                                      listen: false)
                                                  .updateAboutMe(about);
                                              BlocProvider.of<AuthCubit>(
                                                      context)
                                                  .checkAuthStatus();
                                            }
                                            setState(() {});
                                          },
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: TextFormField(
                                          onChanged: (value) {
                                            about = value;
                                          },
                                          initialValue:
                                              '${widget.user != null ? widget.user.about ?? '' : userState.user.about ?? ''}',
                                          enabled: edit,
                                          maxLength: 120,
                                          maxLines: 6,
                                          decoration: InputDecoration(
                                            labelText: "About Me",
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      buildTeacherProgress(
                                        widget.user != null
                                            ? widget.user
                                            : userState.user,
                                        state.activities,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      teacherAchievement(widget.user != null
                                          ? widget.user.id
                                          : userState.user.id),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      teacherSkills(widget.user != null
                                          ? widget.user.id
                                          : userState.user.id),
                                      SizedBox(
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  BlocProvider.of<AuthCubit>(context, listen: false)
                      .checkAuthStatus();
                  return Container(
                    child: Center(
                      child: loadingBar,
                    ),
                  );
                }
              });
            } else {
              BlocProvider.of<AssignedActivitiesCubit>(context)
                  .getAssignedActivities('');
              return Center(
                child: loadingBar,
              );
            }
          }),
        ),
      ),
    );
  }

  int getTotalReward(List<TotalRewardDetails> students) {
    return students.fold<int>(0, (currentValue, student) {
      return currentValue +
          student.teacherDetails[0].coin +
          student.teacherDetails[0].extraCoins;
      // return currentValue;
    });
  }

  Widget teacherSkills(String teacherId) {
    return BlocBuilder<TeacherSkillsCubit, TeacherSkillStates>(
        builder: (context, state) {
      if (state is TeacherSkillsLoaded) {
        return Card(
          elevation: 10,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 250,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'Skills',
                    style: buildTextStyle(weight: FontWeight.bold),
                  ),
                ).expand,
                Container(
                  child: ListView.separated(
                    itemCount: state.skills.length,
                    padding: EdgeInsets.all(5),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8,
                    ),
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text(
                              state.skills[index].skills[0],
                              style: buildTextStyle(),
                            ),
                            Spacer(),
                          ],
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      );
                    },
                  ),
                ).expandFlex(3),
                if (widget.user == null)
                  Row(
                    children: [
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          _title.clear();
                          _desc.clear();
                          setState(() {
                            updating = false;
                            _skills = true;
                            update = false;
                          });
                          _panelController.open();
                        },
                        child: Text(
                          'Add Skill',
                          style: buildTextStyle(
                            size: 15,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      } else {
        BlocProvider.of<TeacherSkillsCubit>(context)
            .getSkills(teacherId: teacherId);
        return Card(
          elevation: 10,
          shadowColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: 250,
          ),
        );
      }
    });
  }

  Card teacherAchievement(String teacherId) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<TeacherAchievementsCubit, TeacherAchievementStates>(
          builder: (context, state) {
        if (state is TeacherAchievementLoaded)
          return Container(
            height: 230,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text(
                    'Achievements',
                    style: buildTextStyle(weight: FontWeight.bold),
                  ),
                ).expand,
                Container(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.navigate_before),
                        onPressed: () {
                          _pageController.previousPage(
                            curve: Curves.easeInOutExpo,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                      ).expand,
                      Container(
                        // color: Colors.grey,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: state.achievements.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xffF0F4FC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // color: index % 2 == 0
                              //     ? Colors.red
                              //     : Colors.green,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        state.achievements[index].title,
                                        style: buildTextStyle(size: 16),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                        onPressed: () {
                                          _skills = false;
                                          _title.clear();
                                          _desc.clear();
                                          update = true;
                                          updating = false;
                                          setState(() {});
                                          teacherAchievements =
                                              state.achievements[index];
                                          _title.text =
                                              state.achievements[index].title;
                                          _desc.text = state
                                              .achievements[index].description;
                                          _panelController.open();
                                        },
                                      ),
                                    ],
                                  ).expand,
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      state.achievements[index].description,
                                      style: buildTextStyle(size: 13),
                                      softWrap: true,
                                    ),
                                  ).expandFlex(3),
                                  //     Row(
                                  //       children: [
                                  //         Spacer(),
                                  //         FlatButton(
                                  //           child: Text(
                                  //             'SEE MORE',
                                  //             style:
                                  //                 buildTextStyle(
                                  //               weight: FontWeight
                                  //                   .bold,
                                  //               size: 15,
                                  //               color: Color(
                                  //                   0xff2892FC),
                                  //             ),
                                  //           ),
                                  //           onPressed: () {},
                                  //         )
                                  //       ],
                                  //     ).expand
                                ],
                              ),
                            );
                          },
                        ),
                      ).expandFlex(7),
                      IconButton(
                        icon: Icon(Icons.navigate_next),
                        onPressed: () {
                          _pageController.nextPage(
                            curve: Curves.easeInOutExpo,
                            duration: Duration(milliseconds: 500),
                          );
                        },
                      ).expand,
                    ],
                  ),
                ).expandFlex(3),
                SizedBox(
                  height: 20,
                ),
                if (widget.user == null)
                  Row(
                    children: [
                      Spacer(),
                      FlatButton(
                        onPressed: () {
                          _skills = false;
                          _title.clear();
                          _desc.clear();
                          update = false;
                          updating = false;
                          setState(() {});
                          _panelController.open();
                        },
                        child: Text(
                          'Add Achievement',
                          style: buildTextStyle(
                            size: 15,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        else {
          BlocProvider.of<TeacherAchievementsCubit>(context)
              .getAchievements(teacherId: teacherId);
          return Container();
        }
      }),
    );
  }

  Widget buildTeacherProgress(UserInfo user, List<Activity> activity) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        // height: 100,
        padding: EdgeInsets.all(10),
        child:
        // BlocBuilder<ActivityCubit, ActivityStates>(
        //     builder: (context, state) {
        //   if (state is ActivityLoaded) {
        //     return
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Text(
                //   '(Coming Soon)',
                //   style: buildTextStyle(),
                // ),
                FutureBuilder<TotalActivityProgress>(
                    future:
                        BlocProvider.of<ActivityCubit>(context, listen: false)
                            .userTotalProgress(user.id, teacher: true),
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Tasks',
                            style: buildTextStyle(weight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: buildLinearPercentBar(
                              lineHeight: 15,
                              percent: snapshot.hasData
                                  ? (snapshot.data.average ?? 0 )/ 100
                                  : 0,
                            ),
                          ),
                        ],
                      );
                    }),
                FutureBuilder<ActivityProgress>(
                    future: BlocProvider.of<ActivityCubit>(context)
                        .announcementProgress(user.id, extra: 'Teacher'),
                    builder: (context, snapshot) {
                      return Row(
                        children: [
                          Text(
                            'Announcement',
                            style: buildTextStyle(
                              size: 12,
                              color: Colors.grey[500],
                            ),
                          ).expandFlex(2),
                          buildLinearPercentBar(
                            lineHeight: 15,
                            percent: snapshot.hasData
                                ? (snapshot.data.average) / 100
                                : 0,
                            color: Color(0xffA57EB4),
                          ).expandFlex(2),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _progressContainer(
                                  text: snapshot.hasData
                                      ? snapshot.data.completed.toString()
                                      : '0'.toString(),
                                ),
                                _progressContainer(
                                  color: Color(0xffFF5A79),
                                  text: (snapshot.hasData
                                          ? snapshot.data.pending
                                          : 0)
                                      .toString(),
                                ),
                              ],
                            ),
                          ).expand
                        ],
                      );
                    }),
                SizedBox(
                  height: 5,
                ),
                // FutureBuilder<ActivityProgress>(
                //     future: BlocProvider.of<ActivityCubit>(context)
                //         .announcementProgress(user.id, extra: 'Teacher'),
                //     builder: (context, snapshot) {
                //       return
                if(widget.sessionReport != null)
                        Row(
                        children: [
                          Text(
                            'Live Session',
                            style: buildTextStyle(
                              size: 12,
                              color: Colors.grey[500],
                            ),
                          ).expandFlex(2),
                          buildLinearPercentBar(
                            lineHeight: 15,
                            percent: widget.sessionReport.avg/widget.sessionReport.total,
                            color: Color(0xffA57EB4),
                          ).expandFlex(2),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _progressContainer(
                                  text: widget.sessionReport.attended.toString()
                                ),
                                _progressContainer(
                                  color: Color(0xffFF5A79),
                                  text: widget.sessionReport.total
                                      .toString(),
                                ),
                              ],
                            ),
                          ).expand
                        ],
                      ),
                    // }),
                // FutureBuilder<ActivityProgress>(
                //     future: BlocProvider.of<ActivityCubit>(context)
                //         .livePollActivityProgress(user.id, extra: 'Teacher'),
                //     builder: (context, snapshot) {
                //       return Row(
                //         children: [
                //           Text(
                //             'LivePoll',
                //             style: buildTextStyle(
                //               size: 12,
                //               color: Colors.grey[500],
                //             ),
                //           ).expandFlex(2),
                //           buildLinearPercentBar(
                //             lineHeight: 15,
                //             percent: snapshot.hasData
                //                 ? snapshot.data.average / 100
                //                 : 0,
                //             color: Color(0xff8CA0C9),
                //           ).expandFlex(2),
                //           Container(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 _progressContainer(
                //                     text: (snapshot.hasData ?? 0
                //                             ? snapshot.data.completed
                //                             : 0)
                //                         .toString()),
                //                 _progressContainer(
                //                   color: Color(0xffFF5A79),
                //                   text: (snapshot.hasData
                //                           ? snapshot.data.pending
                //                           : 0)
                //                       .toString(),
                //                 ),
                //               ],
                //             ),
                //           ).expand
                //         ],
                //       );
                //     }),
                // FutureBuilder<ActivityProgress>(
                //     future: BlocProvider.of<ActivityCubit>(context)
                //         .eventActivityProgress(user.id, extra: 'Teacher'),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) print('${snapshot.data}');
                //       return Row(
                //         children: [
                //           Text(
                //             'Event',
                //             style: buildTextStyle(
                //               size: 12,
                //               color: Colors.grey[500],
                //             ),
                //           ).expandFlex(2),
                //           buildLinearPercentBar(
                //             lineHeight: 15,
                //             percent: snapshot.hasData
                //                 ? snapshot.data.average / 100
                //                 : 0,
                //             color: Color(0xffC396FF),
                //           ).expandFlex(2),
                //           Container(
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: [
                //                 _progressContainer(
                //                     text: (snapshot.hasData
                //                             ? snapshot.data.completed
                //                             : 0)
                //                         .toString()),
                //                 _progressContainer(
                //                   color: Color(0xffFF5A79),
                //                   text: (snapshot.hasData
                //                           ? snapshot.data.pending
                //                           : 0)
                //                       .toString(),
                //                 ),
                //               ],
                //             ),
                //           ).expand
                //         ],
                //       );
                //     }),
                // FutureBuilder<ActivityProgress>(
                //     future: BlocProvider.of<ActivityCubit>(context)
                //         .checkListActivityProgress(user.id, extra: 'Teacher'),
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData)
                //         return Row(
                //           children: [
                //             Text(
                //               'CheckList (To-Do)',
                //               style: buildTextStyle(
                //                 size: 12,
                //                 color: Colors.grey[500],
                //               ),
                //             ).expandFlex(2),
                //             buildLinearPercentBar(
                //               lineHeight: 15,
                //               percent: snapshot.hasData
                //                   ? snapshot.data.average / 100
                //                   : 0,
                //               color: Color(0xff2182C4),
                //             ).expandFlex(2),
                //             Container(
                //               child: Row(
                //                 mainAxisAlignment:
                //                     MainAxisAlignment.spaceAround,
                //                 children: [
                //                   _progressContainer(
                //                       text: (snapshot.hasData
                //                               ? snapshot.data.completed
                //                               : 0)
                //                           .toString()),
                //                   _progressContainer(
                //                     color: Color(0xffFF5A79),
                //                     text: (snapshot.hasData
                //                             ? snapshot.data.pending
                //                             : 0)
                //                         .toString(),
                //                   ),
                //                 ],
                //               ),
                //             ).expand
                //           ],
                //         );
                //       else {
                //         return Container();
                //       }
                //     }),
                // if (widget.user != null)
                //   Row(
                //     children: [
                //       Text(
                //         'Evaluation',
                //         style: buildTextStyle(
                //           size: 12,
                //           color: Colors.grey[500],
                //         ),
                //       ).expandFlex(2),
                //       buildLinearPercentBar(
                //         lineHeight: 15,
                //         percent: getEvaluateStatus(state.allActivities)[1] /
                //             (getEvaluateStatus(state.allActivities)[1] +
                //                 getEvaluateStatus(state.allActivities)[0]),
                //         color: Color(0xff2182C4),
                //       ).expandFlex(2),
                //       Container(
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                //           children: [
                //             _progressContainer(
                //                 text: getEvaluateStatus(state.allActivities)[1]
                //                     .toString()),
                //             _progressContainer(
                //                 color: Color(0xffFF5A79),
                //                 text:
                //                     '${getEvaluateStatus(state.allActivities)[0]}'),
                //           ],
                //         ),
                //       ).expand
                //     ],
                //   ),
              ],
            )
          // } else {
          //   return Center(
          //     child: loadingBar,
          //   );
          // }
        // }
        // ),
      ),
    );
  }

  Container _progressContainer({String text, Color color}) {
    return Container(
      // padding: EdgeInsets.all(10),
      height: 25,
      width: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color ?? Color(0xff2CB9B0),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text ?? '7',
        style: buildTextStyle(color: Colors.white, size: 12),
      ),
    );
  }

  String _validator(String value) {
    if (value.isEmpty) return 'Please provide a value';
    return null;
  }

  Widget _panel(TeacherAchievements teacherAchievements) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _panelController.close();
                },
              )
            ],
          ),
          TextFormField(
            controller: _title,
            validator: _validator,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              hintText: _skills ? 'Add Skill' : 'Add Title',
            ),
          ),
          if (!_skills)
            TextFormField(
              controller: _desc,
              maxLines: 4,
              validator: _validator,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Add Description',
              ),
            ),
          CustomRaisedButton(
            title: 'Save',
            check: !updating,
            onPressed: () async {
              setState(() {
                updating = true;
              });
              if (update) {
                teacherAchievements.title = _title.text;
                teacherAchievements.description = _desc.text;
                if (_title.text.trim().isNotEmpty &&
                    _desc.text.trim().isNotEmpty) {
                  await BlocProvider.of<TeacherAchievementsCubit>(context,
                          listen: false)
                      .updateAchievements(teacherAchievements);
                  BlocProvider.of<TeacherAchievementsCubit>(context)
                      .getAchievements();
                }
              } else if (_skills) {
                if (_title.text.trim().isNotEmpty) {
                  await BlocProvider.of<TeacherSkillsCubit>(context,
                          listen: false)
                      .createSkill(_title.text);
                  BlocProvider.of<TeacherSkillsCubit>(context).getSkills();
                }
              } else {
                if (_title.text.trim().isNotEmpty &&
                    _desc.text.trim().isNotEmpty) {
                  await BlocProvider.of<TeacherAchievementsCubit>(context)
                      .createAchievements(_title.text, _desc.text);
                  BlocProvider.of<TeacherAchievementsCubit>(context)
                      .getAchievements();
                }
              }
              FocusScope.of(context).unfocus();
              _panelController.close();
            },
          ),
        ],
      ),
    );
  }

  // double getAllProgress(List<Activity> activity) {
  //   return activity
  //           .where((act) => act.status.toLowerCase() == 'evaluated')
  //           .length /
  //       (activity
  //                   .where((act) => act.status.toLowerCase() == 'evaluate')
  //                   .length ==
  //               0
  //           ? 1
  //           : activity
  //               .where((act) => act.status.toLowerCase() == 'evaluate')
  //               .length);
  // }

  List<int> getEvaluateStatus(List<Activity> activity) {
    List<int> evaluate = [
      activity.where((act) => act.status.toLowerCase() == 'evaluate').length,
      activity.where((act) => act.status.toLowerCase() == 'evaluated').length,
    ];
    return evaluate;
  }

  double getAllProgress(List<Activity> activity, UserInfo student) {
    return (activity.getAnnouncementProgressTeacher(student).completed +
            activity.getEventProgressTeacher(student).going +
            activity.getLivePollProgressTeacher(student).completed +
            activity.getCheckListProgressTeacher(student).completed) /
        activity.length;
  }

  double getAnnouncementProgress(List<Activity> activity, UserInfo student) {
    return (activity.getAnnouncementProgressTeacher(student).completed /
        getActivityLength('announcement', activity));
  }

  double getEventProgress(List<Activity> activity, UserInfo student) {
    return (activity.getEventProgressTeacher(student).going /
        getActivityLength('event', activity));
  }

  double getCheckListProgress(List<Activity> activity, UserInfo student) {
    print(activity.getCheckListProgressTeacher(student));
    var _progress = activity.getCheckListProgressTeacher(student).completed /
        getActivityLength('check list', activity);
    return (_progress > 1 ? 1 : _progress);
  }

  double getLivePollProgress(List<Activity> activity, UserInfo student) {
    var _progress = activity.getLivePollProgressTeacher(student).completed /
        getActivityLength('livepoll', activity);
    return (_progress > 1 ? 1 : _progress);
  }

  int getActivityLength(String activityName, List<Activity> activity,
      {bool checkNan = true}) {
    return activity
                .where((act) => act.activityType.toLowerCase() == activityName)
                .length ==
            0
        ? checkNan
            ? 1
            : 0
        : activity
            .where((act) => act.activityType.toLowerCase() == activityName)
            .length;
  }
}
