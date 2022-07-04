import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../export.dart';

File _image;
List<Option> _options = [];
int _groupValue = -1;
DateTime _date;
TimeOfDay _time;

class CreateCheckList extends StatefulWidget {
  @override
  _CreateCheckListState createState() => _CreateCheckListState();
}

class _CreateCheckListState extends State<CreateCheckList> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  CheckListTask checkListTask;
  @override
  void initState() {
    _image = null;
    _options = [];
    _groupValue = -1;
    _date = null;
    _time = null;
    checkListTask = CheckListTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (checkListTask.options == null && checkListTask.title == null) {
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
                ),
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
          check: _date != null && _time != null && _options.isNotEmpty,
          onPressed: () {
            if (_options.isEmpty)
              buildShowDialogue(context);
            else if (form.currentState.validate()) {
              checkListTask.endDate = DateFormat('yyyy-MM-dd').format(_date);
              checkListTask.startDate =
                  DateFormat('yyyy-MM-dd').format(DateTime.now());
              checkListTask.dueDate = DateFormat('yyyy-MM-dd').format(_date);
              var _dateTime = DateTime(
                _date.year,
                _date.month,
                _date.day,
                _time.hour,
                _time.minute,
              );
              checkListTask.endTime = _dateTime.toIso8601String();
              checkListTask.options = _options;
              print('pressed');
              Navigator.of(context).push(
                createRoute(
                  pageWidget: MultiBlocProvider(
                    providers: [
                      BlocProvider<GroupCubit>(
                        create: (context) => GroupCubit()..loadGroups(),
                      ),
                    ],
                    child: AssignTask(
                      files: [],
                      // image: _image,
                      task: checkListTask,
                      isJoinedClass: false,
                      title: 'Checklist',
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
              if (checkListTask.options == null &&
                  checkListTask.title == null) {
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
          title: Text(
            'Check List',
            style: buildTextStyle(
              size: 15,
              weight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Spacer(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  // alignment: Alignment.bottomCenter,
                  height: MediaQuery.of(context).size.height * 0.87,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 5,
                        blurRadius: 5,
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: form,
                      child: CheckListWidget(
                        checkListTask: checkListTask,
                      ),
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

class CheckListWidget extends StatefulWidget {
  const CheckListWidget({
    Key key,
    this.checkListTask,
    this.activity,
    this.editable = true,
    this.form,
  }) : super(key: key);

  final CheckListTask checkListTask;
  final Activity activity;
  final GlobalKey<FormState> form;
  final bool editable;

  @override
  _CheckListWidgetState createState() => _CheckListWidgetState();
}

class _CheckListWidgetState extends State<CheckListWidget> {
  String validator(String value) {
    if (value.trim().isNotEmpty) return null;
    return 'Please provide value';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _options = !widget.editable ? widget.activity.options ?? [] : [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: widget.editable ? '' : widget.activity.title,
          enabled: widget.editable,
          maxLength: null,
          maxLines: null,
          validator: (value) {
            widget.checkListTask.title = value;
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
                    initialValue:
                        widget.editable ? '' : widget.activity.coin.toString(),
                    enabled: widget.editable,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    validator: (value) {
                      widget.checkListTask.coin = int.parse(value);
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
              if (!widget.editable)
                Text(
                  DateFormat('dd-MM-yyyy').format(
                      DateTime.parse(
                          widget.activity.dueDate)) ?? '',
                  style: buildTextStyle(size: 15),
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
                style: buildTextStyle(size: 15, color: Colors.grey),
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
        if (!widget.editable)
          ListView.separated(
            separatorBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                      '${(getChecklistPercent(widget.activity.options[index].text) * 100).toStringAsFixed(2)}%'),
                  SizedBox(
                    height: 2,
                  ),
                ],
              );
            },
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(right: 14.0),
            shrinkWrap: true,
            itemCount: widget.activity.options.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 24,
                // decoration: BoxDecoration(
                //   borderRadius:
                //       BorderRadius.all(Radius.circular(5)),
                //   color: const Color(0xfff0f4fc),
                // ),
                child: Row(
                  children: [
                    buildLinearPercentBar(
                      color: Color(0xff8CA0C9),
                      percent: getChecklistPercent(
                          widget.activity.options[index].text),
                      text: widget.activity.options[index].text,
                    ).expand,
                    // Text(
                    // widget.activity.selectedCheckList.length==widget.activity.options.length?'Completed':widget.activity.selectedCheckList.length>0&&widget.activity.selectedCheckList.length<widget.activity.options.length?'Partially Completed':'Not Completed',
                    //   activity.options[index].text,
                    //   style: const TextStyle(
                    //     color: const Color(0xff000000),
                    //     fontWeight: FontWeight.w400,
                    //     fontSize: 11.0,
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        if (widget.editable)
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
        if (!widget.editable) getSelectedList(),
        if (_options.isNotEmpty && widget.editable)
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
                      onPressed: !widget.editable
                          ? null
                          : () {
                              _deleteOptions(option);
                            },
                    ),
                  ),
                )
                .toList(),
          ).mv15,
        KeyboardVisibilityBuilder(
          builder: (ctx, isKeyboardVisible) => SizedBox(
            height: isKeyboardVisible ? 250 : 80,
          ),
        ),
      ],
    );
  }

  void _pickImage() async {
    var __image = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (__image != null) _image = File(__image.path);
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

  double getChecklistPercent(String option) {
    double percent = 0;
    for (var i in widget.activity.selectedCheckList) {
      if (i.options.contains(option)) {
        percent++;
      }
    }
    return percent / widget.activity.assignTo.length;
  }

  void _pickTime() async {
    TimeOfDay _td = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_td != null) _time = _td;
    setState(() {});
  }

  void _deleteOptions(Option option) async {
    _options.remove(option);
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
      setState(() {});
    }
  }

  Widget getSelectedList() {
    switch (widget.activity.assigned) {
      case (Assigned.student):
        return selectedChecklistStudent();
      case (Assigned.parent):
        return selectedChecklistParent();
      case (Assigned.faculty):
        return selectedChecklistTeacher();

        break;
      default:
        return selectedChecklistStudent();
    }
  }

  Widget selectedChecklistStudent() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.activity.selectedCheckList.length + 1,
      itemBuilder: (context, index) {
        if (index == 0)
          return ListTile(
            title: Text(
              'Selected Options',
              style: buildTextStyle(
                size: 18,
                weight: FontWeight.bold,
              ),
            ),
          );
        var student = widget.activity.assignTo.firstWhere((student) =>
            student.studentId.id ==
            widget.activity.selectedCheckList[index - 1].selectedBy);
        var selectedOption = widget.activity.selectedCheckList
            .firstWhere((element) => element.selectedBy == student.studentId.id);
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Row(children: [
            TeacherProfileAvatar(
              imageUrl: student.profileImage,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.name}',
                  style: buildTextStyle(
                    size: 16,
                    weight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                    "Class : ${student.className ?? ''} ${(student.sectionName != 'no name') ? student.sectionName : ''}"),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Color(0xffF0F4FC),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                selectedOption.options.length == widget.activity.options.length
                    ? 'Completed'
                    : selectedOption.options.length > 0 &&
                            selectedOption.options.length <
                                widget.activity.options.length
                        ? 'Partially Completed'
                        : 'Not Completed',
                style: buildTextStyle(
                  color: Color(0xff8CA0C9),
                  size: 12,
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget selectedChecklistTeacher() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.activity.selectedCheckList.length,
      itemBuilder: (context, index) {
        var _teacher = widget.activity.assignToYou.firstWhere((student) =>
            student.teacherId ==
            widget.activity.selectedCheckList[index].selectedByTeacher);
        var selectedOption = widget.activity.selectedCheckList.firstWhere(
            (element) => element.selectedByTeacher == _teacher.teacherId);
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Row(children: [
            TeacherProfileAvatar(
              imageUrl: _teacher.profileImage ?? 'text',
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${_teacher.name}',
              style: buildTextStyle(
                size: 16,
                weight: FontWeight.w400,
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Color(0xffF0F4FC),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                selectedOption.options.length == widget.activity.options.length
                    ? 'Completed'
                    : selectedOption.options.length > 0 &&
                            selectedOption.options.length <
                                widget.activity.options.length
                        ? 'Partially Completed'
                        : 'Not Completed',
                style: buildTextStyle(
                  color: Color(0xff8CA0C9),
                  size: 12,
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget selectedChecklistParent() {
    return Container(
      child: BlocBuilder<StudentProfileCubit, StudentProfileStates>(
          builder: (context, state) {
        if (state is StudentProfileLoaded)
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.activity.selectedCheckList.length,
            itemBuilder: (context, index) {
              var _parent = widget.activity.assignToParent.firstWhere(
                  (student) =>
                      student.parentId ==
                      widget
                          .activity.selectedCheckList[index].selectedByParent);
              var selectedOption = widget.activity.selectedCheckList.firstWhere(
                  (element) => element.selectedByParent == _parent.parentId);

              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Row(children: [
                  TeacherProfileAvatar(
                    imageUrl: _parent.profileImage ?? 'text',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${_parent.name}',
                    style: buildTextStyle(
                      size: 16,
                      weight: FontWeight.w400,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                      color: Color(0xffF0F4FC),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      selectedOption.options.length ==
                              widget.activity.options.length
                          ? 'Completed'
                          : selectedOption.options.length > 0 &&
                                  selectedOption.options.length <
                                      widget.activity.options.length
                              ? 'Partially Completed'
                              : 'Not Completed',
                      style: buildTextStyle(
                        color: Color(0xff8CA0C9),
                        size: 12,
                      ),
                    ),
                  ),
                ]),
              );
            },
          );
        else {
          BlocProvider.of<StudentProfileCubit>(context).loadStudentProfile(limit: 10,page: 1);
          return Container();
        }
      }),
    );
  }
}
