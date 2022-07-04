import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../custom/image_painter/_image_painter.dart';
import '../custom/image_painter/image_painter.dart';
import '../test-module/constants.dart';

class ImageEditAssignment extends StatefulWidget {
  final bool isUrl;
  final String url;
  final Uint8List byte;

  ImageEditAssignment({Key key, this.isUrl, this.url, this.byte})
      : super(key: key);

  @override
  State<ImageEditAssignment> createState() => _ImageEditAssignmentState();
}

class _ImageEditAssignmentState extends State<ImageEditAssignment> {
  final _imageKey = GlobalKey<ImagePainterState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        primary: true,
        backgroundColor: kLightColor,
        title: Text(
          "Correction",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kDarkColor,
          ),
        ),
        actions: [
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    final image = await _imageKey.currentState?.exportImage();
                    setState(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop(image);
                    // var fileName = url.split('/').last.split('.');
                    // var res = await ActivityCubit()
                    //     .uploadBytes(image, "${fileName[0]}_edit.${fileName[1]}");
                    // print(res);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: const Text(
                    //       "Image Exported successfully.",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // );
                  },
                  icon: Icon(Icons.done),
                ),
        ],
      ),
      body: widget.isUrl
          ? ImagePainter.network(
              widget.url,
              key: _imageKey,
              scalable: true,
              initialStrokeWidth: 2,
              initialColor: Colors.red,
              initialPaintMode: PaintMode.freeStyle,
              controlsAtTop: false,
            )
          : ImagePainter.memory(
              widget.byte,
              key: _imageKey,
              scalable: true,
              initialStrokeWidth: 2,
              initialColor: Colors.red,
              initialPaintMode: PaintMode.freeStyle,
              controlsAtTop: false,
            ),
    );
  }
}
