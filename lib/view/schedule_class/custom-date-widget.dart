import 'package:date_picker_timeline/gestures/tap.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWidget extends StatelessWidget {
  final double width;
  final DateTime date;
  final TextStyle monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback onDateSelected;
  final String locale;
  final bool isClassToday;

  DateWidget({
    @required this.date,
    @required this.monthTextStyle,
    @required this.dayTextStyle,
    @required this.dateTextStyle,
    @required this.selectionColor,
    @required this.isClassToday,
    this.width,
    this.onDateSelected,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: width,
        height: 25,
        margin: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: selectionColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                   DateFormat("E", locale)
                      .format(date)
                      .substring(0, 1)
                      .toUpperCase(), // WeekDay
                  style: dayTextStyle),
              Text(date.day.toString(), // Date
                  style: dateTextStyle),
              if (isClassToday)
                CircleAvatar(
                  backgroundColor: Color(0xffDADADA),
                  radius: 4,
                )
            ],
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected(this.date);
        }
      },
    );
  }
}
