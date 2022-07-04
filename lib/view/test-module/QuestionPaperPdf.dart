// import 'dart:io';
//
// import 'package:ext_storage/ext_storage.dart';
// import 'package:flutter/cupertino.dart' as cupertino;
// import 'package:flutter/material.dart' as material;
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart' as widgets;
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:open_file/open_file.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:growonplus_teacher/model/test-model.dart';
//
// class QuestionPaperPDF extends material.StatelessWidget {
//   const QuestionPaperPDF({cupertino.Key key,this.questionPaper}) : super(key: key);
//
//   final QuestionPaper questionPaper;
//   @override
//   material.Widget build(cupertino.BuildContext context) {
//     return material.Container();
//   }
//   Future<String> saveFile(doc, {String filename}) async {
//     String path = '';
//     try {
//       if (Platform.isAndroid) {
//         if (await _requestPermission(Permission.storage)) {
//           path = await ExtStorage.getExternalStoragePublicDirectory(
//               ExtStorage.DIRECTORY_DOCUMENTS);
//         } else {
//           return '';
//         }
//       } else {
//         return '';
//       }
//       final file = File('$path/$filename.pdf');
//       await file.writeAsBytes(await doc.save());
//       return file.path;
//     } catch (e) {
//       print(e);
//     }
//     return '';
//   }
//
//   Future<bool> _requestPermission(Permission permission) async {
//     if (await permission.isGranted) {
//       return true;
//     } else {
//       var result = await permission.request();
//       if (result == PermissionStatus.granted) {
//         return true;
//       }
//     }
//     return false;
//   }
//
//   Future createQuestionPaperPDF(material.BuildContext context) async
//   {
//     var pageTheme = ThemeData.withFont(
//       base: Font.ttf(await rootBundle.load("assets/fonts/Poppins-Regular.ttf")),
//       bold:
//       Font.ttf(await rootBundle.load("assets/fonts/Poppins-SemiBold.ttf")),
//       italic:
//       Font.ttf(await rootBundle.load("assets/fonts/Poppins-Italic.ttf")),
//       boldItalic: Font.ttf(
//           await rootBundle.load("assets/fonts/Poppins-SemiBoldItalic.ttf")),
//     );
//     var doc = Document(theme: pageTheme, pageMode: PdfPageMode.fullscreen);
//     doc.addPage(
//       MultiPage(
//         orientation: PageOrientation.portrait,
//         margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
//         pageFormat: PdfPageFormat.a4,
//         footer: (Context context) => Align(
//           alignment: Alignment.centerRight,
//           child: Text(
//             "Page ${context.pageNumber}/${context.pagesCount}",
//             style: const TextStyle(
//               fontSize: 12,
//               color: PdfColors.black,
//             ),
//           ),
//         ),
//         build: (Context contextA) => [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // SvgImage(svg: logo, width: 50, height: 50),
//               SizedBox(width: 8.0),
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     TextSpan(
//                       text: "9.",
//                       style: TextStyle(
//                         color: PdfColors.black,
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.normal,
//                         letterSpacing: 0,
//                       ),
//                     ),
//                     TextSpan(
//                       text: "8",
//                       style: TextStyle(
//                         color: PdfColor.fromHex("FFC30A"),
//                         fontSize: 20.0,
//                         fontWeight: FontWeight.bold,
//                         fontStyle: FontStyle.normal,
//                         letterSpacing: 0,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 15.0),
//            Container(
//               padding: EdgeInsets.all(10),
//               height: material.MediaQuery.of(context).size.height * 0.25,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(40)),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                  ListTile(
//                       leading: TeacherProfileAvatar(),
//                       title: Text('Created By'),
//                       subtitle: Text(
//                           '${widget.questionPaper.createdBy ?? state.user.name}'),
//                       trailing: Column(
//                         children: [
//                           Container(
//                             height: 20,
//                             width: 100,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               // border: Border.all(
//                               //     width: 0, color: Colors.black)
//                             ),
//                             child: Text(
//                                 'Marks : ${getTotal().toString()}'
//                               // 'Marks : ${widget.questionPaper.section[0].section[0] != null ? widget.questionPaper.section[0].section.fold(0, (previousValue, element) {
//                               //     previousValue + element.totalMarks;
//                               //     log('prev ' +
//                               //         previousValue.toString() +
//                               //         ' element ' +
//                               //         element.totalMarks.toString());
//                               //   }) : '0'}'
//                             ),
//                           ),
//                           Container(
//                             height: 36,
//                             width: 100,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               // border: Border.all(
//                               //     width: 0, color: Colors.black)
//                             ),
//                             child: Text(
//                                 'Coins : ${widget.questionPaper.coin} \nRewards : ${widget.questionPaper.award}'),
//                           ),
//                         ],
//                       )
//                     // Container(
//                     //   height: 100,
//                     //   width: 120,
//                     //   alignment: Alignment.center,
//                     //   decoration: BoxDecoration(
//                     //       border: Border.all(
//                     //           width: 1, color: Colors.black)),
//                     //   child: Text(
//                     //       'Date\n${widget.questionPaper.startDate.toDateTimeFormat(context)}'),
//                     // ),
//                   ),
//                   Spacer(),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   'Question Title:  ',
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                                 Container(
//                                   width: 195,
//                                   alignment: Alignment.bottomCenter,
//                                   decoration: BoxDecoration(
//                                       border: Border(
//                                           bottom:
//                                           BorderSide(width: 1))),
//                                   child: Text(
//                                       '${widget.questionPaper.questionTitle}'),
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             Row(
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Class:  ',
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                     Container(
//                                       width: 50,
//                                       alignment: Alignment.bottomCenter,
//                                       decoration: BoxDecoration(
//                                           border: Border(
//                                               bottom: BorderSide(
//                                                   width: 1))),
//                                       child: Text(
//                                           '${widget.questionPaper.detailQuestionPaper.className}'),
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Row(
//                                   children: [
//                                     Text('Subject:  ',
//                                         style: TextStyle(fontSize: 16)),
//                                     Container(
//                                       alignment: Alignment.bottomCenter,
//                                       // width: 100,
//                                       decoration: BoxDecoration(
//                                           border: Border(
//                                               bottom: BorderSide(
//                                                   width: 1))),
//                                       child: Text(
//                                           '${widget.questionPaper.detailQuestionPaper.subject.first.name}'),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         // Column(
//                         //   children: [
//                         //     Container(
//                         //       height: 50,
//                         //       width: 100,
//                         //       alignment: Alignment.center,
//                         //       decoration: BoxDecoration(
//                         //           // border: Border.all(
//                         //           //     width: 0, color: Colors.black)
//                         //           ),
//                         //       child: Text(
//                         //           'Marks : ${widget.questionPaper.section[0].section.fold(
//                         //         0,
//                         //         (previousValue, element) =>
//                         //             previousValue +
//                         //             element.totalMarks +
//                         //             element.questions.fold(
//                         //                 0,
//                         //                 (previousValue2, element2) =>
//                         //                     previousValue2 +
//                         //                     element2.totalMarks),
//                         //       )}'),
//                         //     ),
//                         //     Container(
//                         //       height: 50,
//                         //       width: 100,
//                         //       alignment: Alignment.center,
//                         //       decoration: BoxDecoration(
//                         //           // border: Border.all(
//                         //           //     width: 0, color: Colors.black)
//                         //           ),
//                         //       child: Text(
//                         //           'Coins : ${widget.questionPaper.coin} \nRewards : ${widget.questionPaper.award}'),
//                         //     ),
//                         //   ],
//                         // )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
// }
//
//
//
