import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';

import '/bloc/innovations/innovations-cubit.dart';
import '/bloc/innovations/innovations-states.dart';
import '/export.dart';
import '/model/innovations.dart';
import '/view/innovations/innovation-listing.dart';
PanelController panelController =  PanelController();
class Innovations extends StatefulWidget {
  @override
  _InnovationsState createState() => _InnovationsState();
}
class _InnovationsState extends State<Innovations>with SingleTickerProviderStateMixin {
  TabController tabController;
  String currentCategory = '';
  int coin = 0;
  PageController pageController =  PageController();
  final StreamController<String> _controller =
      StreamController<String>.broadcast();
  final StreamController<Innovation> _innovationController =
      StreamController<Innovation>.broadcast();
  final GlobalKey<FormState> _form = GlobalKey();
  final ScrollController publishController = ScrollController();
  final ScrollController submitController = ScrollController();
  bool loading = false;
  int page = 1;
  get close {
    _controller.close();
    _innovationController.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController =  TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (panelController.isPanelOpen) {
          panelController.close();
          return false;
        }

        return true;
      },
      child: Material(
        child: BlocBuilder<CurrentInnovationCubit, InnovationCurrentState>(
            builder: (context, state) {
          return SlidingUpPanel(
              minHeight: 0,
              onPanelOpened: () {
                setState(() {});
              },
              onPanelClosed: () {
                setState(() {});
              },
              body: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
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
                body: SafeArea(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Did Something new today?",
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CategoryBadge(
                                    onTap: (category) {
                                      currentCategory = category;
                                      setState(() {});
                                    },
                                    onDoubleTap: (category) {
                                      currentCategory = '';
                                      setState(() {});
                                    },
                                    currentCategory: currentCategory,
                                    color: Color(0xff2cb9b0),
                                    bgColor: Color(0x7f2cb9b0),
                                    imageUrl: 'assets/svg/in-home.svg',
                                    title: 'Home',
                                  ),
                                  CategoryBadge(
                                    onTap: (category) {
                                      currentCategory = category;
                                      setState(() {});
                                    },
                                    onDoubleTap: (category) {
                                      currentCategory = '';
                                      setState(() {});
                                    },
                                    currentCategory: currentCategory,
                                    color: Color(0xff47a6ff),
                                    bgColor: Color(0x7f47a6ff),
                                    imageUrl: 'assets/svg/in-school.svg',
                                    title: 'School',
                                  ),
                                  CategoryBadge(
                                    onTap: (category) {
                                      currentCategory = category;
                                      setState(() {});
                                    },
                                    onDoubleTap: (category) {
                                      currentCategory = '';
                                      setState(() {});
                                    },
                                    currentCategory: currentCategory,
                                    color: Color(0xffc396ff),
                                    bgColor: Color(0x7fc396ff),
                                    imageUrl: 'assets/svg/in-community.svg',
                                    title: 'Community',
                                  ),
                                  CategoryBadge(
                                    onTap: (category) {
                                      currentCategory = category;
                                      setState(() {});
                                    },
                                    onDoubleTap: (category) {
                                      currentCategory = '';
                                      setState(() {});
                                    },
                                    currentCategory: currentCategory,
                                    color: Color(0xfff0a35d),
                                    bgColor: Color(0x7ff0a35d),
                                    imageUrl: 'assets/svg/in-hobbies.svg',
                                    title: 'Hobbies',
                                  ),
                                ],
                              ),
                              SizedBox(height: 14),
                              TabBar(
                                onTap: (index) {
                                  pageController.jumpToPage(index);
                                },
                                labelStyle: TextStyle(
                                    color: Color(0xff261739),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                unselectedLabelStyle: TextStyle(
                                    color: Color(0xff261739),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                indicator: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: const Color(0xffFFC30A),
                                ),
                                controller: tabController,
                                tabs: [
                                  Tab(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 12, right: 12),
                                      child: Text("Published"),
                                    ),
                                  ),
                                  Tab(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 12, right: 12),
                                      child: Text("Submitted"),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 14),
                            ],
                          ),
                        ),
                        Expanded(
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (index) {
                              tabController.animateTo(
                                index,
                                duration: Duration(milliseconds: 120),
                                curve: Curves.easeIn,
                              );
                            },
                            controller: pageController,
                            children: [
                              BlocBuilder<InnovationCubit, InnovationStates>(
                                  builder: (context, state) {
                                if (state is InnovationsLoaded) {
                                  if (!publishController.hasListeners)
                                    publishController.addListener(() {
                                      if (publishController.position.pixels ==
                                          publishController
                                              .position.maxScrollExtent) {
                                        if (state.hasMore && !loading) {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //     content: Text(
                                          //         'Loading more innovations..'),
                                          //   ),
                                          // );
                                          loading = true;
                                          page++;
                                          // BlocProvider.of<InnovationCubit>(
                                          //         context)
                                          //     .loadMoreInnovations(state, page)
                                          //     .then((value) {
                                          //   loading = false;
                                          // });
                                        } else if (!state.hasMore) {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //     content:
                                          //         Text('No more innovations'),
                                          //   ),
                                          // );
                                        }
                                      }
                                    });
                                  return InnovationListing(
                                    scrollController: publishController,
                                    innovations:
                                        state.innovations.where((element) {
                                      if (currentCategory.isEmpty)
                                        return element.published == 'yes';
                                      else
                                        return element.published == 'yes' &&
                                            element.categoryList[0] ==
                                                currentCategory;
                                    }).toList(),
                                  );
                                } else
                                  return loadingBar;
                              }),
                              BlocBuilder<InnovationCubit, InnovationStates>(
                                  builder: (context, state) {
                                if (state is InnovationsLoaded) {
                                  if (!submitController.hasListeners)
                                    submitController.addListener(() {
                                      if (submitController.position.pixels ==
                                          submitController
                                              .position.maxScrollExtent) {
                                        if (state.hasMore && !loading) {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //     content: Text(
                                          //         'Loading more innovations..'),
                                          //   ),
                                          // );
                                          loading = true;
                                          page++;
                                          // BlocProvider.of<InnovationCubit>(
                                          //         context)
                                          //     .loadMoreInnovations(state, page)
                                          //     .then((value) {
                                          //   loading = false;
                                          // });
                                        } else if (!state.hasMore) {
                                          // ScaffoldMessenger.of(context)
                                          //     .showSnackBar(
                                          //   SnackBar(
                                          //     content:
                                          //         Text('No more innovations'),
                                          //   ),
                                          // );
                                        }
                                      }
                                    });
                                  return InnovationSubmittedListing(
                                    scrollController: submitController,
                                    youInnovations:
                                        state.innovations.where((element) {
                                      if (currentCategory.isEmpty)
                                        return true;
                                      else
                                        return element.categoryList[0] ==
                                                currentCategory &&
                                            element.published != 'yes';
                                    }).toList(),
                                    panelController: panelController,
                                    streamController: _controller,
                                    innovationController: _innovationController,
                                  );
                                } else
                                  return loadingBar;
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              defaultPanelState: PanelState.CLOSED,
              controller: panelController,
              isDraggable: true,
              maxHeight: MediaQuery.of(context).size.height * 0.81,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              panelBuilder: (sc) {
                if (state is CurrentInnovationLoaded) {
                  if (state.seeInnovation)
                    return buildPost(state.innovation, context);
                  else
                    return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 20),
                          child: StreamBuilder<String>(
                            initialData: 'Publish',
                            stream: _controller.stream,
                            builder: (context, snapshot) {
                              return BlocBuilder<CurrentInnovationCubit,
                                  InnovationCurrentState>(
                                builder: (context, snapshot2) {
                                  if (snapshot2 is CurrentInnovationLoaded)
                                    // print('inside stream' +
                                    //     snapshot2.innovation.about +
                                    //     '${snapshot2.hasData}');
                                    // if(snapshot.hasData)
                                    return SingleChildScrollView(
                                      child: Form(
                                        key: _form,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${snapshot.data}',
                                                  style: buildTextStyle(
                                                    size: 18,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ).expandFlex(4),
                                                Image.asset(
                                                  'assets/images/points.png',
                                                  height: 25,
                                                ),
                                                TextFormField(
                                                  validator: (value) {
                                                    if (int.tryParse(value) ==
                                                            null &&
                                                        value.isEmpty) {
                                                      return 'Please Provide a valid value';
                                                    }
                                                    snapshot2.innovation.coin =
                                                        int.parse(value);
                                                    coin = int.parse(value);
                                                    print(coin);
                                                    print('inside validator');
                                                    return null;
                                                  },
                                                  maxLength: 2,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    border:
                                                        UnderlineInputBorder(),
                                                  ),
                                                ).expand,
                                              ],
                                            ),
                                            TextFormField(
                                              initialValue:
                                                  '${snapshot2.innovation.title}',
                                              decoration: InputDecoration(
                                                enabled: false,
                                                border: UnderlineInputBorder(),
                                                labelText:
                                                    'what is on your mind?',
                                              ),
                                            ),
                                            TextFormField(
                                              initialValue:
                                                  '${snapshot2.innovation.about}',
                                              decoration: InputDecoration(
                                                enabled: false,
                                                border: UnderlineInputBorder(),
                                                labelText:
                                                    'Tell us about your innovation',
                                              ),
                                            ),
                                            TextFormField(
                                              initialValue: snapshot2
                                                  .innovation.tags
                                                  .join(' '),
                                              decoration: InputDecoration(
                                                enabled: false,
                                                border: UnderlineInputBorder(),
                                                labelText: 'Add tags',
                                              ),
                                            ),
                                            Container(
                                              height: 350,
                                              width: double.infinity,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: 1,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  if (snapshot2
                                                      .innovation.files[index]
                                                      .endsWith('mp4')) {
                                                    // return FutureBuilder<
                                                    //     Uint8List>(
                                                    //   future: VideoThumbnail
                                                    //       .thumbnailData(
                                                    //           video: snapshot2
                                                    //               .innovation
                                                    //               .files[index]),
                                                    //   builder:
                                                    //       (BuildContext context,
                                                    //           AsyncSnapshot
                                                    //               imageSnap) {
                                                    //     return Container(
                                                    //       alignment:
                                                    //           Alignment.center,
                                                    //       child: Center(
                                                    //         child: Icon(
                                                    //           Icons
                                                    //               .play_arrow_rounded,
                                                    //           size: 30,
                                                    //           color: Theme.of(
                                                    //                   context)
                                                    //               .primaryColor,
                                                    //         ),
                                                    //       ),
                                                    //       decoration:
                                                    //           BoxDecoration(
                                                    //         image:
                                                    //             DecorationImage(
                                                    //           image: MemoryImage(
                                                    //               imageSnap
                                                    //                   .data),
                                                    //           fit: BoxFit.cover,
                                                    //         ),
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // );
                                                    return Container(
                                                      height: 350,
                                                      child: Chewie(
                                                        controller:
                                                            ChewieController(
                                                          videoPlayerController:
                                                              VideoPlayerController
                                                                  .network(snapshot2
                                                                      .innovation
                                                                      .files[index]),
                                                          autoPlay: false,
                                                          looping: true,
                                                          autoInitialize: true,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  return CachedImage(
                                                      imageUrl:
                                                          '${snapshot2.innovation.files[index]}',
                                                      height: 250);
                                                },
                                              ),
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                snapshot2.innovation
                                                    .teacherNote = value;
                                              },
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return 'Please provide a value';
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                enabled: true,
                                                border: UnderlineInputBorder(),
                                                labelText: 'Teacher\'s note',
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                              child: CustomRaisedButton(
                                                title: snapshot.data,
                                                onPressed: () {
                                                  handleOnPressed(
                                                      snapshot.data, snapshot2);
                                                },
                                              ),
                                            ),
                                            KeyboardVisibilityBuilder(
                                              builder:
                                                  (ctx, isKeyboardVisible) {
                                                return SizedBox(
                                                  height: isKeyboardVisible
                                                      ? 300
                                                      : 0,
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  else {
                                    return Center(
                                      child: loadingBar,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                } else
                  return Container();
              });
        }),
      ),
    );
  }

  void handleOnPressed(String snapshotData, CurrentInnovationLoaded snapshot2) {
    if (snapshotData == 'Publish') {
      if (_form.currentState.validate()) {
        snapshot2.innovation.published = 'yes';
        BlocProvider.of<InnovationCubit>(context)
            .publishInnovations(snapshot2.innovation, coin);
        BlocProvider.of<GroupCubit>(context).rewardStudents(
          Reward(
            innovationId: snapshot2.innovation.id,
            students: [
              RewardedStudent(
                snapshot2.innovation.coin,
                studentId: snapshot2.innovation.submittedBy.id,
              ),
            ],
          ),
          innovation: true,
        );
        panelController.close();
      }
    } else {
      snapshot2.innovation.published = 'no';
      BlocProvider.of<InnovationCubit>(context)
          .publishInnovations(snapshot2.innovation, coin);
      panelController.close();
    }
  }

  buildPost(Innovation innovation, context) {
    return Container(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xffffffff)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TeacherProfileAvatar(
                    imageUrl: innovation.submittedBy.profileImage,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${innovation.submittedBy != null ? innovation.submittedBy.name : ""} (Student)",
                        style: const TextStyle(
                            color: const Color(0xff828282),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      ),
                      Text(
                        '${DateFormat("DD MMM").format(innovation.createdBy)}',
                        style: const TextStyle(
                            color: const Color(0xff828282),
                            fontWeight: FontWeight.w400,
                            fontSize: 11.0),
                      )
                    ],
                  )
                ],
              ),
              innovation.categoryList.isNotEmpty
                  ? getCategoryType(innovation.categoryList[0])
                  : Container()
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text("${innovation.title}",
              style: const TextStyle(
                  color: const Color(0xff000000),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
          Text("${innovation.about}",
              style: const TextStyle(
                  color: const Color(0xff828282),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 11.0),
              textAlign: TextAlign.left),
          Text("${innovation.tags.join(' ')}",
              style: const TextStyle(
                  color: const Color(0xff828282),
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                  fontStyle: FontStyle.normal,
                  fontSize: 11.0),
              textAlign: TextAlign.left),
          SizedBox(
            height: 16,
          ),
          Container(
            height: 350,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (innovation.files[index].endsWith('mp4')) {
                  // return FutureBuilder<Uint8List>(
                  //   future: VideoThumbnail.thumbnailData(
                  //       video: innovation.files[index]),
                  //   builder: (BuildContext context, AsyncSnapshot imageSnap) {
                  //     return Container(
                  //       alignment: Alignment.center,
                  //       child: Center(
                  //         child: Icon(
                  //           Icons.play_arrow_rounded,
                  //           size: 30,
                  //           color: Theme.of(context).primaryColor,
                  //         ),
                  //       ),
                  //       decoration: BoxDecoration(
                  //         image: DecorationImage(
                  //           image: MemoryImage(imageSnap.data),
                  //           fit: BoxFit.cover,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                  return Container(
                    height: 300,
                    child: Chewie(
                      controller: ChewieController(
                        videoPlayerController: VideoPlayerController.network(
                            '${innovation.files[index]}'),
                        autoPlay: false,
                        looping: true,
                        autoInitialize: true,
                      ),
                    ),
                  );
                }
                return CachedImage(
                    imageUrl: '${innovation.files[index]}', height: 300);
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  LikeButton(
                    size: 16,
                    circleColor: CircleColor(
                        start: Color(0xffFF5A79).withOpacity(0.1),
                        end: Color(0xffFF5A79)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xffFF5A79).withOpacity(0.1),
                      dotSecondaryColor: Color(0xffFF5A79),
                    ),
                    likeBuilder: (bool isLiked) {
                      return SvgPicture.asset(
                        "assets/svg/likes.svg",
                        height: 30,
                        width: 30,
                        color: isLiked ? Color(0xffFF5A79) : Colors.grey,
                      );
                    },
                    isLiked: innovation.liked,
                    onTap: (isLiked) async {
                      innovation.liked = isLiked;

                      /// send your request here
                      final bool success = true;
                      if (isLiked) {
                        innovation.like -= 1;
                        BlocProvider.of<InnovationCubit>(context)
                            .dislikeInnovation(innovation.id);
                      } else {
                        innovation.like += 1;
                        BlocProvider.of<InnovationCubit>(context)
                            .likeInnovation(innovation.id);
                      }
                      // return;
                      // /// if failed, you can do nothing
                      return success ? !isLiked : isLiked;
                    },
                    likeCount: innovation.like,
                    countBuilder: (int count, bool isLiked, String text) {
                      var color = isLiked ? Color(0xffff5a79) : Colors.grey;
                      Widget result;
                      if (count == 0) {
                        result = Text(
                          "like",
                          style: TextStyle(color: color),
                        );
                      } else
                        result = Text(
                          text,
                          style: TextStyle(color: color),
                        );
                      return result;
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/views.svg",
                        height: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(innovation.view.toString())
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/images/points.png",
                    height: 20,
                  ),
                  Text('${innovation.coin ?? 1}'),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
class CategoryBadge extends StatelessWidget {
  const CategoryBadge({
    Key key,
    @required this.currentCategory,
    this.imageUrl,
    this.color,
    this.bgColor,
    this.title,
    @required this.onTap,
    @required this.onDoubleTap,
  }) : super(key: key);

  final String currentCategory;
  final String imageUrl;
  final Color color;
  final Color bgColor;
  final String title;
  final Function(String category) onTap;
  final Function(String category) onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(title);
      },
      onDoubleTap: () {
        onDoubleTap(title);
      },
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            padding: EdgeInsets.all(15),
            child: SvgPicture.asset(imageUrl),
            decoration: new BoxDecoration(
              color: color,
              border: Border.all(
                width: 1,
                color: currentCategory == title
                    ? Colors.black
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: bgColor,
                  offset: Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0,
                )
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            title,
            style: TextStyle(
              color: Color(0xff000000),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
getCategoryType(String category) {
  switch (category) {
    case "Home":
      return Container(
          width: 54,
          height: 54,
          padding: EdgeInsets.all(15),
          child: SvgPicture.asset("assets/svg/in-home.svg"),
          decoration: new BoxDecoration(
            color: Color(0xff2cb9b0),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                  color: Color(0x7f2cb9b0),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0)
            ],
          ));
      break;
    case "School":
      return Container(
          width: 54,
          height: 54,
          padding: EdgeInsets.all(15),
          child: SvgPicture.asset("assets/svg/in-school.svg"),
          decoration: new BoxDecoration(
            color: Color(0xff47a6ff),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                  color: Color(0x7f47a6ff),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0)
            ],
          ));
      break;

    case "Community":
      return Container(
          width: 54,
          height: 54,
          padding: EdgeInsets.all(15),
          child: SvgPicture.asset("assets/svg/in-community.svg"),
          decoration: new BoxDecoration(
            color: Color(0xffc396ff),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                  color: Color(0x7fc396ff),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0)
            ],
          ));
      break;

    case "Hobbies":
      return Container(
          width: 54,
          height: 54,
          padding: EdgeInsets.all(15),
          child: SvgPicture.asset("assets/svg/in-hobbies.svg"),
          decoration: new BoxDecoration(
            color: Color(0xfff0a35d),
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                  color: Color(0x7ff0a35d),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                  spreadRadius: 0)
            ],
          ));
      break;
  }
}