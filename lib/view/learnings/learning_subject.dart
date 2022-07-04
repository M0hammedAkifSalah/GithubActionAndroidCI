import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/model/class-schedule.dart';
import '/view/learnings/learning-files.dart';
import '/view/pdf-viewer.dart';
import '../../export.dart';

class LearningSubjectPage extends StatefulWidget {
  // final LearningDetailsResponse response;
  final LearningChapterLoaded chapters;
  final SchoolClassDetails className;
  final Learnings subject;

  LearningSubjectPage({
    this.className,
    this.subject,
    this.chapters,
  });

  @override
  _LearningChaptersPageState createState() => _LearningChaptersPageState();
}

class _LearningChaptersPageState extends State<LearningSubjectPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController textEditingController = TextEditingController();
  bool loading = false;
  String currentLoading = '';
  LearningTopicLoaded topics;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        // backgroundColor: Colors.white,
        // automaticallyImplyLeading: false,
        title: Text(
          widget.subject.name,
          style: buildTextStyle(
            size: 14,
            weight: FontWeight.w500,
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //   height: 0,
      //   child: Column(
      //     children: [
      //       Row(
      //         children: [
      //           Spacer(),
      //           // FlatButton(
      //           //   child: Text(
      //           //     'Attach Files',
      //           //     style: buildTextStyle(size: 14, color: Colors.blue),
      //           //   ),
      //           //   onPressed: () {},
      //           // ),
      //         ],
      //       ),
      //       SizedBox(
      //         height: 10,
      //       )
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // margin: EdgeInsets.only(top: kToolbarHeight, bottom: 40),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: textEditingController,
                    expands: false,
                    decoration: InputDecoration(
                      hintText: 'Search file by title or type',
                      fillColor: Color(0xffF1F5FB),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Chapters',
                    style: buildTextStyle(
                      size: 20,
                      weight: FontWeight.w600,
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.chapters.chapterLearning.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var chapter =
                        widget.chapters.chapterLearning[index];
                        // if (index == widget.learning.length) {
                        //   return ListTile();
                        // }
                        var iconArrow = Icon(
                          Icons.arrow_forward,
                          color: Color(0xffFFC30A),
                        );
                        var indicator = CupertinoActivityIndicator();
                        if (!chapter.name.toLowerCase().contains(
                            textEditingController.text.toLowerCase())) {
                          return Container();
                        }
                        return ListTile(
                          onTap: () async {
                            currentLoading = chapter.name;
                            setState(() {
                              loading = true;
                            });
                            BlocProvider.of<NewLearningFilesCubit>(
                                context)
                                .emit(NewLearningFilesLoading());
                            topics = await BlocProvider.of<
                                LearningTopicCubit>(context)
                                .loadTopics(chapter.id);
                            if (topics is LearningTopicLoaded)
                              Navigator.of(context)
                                  .push(
                                createRoute(
                                  pageWidget: LearningChapterPage(
                                    className: widget.className,
                                    files: chapter.filesUpload,
                                    subject: widget.subject,
                                    chapter: chapter,
                                    topics: topics,
                                  ),
                                ),
                              )
                                  .then((value) {
                                setState(() {
                                  loading = false;
                                });
                              });
                          },
                          title: Text(
                            chapter.name,
                            style: buildTextStyle(
                              size: 15,
                              weight: FontWeight.w400,
                            ),
                          ),
                          trailing: loading
                              ? currentLoading == chapter.name
                              ? indicator
                              : iconArrow
                              : iconArrow,
                        );
                      }),
                  // Spacer(),
                  // Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text('Swipe up to see files.'),
                  //       SizedBox(
                  //         width: 5,
                  //       ),
                  //       Icon(Icons.expand_less)
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
          ),
        ),


        // NestedScrollView(
        //   body: Container(),
        //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        //     return [
        //       SliverAppBar(
        //         pinned: true,
        //         floating: false,
        //         centerTitle: true,
        //         // toolbarHeight: 400,
        //         expandedHeight: MediaQuery.of(context).size.height * 0.985,
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.only(
        //             bottomLeft: Radius.circular(15),
        //             bottomRight: Radius.circular(15),
        //           ),
        //         ),
        //         flexibleSpace: FlexibleSpaceBar(
        //           collapseMode: CollapseMode.parallax,
        //           background: Container(
        //             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //             margin: EdgeInsets.only(top: kToolbarHeight, bottom: 40),
        //             height: 400,
        //             child: SingleChildScrollView(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   TextField(
        //                     onChanged: (value) {
        //                       setState(() {});
        //                     },
        //                     controller: textEditingController,
        //                     expands: false,
        //                     decoration: InputDecoration(
        //                       hintText: 'Search file by title or type',
        //                       fillColor: Color(0xffF1F5FB),
        //                       filled: true,
        //                       border: OutlineInputBorder(
        //                         borderRadius: BorderRadius.circular(50),
        //                         borderSide: BorderSide.none,
        //                       ),
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     height: 15,
        //                   ),
        //                   Text(
        //                     'Chapters',
        //                     style: buildTextStyle(
        //                       size: 20,
        //                       weight: FontWeight.w600,
        //                     ),
        //                   ),
        //                   ListView.builder(
        //                       physics: NeverScrollableScrollPhysics(),
        //                       itemCount: widget.chapters.chapterLearning.length,
        //                       shrinkWrap: true,
        //                       itemBuilder: (context, index) {
        //                         var chapter =
        //                             widget.chapters.chapterLearning[index];
        //                         // if (index == widget.learning.length) {
        //                         //   return ListTile();
        //                         // }
        //                         var iconArrow = Icon(
        //                           Icons.arrow_forward,
        //                           color: Color(0xffFFC30A),
        //                         );
        //                         var indicator = CupertinoActivityIndicator();
        //                         if (!chapter.name.toLowerCase().contains(
        //                             textEditingController.text.toLowerCase())) {
        //                           return Container();
        //                         }
        //                         return ListTile(
        //                           onTap: () async {
        //                             currentLoading = chapter.name;
        //                             setState(() {
        //                               loading = true;
        //                             });
        //                             BlocProvider.of<NewLearningFilesCubit>(
        //                                     context)
        //                                 .emit(NewLearningFilesLoading());
        //                             topics = await BlocProvider.of<
        //                                     LearningTopicCubit>(context)
        //                                 .loadTopics(chapter.id);
        //                             if (topics is LearningTopicLoaded)
        //                               Navigator.of(context)
        //                                   .push(
        //                                 createRoute(
        //                                   pageWidget: LearningChapterPage(
        //                                     className: widget.className,
        //                                     files: chapter.filesUpload,
        //                                     subject: widget.subject,
        //                                     chapter: chapter,
        //                                     topics: topics,
        //                                   ),
        //                                 ),
        //                               )
        //                                   .then((value) {
        //                                 setState(() {
        //                                   loading = false;
        //                                 });
        //                               });
        //                           },
        //                           title: Text(
        //                             chapter.name,
        //                             style: buildTextStyle(
        //                               size: 15,
        //                               weight: FontWeight.w400,
        //                             ),
        //                           ),
        //                           trailing: loading
        //                               ? currentLoading == chapter.name
        //                                   ? indicator
        //                                   : iconArrow
        //                               : iconArrow,
        //                         );
        //                       }),
        //                   // Spacer(),
        //                   // Center(
        //                   //   child: Row(
        //                   //     mainAxisAlignment: MainAxisAlignment.center,
        //                   //     children: [
        //                   //       Text('Swipe up to see files.'),
        //                   //       SizedBox(
        //                   //         width: 5,
        //                   //       ),
        //                   //       Icon(Icons.expand_less)
        //                   //     ],
        //                   //   ),
        //                   // ),
        //                 ],
        //               ),
        //             ),
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.only(
        //                 bottomLeft: Radius.circular(15),
        //                 bottomRight: Radius.circular(15),
        //               ),
        //             ),
        //           ),
        //         ),
        //         automaticallyImplyLeading: false,
        //         backgroundColor: Colors.white,
        //         // bottom: PreferredSize(
        //         //   preferredSize: Size(double.infinity, 100),
        //         //   child: Container(
        //         //     height: 100,
        //         //     color: Colors.red,
        //         //   ),
        //         // ),
        //         actions: [
        //           IconButton(
        //             icon: Icon(
        //               Icons.close,
        //               color: Colors.black,
        //             ),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //         title: Text(
        //           widget.subject.name,
        //           style: buildTextStyle(
        //             size: 14,
        //             weight: FontWeight.w500,
        //           ),
        //         ),
        //         // bottom: TabBar(
        //         //   indicatorPadding: EdgeInsets.all(20),
        //         //   controller: _controller,
        //         //   isScrollable: true,
        //         //   indicatorSize: TabBarIndicatorSize.tab,
        //         //   // indicatorColor: Colors.yellow,
        //         //   unselectedLabelColor: Colors.black,
        //         //   labelColor: Color(0xffFFC30A),
        //         //   tabs: [
        //         //     Tab(
        //         //       // icon: Icon(Icons.image),
        //         //       // text: 'Photos',
        //         //       child: Container(
        //         //         height: 30,
        //         //         color: Colors.white,
        //         //         child: Row(
        //         //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         //           children: [
        //         //             Icon(
        //         //               Icons.image,
        //         //               size: 18,
        //         //             ),
        //         //             SizedBox(
        //         //               width: 5,
        //         //             ),
        //         //             Text('Image')
        //         //           ],
        //         //         ),
        //         //       ),
        //         //     ),
        //         //     Tab(
        //         //       child: Container(
        //         //         height: 30,
        //         //         color: Colors.white,
        //         //         child: Row(
        //         //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         //           children: [
        //         //             Icon(
        //         //               Icons.video_library,
        //         //               size: 18,
        //         //             ),
        //         //             SizedBox(
        //         //               width: 5,
        //         //             ),
        //         //             Text('Video'),
        //         //           ],
        //         //         ),
        //         //       ),
        //         //     ),
        //         //     Tab(
        //         //       child: Container(
        //         //         height: 30,
        //         //         color: Colors.white,
        //         //         child: Row(
        //         //           mainAxisAlignment: MainAxisAlignment.spaceAround,
        //         //           children: [
        //         //             Icon(
        //         //               Icons.library_books,
        //         //               size: 18,
        //         //             ),
        //         //             SizedBox(
        //         //               width: 5,
        //         //             ),
        //         //             Text('Documents')
        //         //           ],
        //         //         ),
        //         //       ),
        //         //     ),
        //         //   ],
        //         // ),
        //       ),
        //     ];
        //   },
        // ),
      ),
    );
  }
}

