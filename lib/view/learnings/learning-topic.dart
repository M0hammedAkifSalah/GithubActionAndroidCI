import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import '/export.dart';
import '/model/class-schedule.dart';
import '/view/learnings/learning_subject.dart';

class LearningTopicPage extends StatefulWidget {
  final SchoolClassDetails className;
  final Learnings learning;
  final Learnings subject;
  final Learnings chapter;
  LearningTopicPage({
    this.className,
    this.learning,
    @required this.chapter,
    @required this.subject,
  });
  @override
  _LearningChaptersPageState createState() => _LearningChaptersPageState();
}

class _LearningChaptersPageState extends State<LearningTopicPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;
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
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: BlocProvider(
                      create: (context) => LearningDetailsCubit(),
                      child: AddNewLearningPage(
                        widget.className,
                        true,
                        chapter: widget.chapter,
                        subject: widget.subject,
                        topic: widget.learning,
                      ),
                    ),
                  ),
                );
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
          if (snapshot.forTopic) {
            widget.learning.filesUpload.addAll(snapshot.newFiles);
          }
        }
        return SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  centerTitle: true,
                  // toolbarHeight: 400,
                  expandedHeight:
                      (widget.learning.description.length / 2 + 180).toDouble(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      margin: EdgeInsets.only(top: kToolbarHeight),
                      // height: 180,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TextField(
                            //   expands: false,
                            //   decoration: InputDecoration(
                            //     hintText: 'Search file by title or type',
                            //     fillColor: Color(0xffF1F5FB),
                            //     filled: true,
                            //     border: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(50),
                            //       borderSide: BorderSide.none,
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            Text(
                              widget.learning.name,
                              style: buildTextStyle(
                                size: 20,
                                weight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Linkify(text: removeTags(widget.learning.description),
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
                            ),
                            SizedBox(height: 30),
                            // ListTile(
                            //   onTap: () {
                            //     // Navigator.of(context).push(
                            //     //   createRoute(
                            //     //     pageWidget: LearningTopicsPage(
                            //     //       widget.response,
                            //     //       widget.learning,
                            //     //       widget.className,
                            //     //     ),
                            //     //   ),
                            //     // );
                            //   },
                            //   title: Text(
                            //     widget.learning.chapter.name,
                            //     style: buildTextStyle(
                            //       size: 15,
                            //       weight: FontWeight.w400,
                            //     ),
                            //   ),
                            //   trailing: Icon(
                            //     Icons.arrow_forward,
                            //     color: Color(0xffFFC30A),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 30,
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
                    'Topics',
                    
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
                        child: Container(
                          height: 30,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      Tab(
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
                      Tab(
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
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _controller,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridBuilder(
                    topic: true,
                    topicId: widget.learning.id,
                    images: true,
                    files: widget.learning.filesUpload.where((file) {
                      if (file.file == null) return false;
                      return file.file.substring(file.file.length - 3) ==
                              "png" ||
                          file.file.substring(file.file.length - 3) == "jpg" ||
                          file.file.substring(file.file.length - 4) == "jpeg";
                    }).toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridBuilder(
                    topic: true,
                    topicId: widget.learning.id,
                    files: widget.learning.filesUpload.where((file) {
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: GridBuilder(
                    topic: true,
                    topicId: widget.learning.id,
                    files: widget.learning.filesUpload.where((file) {
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

// class GridBuilder extends StatelessWidget {
//   const GridBuilder({
//     this.files,
//     this.images = false,
//   });
//   final List<LearningFiles> files;
//   final bool images;
//   @override
//   Widget build(BuildContext context) {
//     if (files.isEmpty)
//       return Center(
//         child: Text(
//           'No Files',
//           style: buildTextStyle(),
//         ),
//       );
//     return GridView.builder(
//       itemCount: files.length,
//       itemBuilder: (BuildContext context, int index) {
//         if (images)
//           return InkWell(
//             onTap: () {
//               BlocProvider.of<ActivityCubit>(context, listen: false)
//                   .openFile(files[index].url);
//             },
//             child: Container(
//               alignment: Alignment.center,
//               width: double.infinity,
//               height: 100.0,
//               child: CachedNetworkImage(
//                 imageUrl:
//                     '${GlobalConfiguration().get('fileURL')}/${files[index].url}',
//                 fit: BoxFit.cover,
//                 errorWidget: (context, url, error) {
//                   return Container(
//                     color: Colors.grey,
//                     alignment: Alignment.center,
//                     child: Text(
//                       'Error',
//                       style: buildTextStyle(),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         else
//           return InkWell(
//             onTap: () {
//               BlocProvider.of<ActivityCubit>(context, listen: false)
//                   .openFile(files[index].url);
//             },
//             child: Container(
//               padding: EdgeInsets.all(3),
//               color: Theme.of(context).primaryColor,
//               height: 100,
//               alignment: Alignment.center,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Icon(
//                     checkIcon(
//                       files[index].url.substring(files[index].url.length - 3),
//                     ),
//                   ),
//                   Text(files[index].name),
//                 ],
//               ),
//             ),
//           );
//       },
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         mainAxisSpacing: 15,
//         crossAxisSpacing: 15,
//       ),
//     );
//   }
// }
