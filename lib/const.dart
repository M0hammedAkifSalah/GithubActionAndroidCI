import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';


TextStyle buildTextStyle({
  String family,
  double size,
  FontWeight weight,
  Color color,
  bool underline = false,
}) =>
    TextStyle(
      fontFamily: family ?? 'Poppins',
      color: color ?? Colors.black,
      fontWeight: weight ?? FontWeight.normal,
      fontSize: size ?? 18,
      decoration: underline ? TextDecoration.underline : TextDecoration.none,
      decorationColor: Colors.yellow,
      decorationThickness: 3,
    );

// const FILE_URL = 'https://grow-on.s3.ap-south-1.amazonaws.com/';
Future<T> buildShowDialogue<T>(BuildContext context) {
  return showDialog<T>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Please add at least 1 option'),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        )
      ],
    ),
  );
}

bool threadCheck(String userId, String teacherId) {
  return userId == teacherId;
}

const List<String> allowedExtensions = [
  'mp3',
  'mp4',
  'docx',
  'xlsx',
  'png',
  'jpg',
  'jpeg',
  'pdf',
  'ppt',
  'pptx',
  'doc',
  'xlsx'
];

const List<String> imageExtension = [
  "jpg",
  "jpeg",
  "png",
];

const List<String> videoExtension = [
  "mp4",
  "mp3",
];

const List<String> documentExtension = [
  'pdf',
  'ppt',
  'pptx',
  'doc',
  'xlsx',
  'docx',
];

Future<String> getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}
