import 'package:flutter/material.dart';

import 'attached_files_and_url_slider.dart';
import 'file_viewer.dart';


class FileAttachedSlider extends StatefulWidget {
  final List<Media> media;
  final int index;
  final PageController pageController;

  const FileAttachedSlider(this.media, this.index, this.pageController,
      {Key key})
      : super(key: key);

  @override
  _FileAttachedSliderState createState() => _FileAttachedSliderState();
}

class _FileAttachedSliderState extends State<FileAttachedSlider> {
  String filename;
  int _index;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: widget.index);
    _index = widget.index;
    changeFilename();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filename),
      ),
      body: PageView.builder(
        physics: const BouncingScrollPhysics(),
        controller: pageController,
        itemCount: widget.media.length,
        onPageChanged: (index) {
          if (widget.pageController.hasClients) {
            widget.pageController.animateToPage(index,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);
          }
          setState(() {
            _index = index;
            changeFilename();
          });
        },
        itemBuilder: (context, index) {
          var media = widget.media[index];
          return FileViewer(type: media.extension, resourceType: media.resourceType,
              url: media.url, file: media.file);
        },
      ),
    );
  }

  void changeFilename() {
    filename = widget.media[_index].name;
  }
}
