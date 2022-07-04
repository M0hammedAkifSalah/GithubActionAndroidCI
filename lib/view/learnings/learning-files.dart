import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

import '../file_viewer.dart';
import '../test-module/question_view.dart';
import '/bloc/learning/delete-learning.dart';
import '/export.dart';
import '/view/pdf-viewer.dart';
import 'package:dio/src/cancel_token.dart';

class LearningFilesPage extends StatefulWidget {
  final List<LearningFiles> file;
  final bool video;
  final bool topic;
  final bool chapter;
  final String contentId;
  final bool pdf;
  final int index;
  final bool audio;
  final MediaResourceType resourceType;
  final List<File> platformFile;
  final Uint8List bytes;

  const LearningFilesPage({
    Key key,
    @required this.file,
    this.video = false,
    @required this.index,
    this.pdf,
    this.platformFile,
    this.resourceType,
    this.bytes,
    this.audio = false,
    this.chapter = false,
    this.topic = false,
    this.contentId = '',
  }) : super(key: key);

  @override
  _LearningFilesPageState createState() => _LearningFilesPageState();
}

class _LearningFilesPageState extends State<LearningFilesPage> {
  ChewieController chewieController;
  PageController pageController;
  int _index;
  AudioManager _audioManager;
  List<int> _progress;
  List<bool> _isDownloading;
  List<CancelToken> _cancelTokens;

  VideoPlayerController getVideoPlayer({String url,File file}) {
    return url != null ? VideoPlayerController.network(url) : VideoPlayerController.file(file);
  }

  @override
  void initState() {
    super.initState();
    _index = widget.index;
    pageController = PageController(initialPage: widget.index);
    if (widget.video)
      if(widget.file.isNotEmpty)
      chewieController = ChewieController(
        videoPlayerController: getVideoPlayer(url: widget.file[widget.index].file),
        allowFullScreen: true,
        allowMuting: true,
        autoInitialize: true,
        autoPlay: false,
        looping: false,
      );
      else{
        chewieController = ChewieController(

            videoPlayerController: getVideoPlayer(file: widget.platformFile[widget.index]),
            allowFullScreen: true,
            allowMuting: true,
            autoInitialize: true,
            autoPlay: false,
            looping: false,);
      }
    _progress = List.generate(widget.file.length, (index) => 0);
    _isDownloading = List.generate(widget.file.length, (index) => false);
    _cancelTokens = List.generate(widget.file.length, (index) => CancelToken());
    // if(widget.audio){
      _audioManager = AudioManager(
        widget.resourceType,
        widget.file.isNotEmpty
            ? widget.file[widget.index].file
            : widget.platformFile[widget.index].path

      );


    // }


  }

