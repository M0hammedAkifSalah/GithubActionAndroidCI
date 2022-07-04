import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/bloc/activity/edit-activity.dart';
import '../../export.dart';

class EditAssignmentPage extends StatefulWidget {
  EditAssignmentPage({
    Key key,
    this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  _EditAssignmentPageState createState() => _EditAssignmentPageState();
}

class _EditAssignmentPageState extends State<EditAssignmentPage> {
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(
        title: 'Save',
        onPressed: () {
          var act = widget.activity.toJson();
          // Activity(
          //         assigned: widget.activity.assigned,
          //         title: widget.activity.title,
          //         coin: widget.activity.coin,
          //         subject: widget.activity.subject,
          //         learningOutcome: widget.activity.learningOutcome,
          //         description: widget.activity.description,
          //         links: widget.activity.links)
          //     .toJson();
          // act.removeWhere((key, value) => value == null || value == []);
          //Edit assignment functionality and dialog message.
          // act.removeWhere((key, value) => value.toString() == '[]');
          EditActivity().editAssignment(widget.activity.id, act).then((value) {
            if (value) {
              // buildEditDialog(context, 'Assignment updated successfully')
              //     .then((value) {
              //   Navigator.of(context).pop();
              Fluttertoast.showToast(msg: 'Updated');
              // });
            } else {
              buildEditDialog(context, 'Assignment update failed')
                  .then((value) {
                Navigator.of(context).pop();
              });
            }
          });
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: Text(
          'Edit Assignment',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          width: screenwidth > 600 ? MediaQuery.of(context).size.width * 0.60 : MediaQuery.of(context).size.width * 0.99,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextFormField(
                        maxLength: null,
                        maxLines: null,
                        initialValue: widget.activity.title,
                        onChanged: (value) {
                          widget.activity.title = value;
                        },
                        validator: (value) {
                          print(value);
                          // print(widget.assignmentTask);
                          // widget.assignmentTask.title = value;
                          return validator(value);
                        },
                        decoration: InputDecoration(
                          labelText: 'title of assignment'.toUpperCase(),
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
                              initialValue: "${widget.activity.coin ?? 0}",
                              keyboardType: TextInputType.number,
                              maxLength: 2,
                              onChanged: (value) {
                                widget.activity.coin = int.parse(value);
                              },
                              validator: (value) {
                                // widget.assignmentTask.coin = int.parse(value);
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
                            ).expandFlex(1),
                            Spacer(flex: 3),
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   child: Container(
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           'LAST TIME FOR SUBMISSION',
                  //           style: buildTextStyle(size: 15, color: Colors.grey),
                  //         ),
                  //         if (!widget.editable)
                  //           Text(
                  //             widget.activity.endTime ?? '',
                  //             style: buildTextStyle(),
                  //           ),
                  //         if (_time == null && widget.editable)
                  //           IconButton(
                  //             icon: Icon(Icons.timelapse),
                  //             onPressed: _pickTime,
                  //           ),
                  //         if (_time != null && widget.editable)
                  //           FlatButton.icon(
                  //             icon: Icon(
                  //               Icons.edit,
                  //               size: 10,
                  //             ),
                  //             onPressed: _pickTime,
                  //             label: Text(
                  //               _time.format(context),
                  //             ),
                  //           )
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue: widget.activity.subject,
                    onChanged: (value) {
                      widget.activity.subject = value;
                    },
                    validator: (value) {
                      print(value);
                      // print(widget.assignmentTask);
                      // widget.assignmentTask.subject = value;
                      return validator(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Subject Name',
                      labelStyle: buildTextStyle(
                        size: 12,
                        color: Colors.grey,
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 12),
                  //   child: Row(
                  //     children: [
                  //       if (widget.editable)
                  //         BlocBuilder<ClassDetailsCubit, ClassDetailsState>(
                  //             builder: (context, state) {
                  //           return PopupMenuButton(
                  //             onSelected: (value) {
                  //               widget.assignmentTask.className = value.className;
                  //               // BlocProvider.of<SubjectDetailsCubit>(context)
                  //               //     .loadAssignmentSubjectDetails(value.classId);
                  //               setState(() {});
                  //             },
                  //             child: _dropdownMenu(
                  //                 widget.assignmentTask.className ?? 'Class'),
                  //             itemBuilder: (context) {
                  //               return [
                  //                 if (state is ClassDetailsLoaded)
                  //                   for (var _class in state.classDetails)
                  //                     PopupMenuItem(
                  //                       value: _class,
                  //                       child: ListTile(
                  //                         title: Text(_class.className),
                  //                       ),
                  //                     ),
                  //               ];
                  //             },
                  //           );
                  //         }),
                  //       if (!widget.editable) _dropdownMenu(widget.activity.className),
                  //       Spacer(),
                  //       if (!widget.editable)
                  //         _dropdownMenu(widget.activity.subject ?? 'error'),
                  //       if (widget.editable)
                  //         BlocBuilder<SubjectDetailsCubit, SubjectDetails>(
                  //             // stream: null,
                  //             builder: (context, state) {
                  //           return PopupMenuButton(
                  //             onSelected: (value) {
                  //               widget.assignmentTask.subject = value;
                  //               setState(() {});
                  //             },
                  //             child: _dropdownMenu(
                  //                 widget.assignmentTask.subject ?? 'Subject'),
                  //             itemBuilder: (context) {
                  //               return [
                  //                 if (state is SubjectDetailsLoaded)
                  //                   for (var _subject in state.subjects)
                  //                     PopupMenuItem(
                  //                       value: _subject.name,
                  //                       child: ListTile(
                  //                         title: Text(_subject.name),
                  //                       ),
                  //                     ),
                  //               ];
                  //             },
                  //           );
                  //         }),
                  //     ],
                  //   ),
                  // ),
                  TextFormField(
                    initialValue: widget.activity.learningOutcome,
                    validator: (value) {
                      // widget.assignmentTask.learningOutcome = value;
                      return null;
                    },
                    onChanged: (value) {
                      widget.activity.learningOutcome = value;
                    },
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

                    // onChanged: widget.onChanged,
                    validator: (value) {
                      // widget.assignmentTask.description = value;
                      return validator(value);
                    },
                    onChanged: (value) {
                      widget.activity.description = value;
                    },
                    maxLines: 4,
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
                  SizedBox(
                    height: 10,
                  ),

                  // TextFormField(
                  //   maxLines: null,
                  //   validator: (value) {
                  //     if (value.isNotEmpty) {
                  //       for (var i in value.split('\n')) {
                  //         if (i.startsWith('https://') || i.startsWith('http://')) {
                  //           continue;
                  //         } else {
                  //           return 'Please provide a valid link';
                  //         }
                  //       }
                  //       widget.activity.links = value.trim().split('\n');
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: (value) {
                  //     widget.activity.links = value.trim().split('\n');
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: 'Please add links here.',
                  //   ),
                  // ),
                  hSpacing(10),

                  Text(
                    'Note: Please press ⏎ to add new links, if there are multiple links.',
                    style: buildTextStyle(
                      color: Colors.grey,
                      size: 13,
                    ),
                  ),

                  Divider(
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please Enter value';
  }

  Future<dynamic> buildEditDialog(BuildContext context, String title) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Column(
            children: [
              Text(title),
              TextButton(
                onPressed: () {
                  log('true');
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => TeacherHomePage()));
                  log('01');
                },
                child: Text('Ok'),
              )
            ],
          ),
        );
      },
    );
  }
}