class GridBuilder extends StatefulWidget {
  const GridBuilder({
    this.files,
    this.images = false,
    this.chapter = false,
    this.topic = false,
    this.chapterId = '',
    this.topicId = '',
  });

  final List<LearningFiles> files;
  final bool images;
  final bool chapter;
  final bool topic;
  final String chapterId;
  final String topicId;

  @override
  _GridBuilderState createState() => _GridBuilderState();
}

class _GridBuilderState extends State<GridBuilder> {
  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty)
      return Center(
        child: Text(
          'No Files',
          style: buildTextStyle(),
        ),
      );
    return GridView.builder(
      itemCount: widget.files.length,
      itemBuilder: (BuildContext context, int index) {
        if (widget.images)
          return InkWell(
            onTap: () {
              if (widget.chapter) {
                Navigator.of(context)
                    .push<bool>(
                  createRoute(
                      pageWidget: LearningFilesPage(
                          file: widget.files,
                          index: index,
                          chapter: widget.chapter,
                          contentId: widget.chapterId)),
                )
                    .then((value) {
                  if (value) {
                    log("delete: $value");
                    widget.files.remove(widget.files[index]);
                    setState(() {});
                  }
                });
              } else if (widget.topic) {
                Navigator.of(context)
                    .push<bool>(
                  createRoute(
                      pageWidget: LearningFilesPage(
                          file: widget.files,
                          index: index,
                          topic: widget.topic,
                          contentId: widget.topicId)),
                )
                    .then((value) {
                  log("delete: $index $value");
                  if (value) {
                    widget.files.remove(widget.files[index]);
                    setState(() {});
                  }
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 100.0,
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, progress) {
                  return CupertinoActivityIndicator();
                },
                imageUrl: '${widget.files[index].file}',
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.grey,
                    alignment: Alignment.center,
                    child: Text(
                      'Error',
                      style: buildTextStyle(),
                    ),
                  );
                },
              ),
            ),
          );
        else
          return InkWell(
            onTap: () {
              if (widget.files[index].file.endsWith('.mp4'))
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: LearningFilesPage(
                      file: widget.files,
                      index: index,
                      video: true,
                    ),
                  ),
                );
              else if (widget.files[index].file.endsWith('.pdf')) {
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: PdfViewerPage(url: widget.files[index].file),
                  ),
                );
              } else
                BlocProvider.of<ActivityCubit>(context, listen: false)
                    .openFile(widget.files[index].file);
            },
            child: Container(
              padding: EdgeInsets.all(3),
              color: Theme.of(context).primaryColor,
              height: 100,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    checkIcon(
                      widget.files[index].file
                          .substring(widget.files[index].file.length - 3),
                    ),
                  ),
                  Text(widget.files[index].fileName),
                ],
              ),
            ),
          );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
    );
  }
}
