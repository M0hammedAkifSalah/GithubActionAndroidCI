import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:growonplus_teacher/view/test-module/question_view.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../loader.dart';


class FileViewer extends StatefulWidget {
  final String type;
  final MediaResourceType resourceType;
  final String url;
  final PlatformFile file;
  final Uint8List bytes;
  final bool isExpanded;

  const FileViewer({this.type, this.resourceType,
      Key key, this.file, this.url, this.bytes, this.isExpanded = true})
      : super(key: key);

  @override
  _FileViewerState createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AudioManager _audioManager;
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  // VideoDao videoDao;
  TransformationController transformationController;
  TapDownDetails tapDownDetails;
  AnimationController animationController;
  Animation<Matrix4> animation;
  bool isLoading = true;
  String mediaType;
  bool _isAudioPaused = true;

  @override
  void initState() {
    super.initState();
    if (widget.type == "jpg" ||
        widget.type == "jpeg" ||
        widget.type == "png" ||
        widget.type == "jpeg") {
      mediaType = "image";
      transformationController = TransformationController();
      animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300))
        ..addListener(() {
          transformationController.value = animation.value;
        });
    } else if (widget.type == "mp4") {
      mediaType = "video";
      if (widget.resourceType == MediaResourceType.url) {
        // videoDao = AppDatabase().videoDao;
        _initializeVideoPlayerUrl();
      } else {
        _initializeVideoPlayerFile();
      }
    } else if (widget.type == "mp3" ||
        widget.type == "aac" ||
        widget.type == "flac" ||
        widget.type == "alac" ||
        widget.type == "wav" ||
        widget.type == "wma" ||
        widget.type == "dsd" ||
        widget.type == "pcm") {
      mediaType = "audio";
      _audioManager = AudioManager(
          widget.resourceType,
          widget.resourceType == MediaResourceType.url
              ? widget.url
              : widget.file.path);
    }
  }

  @override
  void dispose() {
    if (mediaType == "image") {
      transformationController.dispose();
      animationController.dispose();
    } else if (mediaType == "video") {
      if (widget.resourceType == MediaResourceType.url) {
        // videoDao.updateVideo(VideoTableData(
        //     url: widget.url,
        //     lastPosition: videoPlayerController.value.position.inSeconds));
      }
      videoPlayerController?.dispose();
      chewieController?.dispose();
    } else if (mediaType == "audio") {
      _audioManager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return mediaType == "image"
        ? Center(
            child: GestureDetector(
              onDoubleTapDown: (details) => tapDownDetails = details,
              onDoubleTap: () {
                final position = tapDownDetails.localPosition;
                const double scale = 3;
                final x = -position.dx * (scale - 1);
                final y = -position.dy * (scale - 1);
                final zoomed = Matrix4.identity()
                  ..translate(x, y)
                  ..scale(scale);
                final end = transformationController.value.isIdentity()
                    ? zoomed
                    : Matrix4.identity();
                animation = Matrix4Tween(
                  begin: transformationController.value,
                  end: end,
                ).animate(CurveTween(curve: Curves.easeOut)
                    .animate(animationController));
                animationController.forward(from: 0);
              },
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                panEnabled: false,
                transformationController: transformationController,
                child: widget.resourceType == MediaResourceType.url
                    ? CachedNetworkImage(
                        // imageUrl: widget.fileName,
                        imageUrl:

                                widget.url,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            color: const Color(0xff6fcf97),
                          ),
                        ),
                        errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            color: Colors.grey[200],
                          ),
                        ),
                      )
                    : widget.resourceType == MediaResourceType.file
                        ? Image.file(
                            File(widget.file.path),
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            widget.bytes,
                            fit: BoxFit.cover,
                          ),
              ),
            ),
          )
        : mediaType == "video"
            ? Center(
                child: isLoading
                    ? const SizedBox(
                        height: 200, child: Center(child: loadingBar))
                    : VisibilityDetector(
                        key: Key(widget.url),
                        onVisibilityChanged: (VisibilityInfo info) {
                          if (!mounted) {
                            return;
                          }
                          if (info.visibleFraction == 0) {
                            videoPlayerController.pause();
                          } else if (info.visibleFraction == 1) {
                            videoPlayerController.play();
                          }
                        },
                        child: AspectRatio(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          child: Chewie(
                            controller: ChewieController(
                              videoPlayerController: videoPlayerController,
                              aspectRatio:
                                  videoPlayerController.value.aspectRatio,
                              autoPlay: true,
                              autoInitialize: true,
                              deviceOrientationsAfterFullScreen: [
                                DeviceOrientation.portraitUp
                              ],
                              allowFullScreen: true,
                              errorBuilder: (context, error) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(Icons.error),
                                    Text(error),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              )
            : mediaType == "audio"
                ? VisibilityDetector(
                    key: Key(widget.url),
                    onVisibilityChanged: (VisibilityInfo info) {
                      if (!mounted) {
                        return;
                      }
                      if (info.visibleFraction == 0 &&
                          _audioManager.isPlaying()) {
                        _audioManager.pause();
                      } else if (info.visibleFraction == 1 &&
                          !_audioManager.isPlaying() &&
                          !_isAudioPaused) {
                        _audioManager.play();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: widget.isExpanded
                              ? kFloatingActionButtonMargin + 64
                              : 0.0,
                          left: 15.0,
                          right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          widget.isExpanded
                              ? Expanded(
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(30.0),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff4F5E7B)
                                            .withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: Icon(
                                        Icons.audiotrack_outlined,
                                        color: const Color(0xff4F5E7B),
                                        size:
                                            MediaQuery.of(context).size.width /
                                                2,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(30.0),
                                    decoration: BoxDecoration(
                                        // color: const Color(0xff4F5E7B)
                                        //     .withOpacity(0.15),
                                        // borderRadius: BorderRadius.circular(30.0),
                                        ),
                                    child: Icon(
                                      Icons.multitrack_audio_rounded,
                                      color: const Color(0xff4F5E7B),
                                      size:
                                          MediaQuery.of(context).size.width / 3,
                                    ),
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: ValueListenableBuilder<ProgressBarState>(
                              valueListenable: _audioManager.progressNotifier,
                              builder: (_, value, __) {
                                return ProgressBar(
                                  progress: value.current,
                                  buffered: value.buffered,
                                  total: value.total,
                                  onSeek: _audioManager.seek,
                                  thumbRadius: 10.0,
                                  thumbGlowRadius: 20.0,
                                  barHeight: 5.0,
                                  baseBarColor:
                                      const Color(0xff4F5E7B).withOpacity(0.6),
                                  bufferedBarColor:
                                      const Color(0xff4F5E7B).withOpacity(0.3),
                                  thumbGlowColor:
                                      const Color(0xff4F5E7B).withOpacity(0.3),
                                  progressBarColor: const Color(0xff4F5E7B),
                                  thumbColor: const Color(0xff4F5E7B),
                                  timeLabelLocation: TimeLabelLocation.sides,
                                  timeLabelTextStyle: const TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xff4F5E7B),
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ),
                          ValueListenableBuilder<ButtonState>(
                            valueListenable: _audioManager.buttonNotifier,
                            builder: (_, value, __) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _audioManager.replay(
                                              const Duration(seconds: 10));
                                        },
                                        iconSize: 55.0,
                                        color: const Color(0xff4F5E7B),
                                        icon: const Icon(
                                          Icons.replay_10,
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      () {
                                        switch (value) {
                                          case ButtonState.loading:
                                            return Container(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              width: 92.0,
                                              height: 92.0,
                                              child:
                                                  const CircularProgressIndicator(
                                                color: Color(0xff4F5E7B),
                                              ),
                                            );
                                          case ButtonState.paused:
                                            return IconButton(
                                              icon: const Icon(
                                                Icons
                                                    .play_circle_outline_rounded,
                                              ),
                                              color: const Color(0xff4F5E7B),
                                              iconSize: 75.0,
                                              onPressed: () {
                                                _isAudioPaused = false;
                                                _audioManager.play();
                                              },
                                            );
                                          case ButtonState.playing:
                                            return IconButton(
                                              icon: const Icon(
                                                Icons
                                                    .pause_circle_outline_rounded,
                                              ),
                                              iconSize: 75.0,
                                              color: const Color(0xff4f5e7b),
                                              onPressed: () {
                                                _isAudioPaused = true;
                                                _audioManager.pause();
                                              },
                                            );
                                        }
                                      }(),
                                      const SizedBox(width: 20),
                                      IconButton(
                                        onPressed: () {
                                          _audioManager.forward(
                                              const Duration(seconds: 10));
                                        },
                                        iconSize: 55.0,
                                        color: const Color(0xff4F5E7B),
                                        icon: const Icon(
                                          Icons.forward_10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      if (widget.resourceType == MediaResourceType.url) {
                        String url = widget.url;
                        if (await canLaunchUrlString(url) != null) {
                          await launchUrlString(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      } else {
                        OpenFile.open(widget.file.path);
                      }
                    },
                    child: Center(
                      child: getFileTypeWidget(widget.type),
                    ),
                  );
  }

  Future<void> _initializeVideoPlayerUrl() async {
    if (mounted && videoPlayerController == null) {
      videoPlayerController = VideoPlayerController.network(widget.url);
      await videoPlayerController.initialize().then((_) async {
        // var video = await getVideoInfo(widget.url);
        if (mounted) {
          // videoPlayerController.seekTo(Duration(seconds: video.lastPosition));
          videoPlayerController.play();
        }
      });
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _initializeVideoPlayerFile() async {
    log(widget.file.path.toString());
    if (mounted && videoPlayerController == null) {
      videoPlayerController =
          VideoPlayerController.file(File(widget.file.path));
      await videoPlayerController.initialize().then((_) {
        if (mounted) {
          videoPlayerController.play();
        }
      });
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Future<VideoTableData> getVideoInfo(String fileUrl) async {
  //   VideoTableData video;
  //   video = await videoDao.getVideo(fileUrl);
  //   if (video == null) {
  //     video = VideoTableData(
  //         url: fileUrl, lastPosition: 0, modifiedDate: DateTime.now());
  //     videoDao.insertVideo(video);
  //   }
  //   if (videoPlayerController.value.duration.inSeconds == video.lastPosition) {
  //     video = video.copyWith(lastPosition: 0, modifiedDate: DateTime.now());
  //     await videoDao.updateVideo(video);
  //   }
  //   return video;
  // }

  Widget getFileTypeWidget(String type) {
    var width = MediaQuery.of(context).size.width;
    var size = width / 2;
    var boxFit = BoxFit.fitWidth;
    switch (type) {
      case "jpg":
      case "png":
      case "jpeg":
        return SvgPicture.asset(
          "assets/svg/img.svg",
          width: size,
          fit: boxFit,
        );
        break;
      case "mp4":
        return SvgPicture.asset(
          "assets/svg/vid.svg",
          width: size,
          fit: boxFit,
        );
        break;
      case "mp3":
      case "aac":
        return SvgPicture.asset(
          "assets/svg/audio.svg",
          width: size,
          fit: boxFit,
        );
        break;
      case "doc":
      case "docx":
        return SvgPicture.asset(
          "assets/svg/doc.svg",
          width: size,
          fit: boxFit,
        );

        break;
      case "xlsx":
      case "xls":
        return SvgPicture.asset(
          "assets/svg/excel.svg",
          width: size,
          fit: boxFit,
        );
        break;
      case "pptx":
      case "ppt":
        return SvgPicture.asset(
          "assets/svg/ppt.svg",
          width: size,
          fit: boxFit,
        );
        break;
      case "pdf":
        return SvgPicture.asset(
          "assets/svg/pdf.svg",
          width: size,
          fit: boxFit,
        );
        break;
      default:
        return const SizedBox();
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}

enum MediaResourceType {
  file,
  url,
  bytes,
}
