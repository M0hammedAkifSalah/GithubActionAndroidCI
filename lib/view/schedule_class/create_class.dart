import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import '/export.dart';
import '/model/class-schedule.dart';

class ScheduleClass extends StatefulWidget {
  const ScheduleClass({
    this.classTask,
    this.isEdit,
  });
  final ScheduledClassTask classTask;
  final bool isEdit;

  @override
  _ScheduleClassState createState() => _ScheduleClassState();
}

class _ScheduleClassState extends State<ScheduleClass> {
  final GlobalKey<FormState> _form = GlobalKey();
  bool _repeat = false;
  ScheduledClassTask scheduleClass;
  bool _conference = true;
  DateTime _startDate;
  DateTime _endDate;
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  List<PlatformFile> files = [];

  @override
  void initState() {
    // TODO: implement initState
    scheduleClass = widget.classTask ?? ScheduledClassTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(
        title: widget.isEdit ? 'Update Details' : 'Add Attendees',
        onPressed: () async {
          if (_repeat && _endDate == null) {
            _showDialogue();
            return;
          }
          if (!widget.isEdit) {
            if ((_startDate == null ||
                _startTime == null ||
                _endTime == null)) {
              _showDialogue();
              return;
            }
            if (_startTime.hour > 20) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You cannot select time post 8 PM.'),
                ),
              );
              return;
            }
            scheduleClass.classRepeat = _repeat ? "Yes" : 'No';
            if (!_repeat) {
              scheduleClass.endDate = null;
            }
            if (_form.currentState.validate()) {
              Navigator.of(context).push(
                createRoute(
                  pageWidget: MultiBlocProvider(
                    providers: [
                      BlocProvider<GroupCubit>(
                        create: (context) => GroupCubit(),
                      ),
                      BlocProvider<ScheduleClassCubit>(
                        create: (context) => ScheduleClassCubit(),
                      ),
                      // BlocProvider<>(create: )
                    ],
                    // child: AssignTask(
                    //   files: List<File>.from(
                    //     files.map((e) => File(e.path)),
                    //   ),
                    //   task: scheduleClass,
                    // ),
                    child: AssignTask(
                      files: files,
                      // task: scheduleClass,
                      classes: scheduleClass,
                      isJoinedClass: true,
                      title: 'Schedule Class',
                    ),
                    //     AssignClass(
                    //   classes: scheduleClass,
                    //   task: scheduleClass,
                    //   files: files.map((e) => File(e.path)).toList(),
                    // ),
                  ),
                ),
              );
            }
          } else {
            ScheduleClassUpdate updateClass = ScheduleClassUpdate(
              meetingLink: scheduleClass.meetingLink,
              description: scheduleClass.description,
              files: scheduleClass.files,
            );

            BlocProvider.of<ScheduleClassCubit>(context)
                .updateClass(updateClass, scheduleClass.id,
                    files: files.map((e) => File(e.path)).toList())
                .then((value) {
              Fluttertoast.showToast(msg: 'Class Updated');
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
          }
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: appMarker(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.topLeft,
              child: Text(
                widget.isEdit ? 'Edit Class' : 'Create Class',
                style: buildTextStyle(
                  size: 24,
                  family: 'Poppins',
                  weight: FontWeight.w600,
                ),
              ),
            ).expandFlex(1),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Container(
                    // height: 600,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          enabled: widget.isEdit ? false : true,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              scheduleClass.subjectName = value;
                              return null;
                            }
                            return 'Please Provide value';
                          },
                          initialValue: scheduleClass.subjectName ?? '',
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Add Title/Subject',
                            hintStyle: buildTextStyle(
                              color: Colors.grey[500],
                              size: 12,
                            ),
                          ),
                        ),
                        TextFormField(
                          enabled: widget.isEdit ? false : true,
                          validator: (value) {
                            if (value.trim().isNotEmpty) {
                              scheduleClass.chapterName = value;
                              return null;
                            }
                            return 'Please Provide value';
                          },
                          initialValue: scheduleClass.chapterName ?? '',
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: 'Add Sub Title/Chapter',
                            hintStyle: buildTextStyle(
                              color: Colors.grey[500],
                              size: 12,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              child: Text(
                                scheduleClass.startDate != null
                                    ? DateFormat('dd-MM-yyyy')
                                        .format(scheduleClass.startDate)
                                    : _startDate == null
                                        ? 'Start Date'
                                        : DateFormat('dd-MM-yyyy')
                                            .format(_startDate),
                                style: buildTextStyle(
                                  color: Colors.grey[600],
                                  size: 12,
                                ),
                              ),
                              onPressed: () async {
                                _startDate = await _pickDate();
                                scheduleClass.startDate =_startDate;
                                setState(() {});
                              },
                            ),
                            FlatButton(
                              child: Text(
                                scheduleClass.startTime != null
                                    ? TimeOfDay.fromDateTime(
                                            scheduleClass.startTime)
                                        .format(context)
                                    : _startTime == null
                                        ? 'Start Time'
                                        : _startTime.format(context),
                                style: buildTextStyle(
                                  color: Colors.grey[600],
                                  size: 12,
                                ),
                              ),
                              onPressed: () async {
                                _startTime = await _pickTime();
                                var _start = DateTime(
                                  _startDate.year,
                                  _startDate.month,
                                  _startDate.day,
                                  _startTime.hour,
                                  _startTime.minute,
                                );
                                scheduleClass.startTime = _start;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (_repeat)
                              FlatButton(
                                child: Text(
                                  scheduleClass.endDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(scheduleClass.endDate)
                                      : _endDate == null
                                          ? 'End Date'
                                          : DateFormat('dd-MM-yyyy')
                                              .format(_endDate),
                                  style: buildTextStyle(
                                    color: Colors.grey[600],
                                    size: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  _endDate = await _pickDate();
                                  scheduleClass.endDate = _endDate;
                                  setState(() {});
                                },
                              ),
                            Spacer(),
                            FlatButton(
                              child: Text(
                                scheduleClass.endTime != null
                                    ? TimeOfDay.fromDateTime(
                                            scheduleClass.endTime)
                                        .format(context)
                                    : _endTime == null
                                        ? 'End Time'
                                        : _endTime.format(context),
                                style: buildTextStyle(
                                  color: Colors.grey[600],
                                  size: 12,
                                ),
                              ),
                              onPressed: () async {
                                _endTime = await _pickTime();
                                DateTime _time = DateTime(
                                    _startDate.year,
                                    _startDate.month,
                                    _startDate.day,
                                    _endTime.hour,
                                    _endTime.minute);
                                scheduleClass.endTime = _time;

                                setState(() {});
                              },
                            ),
                          ],
                        ),

                        Visibility(
                          visible:
                              scheduleClass.classRepeat != null ? false : true,
                          child: ListTile(
                            leading: Checkbox(
                              value: _repeat,
                              onChanged: (value) {
                                if (value) {
                                  scheduleClass.classRepeat = 'yes';
                                } else {
                                  scheduleClass.classRepeat = 'no';
                                }
                                _repeat = value;
                                setState(() {});
                                // showDialog(
                                //   context: context,
                                //   child: _RepeatPopUp(),
                                // );
                              },
                            ),
                            title: Text(
                              'Class Repeat.',
                              style: buildTextStyle(
                                color: Colors.grey[500],
                                size: 12,
                              ),
                            ),
                          ),
                        ),
                        // ListTile(
                        //   leading: Checkbox(
                        //     value: _conference,
                        //     onChanged: (value) {
                        //       _conference = value;
                        //       setState(() {});
                        //     },
                        //   ),
                        //   title: Text(
                        //     'Add Video Conferencing',
                        //     style: buildTextStyle(
                        //       color: Colors.grey[500],
                        //       size: 12,
                        //     ),
                        //   ),
                        // ),
                        if (_conference)
                          TextFormField(
                            validator: (value) {
                              log('01 ' + value);
                              if (value.trim().isEmpty) {
                                return 'Please Provide a value';
                              }
                              if (!value.trim().startsWith('https://')) {
                                return 'Please provide a valid link';
                              }
                              scheduleClass.meetingLink = value;
                              log(value);
                              return null;
                            },
                            onChanged: (value) {
                              log(value);
                              scheduleClass.meetingLink = value;
                            },
                            initialValue: scheduleClass.meetingLink ?? '',
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              border: UnderlineInputBorder(),
                              labelText: 'Meeting Link',
                              labelStyle: buildTextStyle(
                                size: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        TextFormField(
                          maxLines: 6,
                          validator: (value) {
                            if (value.isNotEmpty) {
                              scheduleClass.description = value;
                              log(value.toString());
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            scheduleClass.description = value;
                          },
                          initialValue: scheduleClass.description ?? '',
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            border: UnderlineInputBorder(),
                            labelText: 'Description',
                            labelStyle: buildTextStyle(
                              size: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        scheduleClass.files != null
                            ? FileListing(scheduleClass.files)
                            : Container(
                                height: 0,
                              ),
                        Column(
                          children: files
                              .map(
                                (file) => ListTile(
                                  onTap: () {
                                    Fluttertoast.showToast(msg: 'Opening File');
                                    OpenFile.open(file.path);
                                  },
                                  title: Text(
                                    checkText(file.name),
                                    style: buildTextStyle(size: 15),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Color(0xffFFC30A).withOpacity(0.47),
                                    child: Text(
                                      file.extension.toUpperCase(),
                                      style: buildTextStyle(size: 10),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _deleteFile(file);
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        Card(
                          child: ListTile(
                            title: Text(
                              'Attach Files',
                              style: buildTextStyle(
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ),
                            onTap: _pickFiles,
                            // tileColor: Colors.grey,
                            trailing: Icon(
                              Icons.add,
                              color: Color(0xffFF5A79),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey[400],
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ).mv15
                      ],
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ).expandFlex(4)
          ],
        ),
      ),
    );
  }

  Future<DateTime> _pickDate() async {
    DateTime _date;
    _date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 365),
      ),
    );
    return _date;
  }

  Future<TimeOfDay> _pickTime() async {
    TimeOfDay _time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    return _time;
  }

  void _pickFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result.files.isNotEmpty) {
      for (var file in result.files) {
        try {
          if ((file.extension != null && file.extension.isNotEmpty) &&
              (file.name != null && file.name.isNotEmpty) &&
              (file.name != file.extension)) {
            files.add(file);
          } else {
            Fluttertoast.showToast(msg: 'Invalid File Format');
          }
        } catch (error) {
          Fluttertoast.showToast(msg: 'Invalid File Format');
        }
      }
    }
    setState(() {});
  }

  void _deleteFile(PlatformFile file) {
    files.remove(file);
    setState(() {});
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
}

class _RepeatPopUp extends StatelessWidget {
  const _RepeatPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Spacer(),
                Text(
                  'Repeat Class',
                  style: buildTextStyle(
                    size: 18,
                    weight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Repeats Every',
              style: buildTextStyle(color: Colors.grey, size: 12),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                TextFormField(
                  maxLength: 2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    fillColor: Colors.blueGrey[50],
                    filled: true,
                    counterText: '',
                  ),
                ).expandFlex(2),
                SizedBox(
                  width: 15,
                ),
                PopUpMenuWidget(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    height: kTextTabBarHeight + 10,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('week'),
                        Icon(Icons.expand_more),
                      ],
                    ),
                  ),
                  onSelected: (value) {},
                ).expandFlex(3),
                Container().expandFlex(2),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 15,
            ),
            Text(
              'Repeats on',
              style: buildTextStyle(size: 12, color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 350,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                      .map(
                        (day) => CircleAvatar(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.blueGrey[50],
                          child: Text(day),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Spacer(),
            Center(
              child: CustomRaisedButton(
                title: 'Done',
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
