import 'dart:async';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
// import 'package:growon/bloc/innovation/innovation-cubit.dart';
// import 'package:growon/model/innovation.dart';
// import 'package:like_button/like_button.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '/bloc/innovations/innovations-cubit.dart';
import '/export.dart';
import '/model/innovations.dart';
import '/view/innovations/innovations.dart';

class InnovationListing extends StatefulWidget {
  final List<Innovation> innovations;
  final ScrollController scrollController;

  // final List<Innovation> youInnovations;
  // final List<Innovation> otherInnovations;
  // final String category;

  InnovationListing({
    this.innovations,
    this.scrollController,
    // this.category,
    // this.youInnovations,
  });

  @override
  _InnovationListingState createState() => _InnovationListingState();
}

class _InnovationListingState extends State<InnovationListing> {
  ChewieController chewieController;

  VideoPlayerController videoPlayerController(String url) {
    return VideoPlayerController.network(url);
  }

  @override
  void dispose() {
    if (chewieController != null) {
      chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //   return category == "all"

    return ListView.builder(
      controller: widget.scrollController ?? ScrollController(),
      padding: EdgeInsets.only(bottom: 80),
      physics: BouncingScrollPhysics(),
      itemCount: widget.innovations.length,
      itemBuilder: (BuildContext context, int index) => Container(
        child: buildPost(widget.innovations[index], context),
      ),
    );
    //       : category == "you"
    //           ? ListView.builder(
    //               padding: EdgeInsets.only(bottom: 80),
    //               physics: BouncingScrollPhysics(),
    //               itemCount: youInnovations.length,
    //               itemBuilder: (BuildContext context, int index) =>
    //                   buildPost(youInnovations[index], context))
    //           : ListView.builder(
    //               padding: EdgeInsets.only(bottom: 80),
    //               physics: BouncingScrollPhysics(),
    //               itemCount: otherInnovations.length,
    //               itemBuilder: (BuildContext context, int index) =>
    //                   buildPost(otherInnovations[index], context));
  }

  buildPost(Innovation innovation, context) {
    return InkWell(
      onTap: () {
        panelController.open();
        BlocProvider.of<CurrentInnovationCubit>(context, listen: false)
            .loadCurrentInnovation(innovation, true);
        // if(innovation.)
        BlocProvider.of<InnovationCubit>(context, listen: false)
            .addViewInnovation(innovation);
      },
      child: Container(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  spreadRadius: 0)
            ],
            color: const Color(0xffffffff)),
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
                          '${DateFormat("dd MMM").format(innovation.createdBy)}',
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
              height: 10,
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
              height: 5,
            ),
            Container(
              color: Colors.grey[200],
              width: double.infinity,
              child: (innovation.files[0].endsWith('mp4'))
                  ? FutureBuilder<Uint8List>(
                      future: VideoThumbnail.thumbnailData(
                          video: innovation.files[0]),
                      builder: (BuildContext context, AsyncSnapshot imageSnap) {
                        if (imageSnap.data == null)
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        return Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 100,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imageSnap.data),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    )
                  : CachedImage(
                      imageUrl: '${innovation.files[0]}', height: 300),
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
          decoration:  BoxDecoration(
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
          decoration:  BoxDecoration(
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
          decoration:  BoxDecoration(
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
          decoration:  BoxDecoration(
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

class InnovationSubmittedListing extends StatelessWidget {
  final List<Innovation> youInnovations;
  final PanelController panelController;
  final StreamController streamController;
  final StreamController innovationController;
  final ScrollController scrollController;

  InnovationSubmittedListing({
    this.youInnovations,
    this.scrollController,
    this.panelController,
    this.streamController,
    this.innovationController,
  });
  buildPost(Innovation innovation, context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<CurrentInnovationCubit>(context, listen: false)
            .loadCurrentInnovation(innovation, true);
        BlocProvider.of<InnovationCubit>(context, listen: false)
            .addViewInnovation(innovation);
        panelController.open();
      },
      child: Container(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  spreadRadius: 0)
            ],
            color: const Color(0xffffffff)),
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
                          '${DateFormat("dd MMM").format(innovation.createdBy)}',
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
              width: double.infinity,
              color: Colors.grey[200],
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  if (innovation.files[index].endsWith('mp4')) {
                    print('${GlobalConfiguration().get('videoURL')}/' +
                        innovation.files[index]);
                    return FutureBuilder<Uint8List>(
                      future: VideoThumbnail.thumbnailData(
                          video: innovation.files[index]),
                      builder: (BuildContext context, AsyncSnapshot imageSnap) {
                        if (imageSnap.data == null)
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        return Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: Center(
                            child: Icon(
                              Icons.play_arrow_rounded,
                              size: 100,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imageSnap.data),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                    return Chewie(
                      controller: ChewieController(
                        videoPlayerController: VideoPlayerController.network(
                          '${GlobalConfiguration().get('videoURL')}/' +
                              innovation.files[index],
                        ),
                        autoPlay: false,
                        looping: false,
                        autoInitialize: true,
                        errorBuilder: (context, errorMessage) {
                          return Container(
                            child: Text(
                              errorMessage,
                            ),
                          );
                        },
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   alignment: Alignment.center,
                //   width: 113.47404479980469,
                //   height: 17.778032302856445,
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.all(Radius.circular(20)),
                //       color: const Color(0xffc4c4c4)),
                //   child: Text(
                //     "Pending Approval",
                //     style: const TextStyle(
                //         color: const Color(0xffffffff),
                //         fontWeight: FontWeight.w400,
                //         fontSize: 11.0),
                //   ),
                // )
                PopUpMenuWidget(
                  children: (context) {
                    return [
                      PopupMenuItem<String>(
                        height: 50,
                        value: 'Publish',
                        child: Container(
                          // width: 20,
                          child: Text(
                            'Publish',
                            style: buildTextStyle(size: 15),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        height: 30,
                        value: 'Don\'t Publish',
                        child: Container(
                          // width: 20,
                          child: Text(
                            'Don\'t Publish',
                            style: buildTextStyle(size: 15),
                          ),
                        ),
                      )
                    ];
                  },
                  onSelected: (value) {
                    innovationController.add(innovation);
                    // print(innovation.about);
                    streamController.add(value);
                    BlocProvider.of<CurrentInnovationCubit>(context)
                        .loadCurrentInnovation(innovation, false);
                    panelController.open();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: BouncingScrollPhysics(),
      itemCount: youInnovations.length,
      itemBuilder: (BuildContext context, int index) => true
          ? buildPost(
              youInnovations[index],
              context,
            )
          : Container(),
    );
  }
}
