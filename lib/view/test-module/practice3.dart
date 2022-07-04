
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:growonplus_teacher/view/homepage/home_sliver_appbar.dart';

import '/bloc/auth/auth-cubit.dart';
import '/bloc/auth/auth-states.dart';
import '/const.dart';
import '/extensions/utils.dart';
import '/model/test-model.dart';
import '/view/test-module/assignment.dart';
import 'TestUtils.dart';
import 'constants.dart';
import 'question_view.dart';

class SelectQuestionPaper3 extends StatefulWidget {
  final QuestionPaper questionPaper;
  SelectQuestionPaper3(this.questionPaper) {
    if (questionPaper.award == null) questionPaper.award = 0;
    if (questionPaper.detailQuestionPaper.chapters != null
        ? questionPaper.detailQuestionPaper.chapters.isEmpty
        : false) questionPaper.detailQuestionPaper.chapters = [];
    questionPaper.section[0].sectionName = 'Part 1';

    getTeacherName().then((value) {
      questionPaper.createdBy = value;
    });


  }

  @override
  _SelectQuestionPaper3State createState() => _SelectQuestionPaper3State();
}

class _SelectQuestionPaper3State extends State<SelectQuestionPaper3> {
  int radioValue = 0;
  double _finalResult = 0.0;
  List<String> bulletin = [
    '(a)',
    '(b)',
    '(c)',
    '(d)',
    '(e)',
    '(f)',
    '(g)',
    '(h)',
    '(i)',
    '(j)',
    '(k)',
  ];

