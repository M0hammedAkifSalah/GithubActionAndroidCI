import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:growonplus_teacher/view/utils/utils.dart';
import 'package:open_file/open_file.dart';
import 'package:rxdart/subjects.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'file_attached_slider.dart';
import 'file_viewer.dart';



class AttachedFilesAndUrlSlider extends StatefulWidget {
  final BehaviorSubject<List<PlatformFile>> fileStreamController;
  final List<String> urls;

  const AttachedFilesAndUrlSlider(this.urls, this.fileStreamController,
      {Key key})
      : super(key: key);

  @override
  State<AttachedFilesAndUrlSlider> createState() =>
      _AttachedFilesAndUrlSliderState();
}

class _AttachedFilesAndUrlSliderState extends State<AttachedFilesAndUrlSlider> {
  PageController pageController = PageController();
  int _index = 0;
  List<Media> _media;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    _media = [];
    if (widget.urls != null) {
      for (var url in widget.urls) {
        var name = url.split('/').last.split('.');
        _media.add(Media(
            name.last.toLowerCase(), name.first, MediaResourceType.url,
            url: url));
      }
    }
    if (widget.fileStreamController.valueOrNull != null) {
      for (var file in widget.fileStreamController.valueOrNull) {
        _media.add(Media(
            file.extension.toLowerCase(), file.name, MediaResourceType.file,
            file: file));
      }
    }
    widget.fileStreamController.stream.listen((event) {
      _media.removeWhere(
          (element) => element.resourceType == MediaResourceType.file);
      for (var file in event) {
        _media.add(Media(
            file.extension.toLowerCase(), file.name, MediaResourceType.file,
            file: file));
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_media != null && _media.isNotEmpty) {
      if (_index >= _media.length - 1) {
        _index = _media.length - 1;
      }
      return  Column(
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
            "YOUR ATTACHMENTS",
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
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      var media = _media[_index];
                      if (media.resourceType == MediaResourceType.file) {
                        widget.fileStreamController.valueOrNull
                            .removeWhere((element) => element == media.file);
                        widget.fileStreamController.sink
                            .add(widget.fileStreamController.valueOrNull);
                      } else {
                        widget.urls
                            .removeWhere((element) => element == media.url);
                        _media.removeAt(_index);
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.cancel),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }


}
Widget getFileTypeWidget(Media media) {
  var size = 50.0;
  switch (media.extension) {
    case "jpg":
    case "png":
    case "jpeg":
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: media.resourceType == MediaResourceType.url
                ? CachedNetworkImageProvider(
              media.url,
            )
                : FileImage(File(media.file.path)),
          ),
        ),
      );
      break;
    case "mp4":
      return SvgPicture.asset(
        "assets/svg/vid.svg",
        width: size,
      );
      break;
    case "mp3":
    case "aac":
      return SvgPicture.asset(
        "assets/svg/audio.svg",
        width: size,
      );
      break;
    case "doc":
    case "docx":
      return SvgPicture.asset(
        "assets/svg/doc.svg",
        width: size,
      );
      break;
    case "xlsx":
    case "xls":
      return SvgPicture.asset(
        "assets/svg/excel.svg",
        width: size,
      );
      break;
    case "pptx":
    case "ppt":
      return SvgPicture.asset(
        "assets/svg/ppt.svg",
        width: size,
      );
      break;
    case "pdf":
      return SvgPicture.asset(
        "assets/svg/pdf.svg",
        width: size,
      );
      break;
    default:
      return const SizedBox();
      break;
  }
}

class Media {
  MediaResourceType resourceType;
  String url;
  PlatformFile file;
  String name;
  String extension;

  Media(this.extension, this.name, this.resourceType, {this.url, this.file});
}
