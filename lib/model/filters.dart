import 'package:flutter/cupertino.dart';

class EventFilter with ChangeNotifier {
  bool checked;
  String status;
  EventFilter({this.checked = false, this.status = 'Pending'});
  void resetFilter() {
    this.checked = false;
    this.status = 'Pending';
    notifyListeners();
  }
}

class AssignmentFilter with ChangeNotifier {
  bool checked;
  String status;
  bool submitStatus;
  AssignmentFilter({
    this.checked = false,
    this.status = 'Pending',
    this.submitStatus = false,
  });
  void resetFilter() {
    this.checked = false;
    this.status = 'Pending';
    this.submitStatus = false;
    notifyListeners();
  }
}

class Doubts with ChangeNotifier {
  String status;
  Doubts({this.status = 'No Doubts'});
  void resetFilter() {
    this.status = 'No Doubts';
    notifyListeners();
  }
}

class TasksFilter with ChangeNotifier {
  List<String> filter = ['All'];
  bool switchStatus;
  String status;
  TasksFilter({
    this.status = 'No Doubts',
    this.switchStatus = false,
  });
  void resetFilter() {
    this.switchStatus = false;
    this.status = 'Pending';
    this.filter = ['All'];
    notifyListeners();
  }
}
