import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/bloc/activity/edit-activity.dart';
import '../../export.dart';

class EditCheckListPage extends StatefulWidget {
  const EditCheckListPage({
    Key key,
    this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  _EditCheckListPageState createState() => _EditCheckListPageState();
}

class _EditCheckListPageState extends State<EditCheckListPage> {
  List<Option> _options = [];
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
                    options: widget.activity.options)
                .toJson();
            act.removeWhere((key, value) => value == null);
            // edit CheckList Functionality and dialog message
            EditActivity().editCheckList(widget.activity.id, act).then((value) {
              if (value) {
                buildEditDialog(context, 'CheckList updated successfully')
                    .then((value) {
                  Navigator.of(context).pop();
                });
              } else {
                buildEditDialog(context, 'CheckList update failed')
                    .then((value) {
                  Navigator.of(context).pop();
                });
              }
            });
          }),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        automaticallyImplyLeading: true,
        title: Text('Edit Checklist',style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.activity.title,
                  onChanged: (value) {
                    widget.activity.title = value;
                  },
                  maxLength: null,
                  maxLines: null,
                  validator: (value) {
                    return validator(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'title of check list'.toUpperCase(),
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
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            onChanged: (value) {
                              widget.activity.coin = int.parse(value);
                            },
                            validator: (value) {
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
                        style: buildTextStyle(),
                      ),
                    ],
                  ),
                ),
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
                if (_options.isNotEmpty)
                  Column(
                    children: _options
                        .map(
                          (option) => CheckboxListTile(
                            value: option.checked == "YES",
                            title: Text(
                              option.text,
                              style: buildTextStyle(size: 15),
                            ),
                            onChanged: (value) {
                              if (value) {
                                option.checked = 'YES';
                                // options.add(option);
                              } else {
                                option.checked = "NO";
                                // options.remove(option);
                              }
                              setState(() {});
                            },
                            secondary: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _deleteOptions(option);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ).mv15,
              ],
            ),
          ),
        ),
      ),
    );
  }

  double getChecklistPercent(String option) {
    double percent = 0;
    for (var i in widget.activity.selectedCheckList) {
      if (i.options.contains(option)) {
        percent++;
      }
    }
    return percent / widget.activity.assignTo.length;
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
    if (_value.trim().isEmpty) _created = false;
    if (_created) {
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
