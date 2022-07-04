import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_configuration/global_configuration.dart';
import '/export.dart';
import '/model/class-schedule.dart';
import '/view/test-module/constants.dart';

class AddNewLearningPage extends StatefulWidget {
  final bool forChapter;
  final Learnings topic;
  final Learnings chapter;
  final Learnings subject;
  final SchoolClassDetails className;
  AddNewLearningPage(
    this.className,
    this.forChapter, {
    @required this.chapter,
    @required this.topic,
    @required this.subject,
  });
  @override
  _AddNewLearningPageState createState() => _AddNewLearningPageState();
}

class _AddNewLearningPageState extends State<AddNewLearningPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  SchoolClassDetails currentClass;
  Learnings currentSubject;
  Learnings currentChapter;
  Learnings currentTopic;
  GlobalKey<FormState> _form = GlobalKey();
  CustomEditingController _customEditingController = CustomEditingController();
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textAddEditingController = TextEditingController();
  Learnings _learnings;
  List<PlatformFile> _file = [];
  bool uploading = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _learnings = Learnings();
    _tabController = TabController(vsync: this, length: 3);
    currentChapter = widget.chapter;
    currentSubject = widget.subject;
    currentTopic = widget.topic;
    currentClass = widget.className;
  }

  String validator(String value) {
    if (value.isEmpty)
      return 'Please provide a value';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        child: uploading
            ? Container(
                height: 10,
                child: LinearProgressIndicator(
                  color: kPrimaryColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // if (uploading)

                  if (!uploading)
                    CustomRaisedButton(
                      onPressed: () {
                        // setState(() {
                        //   uploading = true;
                        // });
                        handleUpdateLearning();
                      },
                      title: uploading ? 'Uploading..' : 'Upload',
                      check: uploading
                          ? false
                          : currentSubject != null &&
                              _file.isNotEmpty &&
                              currentChapter != null,
                    )
                ],
              ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add Files', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        bottom: TabBar(
          onTap: (value) {
            setState(() {});
          },
          indicatorColor: Color(0xffFFC30A),
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Image',
              //child: Text('Image'),
            ),
            Tab(
              text: 'Video',
              //child: Text('Video'),
            ),
            Tab(
              text: 'Documents',
              //child: Text('Documents'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title of the ${_tabController.index == 0 ? 'Image' : _tabController.index == 1 ? 'Video' : 'Documents'}',
                      style: buildTextStyle(),
                    ),
                    TextFormField(
                      focusNode: focusNode,
                      validator: validator,
                      controller: _textEditingController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Associated With',
                      style: buildTextStyle(size: 22),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Class',
                          style: buildTextStyle(),
                        ),
                        BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
                            builder: (context, state) {
                          return PopUpMenuWidget(
                            onSelected: (value) {
                              BlocProvider.of<LearningDetailsCubit>(context,
                                      listen: false)
                                  .getSubjectDetails(classId: value);
                              if (state is ClassDetailsLoaded) {
                                var _currentClass = state.classDetails.firstWhere(
                                    (learn) => learn.classId == value);
                                currentClass = _currentClass;
                                BlocProvider.of<LearningDetailsCubit>(context)
                                    .getSubjectDetails(
                                        classId: _currentClass.classId);
                                setState(() {});
                              }
                            },
                            children: (context) {
                              if (state is ClassDetailsLoaded) {
                                return [
                                  for (var i in state.classDetails)
                                    PopupMenuItem(
                                      value: i.classId,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Text(i.className),
                                      ),
                                    ),
                                ];
                              }
                              BlocProvider.of<LearningClassCubit>(context)
                                  .getClasses();
                              return [];
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.43,
                                    child: Text(currentClass == null
                                        ? 'Class'
                                        : currentClass.className),
                                  ),
                                  Icon(Icons.expand_more),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subject',
                          style: buildTextStyle(),
                        ),
                        BlocBuilder<LearningDetailsCubit, LearningStates>(
                            builder: (context, snapshot) {
                          return PopUpMenuWidget(
                            onSelected: (value) {
                              if (snapshot is LearningSubjectLoaded) {
                                var _currentSubject = snapshot.subjectLearning
                                    .firstWhere((learn) => learn.id == value);
                                currentSubject = _currentSubject;
                              }
                              setState(() {});
                            },
                            children: (context) {
                              if (snapshot is LearningSubjectLoaded)
                                return [
                                  // PopupMenuItem(
                                  //   value: 'Not Associated',
                                  //   child: Container(
                                  //     padding: EdgeInsets.symmetric(
                                  //         horizontal: 15, vertical: 10),
                                  //     child: Text('Not Associated'),
                                  //   ),
                                  // ),
                                  // if(state is LearningDetailsLoaded)
                                  for (var i in snapshot.subjectLearning)
                                    PopupMenuItem(
                                      value: i.id,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Text(i.name),
                                      ),
                                      // onTap: focusNode.unfocus(),

                                    ),
                                ];
                              BlocProvider.of<LearningDetailsCubit>(context)
                                  .getSubjectDetails(
                                      classId: currentClass.classId);
                              return [];
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.43,
                                    child: Text(
                                      currentSubject == null
                                          ? 'Subject'
                                          : currentSubject.name,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(Icons.expand_more),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chapter',
                          style: buildTextStyle(),
                        ),
                        BlocBuilder<LearningChapterCubit, LearningChapterStates>(
                            builder: (context, snapshot) {
                          if (snapshot is LearningChapterLoaded)
                            return PopUpMenuWidget<Learnings>(
                              onSelected: (value) {
                                currentChapter = value;
                                // if (snapshot is LearningDetailsLoaded) {

                                // }
                                setState(() {});
                              },
                              children: (context) {
                                // if (snapshot is LearningDetailsLoaded)
                                return [
                                  for (var i in snapshot.chapterLearning)
                                    PopupMenuItem<Learnings>(
                                      value: i,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Text(i.name),
                                      ),
                                    ),
                                ];
                                // BlocProvider.of<LearningDetailsCubit>(context)
                                //     .getSubjectDetails(classId: currentClass.id);
                                // return [];
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.43,
                                      child: Text(
                                        currentChapter != null
                                            ? currentChapter.name
                                            : 'Chapter',
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(Icons.expand_more),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          else {
                            BlocProvider.of<LearningChapterCubit>(context)
                                .loadChapters(currentSubject?.id ?? '');
                            return Container();
                          }
                        }),
                      ],
                    ),
                    // }),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Topic',
                          style: buildTextStyle(),
                        ),
                        BlocBuilder<LearningTopicCubit, LearningTopicStates>(
                            builder: (context, snapshot) {
                          if (snapshot is LearningTopicLoaded)
                            return PopUpMenuWidget<Learnings>(
                              value: null,
                              onSelected: (value) {
                                currentTopic = value;
                                // if (snapshot is LearningDetailsLoaded) {

                                // }
                                setState(() {});
                              },
                              children: (context) {
                                // if (snapshot is LearningDetailsLoaded)
                                return [
                                  PopupMenuItem(
                                    value: null,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      child: Text('Not Associated'),
                                    ),
                                  ),
                                  for (var i in snapshot.topicLearning)
                                    PopupMenuItem<Learnings>(
                                      value: i,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        child: Text(i.name),
                                      ),
                                    ),
                                ];
                                // BlocProvider.of<LearningDetailsCubit>(context)
                                //     .getSubjectDetails(classId: currentClass.id);
                                // return [];
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.43,
                                      child: Text(
                                        currentTopic != null
                                            ? currentTopic.name
                                            : 'Topic',
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ),
                                    Icon(Icons.expand_more),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          else {
                            BlocProvider.of<LearningTopicCubit>(context)
                                .loadTopics(currentChapter?.id ?? '');
                            return Container();
                          }
                        }),
                      ],
                    ),
                    // }),
                    SizedBox(height: 30),
                    Text(
                      'Add Tags',
                      style: buildTextStyle(size: 22),
                    ),
                    TextFormField(
                      controller: _textAddEditingController,
                      decoration: InputDecoration(),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                    SizedBox(height: 20),
                    if (_file != null)
                      FileListing(_file.map((e) => e.name).toList()),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Attach Files',
                          style: buildTextStyle(
                            size: 17,
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> get getExtension {
    switch (_tabController.index) {
      case 0:
        return imageExtension;
      case 1:
        return videoExtension;
      case 2:
        return documentExtension;
        break;
      default:
        return <String>[];
    }
  }

  void _pickFiles() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      allowCompression: true,
      allowedExtensions: getExtension,
      type: FileType.custom,
    );
    if (result != null) if (result.files.isNotEmpty) {
      for (var i in result.files) {
        if (i.extension != null || i.extension.isNotEmpty) {
          _file.add(i);
        }
      }
    }
    setState(() {});
  }

  void handleUpdateLearning() async {
    if (_form.currentState.validate()) {
      uploading = true;
      setState(() {});
      var state;
      // _learnings.id = currentSubject.id;
      // _learnings.classId = currentSubject.classId;
      // _learnings.chapter = currentSubject.chapter;
      // _learnings.name = currentSubject.name;
      // _learnings.createdTag = _customEditingController.text;
      // _learnings.fileName = _textEditingController.text;
      // _learnings.subject = currentSubject.subject;
      // _learnings.fileUploaded = UploadedFiles(
      //   name: _textEditingController.text,
      // );
      // print(_learnings.toJson());
      if ((currentChapter != null) && (currentTopic == null)) {
        print('uploading in chapter');
        var learningFiles = List<LearningFiles>.from(
          _file.map((e) => LearningFiles(
              fileName: _textEditingController.text,
              file: GlobalConfiguration().get('fileURL') + '/' + e.name)),
        );
        var _upload = UploadedFiles(
          files: List<LearningFiles>.from(
            _file.map((e) => LearningFiles(
                fileName: _textEditingController.text, file: e.name)),
          ),
        );

        await BlocProvider.of<LearningDetailsCubit>(context, listen: false)
            .updateChapter(
          _upload,
          _textEditingController.text,
          _file,
          currentChapter.id,
        )
            .then((value) {
          learningFiles = value
              .map(
                (e) => LearningFiles(
                    file: e, fileName: _textEditingController.text),
              )
              .toList();
          BlocProvider.of<NewLearningFilesCubit>(context)
              .addNewFiles(learningFiles, false);
        });
        state =
            await BlocProvider.of<LearningChapterCubit>(context, listen: false)
                .loadChapters(currentSubject.id);
      } else if ((currentChapter == null) && (currentTopic == null)) {
        print('updating subject');
        var _upload = UploadedFiles(
          files: List<LearningFiles>.from(
            _file.map((e) => LearningFiles(
                fileName: _textEditingController.text, file: e.name)),
          ),
        );

        await BlocProvider.of<LearningDetailsCubit>(context, listen: false)
            .updateSubject(
          _upload,
          _file,
          currentSubject.id,
        );
      } else {
        print('updating topic');
        var learningFiles = List<LearningFiles>.from(
          _file.map((e) => LearningFiles(
              fileName: _textEditingController.text,
              file: GlobalConfiguration().get('fileURL') + '/' + e.name)),
        );
        _learnings = Learnings();
        _learnings = currentTopic;
        _learnings.tags = [_customEditingController.text];
        _learnings.uploadingFile = UploadedFiles(
          files: List<LearningFiles>.from(
            _file.map((e) => LearningFiles(
                fileName: _textEditingController.text, file: e.name)),
          ),
        );

        await BlocProvider.of<LearningDetailsCubit>(context, listen: false)
            .updateTopics(
          _learnings,
          _textEditingController.text,
          _file,
        )
            .then((value) {
          learningFiles = value
              .map(
                (e) => LearningFiles(
                  file: e,
                  fileName: _textEditingController.text,
                ),
              )
              .toList();
          BlocProvider.of<NewLearningFilesCubit>(context)
              .addNewFiles(learningFiles, true);
        });
        state =
            await BlocProvider.of<LearningTopicCubit>(context, listen: false)
                .loadTopics(currentChapter.id);
      }
      Navigator.of(context).pop();
      return;
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
          Icon(icon ?? Icons.expand_more),
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
}

class CustomEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan(
      {BuildContext context, TextStyle style, bool withComposing}) {
    List<InlineSpan> children = [];
    List<String> _text = text.split(' ');
    for (var i in _text)
      if (i.startsWith('#')) {
        children.add(
          TextSpan(
            style:
                TextStyle(color: Colors.white, backgroundColor: Colors.green),
            text: _text.indexOf(i) == 0 ? i : ' $i ',
          ),
        );
      } else {
        children.add(TextSpan(text: ' $i '));
      }
    return TextSpan(style: style, children: children);
  }
}
