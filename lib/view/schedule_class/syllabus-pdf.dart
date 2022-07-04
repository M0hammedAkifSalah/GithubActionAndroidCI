import 'dart:io';

// import 'package:ext_storage/ext_storage.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../model/class-schedule.dart';

class SyllabusPdf {
  Future createSyllabusPdf(
      material.BuildContext context, DateTime fromDate, DateTime toDate,
      {List<ScheduledClassTask> classes}) async {
    var days = toDate.difference(fromDate).inDays + 1;
    var weeks = (days / DateTime.daysPerWeek).round();
    print("no. of days :$days");
    print("no. of weeks :$weeks");

    var pageTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/Poppins-Regular.ttf")),
      bold:
          Font.ttf(await rootBundle.load("assets/fonts/Poppins-SemiBold.ttf")),
      italic:
          Font.ttf(await rootBundle.load("assets/fonts/Poppins-Italic.ttf")),
      boldItalic: Font.ttf(
          await rootBundle.load("assets/fonts/Poppins-SemiBoldItalic.ttf")),
    );
    var doc = Document(theme: pageTheme, pageMode: PdfPageMode.outlines);
    for (var week = 0; week < weeks; week++) {
      DateTime startDateTime = fromDate.add(Duration(days: 7 * week));
      List<String> weekDay = [];
      weekDay.insert(0, "Time");
      while (startDateTime.weekday != DateTime.sunday) {
        weekDay.add("${DateFormat("EEEE\ndd-MM-yyyy").format(startDateTime)}");
        startDateTime = startDateTime.add(Duration(days: 1));
      }
      startDateTime = startDateTime.subtract(Duration(days: 7));
      List<ScheduledClassTask> classesOfWeek = classes
          .where((element) =>
              element.startTime.isAfter(startDateTime) &&
              element.startTime.isBefore(startDateTime.add(Duration(days: 7))))
          .toList();
      List<List<String>> allItems = [];
      List<String> items = [];
      material.TimeOfDay startTime = material.TimeOfDay(hour: 8, minute: 0);
      for (int j = 0; j < 9; j++) {
        items.clear();
        items.insert(0,
            "${startTime.format(context)}\nto\n${startTime.replacing(hour: startTime.hour + 1).format(context)}");
        for (int day = 1; day < DateTime.daysPerWeek; day++) {
          items.add(classesOfWeek
              .where((element) {
                var time = material.TimeOfDay(
                    hour: element.startTime.hour,
                    minute: element.startTime.minute);
                if (element.startTime.weekday == day &&
                    (time.hour >= startTime.hour &&
                        time.minute >= startTime.minute) &&
                    time.hour < startTime.hour + 1) {
                  return true;
                }
                return false;
              })
              .map((e) =>
                  "${DateFormat("hh:mm a").format(e.startTime)}\n${e.subjectName}")
              .join("\n\n"));
        }
        allItems.add(items.toList());
        startTime = startTime.replacing(hour: startTime.hour + 1);
      }
      doc.addPage(
        MultiPage(
          orientation: PageOrientation.landscape,
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          pageFormat: PdfPageFormat.a4,
          footer: (Context context) => Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Page ${context.pageNumber}/${context.pagesCount}",
              style: const TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ),
          build: (Context context) => [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 8.0),
                SvgImage(svg: 'assets/images/GrowON.png')
                // RichText(
                //   text: TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "9.",
                //         style: TextStyle(
                //           color: PdfColors.black,
                //           fontSize: 20.0,
                //           fontWeight: FontWeight.bold,
                //           fontStyle: FontStyle.normal,
                //           letterSpacing: 0,
                //         ),
                //       ),
                //       TextSpan(
                //         text: "8",
                //         style: TextStyle(
                //           color: PdfColor.fromHex("FFC30A"),
                //           fontSize: 20.0,
                //           fontWeight: FontWeight.bold,
                //           fontStyle: FontStyle.normal,
                //           letterSpacing: 0,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 15.0),
            Table.fromTextArray(
              context: context,
              headers: weekDay,
              headerStyle: TextStyle(
                color: PdfColors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
              headerDecoration: BoxDecoration(color: PdfColors.grey300),
              data: allItems,
              border: TableBorder.all(color: PdfColors.black),
              cellAlignment: Alignment.center,
              cellStyle: TextStyle(
                color: PdfColors.black,
                fontSize: 8.0,
              ),
            ),
          ],
        ),
      );
    }
    String savedFilePath = await saveFile(doc,
        filename:
            "class_timetable_${DateFormat("dd-MM-yyyy").format(fromDate)}to${DateFormat("dd-MM-yyyy").format(toDate)}");
    if (savedFilePath.isNotEmpty) {
      OpenFile.open(savedFilePath);
    } else {
      Fluttertoast.showToast(msg: "Couldn't save");
    }
  }

  Future<String> saveFile(doc, {String filename}) async {
    String path = '';
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          path = await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOCUMENTS);
        } else {
          return '';
        }
      } else {
        return '';
      }
      final file = File('$path/$filename.pdf');
      await file.writeAsBytes(await doc.save());
      return file.path;
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  material.Widget getLogo() {
    return material.Image.asset('assets/images/GrowON.png');
  }
}
