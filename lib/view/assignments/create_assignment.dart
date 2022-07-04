import 'dart:developer';
import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:growonplus_teacher/app-config.dart';
import 'package:growonplus_teacher/bloc/activity/activity-states.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../attached_files_and_url_slider.dart';
import '../audio-record-page.dart';
import '../file_viewer.dart';
import '../learnings/learning-files.dart';
import '/bloc/activity/assignment-cubit.dart';
import '/bloc/activity/assignment-states.dart';
import '/view/evaluate/submission-indicator.dart';
import '../../export.dart';

AssignmentTask _assignmentTask;
PlatformFile _image;
DateTime _endDate;
DateTime _startDate;
TimeOfDay _endTime;
TimeOfDay _startTime;
final _fileStreamController = BehaviorSubject<List<PlatformFile>>();
String type;


typedef OnTaskClickHandler = Function();

class CreateAssignment extends StatefulWidget {
  final String taskName;

  CreateAssignment({this.taskName});

  @override
  _CreateAssignmentState createState() => _CreateAssignmentState();
}

class _CreateAssignmentState extends State<CreateAssignment> {

  GlobalKey<FormState> _form = GlobalKey<FormState>();
  int count = 0;
  OnTaskClickHandler onTaskClickHandler;

  @override
  void initState() {
    super.initState();
    _image = null;
    _endDate = null;
    _startDate = null;
    _startTime = null;
    _endTime = null;
    _assignmentTask = AssignmentTask();
    if(_fileStreamController.hasValue) _fileStreamController.value = [];
  }


