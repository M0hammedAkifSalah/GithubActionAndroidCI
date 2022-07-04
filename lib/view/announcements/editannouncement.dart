import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../bloc/activity/edit-activity.dart';
import '../../export.dart';

class EditAnnouncementPage extends StatefulWidget {
  const EditAnnouncementPage({
    Key key,
    this.announcementTask,
    this.activity,
    this.form,
    this.onChanged,
  }) : super(key: key);

  final AnnouncementTask announcementTask;
  final Activity activity;
  final GlobalKey<FormState> form;

  final Function(String value) onChanged;

  @override
  _EditAnnouncementPageState createState() => _EditAnnouncementPageState();
}

class _EditAnnouncementPageState extends State<EditAnnouncementPage> {
  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please provide a value';
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      bottomNavigationBar: CustomBottomBar(
        title: 'Save',
        onPressed: () {
          var act = widget.activity.toJson();
          // Activity(
          //   assigned: widget.activity.assigned,
          //   title: widget.activity.title,
          //   coin: widget.activity.coin,
          //   description: widget.activity.description,
          //   links: widget.activity.links,
          //   endDate: widget.activity
          // ).toJson();
          // act.removeWhere((key, value) => value == null);
          // act.removeWhere((key, value) => value.toString() == '[]');
          //Anouncement edit Api call and dialog handle
          log(act.toString());

          EditActivity()
              .editAnnouncement(widget.activity.id, act)
              .then((value) {
            if (value) {
              buildEditDialog(context, 'Announcement updated successfully')
                  .then((value) {
                Navigator.of(context).pop();
              });
            } else {
              buildEditDialog(context, 'Announcement update failed')
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
            'Edit Announcement',
            style: TextStyle(color: Colors.black),
          )),
      body: SafeArea(
        child: Center(
          child: Container(
            width: screenwidth > 600 ? MediaQuery.of(context).size.width * 0.60 : MediaQuery.of(context).size.width * 0.99,
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.activity.title,
                    maxLength: null,
                    maxLines: null,
                    onChanged: (value) {
                      widget.activity.title = value;
                    },
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/points.png',
                              height: 20,
                              width: 20,
                            ),
                            TextFormField(
                              initialValue: widget.activity.coin.toString(),
                              maxLength: 2,
                              onChanged: (value) {
                                widget.activity.coin = int.parse(value);
                                print(value);
                              },
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                print(value);
                                if (int.tryParse(value) == null || value.isEmpty)
                                  return 'Please Provider value';
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
                            ).expandFlex(1),
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
                          style: buildTextStyle(size: 15, color: Colors.grey),
                        ),
                        Text(
                          DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(widget.activity.dueDate)) ??
                              '',
                          style: buildTextStyle(),
                        ),
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
                        Text(
                          TimeOfDay.fromDateTime(widget.activity.endDateTime)
                                  .format(context) ??
                              '',
                          style: buildTextStyle(),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    initialValue: widget.activity.description,
                    onChanged: (value) {
                      widget.activity.description = value;
                    },
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
                  // TextFormField(
                  //   maxLines: null,
                  //   validator: (value) {
                  //     if (value.isNotEmpty) {
                  //       for (var i in value.split('\n')) {
                  //         if (i.startsWith('https://') ||
                  //             i.startsWith('http://')) {
                  //           continue;
                  //         } else {
                  //           return 'Please provide a valid link';
                  //         }
                  //       }
                  //       widget.announcementTask.links = value.trim().split('\n');
                  //     }
                  //     return null;
                  //   },
                  //   onChanged: (value) {
                  //     widget.announcementTask.links = value.trim().split('\n');
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildEditDialog(BuildContext context, String title) {
    return showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Column(
            children: [
              Text(title),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.of(context).pop();
              //   },
              //   child: Card(
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              //       child: Text('Okay'),
              //     ),
              //   ),
              // )
            ],
          ),
        );
      },
    );
  }
}
