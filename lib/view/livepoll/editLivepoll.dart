import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/bloc/activity/edit-activity.dart';
import '../../export.dart';

class EditLivePollPage extends StatefulWidget {
  const EditLivePollPage({
    Key key,
    this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  _EditLivePollPageState createState() => _EditLivePollPageState();
}

class _EditLivePollPageState extends State<EditLivePollPage> {
  List<Option> _options = [];
  int _groupValue = -1;
  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please provide value';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _options = widget.activity.options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomBar(
        title: 'Save',
        onPressed: () {
          var act = Activity(
            assigned: null,
            title: widget.activity.title,
            coin: widget.activity.coin,
            options: widget.activity.options,
          ).toJson();
          act.removeWhere((key, value) => value == null);
          //Edit livePoll functionality and dialog message.
          log('-------------------------------------');
          log(widget.activity.id);
          EditActivity()
              .editLivePoll(
                  widget.activity.id,
                  Activity(
                    assigned: null,
                    title: widget.activity.title,
                    coin: widget.activity.coin,
                    options: widget.activity.options,
                  ).toJson()
                    ..removeWhere((key, value) => value == null))
              .then((value) {
            if (value) {
              buildEditDialog(context, 'LivePoll updated successfully')
                  .then((value) {
                Navigator.of(context).pop();
              });
            } else {
              buildEditDialog(context, 'LivePoll update failed').then((value) {
                Navigator.of(context).pop();
              });
            }
          });
        },
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text('Edit LivePoll',style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    // widget.livePollTask.title = value;
                    return validator(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'title of live poll'.toUpperCase(),
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
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              widget.activity.coin = int.parse(value);
                            },
                            validator: (value) {
                              // widget.livePollTask.coin = int.parse(value);
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
                        // widget.activity.dueDate ?? '',
                        DateFormat('dd-MM-yyyy').format(
                            DateTime.parse(
                                widget.activity.dueDate)) ?? '',
                        style: buildTextStyle(size: 15),
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
                        style: buildTextStyle(size: 15),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (_options.isNotEmpty)
                  Column(
                    children: _options
                        .map(
                          (option) => ListTile(
                            title: Text(
                              option.text,
                              style: buildTextStyle(size: 15),
                            ),
                            leading: Radio(
                                value: _options
                                    .indexWhere((element) => element == option),
                                groupValue: _groupValue,
                                onChanged: (value) {
                                  _groupValue = value;
                                  setState(() {});
                                }),
                            trailing: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _deleteOptions(option);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ).mv15,
                FlatButton.icon(
                  onPressed: _addOptions,
                  icon: Icon(
                    Icons.add,
                    color: Colors.blue,
                  ),
                  label: Text(
                    'Add Options',
                    style: buildTextStyle(color: Colors.blue),
                  ),
                  // color: Colors.blue,
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _deleteOptions(Option option) async {
    _options.remove(option);
    widget.activity.options = _options;
    setState(() {});
  }

  void _addOptions() async {
    String _value = '';
    bool _created = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'Cancel',
                style: buildTextStyle(size: 15),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'Create',
                style: buildTextStyle(color: Colors.blue, size: 15),
              ),
            ),
          ],
          title: Text(
            'Add Options',
            style: buildTextStyle(
              size: 20,
              weight: FontWeight.bold,
            ),
          ),
          content: TextField(
            onChanged: (value) {
              _value = value;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Option',
            ),
          ),
        );
      },
    );
    if (_created && _value.trim().isNotEmpty) {
      _options.add(
        Option(
          text: _value,
          checked: "NO",
        ),
      );
      widget.activity.options = _options;
      setState(() {});
    }
  }

  // Widget getLivePollList() {
  //   switch (widget.activity.assigned) {
  //     case (Assigned.student):
  //       return selectedByStudent();
  //     case (Assigned.parent):
  //       return selectedByParent();
  //     case (Assigned.faculty):
  //       return selectedByTeacher();

  //       break;
  //     default:
  //       return selectedByStudent();
  //   }
  // }

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
