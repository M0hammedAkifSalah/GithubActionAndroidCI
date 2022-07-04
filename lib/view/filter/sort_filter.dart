import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/const.dart';
import '/extensions/extension.dart';
import '/model/activity.dart';
import '/model/filters.dart';

class SortAndFilter extends StatefulWidget {
  final List<Activity> activities;
  SortAndFilter({this.activities});
  @override
  _SortAndFilterState createState() => _SortAndFilterState();
}

class _SortAndFilterState extends State<SortAndFilter> {
  EventFilter _eventFilter;
  AssignmentFilter _assignmentFilter;
  Doubts _doubts;
  TasksFilter _tasksFilter;
  List<Activity> _activities = [];
  bool init = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      _activities = widget.activities;
      print('did change   == ${_activities.length}');
      // _assignmentFilter = Provider.of<AssignmentFilter>(context);
      // _eventFilter = Provider.of<EventFilter>(context);
      // _doubts = Provider.of<Doubts>(context);
      // _tasksFilter = Provider.of<TasksFilter>(context);
      // _tasksFilter.filter = [];
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RaisedButton(
                color: Color(0xffFFC30A),
                padding: EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 10,
                ),
                onPressed: () {
                  _activities = [];
                  _tasksFilter =
                      Provider.of<TasksFilter>(context, listen: false);

                  if (!_tasksFilter.filter.contains("All")) {
                    print('inside all condition');
                    _doubts = Provider.of<Doubts>(context, listen: false);
                    _assignmentFilter =
                        Provider.of<AssignmentFilter>(context, listen: false);
                    _eventFilter =
                        Provider.of<EventFilter>(context, listen: false);
                    if (_tasksFilter.filter.isNotEmpty)
                      _activities
                          .addAll(widget.activities.task(_tasksFilter.filter));
                    print('activities === ${_activities.length}');
                    if (_eventFilter.checked)
                      _activities.addAll(widget.activities.eventAndStatus());
                    print('activities === ${_activities.length}');
                    if (_assignmentFilter.checked)
                      _activities
                          .addAll(widget.activities.assignmentAndStatus());
                    print('activities === ${_activities.length}');
                  } else {
                    _activities.addAll(widget.activities);
                  }
                  Navigator.of(context).pop<List<Activity>>(_activities);
                },
                child: Text(
                  'Apply Filters',
                  style: buildTextStyle(
                    color: Colors.black,
                    size: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/GrowON.png'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              // color: Colors.pink,
              padding: EdgeInsets.all(20),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Text(
                      'Sort & Filter',
                      style: buildTextStyle(
                        color: Colors.black,
                        size: 24,
                        family: 'Poppins',
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FlatButton(
                      onPressed: () {
                        Provider.of<AssignmentFilter>(context, listen: false)
                            .resetFilter();
                        Provider.of<TasksFilter>(context, listen: false)
                            .resetFilter();
                        Provider.of<EventFilter>(context, listen: false)
                            .resetFilter();
                        Provider.of<Doubts>(context, listen: false)
                            .resetFilter();
                        setState(() {});
                      },
                      child: Text(
                        'Clear All',
                        style: buildTextStyle(
                          color: Color(0xffEB5757),
                          size: 12,
                          weight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).expandFlex(1),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Consumer<TasksFilter>(
                      builder: (context, value, child) => Column(
                        children: [
                          Container(
                            height: 200,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Tasks',
                                    style: buildTextStyle(
                                      size: 14,
                                    ),
                                  ),
                                ).expandFlex(2),
                                Container(
                                  child: Column(
                                    children: [
                                      for (var i in [
                                        'All',
                                        'Announcement',
                                        'LivePoll',
                                        'Check List'
                                      ])
                                        FilterCheckBox(
                                          text: i,
                                          value: value.filter.contains(i),
                                          onPressed: (val) {
                                            if (i == 'All') {
                                              Provider.of<EventFilter>(context,
                                                      listen: false)
                                                  .resetFilter();
                                              Provider.of<AssignmentFilter>(
                                                      context,
                                                      listen: false)
                                                  .resetFilter();
                                              value.resetFilter();
                                            }
                                            if (val)
                                              value.filter.add(i);
                                            else
                                              value.filter.remove(i);
                                            if (value.filter.contains('All') &&
                                                value.filter.length > 1) {
                                              value.filter.remove('All');
                                            }
                                            setState(() {});
                                          },
                                        )
                                    ],
                                  ),
                                ).expandFlex(6),
                                Container(
                                  child: Column(
                                    children: [
                                      // FilterSwitchWidget(
                                      //   text: 'Delayed',
                                      //   onPressed: (val) {
                                      //     value.switchStatus = val;
                                      //     setState(() {});
                                      //   },
                                      //   value: value.switchStatus,
                                      // ),
                                    ],
                                  ),
                                ).expandFlex(4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Consumer<EventFilter>(
                      builder: (context, value, child) => Column(
                        children: [
                          Row(
                            children: [
                              Container().expand,
                              Container(
                                child: FilterCheckBox(
                                  text: 'Event',
                                  value: value.checked,
                                  onPressed: (val) {
                                    var _task = Provider.of<TasksFilter>(
                                        context,
                                        listen: false);
                                    if (_task.filter.contains('All')) {
                                      _task.filter.remove('All');
                                    }
                                    value.checked = val;
                                    setState(() {});
                                  },
                                ),
                              ).expandFlex(5)
                            ],
                          ),
                          // OptionsRowWidget(
                          //   text1: 'Pending',
                          //   text2: 'Evaluate',
                          //   text3: 'Evaluated',
                          //   current: value.status,
                          //   onPressed: (val) {
                          //     value.status = val;
                          //     setState(() {});
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Divider(),
                    Consumer<AssignmentFilter>(
                      builder: (context, value, child) => Column(
                        children: [
                          Row(
                            children: [
                              Container().expand,
                              Container(
                                child: FilterCheckBox(
                                  text: 'Assignment',
                                  value: value.checked,
                                  onPressed: (val) {
                                    var _task = Provider.of<TasksFilter>(
                                        context,
                                        listen: false);
                                    if (_task.filter.contains('All')) {
                                      _task.filter.remove('All');
                                    }
                                    value.checked = val;
                                    setState(() {});
                                  },
                                ),
                              ).expandFlex(5),
                              // FilterSwitchWidget(
                              //   text: 'Re-submitted',
                              //   onPressed: (val) {
                              //     value.submitStatus = val;
                              //     setState(() {});
                              //   },
                              //   value: value.submitStatus,
                              // ),
                            ],
                          ),
                          // OptionsRowWidget(
                          //   text1: 'Pending',
                          //   text2: 'Evaluate',
                          //   text3: 'Evaluated',
                          //   current: value.status,
                          //   onPressed: (val) {
                          //     value.status = val;
                          //     setState(() {});
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Divider(),
                    // Row(
                    //   children: [
                    //     // Container().expand,
                    //     Container(
                    //       child: FilterCheckBox(
                    //         text: 'Test',
                    //         value: true,
                    //         onPressed: (value) {},
                    //       ),
                    //     ).expandFlex(5),
                    //     FilterSwitchWidget(
                    //       text: 'Re-submitted',
                    //       onPressed: (value) {},
                    //       value: true,
                    //     ),
                    //   ],
                    // ),
                    // OptionsRowWidget(),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ).expandFlex(5),
          ],
        ),
      ),
    );
  }
}

class FilterSwitchWidget extends StatelessWidget {
  const FilterSwitchWidget({
    @required this.text,
    @required this.onPressed,
    @required this.value,
  });
  final String text;
  final Function(bool value) onPressed;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: buildTextStyle(
            color: Color(0xffEB5757),
            size: 14,
          ),
        ),
        Switch(
          value: value,
          activeColor: Color(0xffEB5757),
          onChanged: onPressed,
        ),
      ],
    );
  }
}

class FilterCheckBox extends StatelessWidget {
  const FilterCheckBox({
    @required this.text,
    @required this.value,
    @required this.onPressed,
  });
  final String text;
  final bool value;
  final Function(bool value) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: Color(0xff261739),
            onChanged: onPressed,
          ),
          SizedBox(
            width: 7,
          ),
          Text(
            text,
            style: buildTextStyle(
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionsRowWidget extends StatelessWidget {
  const OptionsRowWidget({
    @required this.current,
    @required this.text1,
    @required this.text2,
    @required this.text3,
    @required this.onPressed,
  });
  final String text1;
  final String text2;
  final String text3;
  final Function(String value) onPressed;
  final String current;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffFFC30A),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              onPressed(text1);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text1,
                style: buildTextStyle(
                  color: Colors.black,
                  size: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: current == text1 ? Color(0xffFFC30A) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
              ),
            ),
          ).expand,
          InkWell(
            onTap: () {
              onPressed(text2);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text2,
                style: buildTextStyle(
                  color: Colors.black,
                  size: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: current == text2 ? Color(0xffFFC30A) : Colors.white,
              ),
            ),
          ).expand,
          InkWell(
            onTap: () {
              onPressed(text3);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text3,
                style: buildTextStyle(
                  color: Colors.black,
                  size: 12,
                ),
              ),
              decoration: BoxDecoration(
                color: current == text3 ? Color(0xffFFC30A) : Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
          ).expand,
        ],
      ),
    );
  }
}