  @override
  void dispose() {
    if (chewieController != null) {
      chewieController.pause();
      chewieController.dispose();
    }
    if(_audioManager != null){
      _audioManager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(widget.file.isNotEmpty ? widget.file[_index].fileName : widget.platformFile[_index].path),
        actions: [
          if (widget.chapter || widget.topic)
            InkWell(
              onTap: () {
                if (widget.chapter) {
                  DeleteLearing().deleteChapterContent({
                    'chapterId': widget.contentId,
                    'fileUploadId': widget.file[_index].id
                  }).then((value) {
                    if (value) {
                      return buildDeleteDialog(
                              context, 'File deleted successfully')
                          .then((value) {
                        Navigator.of(context).pop(true);
                      });
                    } else {
                      return buildDeleteDialog(context, 'Unable to delete file')
                          .then((value) {
                        Navigator.of(context).pop(false);
                      });
                    }
                  });
                } else {
                  DeleteLearing().deleteTopicContent({
                    'topicId': widget.contentId,
                    'fileUploadId': widget.file[_index].id
                  }).then((value) {
                    if (value) {
                      return buildDeleteDialog(
                              context, 'File deleted successfully')
                          .then((value) {
                        Navigator.of(context).pop(true);
                      });
                    } else {
                      return buildDeleteDialog(context, 'Unable to delete file')
                          .then((value) {
                        Navigator.of(context).pop(false);
                      });
                    }
                  });
                }
              },
              child: Icon(Icons.delete),
            ),
          if(widget.file.isNotEmpty)
          IconButton(
            onPressed: () {
              setState(() {
                _progress[_index] = 0;
                _isDownloading[_index] = true;
              });
              ActivityCubit().downloadFile(
                fileUrl: widget.file[_index].file,
                filename: widget.file[_index].file.split("/").last,
                cancelToken: _cancelTokens[_index],
                onReceiveProgress: (received, total) {
                  setState(() {
                    _progress[_index] = ((received / total) * 100).round();
                  });
                  if (_progress[_index] == 100) {
                    setState(() {
                      _isDownloading[_index] = false;
                    });
                    Fluttertoast.showToast(
                        msg: "Downloaded",
                        backgroundColor: Color(0xfff1c00f),
                        textColor: Colors.white);
                  }
                },
                onError: (error) {
                  setState(() {
                    _isDownloading[_index] = false;
                  });
                  if (CancelToken.isCancel(error)) {
                    _cancelTokens[_index] = CancelToken();
                    return;
                  }
                  Fluttertoast.showToast(
                      msg: "Error while Downloading",
                      fontSize: 16,
                      textColor: Colors.white,
                      backgroundColor: Colors.redAccent);
                },
              );
            },
            icon: Icon(_isDownloading[_index] ? Icons.clear : Icons.download),
          ),
          // if (widget.file[_index].file.endsWith('.jpg') ||
          //     widget.file[_index].file.endsWith('.png') ||
          //     widget.file[_index].file.endsWith('.jpeg'))
          //   IconButton(
          //     icon: Icon(Icons.edit),
          //     onPressed: () {
          //       Navigator.of(context).push(
          //         createRoute(
          //           pageWidget: ImageEditAssignment(widget.file[_index].file),
          //         ),
          //       );
          //     },
          //   ),
        ],
        // actions: [
        //   if (!widget.video)
        //     IconButton(
        //       icon: Icon(Icons.edit),
        //       onPressed: () async {
        //         Fluttertoast.showToast(msg: 'Opening File! Please wait..');
        //         await ActivityCubit()
        //             .openFile(widget.file.file, openFile: false);
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //               content: Text(
        //                   'Image downloaded in \'${ExtStorage.DIRECTORY_DOWNLOADS}\' Folder.')),
        //         );
        //         Navigator.of(context).push(
        //           createRoute(
        //             pageWidget: ImageEditAssignment(),
        //           ),
        //         );
        //       },
        //     )
        // ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: widget.file.length <=0 ? widget.platformFile.length : widget.file.length,
        onPageChanged: (value) {
          _index = value;
          setState(() {});
        },
        itemBuilder: (context, index) {
          return getBody(index);
        },
      ),
    );
  }

  Widget getBody(int index) {
    return (widget.file.isNotEmpty ? widget.file[index].file.endsWith('.mp4') : widget.platformFile[index].path.endsWith('.mp4'))
        ? Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: FutureBuilder(
                future: widget.file.isNotEmpty ? getVideoPlayer(url: widget.file[index].file).initialize() : getVideoPlayer(file: widget.platformFile[index]).initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Chewie(
                      controller: chewieController,
                    );
                  else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                }),
          )
        :( widget.file.isNotEmpty ? (widget.file[index].file.endsWith('.mp3') ||
        widget.file[index].file.endsWith('.aac') ||
        widget.file[index].file.endsWith('.flac') ||
        widget.file[index].file.endsWith('.alac') ||
        widget.file[index].file.endsWith('.wav') ||
        widget.file[index].file.endsWith('.wma') ||
        widget.file[index].file.endsWith('.dsd'))
        : (widget.platformFile[index].path.endsWith('.mp3') ||
        widget.platformFile[index].path.endsWith('.aac') ||
        widget.platformFile[index].path.endsWith('.flac') ||
        widget.platformFile[index].path.endsWith('.alac') ||
        widget.platformFile[index].path.endsWith('.wav') ||
        widget.platformFile[index].path.endsWith('.wma') ||
        widget.platformFile[index].path.endsWith('.dsd')))
        ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        // padding: EdgeInsets.all(10.0),
        // margin: const EdgeInsets.only(right: 8.0),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          // color: Color(0xff1B1A57).withOpacity(0.1),
        color: Colors.white
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<ButtonState>(
              valueListenable: _audioManager.buttonNotifier,
              builder: (_, value, __) {
                return Container(
                  // color: Colors.black,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  width: 24.0,
                  height: 24.0,
                  child: () {
                    switch (value) {
                      case ButtonState.loading:
                        return Container(
                          // height: 150,
                          margin: EdgeInsets.all(5.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: const Color(0xff4F5E7B),
                          ),
                        );
                      case ButtonState.paused:
                        return InkResponse(
                          child: Icon(
                            Icons.play_arrow,
                            color: const Color(0xff4F5E7B),
                          ),
                          onTap: _audioManager.play,
                        );
                      case ButtonState.playing:
                        return InkResponse(
                          child: Icon(
                            Icons.pause,
                            color: const Color(0xff4f5e7b),
                          ),
                          onTap: _audioManager.pause,
                        );
                    }
                  }(),
                );
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: ValueListenableBuilder<ProgressBarState>(
                  valueListenable: _audioManager.progressNotifier,
                  builder: (_, value, __) {
                    return ProgressBar(
                      progress: value.current,
                      buffered: value.buffered,
                      total: value.total,
                      onSeek: _audioManager.seek,
                      thumbRadius: 5.0,
                      thumbGlowRadius: 15.0,
                      barHeight: 3.5,
                      baseBarColor:
                      const Color(0xff4F5E7B).withOpacity(0.6),
                      bufferedBarColor:
                      const Color(0xff4F5E7B).withOpacity(0.3),
                      thumbGlowColor:
                      const Color(0xff4F5E7B).withOpacity(0.3),
                      progressBarColor: const Color(0xff4F5E7B),
                      thumbColor: const Color(0xff4F5E7B),
                      timeLabelTextStyle: TextStyle(
                        fontSize: 13.0,
                        color: const Color(0xff4F5E7B),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    )
        // : widget.file[index].file.endsWith('.mp3') ?
        //     showGeneralDialog(context: context,
        //         barrierLabel: "Barrier",
        //         barrierDismissible: true,
        //         barrierColor: Colors.black.withOpacity(0.5),
        //         transitionDuration: Duration(milliseconds: 300),
        //         transitionBuilder: (_, anim, __, child) {
        //           return SlideTransition(
        //             position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
        //             child: child,
        //           );
        //         },
        //         pageBuilder:(_,__,___){
        //          // AudioPlayer audioPlugin = AudioPlayer();
        //
        //           return Align(
        //               alignment: Alignment.bottomCenter,
        //               child: Container(
        //                 width: MediaQuery.of(context).size.width,
        //                 margin: EdgeInsets.only(
        //                   top: 80,
        //                 ),
        //                 height: 400,
        //                 decoration: BoxDecoration(
        //                   color: Colors.white,
        //                   borderRadius: BorderRadius.circular(15),
        //                 ),
        //               child: IconButton(
        //                 icon: Icon(Icons.play_circle_filled_outlined),
        //                 onPressed: (){
        //
        //                  // audioPlugin.play(widget.file[index].file);
        //                 },
        //               ),) ); } )
        : (widget.file.isNotEmpty ? widget.file[index].file.endsWith('.pdf') : widget.platformFile[index].path.endsWith('.pdf'))
            ? PdfViewerPage(
                url: widget.file.isNotEmpty ? widget.file[index].file : widget.platformFile[index].path,
              )
            : (widget.file.isNotEmpty ? (widget.file[index].file.endsWith('.jpg') ||
                    widget.file[index].file.endsWith('.png') ||
                    widget.file[index].file.endsWith('.jpeg')) : (widget.platformFile[index].path.endsWith('.jpg') ||
        widget.platformFile[index].path.endsWith('.png') ||
        widget.platformFile[index].path.endsWith('.jpeg')))
                ? InteractiveViewer(
                    boundaryMargin: EdgeInsets.all(20.0),
                    child: widget.file.isNotEmpty ? CachedNetworkImage(
                      imageUrl: widget.file[index].file,
                      progressIndicatorBuilder: (context, url, progress) {
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      },
                      errorWidget: (context, url, error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );
                        return Text('Something Went Wrong!');
                      },
                    ) : Image.file(widget.platformFile[index]),
                  )
                : InkWell(
                    onTap: () {
                      BlocProvider.of<ActivityCubit>(context, listen: false)
                          .openFile(widget.file[index].file);
                      Fluttertoast.showToast(msg: 'Opening File.');
                    },
                    child: Center(
                      child: CircleAvatar(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xffFFC30A),
                        child: FaIcon(
                          checkIcon( widget.file.isNotEmpty ?
                            widget.file[index].file
                                .substring(widget.file[index].file.length - 3 ):widget.platformFile[index].path
                              .substring(widget.platformFile[index].path.length - 3 ),
                          ),
                        ),
                      ),
                    ),
                  );
  }

  Future<dynamic> buildDeleteDialog(BuildContext context, String title) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text(title),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'))
          ],
        );
      },
    );
  }
}

class AttachedContentView extends StatefulWidget {
  const AttachedContentView({Key key}) : super(key: key);

  @override
  State<AttachedContentView> createState() => _AttachedContentViewState();
}

class _AttachedContentViewState extends State<AttachedContentView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