  @override
  void dispose() {
    _fileStreamController.drain();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
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
      },
      child: Scaffold(
        bottomNavigationBar: BlocBuilder<AuthCubit, AuthStates>(
          builder: (context, state) {
            return CustomBottomBar(
              check: _endDate != null && _startDate != null,
              title: 'Assign',
              onPressed: () {
                if (_form.currentState.validate()) {
                  var _dateTime = DateTime(
                    _endDate.year,
                    _endDate.month,
                    _endDate.day,
                    _endTime.hour,
                    _endTime.minute,
                  );
                  _assignmentTask.endTime = _dateTime;
                  _assignmentTask.isOffline = false;
                  Navigator.of(context).push(
                    createRoute(
                      pageWidget: MultiBlocProvider(
                        providers: [
                          BlocProvider<GroupCubit>(
                            create: (context) => GroupCubit()..loadGroups(),
                          ),
                          BlocProvider<StudentProfileCubit>(
                            create: (context) =>
                                StudentProfileCubit()..loadStudentProfile(page: 1,limit: 10),
                          )
                        ],
                        child: AssignTask(
                          files:  _fileStreamController.hasValue ?
                            _fileStreamController.stream.value :[],
                          // image: File(_fileStreamController.stream.hasValue ? _fileStreamController.stream.value.first.path:null),
                          task: _assignmentTask,
                          title: 'Assignment',
                          isJoinedClass: false,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
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
              if (_assignmentTask.description == null &&
                  _assignmentTask.title == null) {
                Navigator.of(context).pop();
                return null;
              }
              // if(_assignmentTask.title == null && _assignmentTask.coin == null && _assignmentTask.startDate == null
              // && _assignmentTask.endDate == null && _assignmentTask.subject == null && _assignmentTask.learningOutcome == null
              // && _assignmentTask.description == null) {
              //   Navigator.of(context).pop();
              //   return null;
              // }
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
          title: Padding(
            padding: screenwidth > 600 ? const EdgeInsets.fromLTRB(0, 30, 0, 0): const EdgeInsets.all(0.0),
            child: Text(
              'Assignment',
              style: buildTextStyle(
                size: screenwidth > 600 ? 25 : 15,
                weight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Spacer(),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            width:  screenwidth > 600 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 0.99,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            //width: double.infinity,
                            // alignment: Alignment.bottomCenter,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 5,
                                  blurRadius: 5,
                                )
                              ],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: AssignmentWidget(
                              assignmentTask: _assignmentTask,
                              editable: true,
                              onChanged: (value) {
                                count = value.length;
                                setState(() {});
                              },
                              count: count,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AssignmentWidget extends StatefulWidget {
  AssignmentWidget({
    Key key,
    this.editable = true,
    this.activity,
    this.child,
    this.assignmentTask,
    this.onChanged,
    this.count,
  }) : super(key: key);

  final AssignmentTask assignmentTask;
  final Activity activity;
  final bool editable;
  final Widget child;
  final Function(String value) onChanged;
  final count;

  @override
  _AssignmentWidgetState createState() => _AssignmentWidgetState();
}

class _AssignmentWidgetState extends State<AssignmentWidget> {
  bool isEmpty = false;

  bool value = true;

  Widget uploadFilePanel() {
    String text = '';
    Icon icon = Icon(Icons.camera_alt);
    switch (type) {
      case 'image':
        text = 'Camera';
        icon = Icon(Icons.camera_alt);
        break;
      case 'video':
        text = 'Record';
        icon = Icon(Icons.video_call);
        break;
      case 'audio':
        text = 'Record';
        icon = Icon(Icons.mic);
        break;
    }
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            ListTile(
              title: Text(text),
              leading: icon,
              onTap: () async {
                Navigator.of(context).pop();
                // uploadFilePanelController.close();
                switch (type) {
                  case 'image':
                    _pickImage();
                    break;
                  case 'video':
                    _pickVideo();
                    break;
                  case 'audio':
                    PlatformFile audioFile = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AudioRecordPage(),
                      ),
                    );
                    if (audioFile != null) {
                      List<PlatformFile> files =
                      [audioFile];

                      List<PlatformFile>
                      newFiles = [];
                      if (_fileStreamController
                          .stream
                          .valueOrNull !=
                          null) {
                        newFiles.addAll(
                            _fileStreamController
                                .stream
                                .valueOrNull);
                      }
                      newFiles.addAll(files);
                      _fileStreamController.sink
                          .add(newFiles);
                      setState(() {});
                    }
                    break;
                }
              },
            ),
            ListTile(
              title: Text('File'),
              leading: Icon(Icons.file_copy),
              onTap: () async {
                Navigator.of(context).pop();
                // uploadFilePanelController.close();
                String dir;
                switch (type) {
                  case 'image':
                    dir = await ExternalPath.getExternalStoragePublicDirectory(
                        ExternalPath.DIRECTORY_PICTURES);
                    _pickFiles(dir);
                    break;
                  case 'video':
                    dir = await ExternalPath.getExternalStoragePublicDirectory(
                        ExternalPath.DIRECTORY_DCIM);
                    _pickFiles(dir);
                    break;
                  case 'audio':
                    dir = await ExternalPath.getExternalStoragePublicDirectory(
                        ExternalPath.DIRECTORY_MUSIC);
                    _pickFiles(dir);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget uploadPanel() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            ListTile(
              title: Text('Image'),
              onTap: () {
                type = 'image';
                setState(() {});
                // uploadPanelController.close();
                // uploadFilePanelController.open();
                Navigator.of(context).pop();
                bottomSheet(uploadFilePanel());
              },
              leading: Icon(Icons.image),
            ),
            ListTile(
              title: Text('Video'),
              onTap: () {
                type = 'video';
                setState(() {});
                // uploadPanelController.close();
                // uploadFilePanelController.open();
                Navigator.of(context).pop();
                bottomSheet(uploadFilePanel());
              },
              leading: Icon(Icons.videocam),
            ),
            ListTile(
              title: Text('Audio'),
              onTap: () {
                type = 'audio';
                setState(() {});
                // uploadPanelController.close();
                // uploadFilePanelController.open();
                Navigator.of(context).pop();
                bottomSheet(uploadFilePanel());
              },
              leading: Icon(Icons.audiotrack_outlined),
            ),
            ListTile(
              title: Text('Documents'),
              onTap: () async {
                type = 'document';
                setState(() {});
                // uploadPanelController.close();
                Navigator.of(context).pop();
                String dir = await ExternalPath.getExternalStoragePublicDirectory(
                    ExternalPath.DIRECTORY_DOCUMENTS);
                _pickFiles(dir);
                // uploadFilePanelController.open();
              },
              leading: Icon(Icons.file_copy),
            ),
          ],
        ),
      ),
    );
  }

  bottomSheet(Widget child){
    showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.blueGrey
            .withOpacity(0.2),
        backgroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.vertical(
              top: Radius.circular(
                  20.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return child;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                children: [
                  TextFormField(
                    enabled: widget.editable,
                    maxLength: null,
                    maxLines: null,
                    initialValue: widget.editable ? '' : widget.activity.title,
                    validator: (value) {
                      print(value);
                      print(widget.assignmentTask);
                      widget.assignmentTask.title = value;
                      return validator(value);
                    },
                    decoration: InputDecoration(
                        labelText: 'Title of Assignment'.toTitleCase(),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(width: 2),
                        ),
                        labelStyle: buildTextStyle(
                          size: 15,
                          color: Colors.grey.shade700,
                        )),
                  ).expand,
                  if (!widget.editable && widget.activity.status.toLowerCase() != 'evaluated')
                    if(features['forwarded']['isEnabled'])
                    IconButton(
                      icon: Image.asset(
                        'assets/images/forward.png',
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          createRoute(
                              pageWidget: BlocProvider(
                            create: (context) => SchoolTeacherCubit(),
                            child: ForwardTaskPage(widget.activity),
                          )),
                        );
                      },
                    )
                ],
              ),
              Container(
                // height: 48,
                margin: EdgeInsets.symmetric(vertical: 15),
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
                          enabled: widget.editable,
                          initialValue: widget.editable
                              ? ''
                              : "${widget.activity.coin ?? 0}",
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          validator: (value) {
                            if (int.tryParse(value) == null || value.isEmpty) {
                              setState(() {
                                isEmpty = true;
                              });
                              return 'Please Provide a value';
                            }
                            widget.assignmentTask.coin = int.parse(value);
                            return validator(value);
                          },
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            hintText: 'Coins',
                            hintStyle: buildTextStyle(
                              size: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ).expandFlex(isEmpty ? 6 : 1),
                        Spacer(flex: 4),
                        // if(widget.editable)
                        // Row(
                        //   children: [
                        //     Text('Offline'),
                        //     Switch(value:  value, onChanged: (val){
                        //         value = val;
                        //         widget.assignmentTask.isOffline = !val;
                        //         setState(() {
                        //
                        //         });
                        //         log(widget.assignmentTask.isOffline.toString());
                        //     },
                        //     activeColor: Colors.amber),
                        //     Text('Online'),
                        //   ],
                        // )
                        // SvgPicture.asset(
                        //   'assets/svg/trophy.svg',
                        //   height: 20,
                        //   width: 20,
                        // ),
                        // TextFormField(
                        //   enabled: widget.editable,
                        //   initialValue:
                        //       widget.editable ? '' : "${widget.activity.reward}",
                        //   keyboardType: TextInputType.number,
                        //   maxLength: 2,
                        //   validator: (value) {
                        //     widget.assignmentTask.reward = int.parse(value);
                        //     return validator(value);
                        //   },
                        //   decoration: InputDecoration(
                        //     border: UnderlineInputBorder(
                        //       borderSide: BorderSide(width: 2),
                        //     ),
                        //     hintText: 'Reward',
                        //     hintStyle: buildTextStyle(
                        //       size: 10,
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        // ).expandFlex(1),
                        // Spacer(
                        //   flex: 3,
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // FlatButton(
                    //   onPressed: widget.editable ? _pickImage : null,
                    //   child: !widget.editable
                    //       ? CachedImage(imageUrl: widget.activity.image)
                    //       : _image == null
                    //           ? Container(
                    //               height: 180,
                    //               alignment: Alignment.center,
                    //               width: double.infinity,
                    //               child: Row(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: [
                    //                   Icon(Icons.image),
                    //                   SizedBox(
                    //                     width: 15,
                    //                   ),
                    //                   Text(
                    //                     'Add Image',
                    //                     style: buildTextStyle(size: 15),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )
                    //           : Container(
                    //               height: 180,
                    //               width: double.infinity,
                    //               child: Image.file(
                    //                 _image,
                    //                 fit: BoxFit.scaleDown,
                    //               ),
                    //             ),
                    // ),
                  ],
                ),
              ),

              Container(
                // width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    InkWell(
                      onTap: widget.editable
                          ? () async {
                              _startDate = await _pickDate(date: _startDate) ?? _startDate;
                              if(_startDate != null) {
                                widget.assignmentTask.startDate =
                                    DateFormat("dd-MMM-yyyy")
                                        .format(_startDate);
                                _startTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()) ??
                                    _startTime;
                                if(_startTime != null) {
                                  var date = DateTime(
                                    _startDate.year ?? DateTime.now().year,
                                    _startDate.month ?? DateTime.now().month,
                                    _startDate.day ?? DateTime.now().day,
                                    _startTime.hour,
                                    _startTime.minute,
                                  );
                                  widget.assignmentTask.startTime = date;
                                }
                              }
                              setState(() {});
                            }
                          : null,
                      child:
                          // Text(widget.activity.startDate),
                          _dropdownMenu(
                        widget.editable
                            ? '${widget.assignmentTask.startDate ?? 'Start Date &'} ${_startTime == null ? 'Time' : _startTime.format(context)}'
                            : DateFormat("dd-MMM-yyyy")
                                        .format(widget.activity.publishedDate) +
                                    ' ' +
                                    TimeOfDay.fromDateTime(
                                            widget.activity.publishedDate)
                                        .format(context) ??
                                '',
                      ),
                    ),
                    InkWell(
                      onTap: widget.editable
                          ? () async {
                              _endDate = await _pickDate(date: _endDate) ?? _endDate;
                              if(_endDate != null)
                              {
                                widget.assignmentTask.dueDate =
                                    DateFormat("dd-MMM-yyyy").format(_endDate);
                                widget.assignmentTask.endDate =
                                    DateFormat("dd-MMM-yyyy").format(_endDate);
                                _endTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()) ??
                                    _endTime;
                                if(_endTime != null)
                                {
                                  widget.assignmentTask.endTime = DateTime(
                                    _endDate.year ?? DateTime.now().year,
                                    _endDate.month ?? DateTime.now().month,
                                    _endDate.day ?? DateTime.now().day,
                                    _endTime.hour,
                                    _endTime.minute,
                                  );
                                }
                              }
                              setState(() {});
                            }
                          : null,
                      child: _dropdownMenu(
                        widget.editable
                            ? '${widget.assignmentTask.endDate ?? 'End Date &'} ${_endTime == null ? 'Time' : _endTime.format(context)}'
                            : DateFormat("dd-MMM-yyyy")
                                        .format(widget.activity.endDateTime) +
                                    ' ' +
                                    TimeOfDay.fromDateTime(
                                            widget.activity.endDateTime)
                                        .format(context) ??
                                '',
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                enabled: widget.editable,
                initialValue: widget.editable ? '' : widget.activity.subject,
                validator: (value) {
                  print(value);
                  print(widget.assignmentTask);
                  widget.assignmentTask.subject = value;
                  return validator(value);
                },
                decoration: InputDecoration(
                  labelText: 'Subject Name',
                  labelStyle: buildTextStyle(
                    size: 13,
                    color: Colors.grey,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
              ),

              if (features['learningOutcome']['isEnabled'])
                TextFormField(
                  initialValue:
                      widget.editable ? '' : widget.activity.learningOutcome,
                  enabled: widget.editable,
                  validator: (value) {
                    widget.assignmentTask.learningOutcome = value;
                    return null;
                  },
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    border: const UnderlineInputBorder(),
                    labelText: 'Learning Outcome',
                    labelStyle: buildTextStyle(
                      size: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),
              TextFormField(
                initialValue:
                    widget.editable ? '' : widget.activity.description,
                enabled: widget.editable,
                onChanged: widget.onChanged,
                validator: (value) {
                  widget.assignmentTask.description = value;
                  return validator(value);
                },
                maxLines: widget.editable ? 4 : null,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  border: UnderlineInputBorder(),
                  labelText: 'Description (${widget.count ?? 0}/2500)',
                  labelStyle: buildTextStyle(
                    size: 13,
                    color: Colors.grey,
                  ),
                ),
                inputFormatters: [LengthLimitingTextInputFormatter(2500)],
              ),
              SizedBox(
                height: 10,
              ),

              hSpacing(10),
              if (widget.editable)
                Text(
                  'Note: Please press ⏎ to add new links, if there are multiple links.',
                  style: buildTextStyle(
                    color: Colors.grey,
                    size: 13,
                  ),
                ),
              if (!widget.editable) showActivityLinks(context, widget.activity),
              if(widget.editable && !kIsWeb && _fileStreamController.hasValue)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: AttachedFilesAndUrlSlider(
                    null ,
                    _fileStreamController,
                    key: Key(
                      widget.editable ? "edit" : "null",
                    ),
                  ),
                ),
              if(widget.editable && kIsWeb && _fileStreamController.hasValue)
                Column(
                  children: _fileStreamController.value
                      .map(
                        (file) => ListTile(
                      onTap: () {
                        Fluttertoast.showToast(msg: 'Opening File');
                        OpenFile.open(file.path);
                      },
                      title: Text(
                        checkText(file.name)??file.name,
                        style: buildTextStyle(size: 15),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Color(0xffFFC30A).withOpacity(0.47),
                        child: Text(
                         file.extension != null ? file.extension.toUpperCase():'N/A',
                          style: buildTextStyle(size: 10),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // _deleteFile(file);
                          _fileStreamController.value.remove(file);
                          setState((){});
                        },
                      ),
                    ),
                  )
                      .toList(),
                ).mv15,
              if (!widget.editable && widget.activity.files.isNotEmpty)
                  FileListing(
                    widget.activity.files,
                    isPreview: true,
                  ).mv15,
              if (widget.editable && !kIsWeb)
                Card(
                  child: ListTile(
                    title: Text(
                      'Attach Files',
                      style: buildTextStyle(
                        size: 15,
                        weight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                     bottomSheet(uploadPanel());
                      // uploadPanelController.open();
                    },

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
                ).mv15,
              if(widget.editable && kIsWeb)
                Card(
                  child: ListTile(
                    title: Text(
                      'Attach Files',
                      style: buildTextStyle(
                        size: 15,
                        weight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      FilePickerResult result =
                          await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          withData: false,
                          withReadStream: true,
                          allowedExtensions: [
                            'mp3',
                            'mp4',
                            'docx',
                            'xlsx',
                            'png',
                            'jpg',
                            'jpeg',
                            'pdf',
                            'ppt',
                            'pptx',
                            'doc'
                          ],
                          type: FileType.custom);
                      if (result != null) {
                        List<PlatformFile>
                        files =
                            result.files;

                        List<PlatformFile>
                        newFiles = [];
                        if (_fileStreamController
                            .stream
                            .valueOrNull !=
                            null) {
                          newFiles.addAll(
                              _fileStreamController
                                  .stream
                                  .valueOrNull);
                        }
                        newFiles.addAll(files);
                        _fileStreamController
                            .sink
                            .add(newFiles);
                        setState(() {});
                      } else {
                        // User canceled the picker
                      }
                    },
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
                ).mv15,
              // if(widget.editable)
              //   Card(
              //     child: ExpansionTile(
              //       initiallyExpanded: true,
              //       title: Text(
              //         'Attach Files',
              //         style: buildTextStyle(
              //           size: 15,
              //           weight: FontWeight.bold,
              //         ),
              //       ),
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             InkWell(
              //               child: Container(
              //                   padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              //                   child: Icon(Icons.image,size: 45,)
              //               ),
              //             ),
              //             InkWell(
              //               child: Container(
              //                   padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              //                   child: Icon(Icons.videocam,size: 45,)
              //               ),
              //             ),
              //             InkWell(
              //               child: Container(
              //                   padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              //                   child: Icon(Icons.audiotrack_outlined,size: 45,)
              //               ),
              //             ),
              //             InkWell(
              //               child: Container(
              //                 padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              //                   child: Icon(Icons.file_copy,size: 45,)
              //               ),
              //             ),
              //           ],
              //         ),
              //       ],
              //       // onTap: () {
              //       //   uploadPanelController.open();
              //       // },
              //
              //       // tileColor: Colors.grey,
              //       trailing: Icon(
              //         Icons.add,
              //         color: Color(0xffFF5A79),
              //       ),
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //       side: BorderSide(
              //         color: Colors.grey[400],
              //         width: 1,
              //         style: BorderStyle.solid,
              //       ),
              //     ),
              //   ).mv15,
              Divider(
                color: Colors.black87,
              ),
              if (!widget.editable)
                BlocBuilder<AssignmentSubmissionCubit,
                    AssignmentSubmissionStates>(builder: (context, state) {
                  if (state is AssignmentSubmissionLoaded)
                    return Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.submission.length,
                        itemBuilder: (context, index) {
                          var _student = widget.activity.assignTo.firstWhere(
                            (student) =>
                                student.studentId.id ==
                                state.submission[index].studentId,
                          );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                // color: Color(0xff6FCF97).withOpacity(0.25),
                                child: ListTile(
                                  subtitle: Text(
                                      "Class : ${_student.className ?? ''} ${(_student.studentId.sectionName != 'no name') ? _student.studentId.sectionName : ''}"),
                                  contentPadding: EdgeInsets.all(8),
                                  leading: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: getRespectiveIndicator(
                                      true,
                                      state.submission[index].lateSubmission,
                                    ),
                                    child: TeacherProfileAvatar(
                                      imageUrl:
                                          _student.studentId.profileImage ??
                                              'text',
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      createRoute(
                                        pageWidget: BlocProvider<
                                            AssignmentSubmissionCubit>(
                                          create: (context) =>
                                              AssignmentSubmissionCubit()
                                                ..addData(
                                                    widget.activity.submitedBy,
                                                    widget.activity.assignTo),
                                          child: EvaluateAssignment(
                                            activity: widget.activity,
                                            studentInfo: StudentInfo(
                                              id: _student.studentId.id,
                                              name: _student.name,
                                              profileImage:
                                                  _student.profileImage,
                                            ),
                                            submittedBy: widget.activity.submitedBy.firstWhere((submit) {

                                              return submit.studentId == _student.studentId.id;
                                            }, orElse: () {
                                              // return SubmittedBy(
                                              //   message: [
                                              //     SubmittedMessage(text: 'Data Not Found'),
                                              //   ],
                                              // );
                                              return null;
                                            }),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${_student.name}',
                                        style: buildTextStyle(
                                          size: 16,
                                          // weight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          if (_student.status.toLowerCase() ==
                                                  'evaluated' &&
                                              _student.coins != null)
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/points.png',
                                                  height: 25,
                                                ),
                                                SizedBox(width: 2),
                                                Text('${_student.coins ?? 0}'),
                                              ],
                                            ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // for (var message in widget
                              //     .activity.submitedBy[index - 1].message)
                              //   Padding(
                              //     padding: const EdgeInsets.only(left: 20),
                              //     child: LimitedBox(
                              //       child: Text(
                              //         message.text,
                              //         style: buildTextStyle(size: 14),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          );
                        },
                      ),
                    );
                  else {
                    BlocProvider.of<AssignmentSubmissionCubit>(context).addData(
                        widget.activity.submitedBy, widget.activity.assignTo);
                    return Container(
                      child: Center(child: loadingBar),
                    );
                  }
                }),
              KeyboardVisibilityBuilder(
                builder: (ctx, isKeyboardVisible) => SizedBox(
                  height: isKeyboardVisible ? 350 : 80,
                ),
              ),
              BlocBuilder<ActivityCubit, ActivityStates>(
                  builder: (context, state) {
                if (state is TaskUploading)
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        // "Uploading ${state.progress.round()} %",
                        'Uploading ',
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 6),
                      LinearProgressIndicator(),
                    ],
                  );
                else
                  return Container();
              }),
            ],
          ),
        ),
        // SlidingUpPanel(
        //   defaultPanelState: PanelState.CLOSED,
        //   controller: uploadPanelController,
        //   minHeight: 0,
        //   maxHeight: MediaQuery.of(context).size.height * 0.30,
        //   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        //   backdropEnabled: true,
        //   onPanelOpened: () {
        //     setState(() {
        //       panelOpen = true;
        //     });
        //   },
        //   onPanelClosed: () {
        //     setState(() {
        //       panelOpen = false;
        //     });
        //   },
        //   backdropOpacity: 0.0,
        //   backdropColor: Colors.white,
        //   panel: uploadPanel(),
        // ),
        // SlidingUpPanel(
        //   defaultPanelState: PanelState.CLOSED,
        //   controller: uploadFilePanelController,
        //   minHeight: 0,
        //   maxHeight: MediaQuery.of(context).size.height * 0.165,
        //   borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        //   backdropEnabled: true,
        //   onPanelOpened: () {
        //     setState(() {
        //       panelOpen = true;
        //     });
        //   },
        //   onPanelClosed: () {
        //     setState(() {
        //       panelOpen = false;
        //     });
        //   },
        //   panel: uploadFilePanel(),
        //   backdropOpacity: 0.0,
        //   backdropColor: Colors.white,
        // ),
      ],
    );
  }

  Future<DateTime> _pickDate({DateTime date}) async {
    DateTime __date = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 90),
      ),
    );
    if (__date != null) {
      return __date;
    }
    setState(() {});
  }

  void _pickTime() async {
    TimeOfDay _td = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_td != null) _endTime = _td;
    setState(() {});
  }

