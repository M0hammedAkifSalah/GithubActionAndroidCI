import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '/export.dart';

File _image;
List<Option> _options = [];
int _groupValue = -1;
DateTime _date;
TimeOfDay _time;

class CreateLivePoll extends StatefulWidget {
  @override
  _CreateLivePollState createState() => _CreateLivePollState();
}

class _CreateLivePollState extends State<CreateLivePoll> {
  GlobalKey<FormState> form = GlobalKey<FormState>();
  LivePollTask livePollTask;
  @override
  void initState() {
    _image = null;
    _options = [];
    _groupValue = -1;
    _date = null;
    _time = null;
    livePollTask = LivePollTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (livePollTask.options == null && livePollTask.title == null) {
          Navigator.of(context).pop();
          return null;
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
          check: _date != null && _time != null && _options.length >= 2,
          onPressed: () {
            if (_options.isEmpty)
              buildShowDialogue(context);
            else if (form.currentState.validate()) {
              livePollTask.endDate = DateFormat('yyyy-MM-dd').format(_date);
              livePollTask.startDate =
                  DateFormat('yyyy-MM-dd').format(DateTime.now());
              livePollTask.dueDate = DateFormat('yyyy-MM-dd').format(_date);
              var _dateTime = DateTime(
                _date.year,
                _date.month,
                _date.day,
                _time.hour,
                _time.minute,
              );
              livePollTask.endTime = _dateTime.toIso8601String();
              livePollTask.options = _options;
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
                      task: livePollTask,
                      isJoinedClass: false,
                      title: 'Live Poll',
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
              if (livePollTask.description == null &&
                  livePollTask.title == null) {
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
            'Live Poll',
            style: buildTextStyle(
              size: 15,
              weight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
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
                        child: LivePollWidget(livePollTask: livePollTask),
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
}

class LivePollWidget extends StatefulWidget {
  const LivePollWidget({
    Key key,
    this.livePollTask,
    this.activity,
    this.editable = true,
    this.form,
  }) : super(key: key);

  final LivePollTask livePollTask;
  final Activity activity;
  final GlobalKey<FormState> form;
  final bool editable;

  @override
  _LivePollWidgetState createState() => _LivePollWidgetState();
}

class _LivePollWidgetState extends State<LivePollWidget> {
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
            widget.livePollTask.title = value;
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
                    initialValue:
                        widget.editable ? '' : widget.activity.coin.toString(),
                    enabled: widget.editable,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      widget.livePollTask.coin = int.parse(value);
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
                  DateFormat('dd-MM-yyyy')
                          .format(DateTime.parse(widget.activity.dueDate)) ??
                      '',
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
                  style: buildTextStyle(size: 15),
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
        SizedBox(
          height: 20,
        ),
        if (widget.editable)
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
                          onChanged: !widget.editable
                              ? null
                              : (value) {
                                  _groupValue = value;
                                  setState(() {});
                                }),
                      trailing: IconButton(
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
        if (!widget.editable)
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(right: 14.0),
            shrinkWrap: true,
            itemCount: widget.activity.options.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (widget.activity.options[index].getPercent(
                                    widget.activity.selectedLivePoll) *
                                100)
                            .toString() +
                        '%',
                    style: const TextStyle(
                      color: const Color(0xff8ca0c9),
                      fontWeight: FontWeight.w400,
                      fontSize: 10.0,
                    ),
                  ),
                  LinearPercentIndicator(
                    //  width: MediaQuery.of(context).size.width - 50,
                    animation: true,
                    lineHeight: 24.0,
                    animationDuration: 2500,
                    percent: widget.activity.options[index]
                        .getPercent(widget.activity.selectedLivePoll),
                    alignment: MainAxisAlignment.start,
                    center: Text(
                      widget.activity.options[index].text,
                      style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w400,
                        fontSize: 11.0,
                      ),
                    ),

                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Color(0xff8ca0c9),
                    backgroundColor: Color(0xfff0f4fc),
                  ),
                ],
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
        if (!widget.editable)
          // TODO livepoll
          getLivePollList(),
        SizedBox(
          height: 80,
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

  void _deleteOptions(Option option) async {
    _options.remove(option);
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
      setState(() {});
    }
  }

  Widget getLivePollList() {
    switch (widget.activity.assigned) {
      case (Assigned.student):
        return selectedByStudent();
      case (Assigned.parent):
        return selectedByParent();
      case (Assigned.faculty):
        return selectedByTeacher();

        break;
      default:
        return selectedByStudent();
    }
  }

  Widget selectedByStudent() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.activity.selectedLivePoll.length,
      itemBuilder: (context, index) {
        var _student = widget.activity.assignTo.firstWhere((student) =>
            student.studentId.id ==
            widget.activity.selectedLivePoll[index].selectedBy);
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Row(
            children: [
              TeacherProfileAvatar(
                imageUrl: _student.studentId.profileImage ?? '',
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_student.name}',
                    style: buildTextStyle(
                      size: 16,
                      weight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                      "Class : ${_student.className ?? ''} ${(_student.studentId.sectionName != 'no name') ? _student.studentId.sectionName : ''}"),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  color: Color(0xffF0F4FC),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(widget.activity.selectedLivePoll[index].options[0],
                    style: buildTextStyle(color: Color(0xff8CA0C9), size: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget selectedByTeacher() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.activity.selectedLivePoll
          .where((stud) => stud.selectedByTeacher != null)
          .length,
      itemBuilder: (context, index) {
        var _student = widget.activity.assignToYou.firstWhere(
          (student) =>
              student.teacherId ==
              widget.activity.selectedLivePoll[index].selectedByTeacher,
        );
        return Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Row(
            children: [
              TeacherProfileAvatar(
                imageUrl: _student.profileImage ?? '',
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                '${_student.name}',
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
                    widget.activity.selectedLivePoll
                        .where((s) => s.selectedByTeacher != null)
                        .toList()[index]
                        .options[0],
                    style: buildTextStyle(color: Color(0xff8CA0C9), size: 12)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget selectedByParent() {
    return Container(
      child: BlocBuilder<StudentProfileCubit, StudentProfileStates>(
          builder: (context, state) {
        if (state is StudentProfileLoaded)
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.activity.selectedLivePoll
                .where((s) => s.selectedByParent != null)
                .length,
            itemBuilder: (context, index) {
              var _student = widget.activity.assignToParent.firstWhere(
                  (student) =>
                      student.parentId ==
                      widget.activity.selectedLivePoll[index].selectedByParent);
              return Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                child: Row(
                  children: [
                    TeacherProfileAvatar(
                      imageUrl: _student.profileImage ?? '',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${_student.name}',
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
                          widget.activity.selectedLivePoll
                              .where((s) => s.selectedByParent != null)
                              .toList()[index]
                              .options[0],
                          style: buildTextStyle(
                              color: Color(0xff8CA0C9), size: 12)),
                    ),
                  ],
                ),
              );
            },
          );
        else {
          BlocProvider.of<StudentProfileCubit>(context).loadStudentProfile(page: 1,limit: 10);
          return Container();
        }
      }),
    );
  }
}
