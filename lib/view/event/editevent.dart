import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/bloc/activity/edit-activity.dart';
import '../../export.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({
    Key key,
    this.activity,
  }) : super(key: key);

  final Activity activity;

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  String type = 'online';
  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please provide a value';
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
            activityType: widget.activity.activityType,
            locations: widget.activity.locations,
            description: widget.activity.description,
          ).toJson();
          act.removeWhere((key, value) => value == null);
          //Edit event functionality and dialog message.
          EditActivity().editEvent(widget.activity.id, act).then((value) {
            if (value) {
              buildEditDialog(context, 'Event updated successfully')
                  .then((value) {
                Navigator.of(context).pop();
              });
            } else {
              buildEditDialog(context, 'Event update failed').then((value) {
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
        title: Text('Edit Event',style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: form,
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
                      // widget.eventTask.title = value;
                      return validator(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'title of event'.toUpperCase(),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2),
                      ),
                    ),
                  ),
                  Container(
                    // height: 48,
                    margin: EdgeInsets.only(top: 15),
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
                                if (int.tryParse(value) == null)
                                  return 'Please provide a value';
                                // widget.eventTask.coin = int.parse(value);
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
                            Spacer(flex: 5),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TYPE',
                        style: buildTextStyle(size: 15, color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          FilterChip(
                            label: Text('On-Location'),
                            onSelected: (value) {
                              type = 'on-location';
                              widget.activity.activityType = 'on-location';
                              setState(() {});
                            },
                            checkmarkColor: Color(0xffFFC30A),
                            disabledColor: Colors.grey[500],
                            selected: type == 'on-location',
                            selectedColor: Color(0xff261739),
                            labelStyle: buildTextStyle(
                              color: type == 'on-location'
                                  ? Color(0xffFFC30A)
                                  : Colors.white,
                              size: 16,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          FilterChip(
                            label: Text('On-line'),
                            onSelected: (value) {
                              type = 'online';
                              widget.activity.activityType = 'online';
                              setState(() {});
                            },
                            disabledColor: Colors.grey[500],
                            selected: type == 'online',
                            checkmarkColor: Color(0xffFFC30A),
                            selectedColor: Color(0xff261739),
                            labelStyle: buildTextStyle(
                              color: type == 'online'
                                  ? Color(0xffFFC30A)
                                  : Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.activity.locations,
                    onChanged: (value) {
                      widget.activity.locations = value;
                    },
                    validator: (value) {
                      // widget.eventTask.location = value;
                      return validator(value);
                    },
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: UnderlineInputBorder(),
                      labelText: 'LOCATION',
                      labelStyle: buildTextStyle(
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        child: _dropdownMenu(
                          // widget.activity.startDate ?? '',
                          DateFormat('dd-MM-yyyy').format(
                              DateTime.parse(
                                  widget.activity.startDate)) ?? '',
                          icon: Icons.watch_later_outlined,
                        ),
                      ),
                      SizedBox(width: 30),
                      InkWell(
                        child: _dropdownMenu(
                          // widget.activity.endDate ?? '',
                          DateFormat('dd-MM-yyyy').format(
                              DateTime.parse(
                                  widget.activity.endDate)) ?? '',
                          icon: Icons.watch_later_outlined,
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    initialValue: widget.activity.description,
                    // onChanged: widget.onChanged,
                    validator: (value) {
                      // widget.eventTask.description = value;
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _dropdownMenu(
    String title, {
    IconData icon = Icons.expand_more,
  }) {
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
          Icon(icon),
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
