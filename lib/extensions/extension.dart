import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/activity.dart';
import '../model/user.dart';

extension ExpandExtension on Widget {
  Expanded get expand => Expanded(
        flex: 1,
        child: this,
      );

  Expanded expandFlex(int flex) => Expanded(
        flex: flex,
        child: this,
      );
}

extension MarginExtension on Widget {
  Container get mv15 => Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: this,
      );

  Container margin({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
      );
}

extension Filters on List<Activity> {
  List<Activity> task(List<String> filters) => this.where((element) {
        if (filters.contains('All') || filters.isEmpty) return true;
        return filters.contains(element.activityType);
      }).toList();

  List<Activity> taskStatus(String status) => this.where((element) {
        return element.status.toLowerCase() == status.toLowerCase();
      }).toList();

  List<Activity> eventAndStatus({String status = ''}) => this.where((element) {
        if (element.activityType == 'Event') {
          if (status.isNotEmpty)
            return element.status.toLowerCase() == status.toLowerCase();
          else
            return true;
        }
        return false;
      }).toList();

  List<Activity> assignmentAndStatus({String status = ''}) =>
      this.where((element) {
        if (element.activityType == 'Assignment') {
          if (status.isNotEmpty)
            return element.status.toLowerCase() == status.toLowerCase();
          else
            return true;
        }
        return false;
      }).toList();

  List<Activity> sortByDate() {
    this.sort(
      (comp1, comp2) {
        print(comp1.dueDate == null || comp1.dueDate.isEmpty);
        if (comp1.dueDate != null && comp1.dueDate.isNotEmpty) {
          comp1.timeLeft =
              DateTime.parse(comp1.dueDate).compareTo(DateTime.now()) <= 0
                  ? 0
                  : DateTime.parse(comp1.dueDate).day - DateTime.now().day;
          print(comp1.timeLeft);
        }
        return DateTime.now().compareTo(
          comp1.createdAt,
        );
        // return -1;
      },
    );
    return this;
  }
}

extension LivePollPercent on Option {
  double getPercent(List<SelectedOptions> listSubmitted) {
    List<SelectedOptions> single = listSubmitted.where((submitted) {
      if (submitted.options[0] == this.text)
        return true;
      else
        return false;
    }).toList();
    return (single.length /
            (listSubmitted.length == 0 ? 1 : listSubmitted.length))
        .toDouble();
  }
}

class TaskProgress {
  int started;
  int completed;
  int going;
  int notGoing;
  TaskProgress({this.started, this.completed, this.going, this.notGoing});
}

extension Progress on List<Activity> {
  TaskProgress getAnnouncementProgress(StudentInfo student) {
    int completed = 0;
    int started = 0;
    for (var activity in this) {
      if (activity.acknowledgeStartedBy.contains(student.id)) started++;
      if (activity.acknowledgeBy.contains(student.id)) completed++;
    }
    return TaskProgress(completed: completed, started: started);
  }

  TaskProgress getAssignmentProgress(StudentInfo student) {
    int completed = 0;
    int started = 0;
    for (var activity in this) {
      if (activity.assignmentStarted.contains(student.id)) started++;
      for (var submit in activity.submitedBy)
        if (submit.studentId == student.id) completed++;
    }
    return TaskProgress(completed: completed, started: started);
  }

  TaskProgress getEventProgress(StudentInfo student) {
    int going = 0;
    int notGoing = 0;
    for (var activity in this) {
      if (activity.notGoing.contains(student.id)) going++;
      if (activity.going.contains(student.id)) going++;
    }
    return TaskProgress(going: going, notGoing: notGoing);
  }

  TaskProgress getLivePollProgress(StudentInfo student) {
    int completed = 0;
    int started = 0;
    for (var activity in this) {
      for (var select in activity.selectedLivePoll) {
        if (select.selectedBy == student.id) completed++;
      }
    }
    return TaskProgress(completed: completed, started: started);
  }

  TaskProgress getCheckListProgress(StudentInfo student) {
    int completed = 0;
    int started = 0;
    for (var activity in this) {
      for (var select in activity.selectedCheckList) {
        if (select.selectedBy == student.id &&
            select.options.length == activity.options.length) completed++;
      }
    }
    return TaskProgress(completed: completed, started: started);
  }
}

extension ProgressTeacher on List<Activity> {
  TaskProgress getAnnouncementProgressTeacher(UserInfo student) {
    int completed = 0;
    int started = 0;
    for (var activity in this) {
      // if (activity.acknowledgeStartedBy.contains(student.id)) started++;
      if (activity.acknowledgeByTeacher.contains(student.id)) completed++;
    }
    return TaskProgress(completed: completed, started: started);
  }

  TaskProgress getEventProgressTeacher(UserInfo student) {
    int going = 0;
    int notGoing = 0;
    for (var activity in this) {
      if (activity.notGoingByTeacher.contains(student.id)) going++;
      if (activity.goingByTeacher.contains(student.id)) going++;
    }
    return TaskProgress(going: going, notGoing: notGoing);
  }

  TaskProgress getLivePollProgressTeacher(UserInfo student) {
    int completed = 0;
    int started = 0;
    for (var activity in this) {
      for (var select in activity.selectedLivePoll) {
        if (select.selectedByTeacher != null) if (select.selectedByTeacher ==
            student.id) completed++;
      }
    }
    return TaskProgress(completed: completed, started: started);
  }

  TaskProgress getCheckListProgressTeacher(UserInfo student) {
    int completed = 0;
    int started = 0;
    for (var activity in this) {
      for (var select in activity.selectedCheckList) {
        if (select.selectedByTeacher == student.id &&
            select.options.length == activity.options.length) completed++;
      }
    }
    return TaskProgress(completed: completed, started: started);
  }
}

extension StringExtension on String {
  String toTitleCase() {
    if (this == null) return 'null';
    if (this.isNotEmpty) return this[0].toUpperCase() + this.substring(1);
    return this;
  }

  String get secondsToHours {
    int seconds = int.parse(this);
    int mins = ((seconds % 3600) ~/ 60);
    int hours = (seconds ~/ 3600);
    return '$hours hr $mins min';
  }

  Widget get convertToHyperLink {
    var list = this.split(RegExp(r'[ ]|\n'));
    // print('List-after-split: $list');
    var link = list.where((element) => element.startsWith('https://')).toList();
    for (var i in link) {
      list.remove(i);
    }
    // print('List-after-split-link: $list');
    return Column(children: [
      Text("${list.join(' ')}"),
      for (var i in link)
        TextButton(
          child: Text(i),
          onPressed: () {
            launch(i);
          },
        ),
    ]);
  }
}

extension DateAndTimeFormat on DateTime {
  String toDateTimeFormat(BuildContext context) {
    if (this == null) return '';
    return "${DateFormat('dd MMM yyyy').format(this)}\n${TimeOfDay.fromDateTime(this).format(context)}";
  }
}

extension DateAndTimeFormatInLine on DateTime {
  String toDateTimeFormatInLine(BuildContext context) {
    if (this == null) return '';
    return "${DateFormat('dd MMM yyyy').format(this)},  ${TimeOfDay.fromDateTime(this).format(context)}";
  }
}
