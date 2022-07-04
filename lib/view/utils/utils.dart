import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/src/cancel_token.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:growonplus_teacher/app-config.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:open_file/open_file.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../attached_files_and_url_slider.dart';
import '../file_attached_slider.dart';
import '../file_viewer.dart';
import '/export.dart';
import '/model/class-schedule.dart';
import '/view/learnings/learning-files.dart';

class CachedImage extends StatefulWidget {
  const CachedImage({
    @required this.imageUrl,
    this.height,
    this.width,
  });

  final String imageUrl;
  final double height;
  final double width;

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 25,
        child: CupertinoActivityIndicator(),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 25,
      ),
      imageUrl: widget.imageUrl,
      height: widget.height,
      width: widget.width,
      fit: BoxFit.cover,
    );
  }
}

LinearPercentIndicator buildLinearPercentBar({
  double percent = 0.6,
  double lineHeight,
  Color color,
  String text,
  Widget trailing,
  Widget leading,
}) {
  if (percent == null) percent = 0.6;
  return LinearPercentIndicator(
    // linearStrokeCap: LinearStrokeCap.roundAll,
    barRadius: Radius.circular(8),
    //  width: MediaQuery.of(context).size.width - 50,
    animation: true,
    leading: leading,
    trailing: trailing,
    lineHeight: lineHeight ?? 20.0,
    animationDuration: 2500,
    percent: percent > 1 ? 0 : percent ?? 0.6,
    alignment: MainAxisAlignment.start,
    center: Text(
      text ??
          '${percent == null ? '70' : (percent * 100).toStringAsFixed(2)} %',
      style: TextStyle(
        color: percent <= 0.5 ? Colors.black : Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: 11.0,
      ),
    ),

    progressColor: color ?? Color(0xff6FCF97),
    backgroundColor: color == null
        ? Color(0xff6FCF97).withOpacity(0.2)
        : color.withOpacity(0.2),
  );
}

IconData checkIcon(String ext) {
  switch (ext) {
    case "png":
    case "jpg":
    case "jpeg":
      return FontAwesomeIcons.image;
    case "pdf":
      return FontAwesomeIcons.solidFilePdf;
    case "mp4":
      return FontAwesomeIcons.video;
    case "mp3":
      return FontAwesomeIcons.music;
    default:
      return FontAwesomeIcons.file;
  }
}

Container dropdownMenu(String title, {IconData icon}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: Colors.grey[500],
        ),
      ),
    ),
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon ?? Icons.expand_more),
        SizedBox(
          width: 40,
        ),
        Text(
          title,
          style: buildTextStyle(
            size: 12,
            color: Colors.grey[500],
          ),
        )
      ],
    ),
  );
}

Container dropdownMenuAss(String title, double width , {IconData icon}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: Colors.grey[500],
        ),
      ),
    ),
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon ?? Icons.expand_more, size: 16,),

        Text(
          title,
          style: buildTextStyle(
            size: 12,
            color: Colors.grey[500],
          ),
        )
      ],
    ),
  );
}

Future<bool> showDeleteDialogue(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
        ],
        title: Text('Do you want to delete this task?'),
      );
    },
  );
}

class FileListing extends StatefulWidget {
  final List<String> files;
  final DateTime date;
  final String subtitle;
  final bool isDownloadable;
  final bool isPreview;

  FileListing(this.files,
      {this.date,
      this.subtitle,
      this.isDownloadable = false,
      this.isPreview = false});

  @override
  State<FileListing> createState() => _FileListingState();
}

class _FileListingState extends State<FileListing> {
  List<int> _progress;
  List<bool> _isDownloading;
  List<CancelToken> _cancelTokens;
  PageController pageController = PageController();
  int _index = 0;
  List<Media> _media;

