import 'package:flutter/material.dart';
import '/const.dart';

Column buildSubmissionIndicator(
    {String title, Color color, bool fill = false}) {
  return Column(
    children: [
      CircleAvatar(
        radius: fill ? 11 : 15,
        backgroundColor: color ?? Color(0xff6FCF97),
        child: CircleAvatar(
          radius: 8,
          backgroundColor: fill ? color ?? Color(0xff6FCF97) : Colors.white,
        ),
      ),
      if (!fill)
        SizedBox(
          height: 7,
        ),
      if (!fill)
        Text(
          title ?? 'Submitted',
          style: buildTextStyle(
            size: 12,
            weight: FontWeight.bold,
          ),
        ),
      if (!fill)
        SizedBox(
          height: 15,
        ),
    ],
  );
}

Color kSubmitIndicator(bool fill) {
  return Color(0xff6FCF97);
  buildSubmissionIndicator(fill: fill);
}

Color kLateSubmitIndicator(bool fill) {
  return Color(0xffFDA429);
  buildSubmissionIndicator(
    color: Color(0xffFDA429),
    title: 'Late Submitted',
    fill: fill,
  );
}

Color kNoSubmitIndicator(bool fill) {
  return Color(0xffEB5757);
  buildSubmissionIndicator(
    color: Color(0xffEB5757),
    title: 'Not Submitted',
    fill: fill,
  );
}

Color getRespectiveIndicator(bool submitted, bool lateSubmission) {
  if (lateSubmission)
    return kLateSubmitIndicator(true);
  else if (submitted)
    return kSubmitIndicator(true);
  else
    return kNoSubmitIndicator(true);
}