  IconData checkIcon(String ext) {
    switch (ext) {
      case "png":
        return FontAwesomeIcons.image;
      case "jpg":
        return FontAwesomeIcons.image;
      case "pdf":
        return FontAwesomeIcons.solidFilePdf;
      case "mp4":
        return FontAwesomeIcons.video;
      case "mp3":
        return FontAwesomeIcons.music;
      default:
        return FontAwesomeIcons.file;
    }
  }

  Container _dropdownMenu(String title, {IconData icon}) {
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

          // SizedBox(
          //   width: 3,
          // ),
          Text(
            "$title",
            style: buildTextStyle(
              size: 12.5,
              color: Colors.grey[500],
            ),
          ),
          Icon(icon ?? Icons.timelapse_outlined, size: 18,),
        ],
      ),
    );
  }

  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please Enter value';
  }

  void _pickImage() async {
    var __image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    try {
      String path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_PICTURES);
      String filePath = path + '/' + __image.name;
      __image.saveTo(filePath);
      if (__image != null)  _image = PlatformFile(name: __image.name, size: await __image.length(),path: __image.path);
      List<PlatformFile> files = _fileStreamController.stream.valueOrNull;
      if(files == null){
        files = [];
      }
      if(_image != null)
      files.add(_image);
       _fileStreamController.sink.add(files);
    } catch (e) {
      log('error $e');
    }
    setState(() {});
  }

  void _pickVideo() async {
    var __image = await ImagePicker().pickVideo(
      source: ImageSource.camera,
      // imageQuality: 80,
    );

    try {
      String path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_PICTURES);
      String filePath = path + '/' + __image.name;
      __image.saveTo(filePath);
      if (__image != null) _image = PlatformFile(size: await __image.length(), name: __image.name,path: __image.path);
      List<PlatformFile> files = _fileStreamController.stream.valueOrNull;
      if(files == null){
        files =[];
      }

      if (_image != null)
        files.add(_image);
        _fileStreamController.sink.add(files);
    } catch (e) {
      log('error $e');

    }
    setState(() {});
  }
  void _pickFiles(String directory) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
      initialDirectory: directory,
    );
    if (result.files.isNotEmpty) {
      for (var file in result.files) {
        try {
          if ((file.extension != null && file.extension.isNotEmpty) &&
              (file.name != null && file.name.isNotEmpty) &&
              (file.name != file.extension)) {
            List<PlatformFile> files = _fileStreamController.stream.valueOrNull;

            if(files == null){
              files = [];
            }
            files.add(file);
            _fileStreamController.sink.add(files);

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
}