  @override
  void initState() {
    super.initState();
    _media = [];
    if (widget.files != null) {
      for (var url in widget.files) {
        var name = url.split('/').last.split('.');
        _media.add(Media(
            name.last.toLowerCase(), name.first, MediaResourceType.url,
            url: url));
      }
    }
    _progress = List.generate(widget.files.length, (index) => 0);
    _isDownloading = List.generate(widget.files.length, (index) => false);
    _cancelTokens =
        List.generate(widget.files.length, (index) => CancelToken());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
            height: 1,
            color: Colors.grey,
          ),
        ),
        const Text(
          "ATTACHMENTS",
          style: TextStyle(
              color: Color(0xff828282),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              fontStyle: FontStyle.normal,
              fontSize: 10.0),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 9),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Color(0xffF2F5F4),
            borderRadius: BorderRadius.circular(10.0),
          ),
          height: 175,
          child: Stack(
            children: [
              PageView.builder(
                physics: const BouncingScrollPhysics(),
                controller: pageController,
                itemCount: _media.length,
                onPageChanged: (index) {
                  setState(() {
                    _index = index;
                  });
                },
                itemBuilder: (context, index) {
                  Media media = _media[index];

                  return TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async {
                      if (media.extension == "mp4" ||
                          media.extension == "jpg" ||
                          media.extension == "jpeg" ||
                          media.extension == "png" ||
                          media.extension == "mp3" ||
                          media.extension == "aac" ||
                          media.extension == "flac" ||
                          media.extension == "alac" ||
                          media.extension == "wav" ||
                          media.extension == "wma" ||
                          media.extension == "dsd" ||
                          media.extension == "pcm") {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FileAttachedSlider(
                                _media, index, pageController)));
                      } else {
                        if (media.resourceType == MediaResourceType.url) {
                          String url = media.url;
                          if (await canLaunchUrlString(url) != null) {
                            await launchUrlString(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        } else {
                          OpenFile.open(media.file.path);
                        }
                      }
                    },
                    child: getFileTypeWidget(media),
                  );
                },
              ),
              if (_media.length != 1)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(),
                      color: Colors.black12,
                    ),
                    child: Text(
                      "${_index + 1} | ${_media.length}",
                      style: const TextStyle(
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0),
                    ),
                  ),
                ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: IconButton(
              //     onPressed: () {
              //       var media = _media[_index];
              //       if (media.resourceType == MediaResourceType.file) {
              //         widget.fileStreamController.valueOrNull
              //             .removeWhere((element) => element == media.file);
              //         widget.fileStreamController.sink
              //             .add(widget.fileStreamController.valueOrNull);
              //       } else {
              //         widget.urls
              //             .removeWhere((element) => element == media.url);
              //         _media.removeAt(_index);
              //         setState(() {});
              //       }
              //     },
              //     icon: const Icon(Icons.cancel),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
        // Container(
        //   height: 200,
        //   width: MediaQuery.of(context).size.width,
        //   child: PageView.builder(itemBuilder: (context,index){
        //     return InkWell(
        //       onTap: (){
        //         if (widget.files[index].endsWith('.jpg') ||
        //             widget.files[index].endsWith('.png') ||
        //             widget.files[index].endsWith('.jpeg')) {
        //           Navigator.of(context).push(
        //             createRoute(
        //               pageWidget: LearningFilesPage(
        //                 file: widget.files
        //                     .map(
        //                       (e) => LearningFiles(
        //                     file: e,
        //                     fileName: '',
        //                   ),
        //                 )
        //                     .toList(),
        //                 index: index,
        //                 pdf: false,
        //                 video: false,
        //               ),
        //             ),
        //           );
        //         } else if (widget.files[index].endsWith('.mp4')) {
        //           Navigator.of(context).push(
        //             createRoute(
        //               pageWidget: LearningFilesPage(
        //                 file: widget.files
        //                     .map(
        //                       (e) => LearningFiles(
        //                     file: e,
        //                     fileName: '',
        //                   ),
        //                 )
        //                     .toList(),
        //                 index: index,
        //                 pdf: false,
        //                 video: true,
        //               ),
        //             ),
        //           );
        //         } else if (widget.files[index].endsWith('.pdf')) {
        //           Navigator.of(context).push(
        //             createRoute(
        //               pageWidget: LearningFilesPage(
        //                 file: widget.files
        //                     .map(
        //                       (e) => LearningFiles(
        //                     file: e,
        //                     fileName: '',
        //                   ),
        //                 )
        //                     .toList(),
        //                 index: index,
        //                 pdf: true,
        //                 video: false,
        //               ),
        //             ),
        //           );
        //         } else if (widget.files[index].endsWith('.mp3') ||
        //             widget.files[index].endsWith('.aac') ||
        //             widget.files[index].endsWith('.flac') ||
        //             widget.files[index].endsWith('.alac') ||
        //             widget.files[index].endsWith('.wav') ||
        //             widget.files[index].endsWith('.wma') ||
        //             widget.files[index].endsWith('.dsd')) {
        //           Navigator.of(context).push(
        //             createRoute(
        //               pageWidget: LearningFilesPage(
        //                 file: widget.files
        //                     .map(
        //                       (e) => LearningFiles(
        //                     file: e,
        //                     fileName: '',
        //                   ),
        //                 )
        //                     .toList(),
        //                 index: index,
        //                 pdf: false,
        //                 video: false,
        //                 audio: true,
        //                 resourceType: MediaResourceType.url,
        //               ),
        //             ),
        //           );
        //         }
        //         else {
        //           BlocProvider.of<ActivityCubit>(context, listen: false)
        //               .openFile(widget.files[index]);
        //           Fluttertoast.showToast(msg: 'Opening File.');
        //         }
        //       },
        //       child: Container(
        //         child: Stack(
        //           children: [
        //             Center(
        //               child: CircleAvatar(
        //                 foregroundColor: Colors.black,
        //                 backgroundColor: Color(0xffFFC30A),
        //                 child: FaIcon(
        //                   checkIcon(
        //                     widget.files[index].substring(widget.files[index].length - 3),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //             if(widget.files[index].endsWith('.jpg') ||
        //                 widget.files[index].endsWith('.png') ||
        //                 widget.files[index].endsWith('.jpeg'))
        //             CachedNetworkImage(
        //               fit: BoxFit.fill,
        //               imageUrl: widget.files[index],width: MediaQuery.of(context).size.width,height: 200,),
        //             Container(
        //               padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
        //               decoration: BoxDecoration(
        //                 color: Colors.grey.shade300,
        //                 borderRadius: BorderRadius.circular(15.0)
        //               ),
        //                 child: Text('${index+1}/${widget.files.length}')),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        //   itemCount: widget.files.length),
        // );
    //      Column(children: [
    //   for (int i = 0; i < widget.files.length; i++)
    //     ListTile(
    //       onTap: () {
    //         if (widget.files[i].endsWith('.jpg') ||
    //             widget.files[i].endsWith('.png') ||
    //             widget.files[i].endsWith('.jpeg')) {
    //           Navigator.of(context).push(
    //             createRoute(
    //               pageWidget: LearningFilesPage(
    //                 file: widget.files
    //                     .map(
    //                       (e) => LearningFiles(
    //                         file: e,
    //                         fileName: '',
    //                       ),
    //                     )
    //                     .toList(),
    //                 index: i,
    //                 pdf: false,
    //                 video: false,
    //               ),
    //             ),
    //           );
    //         } else if (widget.files[i].endsWith('.mp4')) {
    //           Navigator.of(context).push(
    //             createRoute(
    //               pageWidget: LearningFilesPage(
    //                 file: widget.files
    //                     .map(
    //                       (e) => LearningFiles(
    //                         file: e,
    //                         fileName: '',
    //                       ),
    //                     )
    //                     .toList(),
    //                 index: i,
    //                 pdf: false,
    //                 video: true,
    //               ),
    //             ),
    //           );
    //         } else if (widget.files[i].endsWith('.pdf')) {
    //           Navigator.of(context).push(
    //             createRoute(
    //               pageWidget: LearningFilesPage(
    //                 file: widget.files
    //                     .map(
    //                       (e) => LearningFiles(
    //                         file: e,
    //                         fileName: '',
    //                       ),
    //                     )
    //                     .toList(),
    //                 index: i,
    //                 pdf: true,
    //                 video: true,
    //               ),
    //             ),
    //           );
    //         } else {
    //           BlocProvider.of<ActivityCubit>(context, listen: false)
    //               .openFile(widget.files[i]);
    //           Fluttertoast.showToast(msg: 'Opening File.');
    //         }
    //
    //         // BlocProvider.of<ActivityCubit>(context, listen: false)
    //         //     .downloadFile(e.toString());
    //       },
    //       leading: CircleAvatar(
    //         foregroundColor: Colors.black,
    //         backgroundColor: Color(0xffFFC30A),
    //         child: FaIcon(
    //           checkIcon(
    //             widget.files[i].substring(widget.files[i].length - 3),
    //           ),
    //         ),
    //       ),
    //       subtitle: Text(
    //         widget.subtitle ?? '',
    //         style: buildTextStyle(size: 12, color: Colors.red),
    //       ),
    //       title: Text(
    //         checkText(widget.files[i]),
    //         // files[i].split('/').last.toString(),
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //       trailing: widget.isDownloadable
    //           ? Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Stack(
    //                   alignment: Alignment.center,
    //                   children: [
    //                     Visibility(
    //                       visible: _isDownloading[i ?? 0] ?? false,
    //                       maintainAnimation: true,
    //                       maintainSize: true,
    //                       maintainState: true,
    //                       child: CircularPercentIndicator(
    //                         radius: 45.0,
    //                         percent: (_progress[i] / 100).toDouble(),
    //                         circularStrokeCap: CircularStrokeCap.round,
    //                       ),
    //                     ),
    //                     IconButton(
    //                       onPressed: _isDownloading[i]
    //                           ? () {
    //                               if (!_cancelTokens[i].isCancelled)
    //                                 _cancelTokens[i].cancel("Cancelled");
    //                             }
    //                           : () {
    //                               setState(() {
    //                                 _progress[i] = 0;
    //                                 _isDownloading[i] = true;
    //                               });
    //                               ActivityCubit().downloadFile(
    //                                 fileUrl: widget.files[i],
    //                                 filename: widget.files[i].split("/").last,
    //                                 cancelToken: _cancelTokens[i],
    //                                 onReceiveProgress: (received, total) {
    //                                   setState(() {
    //                                     _progress[i] =
    //                                         ((received / total) * 100).round();
    //                                   });
    //                                   if (_progress[i] == 100) {
    //                                     setState(() {
    //                                       _isDownloading[i] = false;
    //                                     });
    //                                     Fluttertoast.showToast(
    //                                         msg: "Downloaded",
    //                                         backgroundColor: Color(0xfff1c00f),
    //                                         textColor: Colors.white);
    //                                   }
    //                                 },
    //                                 onError: (error) {
    //                                   setState(() {
    //                                     _isDownloading[i] = false;
    //                                   });
    //                                   if (CancelToken.isCancel(error)) {
    //                                     _cancelTokens[i] = CancelToken();
    //                                     return;
    //                                   }
    //                                   Fluttertoast.showToast(
    //                                       msg: "Error while Downloading",
    //                                       fontSize: 16,
    //                                       textColor: Colors.white,
    //                                       backgroundColor: Colors.redAccent);
    //                                 },
    //                               );
    //                             },
    //                       icon: Icon(
    //                           _isDownloading[i] ? Icons.clear : Icons.download),
    //                     ),
    //                   ],
    //                 ),
    //                 if (widget.date != null)
    //                   SizedBox(
    //                     width: 5,
    //                   ),
    //                 if (widget.date != null)
    //                   Text(TimeOfDay.fromDateTime(widget.date).format(context))
    //               ],
    //             )
    //           : const SizedBox(
    //               width: 0,
    //               height: 0,
    //             ),
    //     ),
    // ]);
  }

  // Widget getFileTypeWidget(Media media) {
  //   var size = 50.0;
  //   switch (media.extension) {
  //     case "jpg":
  //     case "png":
  //     case "jpeg":
  //       return Container(
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             fit: BoxFit.fill,
  //             image: media.resourceType == MediaResourceType.url
  //                 ? CachedNetworkImageProvider(
  //               media.url,
  //             )
  //                 : FileImage(File(media.file.path)),
  //           ),
  //         ),
  //       );
  //       break;
  //     case "mp4":
  //       return SvgPicture.asset(
  //         "assets/svg/vid.svg",
  //         width: size,
  //       );
  //       break;
  //     case "mp3":
  //     case "aac":
  //       return SvgPicture.asset(
  //         "assets/svg/audio.svg",
  //         width: size,
  //       );
  //       break;
  //     case "doc":
  //     case "docx":
  //       return SvgPicture.asset(
  //         "assets/svg/doc.svg",
  //         width: size,
  //       );
  //       break;
  //     case "xlsx":
  //     case "xls":
  //       return SvgPicture.asset(
  //         "assets/svg/excel.svg",
  //         width: size,
  //       );
  //       break;
  //     case "pptx":
  //     case "ppt":
  //       return SvgPicture.asset(
  //         "assets/svg/ppt.svg",
  //         width: size,
  //       );
  //       break;
  //     case "pdf":
  //       return SvgPicture.asset(
  //         "assets/svg/pdf.svg",
  //         width: size,
  //       );
  //       break;
  //     default:
  //       return const SizedBox();
  //       break;
  //   }
  // }
}
String checkText(String fil) {
  if (fil.endsWith('jpeg') || fil.endsWith('jpg') || fil.endsWith('png')) {
    return 'Image';
  }
  if (fil.endsWith('mp4') ||
      fil.toLowerCase().endsWith('avi') ||
      fil.endsWith('mkv') ||
      fil.endsWith('webM')) {
    return 'Video';
  }
  if (fil.endsWith('mp3') || fil.endsWith('aac')) {
    return 'Audio';
  }
  if (fil.endsWith('pdf')) {
    return 'PDF';
  }
  if (fil.toLowerCase().endsWith('.pptx')) {
    return 'PPT';
  }
  if (fil.toLowerCase().endsWith('.doc') ||
      fil.toLowerCase().endsWith('.docx')) {
    return 'Document';
  }
  if(fil.isEmpty)
    return 'Invalid File';
}

