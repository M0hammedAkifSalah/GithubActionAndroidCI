import 'package:flutter/material.dart';

import '../../export.dart';

class ActionByWidget extends StatefulWidget {
  final Activity activity;
  ActionByWidget(this.activity);

  @override
  _ActionByWidgetState createState() => _ActionByWidgetState();
}

class _ActionByWidgetState extends State<ActionByWidget> {
  List<String> completedBy = [];
  List<String> startedBy = [];
  List<String> notStartedBy = [];
  bool init = true;
  @override
  void initState() {
    completedBy = [];
    startedBy = [];
    notStartedBy = [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (init) {
      // getRespectiveStudents();
      init = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Actioned by',
          style: buildTextStyle(
            size: 18,
            weight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_rounded, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: widget.activity.assignTo.isNotEmpty
                ? buildAssignedStudentList()
                : widget.activity.assignToYou.isNotEmpty
                    ? buildAssignedTeacherList()
                    : buildAssignedParentList(),
          ),
        ),
      ),
    );
  }

  Widget buildAssignedStudentList() {
    getRespectiveStudents();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionWidget(
          title: 'Completed By',
          students: widget.activity.assignTo.where((stud) {
            bool present = false;
            for (var i in completedBy) {
              if (i == stud.studentId.id) return true;
            }
            return present;
          }).toList(),
          // remaining: widget.activity.assignTo.length - completedBy.length,
        ),
        _ActionWidget(
          title: 'Started By',
          students: widget.activity.assignTo.where((stud) {
            bool present = false;
            for (var i in startedBy) {
              if (i == stud.studentId.id) return true;
            }
            return present;
          }).toList(),
        ),
        _ActionWidget(
          title: 'Not Started By',
          students: widget.activity.assignTo.where((stud) {
            bool present = false;
            for (var i in notStartedBy) {
              if (i == stud.studentId.id) return true;
            }
            return present;
          }).toList(),
        ),
      ],
    );
  }

  Widget buildAssignedParentList() {
    getRespectiveParents();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionWidget(
          title: 'Completed By',
          students: widget.activity.assignToParent
              .where(
                (element) => completedBy.contains(element.parentId),
              )
              .toList(),
          // remaining:
          //     widget.activity.assignToParent.length - completedBy.length,
        ),
        _ActionWidget(
          title: 'Started By',
          students: widget.activity.assignToParent
              .where((element) => startedBy.contains(element.parentId))
              .toList(),
        ),
        _ActionWidget(
          title: 'Not Started By',
          students: widget.activity.assignToParent
              .where((element) => notStartedBy.contains(element.parentId))
              .toList(),
          // remaining: notStartedBy.length,
        ),
      ],
    );
  }

  Widget buildAssignedTeacherList() {
    getRespectiveTeachers();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ActionWidget(
          title: 'Completed By',
          students: widget.activity.assignToYou.where((stud) {
            bool present = false;
            for (var i in completedBy) {
              if (i == stud.teacherId) return true;
            }
            return present;
          }).toList(),
          // remaining:
          //     widget.activity.assignToYou.length - completedBy.length,
        ),
        _ActionWidget(
          title: 'Started By',
          students: widget.activity.assignToYou.where((stud) {
            bool present = false;
            for (var i in startedBy) {
              if (i == stud.teacherId) return true;
            }
            return present;
          }).toList(),
        ),
        _ActionWidget(
          title: 'Not Started By',
          // remaining: notStartedBy.length,
          students: widget.activity.assignToYou.where((stud) {
            bool present = false;
            for (var i in notStartedBy) {
              if (i == stud.teacherId) return true;
            }
            return present;
          }).toList(),
        ),
      ],
    );
  }

  void getRespectiveStudents({bool teacher = false}) {
    switch (widget.activity.activityType) {
      case 'Assignment':
        if (!teacher) {
          widget.activity.submitedBy.forEach((submit) {
            completedBy.add(submit.studentId);
          });
          widget.activity.assignmentStarted.forEach((start) {
            startedBy.add(start is String ? start : '');
          });
          widget.activity.assignTo.forEach((assign) {
            if (!completedBy.contains(assign.studentId.id) &&
                !startedBy.contains(assign.studentId.id))
              notStartedBy.add(assign.studentId.id);
          });
        } else {
          widget.activity.acknowledgeByTeacher.forEach((assign) {
            completedBy.add(assign.acknowledgeByTeacher);
          });
          // widget.activity.assignToYou.
        }
        break;
      case 'Announcement':
        widget.activity.acknowledgeBy.forEach((ack) {
          completedBy.add(ack.acknowledgeByStudent);
        });
        widget.activity.acknowledgeStartedBy.forEach((start) {
          startedBy.add(start is String ? start : '');
        });
        widget.activity.assignTo.forEach((assign) {
          if (!completedBy.contains(assign.studId.toString()) &&
              !startedBy.contains(assign.studId.toString()))
            notStartedBy.add(assign.studId.toString());
        });
        break;

      case 'LivePoll':
        widget.activity.selectedLivePoll.forEach((lvp) {
          completedBy.add(lvp.selectedBy);
        });
        widget.activity.assignTo.forEach((assign) {
          if (!completedBy.contains(assign.studentId.id) &&
              !startedBy.contains(assign.studentId.id))
            notStartedBy.add(assign.studentId.id);
        });
        break;
      case 'Check List':
        widget.activity.selectedCheckList.forEach((cl) {
          completedBy.add(cl.selectedBy);
        });
        widget.activity.assignTo.forEach((assign) {
          if (!completedBy.contains(assign.studentId.id) &&
              !startedBy.contains(assign.studentId.id))
            notStartedBy.add(assign.studentId.id);
        });
        break;
      case 'Event':
        widget.activity.going.forEach((ev) {
          completedBy.add(ev);
        });
        widget.activity.notGoing.forEach((ev) {
          completedBy.add(ev);
        });
        widget.activity.assignTo.forEach((assign) {
          if (!completedBy.contains(assign.studentId.id) &&
              !startedBy.contains(assign.studentId.id))
            notStartedBy.add(assign.studentId.id);
        });
        break;

      default:
    }
  }

  void getRespectiveTeachers({bool teacher = false}) {
    switch (widget.activity.activityType) {
      case 'Announcement':
        widget.activity.acknowledgeByTeacher.forEach((ack) {
          completedBy.add(ack.acknowledgeByTeacher);
        });
        // widget.activity.acknowledgeStartedBy.forEach((start) {
        //   startedBy.add(start is String ? start : '');
        // });
        widget.activity.assignToYou.forEach((assign) {
          if (!completedBy.contains(assign)) notStartedBy.add(assign.teacherId);
        });
        break;

      case 'LivePoll':
        widget.activity.selectedLivePoll.forEach((lvp) {
          completedBy.add(lvp.selectedByTeacher);
        });
        widget.activity.assignToYou.forEach((assign) {
          if (!completedBy.contains(assign)) notStartedBy.add(assign.teacherId);
        });
        break;
      case 'Check List':
        widget.activity.selectedCheckList.forEach((cl) {
          completedBy.add(cl.selectedByTeacher);
        });
        widget.activity.assignToYou.forEach((assign) {
          if (!completedBy.contains(assign)) notStartedBy.add(assign.teacherId);
        });
        break;
      case 'Event':
        widget.activity.goingByTeacher.forEach((ev) {
          completedBy.add(ev);
        });
        widget.activity.notGoingByTeacher.forEach((ev) {
          completedBy.add(ev);
        });
        widget.activity.assignToYou.forEach((assign) {
          if (!completedBy.contains(assign)) notStartedBy.add(assign.teacherId);
        });
        break;

      default:
    }
  }

  void getRespectiveParents({bool teacher = false}) {
    switch (widget.activity.activityType) {
      case 'Announcement':
        widget.activity.acknowledgeByParent.forEach((ack) {
          completedBy.add(ack.acknowledgeByParent);
        });
        // widget.activity.acknowledgeStartedBy.forEach((start) {
        //   startedBy.add(start is String ? start : '');
        // });
        widget.activity.assignToParent.forEach((assign) {
          if (!completedBy.contains(assign.parentId))
            notStartedBy.add(assign.parentId);
        });
        break;

      case 'LivePoll':
        widget.activity.selectedLivePoll.forEach((lvp) {
          completedBy.add(lvp.selectedByParent);
        });
        widget.activity.assignToParent.forEach((assign) {
          if (!completedBy.contains(assign.parentId))
            notStartedBy.add(assign.parentId);
        });
        break;
      case 'Check List':
        widget.activity.selectedCheckList.forEach((cl) {
          completedBy.add(cl.selectedByParent);
        });
        widget.activity.assignToParent.forEach((assign) {
          if (!completedBy.contains(assign.parentId))
            notStartedBy.add(assign.parentId);
        });
        break;
      case 'Event':
        widget.activity.goingByParent.forEach((ev) {
          completedBy.add(ev);
        });
        widget.activity.notGoingByParent.forEach((ev) {
          completedBy.add(ev);
        });
        widget.activity.assignToParent.forEach((assign) {
          if (!completedBy.contains(assign.parentId))
            notStartedBy.add(assign.parentId);
        });
        break;

      default:
    }
  }
}

class _ActionWidget extends StatelessWidget {
  const _ActionWidget({
    this.title,
    this.students,
    this.remaining,
  });
  final String title;
  final List<dynamic> students;
  final int remaining;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Text(
            title,
            style: buildTextStyle(
              size: 14,
              weight: FontWeight.w500,
            ),
          ),
          for (var student in students)
            ListTile(
              leading: TeacherProfileAvatar(
                imageUrl: student is AssignTo
                    ? student.studentId.profileImage ?? 'text'
                    : student is AssignToTeacher
                        ? student.profileImage ?? 'text'
                        : student.profileImage ?? 'text',
              ),
              title: Text(
                "${student.name}",
                style: buildTextStyle(
                  size: 15,
                ),
              ),
            ),
          if (remaining != null)
            Text(
              '$remaining remaining',
              style: buildTextStyle(
                color: Colors.grey[300],
                size: 12,
              ),
            ),
        ],
      ),
    );
  }
}