  AudioManager audio;

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> showDialog1() {
    return showGeneralDialog<bool>(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(
                top: 80,
              ),
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              "Save Draft",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              "Publish and Assign",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              "Publish only",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void showDialog2() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: const EdgeInsets.only(
                top: 80,
              ),
              width: MediaQuery.of(context).size.width,
              height: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Section Details & Instruction",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Title",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${widget.questionPaper.questionTitle}",
                        style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Instructions",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${widget.questionPaper.section[0].information}",
                        style: const TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              pageWidget: AssignTest(
                                widget.questionPaper,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 60,
                          decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: const Center(
                            child: Text(
                              "Save Instructions",
                              style: TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w600,
                                color: kBlackColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  int getTotal() {
    int tot = 0;
    widget.questionPaper.section[0].section.forEach((element) {
      tot = tot + element.totalMarks;
    });
    return tot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 5,
        title: Text(
          "PRACTICE QUESTION PAPER",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: kBlackColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.05),
            child: Icon(
              Icons.print,
              color: kGreyColor,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool _var = false;
          _var = await showDialog1();
          if (_var) {
            showDialog2();
          }
        },
        child: Icon(
          Icons.play_arrow,
          color: kWhiteColor,
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
                if (state is AccountsLoaded) {
                  return Card(
                    elevation: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      width: double.infinity,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(40)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                              leading: TeacherProfileAvatar(),
                              title: Text('Created By'),
                              subtitle: Text(
                                  '${widget.questionPaper.createdBy ?? state.user.name}'),
                              trailing: Container(
                                width: 100.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20.0,
                                      child: Text(
                                          'Marks : ${getTotal().toString()}'
                                          // 'Marks : ${widget.questionPaper.section[0].section[0] != null ? widget.questionPaper.section[0].section.fold(0, (previousValue, element) {
                                          //     previousValue + element.totalMarks;
                                          //     log('prev ' +
                                          //         previousValue.toString() +
                                          //         ' element ' +
                                          //         element.totalMarks.toString());
                                          //   }) : '0'}'
                                          ),
                                    ),
                                    Container(
                                      height: 20.0,
                                      child: Text(
                                          'Coins : ${widget.questionPaper.coin}'),
                                    ),
                                    Container(
                                      height: 16.0,
                                      child: Text(
                                          'Rewards : ${widget.questionPaper.award}'),
                                    ),
                                  ],
                                ),
                              )
                              // Container(
                              //   height: 100,
                              //   width: 120,
                              //   alignment: Alignment.center,
                              //   decoration: BoxDecoration(
                              //       border: Border.all(
                              //           width: 1, color: Colors.black)),
                              //   child: Text(
                              //       'Date\n${widget.questionPaper.startDate.toDateTimeFormat(context)}'),
                              // ),
                              ),
                          // Spacer(),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Question Title:  ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      alignment: Alignment.bottomCenter,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(width: 1))),
                                      child: Text(
                                          '${widget.questionPaper.questionTitle}'),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Class:  ',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Container(
                                          width: 50,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom:
                                                      BorderSide(width: 1))),
                                          child: Text(
                                              '${widget.questionPaper.detailQuestionPaper.className}'),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Row(
                                      children: [
                                        Text('Subject:  ',
                                            style: TextStyle(fontSize: 16)),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          // width: 100,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom:
                                                      BorderSide(width: 1))),
                                          child: Text(
                                              '${widget.questionPaper.detailQuestionPaper.subject.first.name}'),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  BlocProvider.of<AuthCubit>(context).checkAuthStatus();
                  return Container();
                }
              }),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: kLightColor,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.event_note_sharp,
                        size: 20,
                        color: kBlackColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Test Instructions",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 40,
                decoration: BoxDecoration(
                    color: kLightColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: kGreyColor)),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                    right: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child: Center(
                    child: Text(
                      widget.questionPaper.section[0].information == null
                          ? 'There is no Instruction for this Test'
                          : widget.questionPaper.section[0].information,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kBlackColor),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                color: kLightColor,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.questionPaper.section[0].section.length,
                  itemBuilder: (BuildContext context, int index) {
                    var section = widget.questionPaper.section[0].section;
                    // log(section[index].matchOptions.column1[index].value);
                    return Padding(
                      padding: EdgeInsets.only(
                        top: 10,
                        // left: MediaQuery.of(context).size.width * 0.01,
                        // right: MediaQuery.of(context).size.width * 0.00,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // CachedNetworkImage(imageUrl: section[index].options[0].value,
                              // errorWidget: (context,url,error) {
                              //   log(error.toString());
                              //   return Text(error.toString());},),
                              // Text(
                              //   "Q ${index + 1}",
                              //   style: const TextStyle(
                              //       fontSize: 12,
                              //       fontWeight: FontWeight.w700,
                              //       color: kBlackColor),
                              // ),
                              Text("Q${index+1}",style: buildTextStyle(weight: FontWeight.bold,size: 12,),),
                              // SizedBox(
                              //   width: MediaQuery.of(context).size.width * 0.02,
                              // ),
                              // Container(
                              //   width: MediaQuery.of(context).size.width * 0.74,
                              //   child:
                              //   Flexible(
                              //     fit: FlexFit.tight,
                              //       child: Html(data: section[index].question[0])),
                              Flexible(
                                fit: FlexFit.tight,
                                child: Html(data:parseHtmlString(section[index].question.first),shrinkWrap: true, ),
                              ),
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Icon(
                                  //   Icons.edit,
                                  //   color: kGreyColor,
                                  //   size: 18,
                                  // ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: kPrimaryColor,
                                        size: 18.0,
                                      ),
                                      Text(
                                        " ${section[index].totalMarks}",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: kBlackColor),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_forever_outlined),
                                    color: kGreyColor,
                                    onPressed: () {
                                      section.remove(section[index]);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          if (section[index].questionType.first ==
                              'comprehension')
                            questionBuilder(index),
                          // QuestionBuilderDuringCreation(
                          //   i: index,
                          //   questionPaper: widget.questionPaper,
                          // ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i
                                        in section[index].matchOptions.column1)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          //  Html(
                                          (int.parse(i.type) + 0).toString() +
                                              " - " +
                                              i.value,
                                          style: buildTextStyle(
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          // shrinkWrap: true,
                                          //  ).data.trim(),
                                        ),
                                      ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i
                                        in section[index].matchOptions.column2)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          // Html(
                                          i.type + " - " + i.value,
                                          style: buildTextStyle(
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          // shrinkWrap: true,
                                          // ).data.trim(),
                                        ),
                                      ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (var i
                                        in section[index].matchOptions.column3)
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueGrey,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.all(5),
                                        child: Text(
                                          // Html(
                                          i.type + " - " + i.value,
                                          style: buildTextStyle(
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          // shrinkWrap: true,
                                          // ).data.trim(),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          for (int i = 0;
                              i < section[index].options.length;
                              i++)
                            if (section[index].options[i].value != null)
                              buildOptionsWidget(
                                  context, section[index].options[i],
                                  //section[index],
                                  prefix: bulletin[i],
                                  audioManager: audio),
                        ],
                      )),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView questionBuilder(int i) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.questionPaper.section[0].section[i].questions.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        // if (!"${questions[index].questionType[0]}"
        //         .toLowerCase()
        //         .contains(filter.toLowerCase()) &&
        //     filter != "None") {
        //   return Container();
        // }
        var section = widget.questionPaper.section[0].section[i].questions;
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.03,
          ),
          child: Container(
            // height: 275,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(
                //   radius: 9,
                //   backgroundColor: Colors.yellow,
                // ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Q ${index + 1}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor),
                          ),
                          // Container(
                          //   width : 25,
                          //   child: TeXView(
                          //     renderingEngine: TeXViewRenderingEngine.mathjax(),
                          //     child: TeXViewDocument("Q${index + 1}."),
                          //   ),
                          // ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child:
                            Html(data: parseHtmlString(section[index].question[0])),
                            // TeXView(
                            //   renderingEngine: TeXViewRenderingEngine.mathjax(),
                            //   child: TeXViewDocument(section[index].question[0]),
                            // ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('MM: ${section[index].totalMarks}')
                              // Icon(
                              //   Icons.edit,
                              //   color: kGreyColor,
                              //   size: 18,
                              // ),
                            ],
                          )
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i
                                    in section[index].matchOptions.column1)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      // Html(
                                      (int.tryParse(i.type) ?? 0 + 1)
                                              .toString() +
                                          " - " +
                                          i.value,
                                      style: buildTextStyle(
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      // shrinkWrap: true,
                                      // ).data.trim(),
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i
                                    in section[index].matchOptions.column2)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      // Html(
                                      i.type + " - " + i.value,
                                      style: buildTextStyle(
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      // shrinkWrap: true,
                                      // ).data.trim(),
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i
                                    in section[index].matchOptions.column3)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      // Html(
                                      i.type + " - " + i.value,
                                      style: buildTextStyle(
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      // shrinkWrap: true,
                                      // ).data.trim(),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (section[index].options != null)
                        for (int j = 0; j < section[index].options.length; j++)
                          if (section[index].options[j].value != null)
                            buildOptionsWidget(
                                context, section[index].options[j],
                                // section[index],
                                prefix: bulletin[j],
                                audioManager: audio),
                    ],
                  ),
                ),
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Icon(
                //       Icons.remove_red_eye_outlined,
                //     ),
                //     Row(
                //       children: [
                //         Icon(
                //           Icons.star,
                //           color: kPrimaryColor,
                //         ),
                //         Text(
                //           "${questions[index].totalMarks}",
                //           style: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w400,
                //             color: kBlackColor,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