String checkAssignedTo(Assigned assign) {
  switch (assign) {
    case (Assigned.parent):
      return 'Parent';
    case (Assigned.student):
      return 'Student';
    case (Assigned.teacher):
      return 'Teacher';
    case (Assigned.faculty):
      return 'Teacher';

      break;
    default:
      return '';
  }
}

class PopUpMenuWidget<T> extends StatelessWidget {
  const PopUpMenuWidget({
    @required this.onSelected,
    this.child,
    this.children,
    this.showEdit = true,
    this.value,
  });
  final void Function(T value) onSelected;
  final Widget child;
  final bool showEdit;
  final T value;
  final List<PopupMenuEntry<T>> Function(BuildContext context) children;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      onSelected: onSelected,
      itemBuilder: children != null
          ? children
          : (context) {
              return [
                // if(children!=null) ...children,
                // if(children==null)
                PopupMenuItem<T>(
                  height: 30,
                  value: value ?? 'Evaluate',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // width: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Evaluate',
                          style: buildTextStyle(size: 15),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SvgPicture.asset('assets/svg/evaluate.svg'),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem<T>(
                  height: 30,
                  value: value ?? 'Delete',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // width: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delete',
                          style: buildTextStyle(size: 15),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(Icons.delete)
                      ],
                    ),
                  ),
                ),
                if (showEdit)
                  PopupMenuItem<T>(
                    height: 30,
                    value: value ?? 'Edit',
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // width: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit',
                            style: buildTextStyle(size: 15),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(Icons.edit)
                        ],
                      ),
                    ),
                  )
              ];
            },
      child: child ??
          Container(
            height: 15,
            width: 20,
            child: SvgPicture.asset("assets/svg/mask.svg"),
          ),
    );
  }
}

void showDialogueInvalidUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Your ID is set for Backend Operations only.'),
        content: Text('You don\'t have access to the app.'),
        actions: [
          TextButton(
            onPressed: () {
              // SystemNavigator.pop(animated: true);
              exit(0);
              // Navigator.of(context).popUntil((route) => false);
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

Future showDialogueForDetails(BuildContext context,
    {String message,
    String subTitle = '',
    List<Widget> actions = const []}) async {
  await showDialog(
    context: context,
    useRootNavigator: true,
    builder: (context) {
      return AlertDialog(
        title: Text(message ?? 'Please select class/subject'),
        content: Text(subTitle),
        actions: [
          for (var i in actions) i,
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

Column showActivityLinks(BuildContext context, Activity activities) {
  return Column(
      children: activities.links.map((e) {
    return TextButton(
      style: ButtonStyle(),
      onPressed: () async {
        var check = await canLaunch(e);
        if (check)
          launch(e);
        else
          showDialogueForDetails(context,
              message: 'Invalid Link',
              subTitle: 'Please ask the creator to provide the valid link.');
      },
      child: Text('$e'),
    );
  }).toList());
}

SizedBox hSpacing([double width]) {
  return SizedBox(
    width: width ?? 10,
  );
}

SizedBox vSpacing([double height]) {
  return SizedBox(
    height: height ?? 10,
  );
}

class TimePickerWidget extends StatefulWidget {
  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  int mins = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        ),
      ],
      title: Text('Set Duration'),
      content: Consumer<TimePicker>(
        builder: (context, value, child) => Row(
          children: [
            NumberPicker(
              textMapper: (numberText) {
                return '$numberText Hrs';
              },
              maxValue: 5,
              minValue: 0,
              value: value.getHours,
              onChanged: (val) {
                value.setHours = val;
                setState(() {});
              },
            ),
            NumberPicker(
              textMapper: (numberText) {
                return '$numberText Mins';
              },
              maxValue: 59,
              minValue: 0,
              value: value.getMins,
              onChanged: (val) {
                value.setMins = val;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<int>> showAddTestScoreDialogue(BuildContext context,
    {int award, int coin}) async {
  int _award = award ?? 0;
  int _coin = coin ?? 0;
  GlobalKey<FormState> formKey = GlobalKey();
  return showDialog<List<int>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Add Coins and Award for Test.',
          style: buildTextStyle(),
        ),
        content: Container(
          height: 170,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/trophy.svg',
                      height: 50,
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        initialValue: award == null ? '' : '$award',
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        validator: (value) {
                          if (value.isEmpty) return 'Please provide a value';
                          if (int.tryParse(value) == null)
                            return 'Invalid Value';
                          _award = int.parse(value);
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Award',
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Image.asset('assets/images/points.png', height: 50),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextFormField(
                        initialValue: coin == null ? '' : '$coin',
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        validator: (value) {
                          if (value.isEmpty) return 'Please provide a value';
                          if (int.tryParse(value) == null)
                            return 'Invalid Value';
                          _coin = int.parse(value);
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter Coin',
                          counterText: '',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState.validate()) {
                Navigator.of(context).pop([_award, _coin]);
              }
            },
            child: Text('Ok'),
          ),
        ],
      );
    },
  );
}

void showValidationDialogue(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Please enter all details.',
          style: buildTextStyle(
            size: 20,
            weight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Make sure that following details are filled.\n * Subjects\n * Class\n * Coins and Award.',
          style: buildTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          )
        ],
      );
    },
  );
}

Future<void> showAssignedDialogue(BuildContext context, String title,
    {Widget destination}) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
          title: Text('$title assigned Successfully!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      createRoute(pageWidget: destination ?? TeacherHomePage()),
                      (route) => false);
                },
                child: Text('Ok')),
          ]);
    },
  );
}

