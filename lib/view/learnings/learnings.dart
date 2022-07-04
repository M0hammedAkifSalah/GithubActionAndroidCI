import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/export.dart';
import '/model/class-schedule.dart';
import '/view/learnings/learning_subject.dart';

class LearningsPage extends StatefulWidget {
  @override
  _LearningsPageState createState() => _LearningsPageState();
}

class _LearningsPageState extends State<LearningsPage> {
  SchoolClassDetails currentClass;
  bool initial;
  bool loading = false;
  String currentLoading = '';
  LearningChapterStates chapters;
  TextEditingController textEditingController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    initial = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
          actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.close,
          //     color: Colors.black,
          //   ),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
            title: Text(
              'Learnings',
              style: buildTextStyle(
                size: 14,
                weight: FontWeight.w500,
              ),
            ),
      ),
      body: BlocBuilder<RecentFilesCubit, RecentFileStates>(
          builder: (context, recentState) {
        return BlocBuilder<LearningDetailsCubit, LearningStates>(
          builder: (context, state2) {
            var iconArrow = Icon(
              Icons.arrow_forward,
              color: Color(0xffFFC30A),
            );
            var indicator = CupertinoActivityIndicator();
            return SafeArea(
               child:
                   GestureDetector(
                     onTap: () {
                       FocusScope.of(context).unfocus();
                     },
                     child: Container(
                       color: Colors.white,
                        height: MediaQuery.of(context).size.height,
                       padding: EdgeInsets.all(20),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisSize: MainAxisSize.max,
                         children: [
                           TextField(
                             controller: textEditingController,
                             expands: false,
                             onChanged: (value) {

                               setState(() {});
                             },
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
                             height: 10,
                           ),
                           Row(
                             mainAxisAlignment:
                             MainAxisAlignment.spaceBetween,
                             children: [
                               Text(
                                 'Class',
                                 style: buildTextStyle(size: 18),
                               ),
                               BlocBuilder<ClassDetailsCubit,
                                   ClassDetailsState>(
                                   builder: (context, state) {

                                     return PopUpMenuWidget(
                                       onSelected: (value) {
                                         initial = false;

                                         BlocProvider.of<LearningDetailsCubit>(
                                             context,
                                             listen: false)
                                             .getSubjectDetails(classId: value)
                                             .then((value) {
                                         });
                                         BlocProvider.of<RecentFilesCubit>(
                                             context,
                                             listen: false)
                                             .getRecentFiles(value);
                                         if (state is ClassDetailsLoaded) {
                                           currentClass = state.classDetails
                                               .firstWhere((learn) =>
                                           learn.classId == value);
                                           setState(() {});
                                         }
                                       },
                                       children: (context) {
                                         if (state is ClassDetailsLoaded) {

                                           return [
                                             for (var i in state.classDetails)
                                               PopupMenuItem(
                                                 value: i.classId,
                                                 child: Container(
                                                   padding: EdgeInsets.symmetric(
                                                       horizontal: 15,
                                                       vertical: 10),
                                                   child: Text(i.className),
                                                 ),
                                               ),
                                           ];
                                         }
                                         return [];
                                       },

                                       child: Container(
                                         padding:
                                         EdgeInsets.symmetric(horizontal: 8),
                                         height: 30,
                                         width: 100,
                                         child: Row(
                                           mainAxisAlignment:
                                           MainAxisAlignment.spaceBetween,
                                           children: [
                                             Text(
                                                 currentClass != null
                                                     ? currentClass.className
                                                     : 'Class'),
                                             Icon(Icons.expand_more),
                                           ],
                                         ),
                                         decoration: BoxDecoration(
                                           border:
                                           Border.all(color: Colors.black12),
                                           borderRadius:
                                           BorderRadius.circular(2),
                                         ),
                                       ),
                                     );
                                   })
                             ],
                           ),
                           Text(
                             'Subjects',
                             style: buildTextStyle(
                               size: 20,
                               weight: FontWeight.w600,
                             ),
                             textAlign: TextAlign.start,
                           ),

                           Container(

                             padding:
                             EdgeInsets.symmetric(vertical: 10,),
                             margin: EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context).size.height * 0.65,
                             child: SingleChildScrollView(
                               physics: BouncingScrollPhysics(),

                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [


                                   initial ? Center(
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Text('Please Select Class',
                                         style: buildTextStyle(),),
                                     ),
                                   ) : Container(),
                                   if (state2 is LearningSubjectLoaded)
                                     ListView.builder(
                                         physics: BouncingScrollPhysics(),
                                         shrinkWrap: true,
                                         itemCount: state2.subjectLearning.length,
                                         itemBuilder: (context, index) {
                                           var i = state2.subjectLearning[index];
                                           if (!i.name.toLowerCase().contains(
                                               textEditingController.text
                                                   .toLowerCase())) {
                                             return Container();
                                           }
                                           return  ListTile(
                                             onTap: () async {
                                               currentLoading = i.name;
                                               setState(() {
                                                 loading = true;
                                               });
                                               chapters = await BlocProvider.of<
                                                   LearningChapterCubit>(context)
                                                   .loadChapters(i.id);

                                               if (chapters is LearningChapterLoaded)
                                                 Navigator.of(context)
                                                     .push(
                                                   createRoute(
                                                     pageWidget: LearningSubjectPage(
                                                       subject: i,
                                                       chapters: chapters,
                                                       className: currentClass,
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
                                               i.name,
                                               style: buildTextStyle(
                                                 size: 15,
                                                 weight: FontWeight.w400,
                                               ),
                                             ),
                                             trailing: loading
                                                 ? currentLoading == i.name
                                                 ? indicator
                                                 : iconArrow
                                                 : iconArrow,
                                             subtitle: Text(
                                               '${i.repository[0].chapterCount} Chapter',
                                               style: buildTextStyle(
                                                 size: 12,
                                                 color: Colors.grey[400],
                                               ),
                                             ),
                                           );
                                         }),
                                   if (state2 is LearningSubjectLoading && !initial)
                                     Center(
                                       child: Padding(
                                         padding: const EdgeInsets.only(top: 100),
                                         child: CupertinoActivityIndicator(
                                           animating: true,
                                           radius: 15,
                                         ),
                                       ),
                                     ),
                                   if (state2 is LearningSubjectEmpty && !initial)
                                     Center(
                                       child: Padding(
                                         padding: const EdgeInsets.only(top: 100),
                                         child: Text(
                                           'No Data Available',
                                           style: buildTextStyle(),
                                         ),
                                       ),
                                     ),


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
                         ],
                       ),

               ),
                   )
              // CustomScrollView(
              //   slivers: [
              //     SliverAppBar(
              //       pinned: true,
              //       floating: true,
              //       centerTitle: true,
              //       // toolbarHeight: 400,
              //       expandedHeight: MediaQuery.of(context).size.height - 10,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.only(
              //           bottomLeft: Radius.circular(15),
              //           bottomRight: Radius.circular(15),
              //         ),
              //       ),
              //       flexibleSpace: FlexibleSpaceBar(
              //         background:

                   // ),
                    // automaticallyImplyLeading: false,
                    // backgroundColor: Colors.white,
                    // // bottom: PreferredSize(
                    // //   preferredSize: Size(double.infinity, 100),
                    // //   child: Container(
                    // //     height: 100,
                    // //     color: Colors.red,
                    // //   ),
                    // // ),
                    // actions: [
                    //   IconButton(
                    //     icon: Icon(
                    //       Icons.close,
                    //       color: Colors.black,
                    //     ),
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //   ),
                    // ],
                //     title: Text(
                //       'Learnings',
                //       style: buildTextStyle(
                //         size: 14,
                //         weight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                //   if (recentState is RecentFileLoaded)
                //     SliverGrid(
                //       delegate: SliverChildBuilderDelegate(
                //         (context, index) => Container(
                //           height: 100,
                //           child: InkWell(
                //             onTap: () {
                //               BlocProvider.of<ActivityCubit>(context,
                //                       listen: false)
                //                   .openFile(recentState.files[index].file);
                //             },
                //             child: checkWidget(recentState.files[index].file),
                //           ),
                //         ),
                //         childCount: recentState.files.length,
                //       ),
                //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         crossAxisSpacing: 7,
                //         mainAxisSpacing: 10,
                //       ),
                //     )
                // ],
             // ),
            );
          },
        );
      }),
    );
  }

  List<LearningFiles> getAllFiles(List<Learnings> learnings) {
    List<LearningFiles> files = [];
    learnings.forEach((learning) {
      files.addAll(learning.filesUpload);
    });
    return files;
  }

  Widget checkWidget(String fileName) {
    if (fileName.endsWith('jpg') ||
        fileName.endsWith('jpeg') ||
        fileName.endsWith('png'))
      return CachedNetworkImage(
        imageUrl: '$fileName',
        errorWidget: (context, url, error) {
          return Container(
            color: Colors.grey,
            alignment: Alignment.center,
            child: Text('Error'),
          );
        },
      );
    else
      return Container(
        padding: EdgeInsets.all(3),
        color: Theme.of(context).primaryColor,
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              checkIcon(
                fileName.substring(fileName.length - 3),
              ),
            ),
            LimitedBox(
              maxHeight: 20,
              child: Text(
                fileName,
                softWrap: true,
              ),
            ),
          ],
        ),
      );
  }
}
