import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:growonplus_teacher/app-config.dart';

import '/bloc/activity/assignment-cubit.dart';
import '/bloc/activity/assignment-states.dart';
import '../../export.dart';
import 'image-editor.dart';

class EvaluateAssignment extends StatefulWidget {
  final StudentInfo studentInfo;
  final Activity activity;
  final SubmittedBy submittedBy;
  final String comment;

  EvaluateAssignment(
      {this.activity, this.studentInfo, this.comment, this.submittedBy});

  @override
  _EvaluateAssignmentState createState() => _EvaluateAssignmentState();
}

class _EvaluateAssignmentState extends State<EvaluateAssignment> {
  PanelController _panel = PanelController();
  TextEditingController reassignTextController = TextEditingController();
  TextEditingController scoreTextController = TextEditingController();
  bool _assign = false;

  // List<PlatformFile> _files = [];
  List<PlatformFile> _attachedImages = [];
  String ableTo = 'Able To';
  Reward reward = Reward();
  int extraCoin = 0;
  int maxHeight = 0;
  String reason = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          if (_panel.isPanelOpen) {
            _panel.close();
            return false;
          } else {
            Navigator.of(context).pop();
            return true;
          }
        },
        child:
            BlocBuilder<AssignmentSubmissionCubit, AssignmentSubmissionStates>(
                builder: (context, state) {
          if (state is AssignmentSubmissionLoaded) {
            return KeyboardVisibilityBuilder(
              builder: (_, isKeyboardVisible) => SlidingUpPanel(
                borderRadius: BorderRadius.circular(20),
                controller: _panel,
                panel: _assign
                    ? _assignPanel(state)
                    : _scorePanel(state, widget.activity.coin),
                minHeight: 0,
                maxHeight: ((_assign ? 450 : 580) +
                        maxHeight +
                        (_attachedImages.isNotEmpty ? 150 : 0))
                    .toDouble(),
                body: Scaffold(
                  bottomNavigationBar: widget.activity.status.toLowerCase() !=
                              'evaluated' &&
                          [
                            'pending',
                            'submitted',
                            're-submitted'
                          ].contains(state.allStudents
                              .firstWhere((element) =>
                                  element.studentId.id == widget.studentInfo.id)
                              .status
                              .toLowerCase())
                      ? Container(
                          color: Colors.white,
                          height: 110,
                          width: double.infinity,
                          child: Column(
                            children: [
                              CustomRaisedButton(
                                title: 'Re-assign with Comment',
                                check: true,
                                width: 220,
                                onPressed: () {
                                  setState(() {
                                    _assign = true;
                                  });

                                  maxHeight = 0;
                                  _panel.open();
                                },
                                bgColor: const Color(0xff261739),
                                textColor: Theme.of(context).primaryColor,
                              ),
                              CustomRaisedButton(
                                width: 220,
                                check: true,
                                title: 'Evaluate with Score',
                                onPressed: () {
                                  widget.studentInfo.taskEvaluated = false;
                                  _assign = false;
                                  setState(() {});
                                  maxHeight = 0;
                                  _panel.open();
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
                        ),
                  appBar: AppBar(
                    iconTheme: const IconThemeData(color: Colors.black),
                    title: Text(
                      'Assignment',
                      style: buildTextStyle(
                        size: 15,
                        weight: FontWeight.w600,
                      ),
                    ),
                    centerTitle: true,
                  ),
                  body: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListTile(
                              leading: TeacherProfileAvatar(
                                imageUrl:
                                    widget.studentInfo.profileImage ?? 'text',
                              ),
                              title: Text(widget.studentInfo.name),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.activity.status.toTitleCase(),
                                    style: buildTextStyle(
                                        size: 12, color: Colors.grey[400]),
                                  ),
                                  Text(
                                    // widget.activity.dueDate,
                                    DateFormat('yMMMd').format(
                                            widget.submittedBy.submittedDate) ??
                                        '',
                                    style: buildTextStyle(
                                      size: 12,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            EvaluateWidget(
                              comment: widget.comment,
                              activity: widget.activity,
                              studentName: widget.studentInfo.name,
                              submittedBy: widget.submittedBy,
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Container(
              child: Center(
                child: loadingBar,
              ),
            );
          }
        }),
      ),
    );
  }

  Widget _assignPanel(AssignmentSubmissionLoaded state) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(
                    flex: 4,
                  ),
                  Text(
                    'Re-assign',
                    style: buildTextStyle(
                      size: 14,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _panel.close();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                maxLines: 5,
                onTap: () {
                  setState(() {
                    maxHeight = 200;
                  });
                },
                controller: reassignTextController,
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Write comment',
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              // for (var i in _files)
              //   ListTile(
              //     leading: Icon(checkIcon(i.extension)),
              //     trailing: IconButton(
              //       icon: Icon(Icons.close),
              //       onPressed: () {
              //         _files.remove(i);
              //         setState(() {});
              //       },
              //     ),
              //     title: Text('${i.name}'),
              //   ),
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
              //     trailing: const Icon(
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
              // ).mv15,
              // SizedBox(height: 15),
              attachFile(),
              CustomRaisedButton(
                title: 'Re-assign',
                onPressed: () async {
                  state.allStudents.forEach((element) {
                    if (element.studentId.id == widget.studentInfo.id)
                      element.status = 'Re-work';
                  });
                  BlocProvider.of<AssignmentSubmissionCubit>(context)
                      .addData(state.submission, state.allStudents);
                  await BlocProvider.of<ActivityCubit>(context, listen: false)
                      .reassignAssignment(
                    widget.studentInfo.id,
                    widget.activity.id,
                    reassignTextController.text,
                    _attachedImages,
                  );
                  showDialog(
                      context: context,
                      builder: (context) {
                        // return const CustomAlertDialog(
                        //   message: 'Assignment Re-Assigned Successfully',
                        //   confirm: 'ok',
                        // );
                      });
                  _panel.close();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget attachFile() {
    return Column(
      children: [
        const SizedBox(height: 20),
        if (_attachedImages.isNotEmpty)
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: ReorderableListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _attachedImages.length,
              proxyDecorator: (child, index, animation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget child) {
                    final double animValue =
                        Curves.easeInOut.transform(animation.value);
                    final double elevation = lerpDouble(0, 6, animValue);
                    return Material(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(20.0),
                      elevation: elevation,
                      child: child,
                    );
                  },
                  child: child,
                );
              },
              itemBuilder: (context, index) {
                var attachment = _attachedImages[index];
                return SizedBox(
                  width: 150,
                  height: 150,
                  key: Key('$index'),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: Colors.red.shade50,
                            padding: EdgeInsets.zero,
                          ),
                          clipBehavior: Clip.antiAlias,
                          onPressed: () {
                            if (attachment.extension == "jpg" ||
                                attachment.extension == "jpeg" ||
                                attachment.extension == "png") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    appBar: AppBar(
                                      iconTheme:
                                          IconThemeData(color: Colors.black),
                                      title: Text(
                                        "Preview",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    body: InteractiveViewer(
                                      child: Center(
                                        child: Image.memory(
                                          attachment.bytes,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: attachment.extension == "jpg" ||
                                        attachment.extension == "jpeg" ||
                                        attachment.extension == "png"
                                    ? Image.memory(
                                        attachment.bytes,
                                        fit: BoxFit.fill,
                                        width: 100,
                                        height: 100,
                                      )
                                    : Icon(checkIcon(attachment.extension)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _attachedImages.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.cancel),
                      ),
                    ],
                  ),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = _attachedImages.removeAt(oldIndex);
                  _attachedImages.insert(newIndex, item);
                });
              },
            ),
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
            onTap: () {
              List<SubmittedMessage> messages = [];
              // if(widget.submittedBy != null)
              for (var item in widget.submittedBy.message) {
                messages.add(item.clone());
              }
              SubmittedMessage message = messages.lastWhere(
                (element) =>
                    !element.evaluator &&
                    element.file != null &&
                    element.file.isNotEmpty,
                orElse: () => null,
              );
              if (message != null) {
                message.file.removeWhere((element) {
                  return !element.toLowerCase().endsWith('.jpeg') &&
                      !element.toLowerCase().endsWith('.jpg') &&
                      !element.toLowerCase().endsWith('.png');
                });
                if (message.file.isEmpty) {
                  message = null;
                }
              }
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  useRootNavigator: true,
                  builder: (BuildContext contextA) {
                    return SimpleDialog(
                      title: const Text('Pick From'),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      children: <Widget>[
                        if (message != null)
                          SimpleDialogOption(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 24.0),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              Map<String, dynamic> imageData =
                                  await showPicker(message);
                              if (imageData != null) {
                                setState(() {
                                  _attachedImages.add(PlatformFile(
                                    name:
                                        "${imageData["name"][0]}_edit.${imageData["name"][1]}",
                                    size: imageData["data"].lengthInBytes,
                                    bytes: imageData["data"],
                                  ));
                                });
                              }
                            },
                            child: const ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.image),
                              title: Text('Student\'s Attachment'),
                            ),
                          ),
                        SimpleDialogOption(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 24.0),
                          onPressed: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: allowedExtensions,
                              withData: true,
                            );
                            if (result != null) {
                              var file = result.files.single;
                              var ext = file.extension;
                              if (ext != "jpg" &&
                                  ext != "jpeg" &&
                                  ext != "png") {
                                setState(() {
                                  _attachedImages.add(file);
                                });
                                Navigator.of(context).pop();
                                return;
                              }
                              var imageData = await Navigator.of(context).push(
                                createRoute(
                                  pageWidget: ImageEditAssignment(
                                      isUrl: false, byte: file.bytes),
                                ),
                              );
                              if (imageData is Uint8List && imageData != null) {
                                setState(() {
                                  _attachedImages.add(PlatformFile(
                                    name: file.name,
                                    size: imageData.lengthInBytes,
                                    bytes: imageData,
                                  ));
                                });
                                Navigator.of(context).pop();
                              }
                            } else {
                              // User canceled the picker
                            }
                          },
                          child: const ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.smartphone),
                            title: Text('Device'),
                          ),
                        ),
                      ],
                    );
                  });
              // _pickFiles();
            },
            // tileColor: Colors.grey,
            trailing: const Icon(
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
        SizedBox(height: 15),
      ],
    );
  }

  // void _pickFiles() async {
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //     allowMultiple: true,
  //     allowCompression: true,
  //     type: FileType.custom,
  //     allowedExtensions: allowedExtensions,
  //   );
  //   if (result.files.isNotEmpty) {
  //     for (var file in result.files) {
  //       try {
  //         if ((file.extension != null && file.extension.isNotEmpty) &&
  //             (file.name != null && file.name.isNotEmpty) &&
  //             (file.name != file.extension)) {
  //           _files.add(file);
  //         } else {
  //           log('File-name: ${file.name}, ${file.extension}, ${file.size}');
  //           Fluttertoast.showToast(msg: 'Invalid File Format');
  //         }
  //       } catch (error) {
  //         log('File-name-error: ${file.name}, ${file.extension}, ${file.size}');
  //         Fluttertoast.showToast(msg: 'Invalid File Format');
  //       }
  //     }
  //   }
  //   setState(() {});
  // }

  Future<Map<String, dynamic>> showPicker(SubmittedMessage message) async {
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Attachments"),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.clear),
              ),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: message.file.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: Colors.red.shade50,
                      padding: EdgeInsets.zero,
                    ),
                    clipBehavior: Clip.antiAlias,
                    onPressed: () async {
                      var imageData = await Navigator.of(context).push(
                        createRoute(
                          pageWidget: ImageEditAssignment(
                              isUrl: true, url: message.file[index]),
                        ),
                      );
                      if (imageData is Uint8List && imageData != null) {
                        var fileName =
                            message.file[index].split('/').last.split('.');
                        Navigator.of(context)
                            .pop({"name": fileName, "data": imageData});
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: message.file[index],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _scorePanel(AssignmentSubmissionLoaded state, int coin) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Spacer(
                  flex: 4,
                ),
                Text(
                  'Scoring',
                  style: buildTextStyle(
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _panel.close();
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              maxLines: 4,
              onTap: () {
                setState(() {
                  maxHeight = 200;
                });
              },
              controller: scoreTextController,
              onChanged: (value) {
                reason = value;
              },
              decoration: const InputDecoration(
                alignLabelWithHint: true,
                labelText: 'Write comment',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  child: Column(
                    children: [
                      Text(
                        'Actioned Points',
                        style:
                            buildTextStyle(color: Color(0xff828282), size: 12),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/points.png',
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(
                            width: 50,
                            child: TextFormField(
                              initialValue: '$coin',
                              enabled: false,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  child: Column(
                    children: [
                      Text(
                        'Additional Points',
                        style:
                            buildTextStyle(color: Color(0xff828282), size: 12),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/points.png',
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(
                            width: 50,
                            child: TextFormField(
                              initialValue: '0',
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              decoration: const InputDecoration(
                                counterText: '',
                              ),
                              onChanged: (value) {
                                if (int.tryParse(value) != null) {
                                  extraCoin = int.parse(value);
                                }
                              },
                              // enabled: false,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Action Status',
                  style: buildTextStyle(size: 12),
                ),
                PopupMenuButton(
                  onSelected: (value) {
                    ableTo = value;
                    // widget.assignmentTask.subject = value;
                    setState(() {});
                  },
                  child: dropdownMenu(ableTo),
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'Able To',
                        child: ListTile(
                          title: Text('Able To'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'Unable To',
                        child: ListTile(
                          title: Text('Unable To'),
                        ),
                      ),
                    ];
                  },
                )
              ],
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            attachFile(),
            CustomRaisedButton(
              title: 'Reward',
              onPressed: () async {
                reward.activityId = widget.activity.id;
                reward.students = [
                  RewardedStudent(
                    coin,
                    studentId: widget.studentInfo.id,
                    extraCoin: extraCoin,
                    reason: reason,
                  ),
                ];
                for (var element in state.allStudents) {
                  if (element.studentId.id == widget.studentInfo.id) {
                    element.status = 'Evaluated';
                  }
                }
                if (widget.activity.updateAssignmentStatus) {
                  log("Calling-update-status-assignment");
                  BlocProvider.of<ActivityCubit>(context)
                      .updateAssignmentStatus(widget.activity.id);
                }
                if (_attachedImages.isNotEmpty) {
                  await BlocProvider.of<ActivityCubit>(context).submitEvaluated(
                      widget.studentInfo.id,
                      widget.activity.id,
                      reason,
                      _attachedImages);
                }
                Fluttertoast.showToast(msg: 'Student is rewarded');
                BlocProvider.of<AssignmentSubmissionCubit>(context)
                    .addData(state.submission, state.allStudents);
                BlocProvider.of<GroupCubit>(context, listen: false)
                    .rewardStudents(reward);
                _panel.close();

                Navigator.of(context).pushReplacement(
                  createRoute(
                    pageWidget: MultiBlocProvider(
                      providers: [
                        BlocProvider<GroupCubit>(
                          create: (context) => GroupCubit(),
                        ),
                        BlocProvider<AssignmentSubmissionCubit>(
                          create: (context) => AssignmentSubmissionCubit()
                            ..addData(
                                widget.activity.submitedBy, widget.activity.assignTo),
                        ),
                      ],
                      child: EvaluateTask(
                          widget.activity, widget.activity.status == 'Evaluate'),
                    ),
                  ),
                );
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class EvaluateWidget extends StatefulWidget {
  EvaluateWidget(
      {Key key,
      this.activity,
      this.studentName,
      this.submittedBy,
      this.comment})
      : super(key: key);

  final Activity activity;
  final String studentName;
  final SubmittedBy submittedBy;
  final String comment;

  @override
  _EvaluateWidgetState createState() => _EvaluateWidgetState();
}

class _EvaluateWidgetState extends State<EvaluateWidget>
    with SingleTickerProviderStateMixin {
  TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TextFormField(
              enabled: false,
              initialValue: widget.activity.title,
              decoration: InputDecoration(
                labelText: 'Title of Assignment'.toUpperCase(),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 2),
                ),
              ),
            ).expand,
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
                    enabled: false,
                    initialValue: "${widget.submittedBy != null ? widget.submittedBy.coins ?? 0:0}".toString(),
                    keyboardType: TextInputType.number,
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
                  ).expandFlex(1),
                  Spacer(),
                  // SvgPicture.asset(
                  //   'assets/svg/trophy.svg',
                  //   height: 20,
                  //   width: 20,
                  // ),
                  // TextFormField(
                  //   enabled: false,
                  //   initialValue: "${widget.activity.reward ?? 0}",
                  //   keyboardType: TextInputType.number,
                  //   decoration: InputDecoration(
                  //     border: UnderlineInputBorder(
                  //       borderSide: BorderSide(width: 2),
                  //     ),
                  //     hintText: 'Coins',
                  //     hintStyle: buildTextStyle(
                  //       size: 10,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ).expandFlex(1),
                  Spacer(
                    flex: 3,
                  ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(
              //   'LAST DATE FOR SUBMISSION',
              //   style: buildTextStyle(size: 15, color: Colors.grey),
              // ),
              // if (_date == null && widget.editable)
              //   IconButton(
              //     icon: Icon(Icons.calendar_today),
              //     onPressed: _pickDate,
              //   ),
              // if (_date != null && widget.editable)
              //   FlatButton.icon(
              //     icon: Icon(
              //       Icons.edit,
              //       size: 10,
              //     ),
              //     onPressed: _pickDate,
              //     label: Text(
              //       DateFormat("d-MM-yyyy").format(_date),
              //     ),
              //   ),
              // if (!widget.editable)
              //   FlatButton.icon(
              //     icon: Icon(
              //       Icons.edit,
              //       size: 10,
              //     ),
              //     onPressed: null,
              //     label: Text(
              //       widget.activity.dueDate,
              //     ),
              //   ),
              InkWell(
                child: _dropdownMenu(
                    '${DateTime.parse(widget.activity.startDate).toDateTimeFormatInLine(context)}'),
              ),

              InkWell(
                child: _dropdownMenu(
                    '${widget.activity.endDateTime.toDateTimeFormatInLine(context)}'),
              ),
            ],
          ),
        ),
        Row(
          children: [
            // _dropdownMenu(widget.activity.className),
            // Spacer(),
            _dropdownMenu(widget.activity.subject ?? 'error'),
          ],
        ),
        if (features['learningOutcome']['isEnabled'])
          TextFormField(
            initialValue: widget.activity.learningOutcome,
            enabled: false,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              border: UnderlineInputBorder(),
              labelText: 'LEARNING OUTCOME',
              labelStyle: buildTextStyle(
                size: 12,
                color: Colors.grey,
              ),
            ),
          ),
        TextFormField(
          initialValue: widget.activity.description,
          enabled: false,
          maxLines: null,
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
        if (widget.activity.files.isNotEmpty)
          FileListing(widget.activity.files),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Submission By Student',
            style: buildTextStyle(size: 20),
          ),
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.submittedBy != null)
              for (var submit in widget.submittedBy.message)
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              '${DateFormat('dd-MMM-yy').format(submit.submittedDate)}'),
                          SizedBox(
                            width: 5,
                          ),
                          Divider(
                            color: Colors.grey,
                          ).expand,
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      submit.text.convertToHyperLink,
                      if (submit.lateReason != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Comment by Student : '
                                          // '${DateFormat('dd-MMM-yy').format(submit.submittedDate)}'
                                          ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ).expand,
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  submit.lateReason.convertToHyperLink,
                                  // if(widget.activity.files.isNotEmpty)
                                  //   FileListing(
                                  //     submit.file ?? [],
                                  //     date: submit.submittedDate,
                                  //     subtitle: submit.evaluator ? 'By Evaluator' : null,
                                  //   )
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (submit.file.isNotEmpty ?? [].isNotEmpty)
                        FileListing(
                          submit.file,
                          date: submit.submittedDate,
                          subtitle: submit.evaluator ? 'By Evaluator' : null,
                        )
                    ],
                  ),
                ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Feedback',
            style: buildTextStyle(size: 20),
          ),
        ),
        Column(
          children: [
            for (var i in widget.activity.activityReward)
              if(widget.submittedBy != null)
              if (i.studentId == widget.submittedBy.studentId)
                Container(
                  child: Text(i.reason ?? 'No Feedback'),
                )
          ],
        )
      ],
    );
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
            width: 10,
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

  String validator(String value) {
    if (value.isNotEmpty) return null;
    return 'Please Enter value';
  }
}