Widget appMarker() {
  // if (logo) {
  //   return Image.asset('assets/images/Logo.png');
  // }
  // return Image.asset('assets/images/GrowON.png');
  // if (features['logo']['isGrowOn']) {
  //   return Image.asset('assets/images/GrowON.png');
  // } else {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: 'grow', style: buildTextStyle(weight: FontWeight.bold)),
          TextSpan(
            text: 'On',
            style: buildTextStyle(
                color: Color(0xffFFC30A), weight: FontWeight.bold),
          ),
        ],
      ),
    );

  }

Future<dynamic> checkFunction(
  BuildContext context,
  String name, {
  @required dynamic task,
  @required List<PlatformFile> files,
  @required List<StudentInfo> assignedStudents,
  @required List<String> assignedTeachers,
  @required QuestionPaper questionPaper,
  @required ScheduledClassTask classes,
  @required List<StudentInfo> assignedParents,
}) async {
  if (questionPaper != null) {
    questionPaper.assignTo = assignedStudents
        .map((e) => TestAssignTo(
             // branch: e.branchId,
              classId: e.userInfoClass,
              schoolId: e.schoolId,
              sectionId: e.section,
              studentId: e.id,
            ))
        .toList();
    return BlocProvider.of<QuestionPaperCubit>(context).createQuestionPaper(
      questionPaper,
      Provider.of<TimePicker>(context, listen: false).getTimeInSeconds,
    );
  }
  if (classes != null) {
    return BlocProvider.of<ScheduleClassCubit>(context).createClass(classes,
        assignedStudents: assignedStudents,
        teacher: assignedTeachers,
        files: files,
        assignedTeachers: assignedTeachers);
  } else {
    switch (name) {
      case 'Assignment':
        return context.read<ActivityCubit>().createAssignment(
              assignmentTask: task,
              attachments: files,
              students: assignedStudents,
              teacher: assignedTeachers,
              parents: assignedParents
                  .map(
                    (e) => AssignToParent(
                      parentId: e.parentId,
                      studentId: e.id,
                    ),
                  )
                  .toList(),
            );
        break;
      case 'Announcement':
        return context.read<ActivityCubit>().createAnnouncement(
              assignmentTask: task,
              attachments: files,
              students: assignedStudents,
              teacher: assignedTeachers,
              parents: assignedParents.map(
                (e) {
                  return AssignToParent(
                    parentId: e.parentId,
                    studentId: e.id,
                  );
                },
              ).toList(),
            );
        break;
      case 'LivePoll':
        return context.read<ActivityCubit>().createLivePoll(
              assignmentTask: task,
              attachments: files,
              students: assignedStudents,
              teacher: assignedTeachers,
              parents: assignedParents
                  .map(
                    (e) => AssignToParent(
                      parentId: e.parentId,
                      studentId: e.id,
                    ),
                  )
                  .toList(),
            );
        break;
      case 'Event':
        return context.read<ActivityCubit>().createEvent(
              assignmentTask: task,
              attachments: files,
              students: assignedStudents,
              teacher: assignedTeachers,
              parents: assignedParents
                  .map(
                    (e) => AssignToParent(
                      parentId: e.parentId,
                      studentId: e.id,
                    ),
                  )
                  .toList(),
            );
        break;
      case 'Check List':
        return context.read<ActivityCubit>().createCheckList(
              assignmentTask: task,
              attachments: files,
              students: assignedStudents,
              teacher: assignedTeachers,
              parents: assignedParents
                  .map(
                    (e) => AssignToParent(
                      parentId: e.parentId,
                      studentId: e.id,
                    ),
                  )
                  .toList(),
            );
        break;
      default:
        return BlocProvider.of<ScheduleClassCubit>(context).createClass(
          task,
          assignedStudents: assignedStudents,
          teacher: assignedTeachers,
          files: files,
        );
    }
  }
}


class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({Key key, this.message, this.confirm})
      : super(key: key);

  final String message, confirm;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(confirm),
        ),
      ],
    );
  }
}

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();
  static MyConnectivity get instance => _instance;
  final _connectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;

  void initialise() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _checkStatus(result);
    _connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('www.google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();
}

String removeTags(String html){
  return HtmlParser.parseHTML(html).body.text;
}
