import 'package:flutter/material.dart';

import '../../const.dart';
import '../../model/user.dart';
import '../homepage/home_sliver_appbar.dart';

class SelectedStudent extends StatefulWidget {
  final Function(List<StudentInfo>) onSelected;
  final List<StudentInfo> selectedStudents;

  const SelectedStudent(
      {Key key, @required this.onSelected, @required this.selectedStudents})
      : super(key: key);

  @override
  _SelectedStudentState createState() => _SelectedStudentState();
}

class _SelectedStudentState extends State<SelectedStudent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Selected Students',
          style: buildTextStyle(weight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: widget.selectedStudents.isEmpty
          ? Center(
              child: Text("No Students Selected"),
            )
          : ListView.builder(
              itemCount: widget.selectedStudents.length,
              itemBuilder: (builder, index) {
                var student = widget.selectedStudents[index];
                return ListTile(
                  onTap: () {
                    if (!widget.selectedStudents.contains(student))
                      widget.selectedStudents.add(student);
                    else
                      widget.selectedStudents.remove(student);
                    setState(() {});
                    widget.onSelected(widget.selectedStudents);
                  },
                  title: Text('${student.name}'),
                  subtitle: Text(
                      "${student.className ?? ''} ${student.sectionName ?? ''}"),
                  leading: TeacherProfileAvatar(
                    imageUrl: student.profileImage ?? 'test',
                  ),
                  trailing: Icon(Icons.delete),
                );
              },
            ),
    );
  }
}
