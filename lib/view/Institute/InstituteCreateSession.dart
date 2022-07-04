import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';
import 'package:growonplus_teacher/view/Institute/AssignSession.dart';
import 'package:intl/intl.dart';
import '../test-module/constants.dart';
import '/export.dart';
import '/model/class-schedule.dart';

class CreateSession extends StatefulWidget {
  CreateSession(
      {this.isEdit=false,
      this.institute,
      this.user,
      this.receivedSession});

  final bool isEdit;
  final Institute institute;
  final UserInfo user;
  final ReceivedSession receivedSession;

  @override
  _CreateSessionState createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  final GlobalKey<FormState> _form = GlobalKey();
  bool _repeat = false;
  bool _conference = true;
  DateTime _startDate;
  DateTime _endDate;
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  List<PlatformFile> files = [];
  Session session;

  String sessionType;
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
     session = Session(
          createdAt: widget.receivedSession.createdAt,
          createdBy: widget.receivedSession.createdBy.name,
          meetingLink: widget.receivedSession.meetingLink,
          description: widget.receivedSession.description,
          doesSessionRepeat: widget.receivedSession.doesSessionRepeat,
          files: widget.receivedSession.files,
          id: widget.receivedSession.id,
          instituteId: widget.receivedSession.instituteId,
          isDaily: widget.receivedSession.isDaily,
          isForStudent: widget.receivedSession.isForStudent,
          sessionEndDate: widget.receivedSession.sessionEndDate,
          sessionEndTime: widget.receivedSession.sessionEndTime,
          sessionStartDate: widget.receivedSession.sessionStartDate,
          sessionStartTime: widget.receivedSession.sessionStartTime,
          subjectName: widget.receivedSession.subjectName,
      );


    }else{
      session =  Session();
    }
    if(widget.receivedSession != null) {
      if (widget.receivedSession.doesSessionRepeat.toLowerCase() == 'yes') {
        _repeat = true;
        sessionType = 'Weekly';
      }
      if (widget.receivedSession.isDaily.toLowerCase() == 'yes') {
        _repeat = true;
        sessionType = 'Daily';
      }


    }
    if(!widget.isEdit) {
      session.isForStudent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(
        title: widget.isEdit ? 'Update Details' : 'Add Attendees',
        onPressed: () async {
          if (_repeat && session.sessionEndDate == null) {
            _showDialogue('Please provide dates');
            return;
          }
          if(widget.isEdit)
          {
            if ((session.sessionStartDate == null ||
                session.sessionStartTime == null ||
                session.sessionEndTime == null)) {
              _showDialogue('Please provide dates');
              return;
            }

            if (session.sessionStartTime == session.sessionEndTime) {
              _showDialogue('StartTime and EndTime can not be same');
              return;
            }
            if (_repeat) if (session.sessionStartDate ==
                session.sessionEndDate) {
              _showDialogue('StartDate and EndDate can not be same');
              return;
            }
            if(session.sessionStartTime.hour > session.sessionEndTime.hour){
              _showDialogue('StartTime can not be after End Time');
              return ;
            }

            if(_repeat){
              if (session.sessionStartDate.isAfter(session.sessionEndDate)) {
                _showDialogue('StartDate cannot be after EndDate');
                return;
              }
            }

            if(!_repeat)
            {
              if (session.sessionStartTime.hour < DateTime.now().hour) {
                _showDialogue('StartTime cannot be Earlier');
                return;
              }
            }
          }

          else{
            if ((_startDate == null ||
                _startTime == null ||
                _endTime == null)) {
              _showDialogue('Please provide dates');
              return;
            }
            if(_startTime.hour > _endTime.hour){
              _showDialogue('StartTime can not be after End Time');
              return ;
            }
            if(!_repeat)
            {
              if (_startTime.hour < DateTime.now().hour) {
                _showDialogue('StartTime cannot be Earlier');
                return;
              }
            }

            if(_repeat){
              if (_startDate.isAfter(_endDate)) {
                _showDialogue('StartDate cannot be after EndDate');
                return;
              }
            }

            if (_startTime == _endTime) {
              _showDialogue('StartTime and EndTime can not be same');
              return;
            }
            if (_repeat) if (_startDate ==
                _endDate) {
              _showDialogue('StartDate and EndDate can not be same');
              return;
            }
          }

          // if(session.isStudent == false && session.isTeacher == false){
            //   _showDialogue('Kindly select Attendees');
            //   return;
            // }

            // if (_startTime.hour > 21) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(
            //       content: Text('You cannot select time post 9 PM.'),
            //     ),
            //   );
            //   return;
            // }
            // session.doesSessionRepeat = _repeat ? "Yes" : 'No';
            if (session.doesSessionRepeat == null || !_repeat) {
              session.doesSessionRepeat = 'no';
            }
            if (session.isDaily == null  || !_repeat) {
              session.isDaily = 'no';
            }
            if (!_repeat) {
              session.sessionEndDate = null;
            }
            if (_repeat && sessionType == null) {
              Fluttertoast.showToast(msg: 'Select Session Type');
            }
            else if (_form.currentState.validate()) {
              Navigator.of(context).push(
                createRoute(
                  pageWidget: BlocProvider<InstituteCubit>(
                    create: (context) {
                      return InstituteCubit()..getInstitute(widget.institute.id);
                    },
                    child: AssignSession(
                      files: files,
                      user: widget.user,
                      title: 'Schedule Session',
                      session: session,
                      isEdit: widget.isEdit,
                    ),
                  ),
                ),
              );
            }
          // else {
          //   ScheduleClassUpdate updateClass = ScheduleClassUpdate(
          //     meetingLink: session.meetingLink,
          //     description: session.description,
          //     files: session.files,
          //   );
          //
          //   BlocProvider.of<ScheduleClassCubit>(context)
          //       .updateClass(updateClass, session.instituteId,
          //           files: files.map((e) => File(e.path)).toList())
          //       .then((value) {
          //     Fluttertoast.showToast(msg: 'Session Updated');
          //     Navigator.of(context).pop();
          //     Navigator.of(context).pop();
          //   });
          // }
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
                widget.isEdit ? 'Edit Session' : 'Create Session',
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
                        Stack(
                          children: [
                            TextFormField(
                              enabled: true,
                              validator: (value) {
                                if (value.trim().isNotEmpty) {
                                  session.subjectName = value;
                                  return null;
                                }
                                return 'Please Provide value';
                              },
                              initialValue: widget.isEdit
                                  ? session.subjectName
                                  : '',
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                hintText: 'Add Title/Subject',
                                hintStyle: buildTextStyle(
                                  color: Colors.grey[500],
                                  size: 12,
                                ),
                              ),
                            ),
                            Positioned(
                                top: 10.0,
                                left: MediaQuery.of(context).size.width * 0.85,
                                child: Text(
                                  '*',
                                  style: TextStyle(
                                      // color: session.subjectName == null
                                      //     ? Colors.red
                                      //     : Colors.black
                                      ),
                                ))
                          ],
                        ),
                        // TextFormField(
                        //   enabled: widget.isEdit ? false : true,
                        //   validator: (value) {
                        //     if (value.trim().isNotEmpty) {
                        //       session. = value;
                        //       return null;
                        //     }
                        //     return 'Please Provide value';
                        //   },
                        //   initialValue: scheduleClass.chapterName ?? '',
                        //   decoration: InputDecoration(
                        //     border: UnderlineInputBorder(),
                        //     hintText: 'Add Sub Title/Chapter',
                        //     hintStyle: buildTextStyle(
                        //       color: Colors.grey[500],
                        //       size: 12,
                        //     ),
                        //   ),
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              child: Text(
                               (session.sessionStartDate != null
                                        ? DateFormat('dd-MM-yyyy')
                                            .format(session.sessionStartDate)
                                        : _startDate == null
                                            ? 'Start Date *'
                                            : DateFormat('dd-MM-yyyy')
                                                .format(_startDate)),
                                style: buildTextStyle(
                                  color: Colors.grey[600],
                                  size: 12,
                                ),
                              ),
                              onPressed: () async {
                                _startDate = await _pickDate(_startDate ?? session.sessionStartDate) ?? _startDate ?? session.sessionStartDate;
                                session.sessionStartDate = _startDate;

                                setState(() {});
                              },
                            ),
                            FlatButton(
                              child: Text(
                               (session.sessionStartTime != null
                                        ? TimeOfDay.fromDateTime(session.sessionStartTime)
                                            .format(context)
                                        : _startTime != null
                                            ? _startTime.format(context)
                                            : 'Start Time *'),
                                style: buildTextStyle(
                                  color: Colors.grey[600],
                                  size: 12,
                                ),
                              ),
                              onPressed: () async {
                                _startTime = await _pickTime(_startTime ??  TimeOfDay.fromDateTime(session.sessionStartTime ?? DateTime.now())) ?? _startTime ?? TimeOfDay.fromDateTime(session.sessionStartTime);
                                var _start = DateTime(
                                   _startDate != null ? _startDate.year : (session.sessionStartDate != null ? session.sessionStartDate.year : DateTime.now().year),
                                  _startDate != null ?_startDate.month:(session.sessionStartDate != null ?session.sessionStartDate.month: DateTime.now().month),
                                  _startDate != null ? _startDate.day : (session.sessionStartDate != null ? session.sessionStartDate.day: DateTime.now().day),
                                  _startTime.hour,
                                  _startTime.minute,
                                );
                                session.sessionStartTime = _start;
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: ListTile(
                                leading: Checkbox(
                                  value: _repeat,
                                  // value: widget.isEdit ? ((widget.instituteSession.doesSessionRepeat.toLowerCase() == 'yes') || (wid) ? true : false) : _repeat,
                                  onChanged: (value) {
                                    // if (value) {
                                    //   session.doesSessionRepeat = 'yes';
                                    // } else {
                                    //   session.doesSessionRepeat = 'no';
                                    // }
                                    _repeat = value;
                                    setState(() {});
                                    // showDialog(
                                    //   context: context,
                                    //   child: _RepeatPopUp(),
                                    // );
                                  },
                                ),
                                title: Text(
                                  'Recurring Session',
                                  style: buildTextStyle(
                                    color: Colors.grey[500],
                                    size: 12,
                                  ),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width * 0.6,
                            ),

                            // Spacer(),
                            FlatButton(
                              child: Text(
                               session.sessionEndTime != null
                                        ? TimeOfDay.fromDateTime(session.sessionEndTime)
                                            .format(context)
                                        : _endTime == null
                                            ? 'End Time *'
                                            : _endTime.format(context),
                                style: buildTextStyle(
                                  color: Colors.grey[600],
                                  size: 12,
                                ),
                              ),
                              onPressed: () async {
                                _endTime = await _pickTime(_endTime ?? TimeOfDay.fromDateTime(session.sessionEndTime ?? DateTime.now().add(Duration(minutes: 45)))) ?? _endTime ?? TimeOfDay.fromDateTime(session.sessionEndTime);
                                DateTime _time = DateTime(
                                   _startDate != null ? _startDate.year:(session.sessionStartDate != null ? session.sessionStartDate.year : DateTime.now().year),
                                    _startDate != null ? _startDate.month : (session.sessionStartDate != null ? session.sessionStartDate.month : DateTime.now().month),
                                    _startDate != null ? _startDate.day: (session.sessionStartDate != null ? session.sessionStartDate.day : DateTime.now().day),
                                    _endTime.hour,
                                    _endTime.minute);
                                session.sessionEndTime = _time;

                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        if (_repeat)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlatButton(
                                child: Text(
                                  (session.sessionEndDate != null
                                          ? DateFormat('dd-MM-yyyy')
                                              .format(session.sessionEndDate)
                                          : _endDate == null
                                              ? 'End Date *'
                                              : DateFormat('dd-MM-yyyy')
                                                  .format(_endDate)),
                                  style: buildTextStyle(
                                    color: Colors.grey[600],
                                    size: 12,
                                  ),
                                ),
                                onPressed: () async {
                                  _endDate = await _pickDate(_endDate ?? session.sessionEndDate) ?? _endDate ?? session.sessionEndDate;
                                  session.sessionEndDate = _endDate;

                                  setState(() {});
                                },
                              ),

                              Center(
                                child: DropdownButton<String>(
                                  focusColor: Colors.white,
                                  value:  sessionType,
                                  //elevation: 5,
                                  style: const TextStyle(color: Colors.white),
                                  iconEnabledColor: Colors.black,
                                  items: <String>['Daily', "Weekly"]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    "Session Type",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: kBlackColor),
                                  ),
                                  onChanged: (String value) {
                                    setState(() {
                                      sessionType = value;
                                      if (value.toLowerCase() == 'daily') {
                                        session.doesSessionRepeat = 'No';
                                        session.isDaily = 'yes';
                                      } else if (value.toLowerCase() == 'weekly') {
                                        session.doesSessionRepeat = 'yes';
                                        session.isDaily = 'no';
                                      }
                                    });
                                  },
                                ),
                              ),

                              // Container(
                              //   child: Form(
                              //     key: _formKey,
                              //     // autovalidate: _autovalidate,
                              //     child: Column(
                              //       children: <Widget>[
                              //         DropdownButtonFormField<String>(
                              //           value: sessionType,
                              //           hint: Text(
                              //             'Salutation',
                              //           ),
                              //           onChanged: (String value) {
                              //             setState(() {
                              //               sessionType = value;
                              //               if(value.toLowerCase() == 'daily')
                              //               {
                              //                 session.doesSessionRepeat = 'No';
                              //                 session.isDaily = 'yes';
                              //               }
                              //               else if(value.toLowerCase() == 'weekly')
                              //               {
                              //                 session.doesSessionRepeat = 'yes';
                              //                 session.isDaily = 'no';
                              //               }
                              //               else
                              //               {
                              //                 session.doesSessionRepeat = 'No';
                              //                 session.isDaily = 'yes';
                              //               }
                              //             });
                              //           },
                              //           validator: (value) => value == null ? 'field required' : null,
                              //           items: <String>[
                              //             'Daily',
                              //             "Weekly"
                              //           ].map<
                              //               DropdownMenuItem<
                              //                   String>>(
                              //                   (String value) {
                              //                 return DropdownMenuItem<
                              //                     String>(
                              //                   value: value,
                              //                   child: Text(
                              //                     value,
                              //                     style: TextStyle(
                              //                         color:
                              //                         Colors.black),
                              //                   ),
                              //                 );
                              //               }).toList(),
                              //         ),
                              //         // TextFormField(
                              //         //   decoration: InputDecoration(hintText: 'Name'),
                              //         //   validator: (value) => value.isEmpty ? 'Name is required' : null,
                              //         //   onSaved: (value) => name = value,
                              //         // ),
                              //         FlatButton(
                              //           child: Text('PROCEED'),
                              //           color: Colors.green,
                              //           onPressed: () {
                              //             if (_formKey.currentState.validate()) {
                              //               //form is valid, proceed further
                              //               _formKey.currentState.save();//save once fields are valid, onSaved method invoked for every form fields
                              //
                              //             } else {
                              //               setState(() {
                              //                 _autovalidate = true; //enable realtime validation
                              //               });
                              //             }
                              //           },
                              //         )
                              //       ],
                              //     ),
                              //   ),
                              // )
                            ],
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
                          Stack(
                            children: [
                              TextFormField(
                                textCapitalization: TextCapitalization.none,
                                validator: (value) {
                                  if (value.trim().isEmpty) {
                                    return 'Please Provide a value';
                                  }
                                  if (!value
                                      .toLowerCase()
                                      .trim()
                                      .startsWith('https://')) {
                                    return 'Please provide a valid link';
                                  }
                                  // session.meetingLink = value.replaceAll(' ', '');
                                  session.meetingLink = value.trim();
                                  return null;
                                },
                                onChanged: (value) {
                                  // session.meetingLink = value.replaceAll(' ', '');
                                  session.meetingLink = value.trim();
                                },
                                initialValue: session.meetingLink ?? '',
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
                              Positioned(
                                  top: 20.0,
                                  left: MediaQuery.of(context).size.width * 0.85,
                                  child: Text(
                                    '*',
                                    style: TextStyle(
                                        // color: session.subjectName == null
                                        //     ? Colors.red
                                        //     : Colors.black
                                        ),
                                  )),
                            ],
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        Text('Session is for :',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        // ListTile(
                        //   title: Text('Teacher'),
                        //   trailing: InkWell(
                        //     onTap: () {
                        //       session.isTeacher = !session.isTeacher;
                        //       setState(() {});
                        //       log(session.isTeacher.toString());
                        //       // if(session.isTeacher == true){
                        //       //   session.isTeacher = false;
                        //       // }
                        //       // else{
                        //       //   session.isTeacher = true;
                        //       // }
                        //     },
                        //     child: Container(
                        //       width: 80,
                        //       height: 30.0,
                        //       decoration: BoxDecoration(
                        //           color: session.isTeacher
                        //               ? Colors.yellow
                        //               : Colors.white,
                        //           borderRadius: BorderRadius.circular(20.0),
                        //           border: Border.all(
                        //               color: Colors.yellow, width: 2)),
                        //       child: Center(
                        //           child: Text(
                        //         session.isTeacher ? 'Deselect' : "Select",
                        //         style: TextStyle(
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.bold),
                        //       )),
                        //     ),
                        //   ),
                        // ),
                        ListTile(
                          title: Text('Student'),
                          trailing: InkWell(
                            onTap: () {
                              // if(!widget.isEdit)
                              {
                                session.isForStudent = !session.isForStudent;
                                setState(() {});
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 30.0,
                              decoration: BoxDecoration(
                                  color: (
                                      // (widget.receivedSession != null)
                                      // ? (widget.receivedSession.isForStudent
                                      //     ? Colors.yellow
                                      //     : Colors.white)
                                      // :
                                  session.isForStudent
                                          ? Colors.yellow
                                          : Colors.white),
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(color: Colors.yellow, width: 2)),
                              child: Center(
                                  child: Text(
                                (
                                    // (widget.receivedSession != null)
                                    // ? (widget.receivedSession.isForStudent
                                    //     ? 'Deselect'
                                    //     : 'Select')
                                    // :
                                session.isForStudent
                                        ? 'Deselect'
                                        : 'Select'),
                                // widget.instituteSession.isForStudent ? 'Deselect' : "Select",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold),
                              )),
                            ),
                          ),
                        )
                        // TextFormField(
                        //   maxLines: 6,
                        //   validator: (value) {
                        //     if (value.isNotEmpty) {
                        //       session.description = value;
                        //       log(value.toString());
                        //       return null;
                        //     }
                        //     return null;
                        //   },
                        //   onChanged: (value) {
                        //     session.description = value;
                        //   },
                        //   initialValue: session.description ?? '',
                        //   decoration: InputDecoration(
                        //     alignLabelWithHint: true,
                        //     border: UnderlineInputBorder(),
                        //     labelText: 'Description',
                        //     labelStyle: buildTextStyle(
                        //       size: 12,
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        // ),
                        // session.files != null
                        //     ? FileListing(session.files)
                        //     : Container(
                        //         height: 0,
                        //       ),
                        // Column(
                        //   children: files
                        //       .map(
                        //         (file) => ListTile(
                        //           onTap: () {
                        //             Fluttertoast.showToast(msg: 'Opening File');
                        //             OpenFile.open(file.path);
                        //           },
                        //           title: Text(
                        //             checkText(file.name),
                        //             style: buildTextStyle(size: 15),
                        //           ),
                        //           leading: CircleAvatar(
                        //             backgroundColor:
                        //                 Color(0xffFFC30A).withOpacity(0.47),
                        //             child: Text(
                        //               file.extension.toUpperCase(),
                        //               style: buildTextStyle(size: 10),
                        //             ),
                        //           ),
                        //           trailing: IconButton(
                        //             icon: Icon(Icons.delete),
                        //             onPressed: () {
                        //               _deleteFile(file);
                        //             },
                        //           ),
                        //         ),
                        //       )
                        //       .toList(),
                        // ),
                        // Card(
                        //   child: ListTile(
                        //     title: Text(
                        //       'Attach Files',
                        //       style: buildTextStyle(
                        //         size: 15,
                        //         weight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     onTap: _pickFiles,
                        //     // tileColor: Colors.grey,
                        //     trailing: Icon(
                        //       Icons.add,
                        //       color: Color(0xffFF5A79),
                        //     ),
                        //   ),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //     side: BorderSide(
                        //       color: Colors.grey[400],
                        //       width: 1,
                        //       style: BorderStyle.solid,
                        //     ),
                        //   ),
                        // ).mv15
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

  Future<DateTime> _pickDate(DateTime date) async {
    DateTime _date;
    _date = await showDatePicker(
      context: context,
      initialDate: (date != null && !date.isBefore(DateTime.now())) ? date :  DateTime.now(),
      firstDate: DateTime.now() ,
      // _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 365),
      ),
    );
    return _date;
  }

  Future<TimeOfDay> _pickTime(TimeOfDay time) async {
    TimeOfDay _time = await showTimePicker(
      context: context,
      initialTime: time ?? TimeOfDay.now(),
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

  _showDialogue(String _dialogue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_dialogue),
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
