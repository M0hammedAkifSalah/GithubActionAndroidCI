import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '/export.dart';

GlobalKey<FormState> form = GlobalKey<FormState>();
File image;
DateTime _date;

DateTime _startDate;
DateTime _endDate;
TimeOfDay _time;

class CreateEvent extends StatefulWidget {
  final String taskName;
  CreateEvent({this.taskName});
  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  EventTask eventTask;

  @override
  void initState() {
    image = null;
    _date = null;
    _startDate = null;
    _endDate = null;
    _time = null;
    super.initState();
    eventTask = EventTask();
  }

  _showDialogue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Please provide dates'),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (eventTask.description == null && eventTask.title == null) {
          return true;
        }
        return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure to go back?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'),
                )
              ],
            );
          },
        );
        // if (check) {
        //   Navigator.of(context).pop();
        // }
      },
      child: Scaffold(
        bottomNavigationBar: CustomBottomBar(
          title: 'Assign',
          check: _endDate != null && _startDate != null && _time != null,
          onPressed: () {
            setState(() {});
            if (_date != null && _startDate != null && _endDate != null) {
              if (form.currentState.validate()) {
                eventTask.endDate = DateFormat('yyyy-MM-dd').format(_endDate);
                eventTask.startDate =
                    DateFormat('yyyy-MM-dd').format(_startDate);
                eventTask.dueDate = DateFormat('yyyy-MM-dd').format(_date);
                var _dateTime = DateTime(
                  _endDate.year,
                  _endDate.month,
                  _endDate.day,
                  _time.hour,
                  _time.minute,
                );
                eventTask.endTime = _dateTime.toIso8601String();

                print('pressed');
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: MultiBlocProvider(
                      providers: [
                        BlocProvider<GroupCubit>(
                          create: (context) => GroupCubit()..loadGroups(),
                        ),
                      ],
                      child: AssignTask(
                        files: [],
                        // image: image,
                        task: eventTask,
                        title: 'Event',
                        isJoinedClass: false,
                      ),
                    ),
                  ),
                );
              }
            } else
              _showDialogue();
          },
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () async {
              if (eventTask.description == null && eventTask.title == null) {
                Navigator.of(context).pop();
                return null;
              }
              bool check = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure to go back?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No'),
                      )
                    ],
                  );
                },
              );
              if (check) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            'Event',
            style: buildTextStyle(
              size: 15,
              weight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Spacer(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    // alignment: Alignment.bottomCenter,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 5,
                          blurRadius: 5,
                        )
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: EventWidget(
                      eventTask: eventTask,
                      onChanged: (value) {
                        setState(() {});
                      },
                      editable: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EventWidget extends StatefulWidget {
  const EventWidget({
    Key key,
    this.activity,
    this.editable = true,
    this.eventTask,
    this.onChanged,
  }) : super(key: key);

  final EventTask eventTask;
  final bool editable;
  final Activity activity;
  final Function(String value) onChanged;

  @override
  _EventWidgetState createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  String type = 'online';
  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please provide a value';
  }

  bool _isEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: form,
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.editable ? '' : widget.activity.title,
              enabled: widget.editable,
              maxLength: null,
              maxLines: null,
              validator: (value) {
                widget.eventTask.title = value;
                return validator(value);
              },
              decoration: InputDecoration(
                labelText: 'title of event'.toUpperCase(),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
              ),
            ),
            Container(
              // height: 48,
              margin: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/points.png',
                        height: 20,
                        width: 20,
                      ),
                      TextFormField(
                        initialValue: widget.editable
                            ? ''
                            : widget.activity.coin.toString(),
                        enabled: widget.editable,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (int.tryParse(value) == null) {
                            setState(() {
                              _isEmpty = true;
                            });
                            return 'Please provide a value';
                          }
                          widget.eventTask.coin = int.parse(value);
                          return validator(value);
                        },
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(width: 2),
                          ),
                          hintText: 'Coins',
                          hintStyle: buildTextStyle(
                            size: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ).expandFlex(_isEmpty ? 6 : 1),
                      Spacer(flex: 5),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LAST DATE FOR SUBMISSION',
                    style: buildTextStyle(size: 15, color: Colors.grey),
                  ),
                  if (!widget.editable)
                    Text(
                      DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(
                              widget.activity.dueDate)) ?? '',
                      style: buildTextStyle(),
                    ),
                  if (_date == null && widget.editable)
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        _date = await _pickDate(_date);
                        setState(() {});
                      },
                    ),
                  if (_date != null && widget.editable)
                    FlatButton.icon(
                      icon: Icon(
                        Icons.edit,
                        size: 10,
                      ),
                      onPressed: () async {
                        _date = await _pickDate(_date);
                        setState(() {});
                      },
                      label: Text(
                        DateFormat("d MMM").format(_date),
                      ),
                    )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'LAST TIME FOR SUBMISSION',
                    style: buildTextStyle(size: 15, color: Colors.grey),
                  ),
                  if (!widget.editable)
                    Text(
                      TimeOfDay.fromDateTime(widget.activity.endDateTime)
                              .format(context) ??
                          '',
                      style: buildTextStyle(),
                    ),
                  if (_time == null && widget.editable)
                    IconButton(
                      icon: Icon(Icons.timelapse),
                      onPressed: _pickTime,
                    ),
                  if (_time != null && widget.editable)
                    FlatButton.icon(
                      icon: Icon(
                        Icons.edit,
                        size: 10,
                      ),
                      onPressed: _pickTime,
                      label: Text(
                        _time.format(context),
                      ),
                    )
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TYPE',
                  style: buildTextStyle(size: 15, color: Colors.grey),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    FilterChip(
                      label: Text('On-Location'),
                      onSelected: !widget.editable
                          ? null
                          : (value) {
                              type = 'on-location';
                              setState(() {});
                            },
                      checkmarkColor: Color(0xffFFC30A),
                      disabledColor: Colors.grey[500],
                      selected: type == 'on-location',
                      selectedColor: Color(0xff261739),
                      labelStyle: buildTextStyle(
                        color: type == 'on-location'
                            ? Color(0xffFFC30A)
                            : Colors.white,
                        size: 16,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    FilterChip(
                      label: Text('On-line'),
                      onSelected: !widget.editable
                          ? null
                          : (value) {
                              type = 'online';
                              setState(() {});
                            },
                      disabledColor: Colors.grey[500],
                      selected: type == 'online',
                      checkmarkColor: Color(0xffFFC30A),
                      selectedColor: Color(0xff261739),
                      labelStyle: buildTextStyle(
                        color:
                            type == 'online' ? Color(0xffFFC30A) : Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            TextFormField(
              initialValue: widget.editable ? '' : widget.activity.locations,
              enabled: widget.editable,
              validator: (value) {
                widget.eventTask.location = value;
                return validator(value);
              },
              decoration: InputDecoration(
                alignLabelWithHint: true,
                border: UnderlineInputBorder(),
                labelText: 'LOCATION',
                labelStyle: buildTextStyle(
                  size: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: widget.editable
                        ? () async {
                            _startDate = await _pickDate(_startDate);
                            setState(() {});
                          }
                        : null,
                    child: _dropdownMenu(
                      !widget.editable
                          // ? widget.activity.startDate ?? ''
                    ?  DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(
                              widget.activity.startDate)) ?? ''
                          : _startDate == null
                              ? 'START DATE'
                              : DateFormat('d/MM/yyyy').format(_startDate),
                      icon: Icons.watch_later_outlined,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: widget.editable
                        ? () async {
                            _endDate = await _pickDate(_endDate);
                            setState(() {});
                          }
                        : null,
                    child: _dropdownMenu(
                      !widget.editable
                          // ? widget.activity.endDate ?? ''
                     ? DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(
                              widget.activity.endDate)) ?? ''
                          : _endDate == null
                              ? 'END DATE'
                              : DateFormat('d/MM/yyyy').format(_endDate),
                      icon: Icons.watch_later_outlined,
                    ),
                  ),
                )
              ],
            ),
            TextFormField(
              initialValue: widget.editable ? '' : widget.activity.description,
              enabled: widget.editable,
              onChanged: widget.onChanged,
              validator: (value) {
                widget.eventTask.description = value;
                return validator(value);
              },
              maxLines: !widget.editable ? null : 4,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                border: UnderlineInputBorder(),
                labelText: 'DESCRIPTION',
                labelStyle: buildTextStyle(
                  size: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            if (!widget.editable)
              ListTile(
                title: Text(
                  '',
                  style: buildTextStyle(size: 18, weight: FontWeight.bold),
                ),
              ),
            if (!widget.editable) eventList(),
            // KeyboardVisibilityBuilder(
            //   builder: (ctx, isKeyboardVisible) => SizedBox(
            //     height: isKeyboardVisible ? 350 : 0,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Container _dropdownMenu(
    String title, {
    IconData icon = Icons.expand_more,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey[500],
          ),
        ),
      ),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          SizedBox(
            width: 40,
          ),
          Text(
            title,
            style: buildTextStyle(
              size: 12,
              color: Colors.grey[500],
            ),
          )
        ],
      ),
    );
  }

  void _pickTime() async {
    TimeOfDay _td = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_td != null) _time = _td;
    setState(() {});
  }

  Future<DateTime> _pickDate(DateTime date) async {
    DateTime _date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 90),
      ),
    );
    if (_date != null) return _date;
    return date;
  }

  Widget eventList() {
    switch (widget.activity.assigned) {
      case (Assigned.student):
        return eventByStudent();
      case (Assigned.parent):
        return eventByParent();
      case (Assigned.faculty):
        return eventByTeacher();

        break;
      default:
        return eventByStudent();
    }
  }

  Widget eventByStudent() {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.activity.going.length,
          itemBuilder: (context, index) {
            var _student = widget.activity.assignTo.firstWhere(
                (student) => student.studentId.id == widget.activity.going[index]);
            return ListTile(
              subtitle: Text(
                  "Class : ${_student.className ?? ''} ${(_student.sectionName != 'no name') ? _student.sectionName : ''}"),
              leading: TeacherProfileAvatar(
                imageUrl: _student.profileImage ?? 'text',
              ),
              title: Text(
                '${_student.name}',
                style: buildTextStyle(
                  size: 16,
                  // weight: FontWeight.bold,
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Going',
                  style: buildTextStyle(color: Colors.blue, size: 12),
                ),
              ),
            );
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.activity.notGoing.length,
          itemBuilder: (context, index) {
            var _student = widget.activity.assignTo.firstWhere((student) =>
                student.studentId.id == widget.activity.notGoing[index]);
            return ListTile(
              subtitle: Text(
                  "Class : ${_student.className ?? ''} ${(_student.sectionName != 'no name') ? _student.sectionName : ''}"),
              leading: TeacherProfileAvatar(
                imageUrl: _student.profileImage ?? 'text',
              ),
              title: Text(
                '${_student.name}',
                style: buildTextStyle(
                  size: 16,
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Not Going',
                  style: buildTextStyle(color: Colors.blue, size: 12),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget eventByTeacher() {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.activity.assignToYou
              .where((element) => !['pending', 'not going']
                  .contains(element.status.toLowerCase()))
              .length,
          itemBuilder: (context, index) {
            var _teacher = widget.activity.assignToYou.firstWhere(
              (student) =>
                  widget.activity.goingByTeacher[index] == student.teacherId,
            );
            return ListTile(
              leading: TeacherProfileAvatar(
                imageUrl: _teacher.profileImage ?? 'text',
              ),
              title: Text(
                '${_teacher.name}',
                style: buildTextStyle(
                  size: 16,
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Going',
                  style: buildTextStyle(color: Colors.blue, size: 12),
                ),
              ),
            );
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.activity.assignToYou
              .where((element) =>
                  !['pending', 'going'].contains(element.status.toLowerCase()))
              .length,
          itemBuilder: (context, index) {
            var _teacher = widget.activity.assignToYou.firstWhere(
              (student) =>
                  widget.activity.notGoingByTeacher[index] == student.teacherId,
            );
            return ListTile(
              title: Text(
                '${_teacher.name}',
                style: buildTextStyle(
                  size: 16,
                ),
              ),
              leading: TeacherProfileAvatar(
                imageUrl: _teacher.profileImage,
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Not Going',
                  style: buildTextStyle(color: Colors.blue, size: 12),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget eventByParent() {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.activity.goingByParent.length,
          itemBuilder: (context, index) {
            var _parent = widget.activity.assignToParent.firstWhere((element) =>
                widget.activity.goingByParent.contains(element.parentId));
            return ListTile(
              title: Text(
                '${_parent.name}',
                style: buildTextStyle(
                  size: 16,
                  weight: FontWeight.bold,
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Going',
                  style: buildTextStyle(color: Colors.blue, size: 12),
                ),
              ),
            );
          },
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.activity.notGoingByParent.length,
          itemBuilder: (context, index) {
            var _parent = widget.activity.assignToParent.firstWhere((element) =>
                widget.activity.notGoingByParent.contains(element.parentId));
            return ListTile(
              title: Text(
                '${_parent.name}',
                style: buildTextStyle(
                  size: 16,
                ),
              ),
              leading: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Text(
                  'Not Going',
                  style: buildTextStyle(color: Colors.blue, size: 12),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
