import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '/export.dart';
import '/model/class-schedule.dart';
import '/view/learnings/learning-topic.dart';
import '/view/learnings/learning_subject.dart';

class LearningChapterPage extends StatefulWidget {
  final SchoolClassDetails className;
  final LearningTopicLoaded topics;
  final List<LearningFiles> files;
  final Learnings chapter;
  final Learnings subject;
  // final LearningDetailsResponse response;
  LearningChapterPage({
    @required this.className,
    @required this.topics,
    @required this.subject,
    @required this.files,
    this.chapter,
  });
  @override
  _LearningTopicsPageState createState() => _LearningTopicsPageState();
}

class _LearningTopicsPageState extends State<LearningChapterPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  TextEditingController textEditingController = TextEditingController();
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
      bottomNavigationBar: Container(
        height: 80,
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                // FlatButton(
                //   child: Text(
                //     'Attach Files',
                //     style: buildTextStyle(size: 14, color: Colors.blue),
                //   ),
                //   onPressed: () {},
                // ),
              ],
            ),
            CustomRaisedButton(
              title: 'Add Files',
              icon: Icons.add,
              onPressed: () async {
                var state = await Navigator.of(context).push(
                  createRoute(
                    pageWidget: BlocProvider(
                      create: (context) => LearningDetailsCubit(),
                      child: AddNewLearningPage(
                        widget.className,
                        true,
                        chapter: widget.chapter,
                        subject: widget.subject,
                        topic: null,
                      ),
                    ),
                  ),
                );
                setState(() {});
              },
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      body: BlocBuilder<NewLearningFilesCubit, NewLearningFilesStates>(
          builder: (context, snapshot) {
        if (snapshot is NewLearningFilesLoaded) {
          if (!snapshot.forTopic) widget.files.addAll(snapshot.newFiles);
        }
        return SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  centerTitle: true,
                  // toolbarHeight: 400
                  expandedHeight: MediaQuery.of(context).size.height * 0.9,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  snap: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        margin: EdgeInsets.only(top: kToolbarHeight, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextField(
                              controller: textEditingController,
                              onChanged: (value) {
                                setState(() {});
                              },
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
                            Container(
                              child: Linkify(text: removeTags(widget.chapter.description),
                                onOpen: (link) async {
                                  // if (await canLaunchUrl(Uri(path: link.url))) {
                                    await launchUrl(Uri.parse(link.url),mode: LaunchMode.externalApplication);
                                  // } else {
                                  //   throw 'Could not launch $link';
                                  // }
                                },
                                options: LinkifyOptions(
                                  defaultToHttps: true,
                                  humanize: true,
                                  looseUrl: true,
                                ),

                              ),
                              // Html(
                              //   data: widget.chapter.description,
                              // ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Topics',
                              style: buildTextStyle(
                                size: 20,
                                weight: FontWeight.w600,
                              ),
                            ),
                            ListView.builder(
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.topics.topicLearning.length + 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (widget.topics.topicLearning.length ==
                                      index) {
                                    return SizedBox(
                                      height: 0,
                                    );
                                  }
                                  var topic = widget.topics.topicLearning[index];
                                  if (!topic.name.toLowerCase().contains(
                                      textEditingController.text.toLowerCase())) {
                                    return Container();
                                  }
                                  return ListTile(
                                    onTap: () {
                                      BlocProvider.of<NewLearningFilesCubit>(
                                              context)
                                          .emit(NewLearningFilesLoading());
                                      Navigator.of(context).push(
                                        createRoute(
                                            pageWidget: LearningTopicPage(
                                          className: widget.className,
                                          learning: topic,
                                          chapter: widget.chapter,
                                          subject: widget.subject,
                                        )),
                                      );
                                    },
                                    title: Text(
                                      topic.name,
                                      style: buildTextStyle(
                                        size: 15,
                                        weight: FontWeight.w400,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xffFFC30A),
                                    ),
                                  );
                                }),
                            // SizedBox(
                            //   height: 30,
                            // ),
                            Spacer(),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Swipe up to see files'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.expand_less)
                                  ],
                                ),
                              ),
                            )
                          ],
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
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  // bottom: PreferredSize(
                  //   preferredSize: Size(double.infinity, 100),
                  //   child: Container(
                  //     height: 100,
                  //     color: Colors.red,
                  //   ),
                  // ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  title: Text(
                    widget.chapter.name,
                    style: buildTextStyle(
                      size: 14,
                      weight: FontWeight.w500,
                    ),
                  ),
                  bottom: TabBar(
                    indicatorPadding: EdgeInsets.all(20),
                    controller: _controller,
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    // indicatorColor: Colors.yellow,
                    unselectedLabelColor: Colors.black,

                    labelColor: Color(0xffFFC30A),
                    tabs: [
                      Tab(
                        // icon: Icon(Icons.image),
                        // text: 'Photos',
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(
                            height: 30,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Image')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(
                            height: 30,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.video_library,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Video'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(
                            height: 30,
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.library_books,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Documents')
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _controller,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridBuilder(
                    chapter: true,
                    chapterId: widget.chapter.id,
                    images: true,
                    files: widget.files.where((file) {
                      if (file.file == null) return false;
                      return file.file.substring(file.file.length - 3) ==
                              "png" ||
                          file.file.substring(file.file.length - 3) == "jpg" ||
                          file.file.substring(file.file.length - 4) == "jpeg";
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridBuilder(
                    chapter: true,
                    chapterId: widget.chapter.id,
                    files: widget.files.where((file) {
                      if (file.file == null) return false;
                      return file.file.substring(file.file.length - 3) ==
                              "mp4" ||
                          file.file.substring(file.file.length - 3) == "wav" ||
                          file.file.substring(file.file.length - 3) == "avi" ||
                          file.file.substring(file.file.length - 3) == "mov" ||
                          file.file.substring(file.file.length - 3) == "mp3";
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridBuilder(
                    chapter: true,
                    chapterId: widget.chapter.id,
                    files: widget.files.where((file) {
                      if (file.file == null) return false;
                      return file.file.substring(file.file.length - 3) ==
                              "pdf" ||
                          file.file.substring(file.file.length - 4) == "docx" ||
                          file.file.substring(file.file.length - 3) == "doc" ||
                          file.file.substring(file.file.length - 3) == "csv" ||
                          file.file.substring(file.file.length - 3) == "xls" ||
                          file.file.substring(file.file.length - 4) == "xlsx";
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }


}
