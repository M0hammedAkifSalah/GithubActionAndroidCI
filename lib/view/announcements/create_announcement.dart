

import 'dart:developer';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:rxdart/rxdart.dart';

import '../../export.dart';
import '../attached_files_and_url_slider.dart';
import '../audio-record-page.dart';
PlatformFile _image;
DateTime _date;
TimeOfDay _time;
final _fileStreamController = BehaviorSubject<List<PlatformFile>>();
class CreateAnnouncement extends StatefulWidget {
  final String taskName;
  CreateAnnouncement({this.taskName});
  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  AnnouncementTask announcementTask;
  GlobalKey<FormState> form = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    _date = null;
    _time = null;
    announcementTask = AnnouncementTask();
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
        if (announcementTask.description == null &&
            announcementTask.title == null) {
          // Navigator.of(context).pop();
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
          check: _date != null && _time != null,
          onPressed: () {
            if (form.currentState.validate()) {
              announcementTask.dueDate = DateFormat('yyyy-MM-dd').format(_date);
              _date = DateTime(
                  _date.year, _date.month, _date.day, _time.hour, _time.minute);
              announcementTask.endTime = _date.toIso8601String();
              Navigator.of(context).push(
                createRoute(
                  pageWidget: MultiBlocProvider(
                    providers: [
                      BlocProvider<GroupCubit>(
                        create: (context) => GroupCubit()..loadGroups(),
                      ),
                      BlocProvider<StudentProfileCubit>(
                        create: (context) =>
                            StudentProfileCubit()..loadStudentProfile(
                              page: 1,
                              limit: 10,
                            ),
                      )
                    ],
                    child: AssignTask(
                      files:
                      _fileStreamController.hasValue ?
                      _fileStreamController.stream.value :[],
                      // image: _image,
                      task: announcementTask,
                      title: 'Announcement',
                      isJoinedClass: false,
                    ),
                  ),
                ),
              );
            }
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
              if (announcementTask.description == null &&
                  announcementTask.title == null) {
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
          title: Padding(
            padding: screenwidth > 600 ? const EdgeInsets.fromLTRB(0, 30, 0, 0): const EdgeInsets.all(0.0),
            child: Text(
              'Announcement',
              style: buildTextStyle(
                size: screenwidth > 600 ? 25 : 15,
                weight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Center(

            child: Container(
              width:  screenwidth > 600 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 0.99,
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
                      Padding(
                        padding:screenwidth > 600 ?  const EdgeInsets.all(28.0) :const EdgeInsets.all(0.0) ,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          width: double.infinity,
                          // alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
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
                          child: Form(
                            key: form,
                            child: AnnouncementWidget(
                              announcementTask: announcementTask,
                              editable: true,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnnouncementWidget extends StatefulWidget {
  const AnnouncementWidget({
    Key key,
    this.announcementTask,
    this.activity,
    this.editable = true,
    this.form,
    this.onChanged,
  }) : super(key: key);

  final AnnouncementTask announcementTask;
  final Activity activity;
  final GlobalKey<FormState> form;
  final bool editable;
  final Function(String value) onChanged;

  @override
  _AnnouncementWidgetState createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please provide a value';
  }

  bool isEmpty = false;

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
    return Column(
      children: [
        TextFormField(
          initialValue: !widget.editable ? widget.activity.title : '',
          enabled: widget.editable,
          maxLength: null,
          maxLines: null,
          validator: (value) {
            widget.announcementTask.title = value;
            return validator(value);
          },
          decoration: InputDecoration(
            labelText: 'title of announcement'.toUpperCase(),
            border: UnderlineInputBorder(
              borderSide: BorderSide(width: 2),
            ),
          ),
        ),
        Container(
          // height: 48,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.asset(
                    'assets/images/points.png',
                    height: 20,
                    width: 20,
                  ),
                  TextFormField(
                    initialValue:
                        !widget.editable ? widget.activity.coin.toString() : '',
                    enabled: widget.editable,
                    maxLength: 2,
                    onChanged: (value) {
                      print(value);
                    },
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      print(value);
                      if (int.tryParse(value) == null || value.isEmpty) {
                        setState(() {
                          isEmpty = true;
                        });
                        return 'Please Provide a value';
                      }
                      widget.announcementTask.coin = int.parse(value);
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
                  ).expandFlex(isEmpty ? 6 : 1),
                  Spacer(
                    flex: 5,
                  ),
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
                style: buildTextStyle(size: 12, color: Colors.grey),
              ),
              if (!widget.editable)
                Text(
                  DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(widget.activity.dueDate)) ??
                      '',
                  style: buildTextStyle(),
                ),
              if (_date == null && widget.editable)
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
              if (_date != null && widget.editable)
                FlatButton.icon(
                  icon: Icon(
                    Icons.edit,
                    size: 10,
                  ),
                  onPressed: _pickDate,
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
                style: buildTextStyle(size: 12, color: Colors.grey),
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
        TextFormField(
          initialValue: !widget.editable ? widget.activity.description : '',
          enabled: widget.editable,
          onChanged: widget.onChanged,
          maxLines: 6,
          validator: (value) {
            widget.announcementTask.description = value;
            return validator(value);
          },
          decoration: InputDecoration(
            alignLabelWithHint: true,
            border: UnderlineInputBorder(),
            labelText: 'Announcement',
            labelStyle: buildTextStyle(
              size: 12,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
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
        SizedBox(
          height: 10,
        ),
        if (!widget.editable) getAcknowledgedList(),
        KeyboardVisibilityBuilder(
          builder: (ctx, isKeyboardVisible) => SizedBox(
            height: isKeyboardVisible ? 250 : 80,
          ),
        ),
      ],
    );
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

  void _pickDate() async {
    DateTime __date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 90),
      ),
    );
    if (__date != null) _date = __date;
    setState(() {});
  }

  void _pickTime() async {
    TimeOfDay _td = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_td != null) _time = _td;
    setState(() {});
  }

  Widget getAcknowledgedList() {
    switch (widget.activity.assigned) {
      case (Assigned.student):
        return acknowledgedByStudent();
      case (Assigned.parent):
        return acknowledgedByParent();
      case (Assigned.faculty):
        return acknowledgedByTeacher();

        break;
      default:
        return acknowledgedByStudent();
    }
  }

  Widget acknowledgedByStudent() {
    List<AssignTo> _student;

    // _student = widget.activity.assignTo.firstWhere((student) =>
    //   student.studentId.id ==
    //   widget.activity.acknowledgeBy[index].acknowledgeByStudent);
    _student = widget.activity.assignTo
        .where((element) => element.status.toLowerCase() == 'submitted')
        .toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _student.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: TeacherProfileAvatar(
            imageUrl: _student[index].studentId.profileImage ?? 'text',
          ),
          subtitle: Text(
              "Class : ${_student[index].className ?? ''} ${(_student[index].studentId.sectionName != 'no name') ? _student[index].studentId.sectionName : ''}"),
          title: Text(
            '${_student[index].studentId.name}',
            style: buildTextStyle(
              size: 16,
            ),
          ),
        );
      },
    );
  }

  Widget acknowledgedByTeacher() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.activity.acknowledgeByTeacher.length,
      itemBuilder: (context, index) {
        var _teacher = widget.activity.assignToYou.firstWhere(
          (student) =>
              student.teacherId ==
              widget.activity.acknowledgeByTeacher[index].acknowledgeByTeacher,
        );
        return ListTile(
          leading: TeacherProfileAvatar(
            imageUrl: _teacher.profileImage,
          ),
          title: Text(
            '${_teacher.name}',
            style: buildTextStyle(
              size: 16,
            ),
          ),
        );
      },
    );
  }

  Widget acknowledgedByParent() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.activity.acknowledgeByParent.length,
      itemBuilder: (context, index) {
        var parent = widget.activity.assignToParent
            .where((element) => widget.activity.acknowledgeByParent
                .map((e) => e.acknowledgeByParent)
                .contains(element.parentId))
            .toList()[index];
        return ListTile(
          leading: TeacherProfileAvatar(
            imageUrl: parent.profileImage ?? 'text',
          ),
          title: Text(
            '${parent.name}',
            style: buildTextStyle(
              size: 16,
            ),
          ),
        );
      },
    );
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
}
