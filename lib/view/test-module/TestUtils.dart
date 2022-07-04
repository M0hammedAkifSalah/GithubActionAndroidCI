import 'dart:developer';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/extensions/utils.dart';
import 'package:growonplus_teacher/model/learning.dart';
import 'package:growonplus_teacher/model/test-model.dart';
import 'package:growonplus_teacher/view/learnings/learning-files.dart';
import 'package:growonplus_teacher/view/test-module/question_view.dart';
import 'package:growonplus_teacher/view/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const.dart';

import '../file_viewer.dart';
import 'constants.dart';

Widget buildOptionsWidget(BuildContext context, QuestionOptions i,
    {String prefix, AudioManager audioManager,List<QuestionOptions> answer,String type}) {
  audioManager = AudioManager(
      MediaResourceType.url,
    i.value
  );
  log('option type $type');
  bool check;
  if(answer != null)
  check = answer.firstWhere((element) => element.value == i.value,orElse: ()=>null) != null ? true : false;
  return i.value != null
      ? Container(
          // width: MediaQuery.of(context).size.width * 0.95,
          child: Row(
            children: [
              // if(type != null)
              //   if(type.toLowerCase() == 'image')
              //     Padding(
              //       padding: EdgeInsets.only(top: 3, bottom: 3),
              //       child: Container(
              //         color: check?? false ? Colors.greenAccent.withOpacity(0.2) : null ,
              //         width: MediaQuery.of(context).size.width * 0.8,
              //         child: ListTile(
              //           dense: true,
              //           leading: Text(prefix ?? ''),
              //           title: Text(i.fileText ?? ''),
              //           trailing: GestureDetector(
              //             onTap: () {
              //               List<String> files = [i.value];
              //               Navigator.of(context).push(
              //                 createRoute(
              //                   pageWidget: LearningFilesPage(
              //                     file: files
              //                         .map(
              //                           (e) => LearningFiles(
              //                         file: e,
              //                         fileName: '',
              //                       ),
              //                     )
              //                         .toList(),
              //                     index: 0,
              //                     pdf: false,
              //                     video: false,
              //                   ),
              //                 ),
              //               );
              //             },
              //             child: CachedImage(
              //               imageUrl: i.value,
              //               height: 60,
              //               width: 60,
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              if (i.value != null)
                if (i.value.endsWith('.jpg') ||
                    i.value.endsWith('.png') ||
                    i.value.endsWith('jpeg'))
                  Padding(
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: Container(
                      color: check?? false ? Colors.greenAccent.withOpacity(0.2) : null ,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ListTile(
                        dense: true,
                        leading: Text(prefix ?? ''),
                        title: Text(i.fileText ?? ''),
                        trailing: GestureDetector(
                          onTap: () {
                            List<String> files = [i.value];
                            Navigator.of(context).push(
                              createRoute(
                                pageWidget: LearningFilesPage(
                                  file: files
                                      .map(
                                        (e) => LearningFiles(
                                          file: e,
                                          fileName: '',
                                        ),
                                      )
                                      .toList(),
                                  index: 0,
                                  pdf: false,
                                  video: false,
                                ),
                              ),
                            );
                          },
                          child: CachedImage(
                            imageUrl: i.value,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                    ),
                  )
                else if (i.value.endsWith('.mp3'))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(right: 8.0),
                      width: MediaQuery.of(context).size.width / 1.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:  check?? false ? Colors.greenAccent.withOpacity(0.2) : Color(0xff1B1A57).withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<ButtonState>(
                            valueListenable: audioManager.buttonNotifier,
                            builder: (_, value, __) {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 8.0),
                                width: 24.0,
                                height: 24.0,
                                child: () {
                                  switch (value) {
                                    case ButtonState.loading:
                                      return Container(
                                        margin: EdgeInsets.all(5.0),
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          color: const Color(0xff4F5E7B),
                                        ),
                                      );
                                    case ButtonState.paused:
                                      return InkResponse(
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: const Color(0xff4F5E7B),
                                        ),
                                        onTap: audioManager.play,
                                      );
                                    case ButtonState.playing:
                                      return InkResponse(
                                        child: Icon(
                                          Icons.pause,
                                          color: const Color(0xff4f5e7b),
                                        ),
                                        onTap: audioManager.pause,
                                      );
                                  }
                                }(),
                              );
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: ValueListenableBuilder<ProgressBarState>(
                                valueListenable: audioManager.progressNotifier,
                                builder: (_, value, __) {
                                  return ProgressBar(
                                    progress: value.current,
                                    buffered: value.buffered,
                                    total: value.total,
                                    onSeek: audioManager.seek,
                                    thumbRadius: 5.0,
                                    thumbGlowRadius: 15.0,
                                    barHeight: 3.5,
                                    baseBarColor:
                                        const Color(0xff4F5E7B).withOpacity(0.6),
                                    bufferedBarColor:
                                        const Color(0xff4F5E7B).withOpacity(0.3),
                                    thumbGlowColor:
                                        const Color(0xff4F5E7B).withOpacity(0.3),
                                    progressBarColor: const Color(0xff4F5E7B),
                                    thumbColor: const Color(0xff4F5E7B),
                                    timeLabelTextStyle: TextStyle(
                                      fontSize: 13.0,
                                      color: const Color(0xff4F5E7B),
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                      decoration: BoxDecoration(
                        color: check?? false ? Colors.greenAccent.withOpacity(0.2) : null,
                        borderRadius: BorderRadius.all(Radius.circular(5))
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      // margin: EdgeInsets.symmetric(horizontal: 5),
                      width: MediaQuery.of(context).size.width * 0.90,
                      // height: MediaQuery.of(context).size.height * 25,
                      child:
                      Row(
                        children: [
                          Text(prefix ?? ''),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Html(
                              data: parseHtmlString(i.value,fontSize: 14) ?? ''),
                          ),
                          Text(i.fileText ?? '')
                        ],
                      ),
                    ),
            ],
          ),
        )
      : Text('There is No Answer');
}

//to display correct answers during evaluation
Widget correctAnswerDuringEvaluation(
    BuildContext context, QuestionView widget, AudioManager audio,
    {bool isComprehension, int index}) {
  //if the question type is comprehension
  if (isComprehension) {
    log('02');
    if (widget.questionPaper.section[0].section[widget.index].questions[index]
            .questionType.first ==
        'freeText')
      return Container(
        height: 0,
        width: 0,
      );
    return AnswerOptions(
        context,
        widget.questionPaper.section[0].section[widget.index].questions[index]
            .answer,
        'Correct Answer',
        isAnswerByStudent: false);
  } else {
    return AnswerOptions(
        context,
        widget.questionPaper.section[0].section[widget.index].answer,
        'Correct Answer',
        isAnswerByStudent: false);
  }
}

//to display correct Answer during question paper creation


//to display options for answer
Container AnswerOptions(
    BuildContext context, List<QuestionOptions> answer, String text,
    {bool isAnswerByStudent, bool correctOrNot}) {
  Color color = Colors.white;
  isAnswerByStudent = isAnswerByStudent ?? false;
  correctOrNot = correctOrNot ?? false;
  if (isAnswerByStudent && correctOrNot) {
    color = Colors.greenAccent.withOpacity(0.2);
  }
  if (!correctOrNot && isAnswerByStudent) {
    color = Colors.red.withOpacity(0.2);
  }

  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: answer.isEmpty || answer == null || answer.contains(null)
              ? const Text('There is No Answer ')
              : Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  // elevation: 7,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: color,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, listIndex) {
                        return buildOptionsWidget(context, answer[listIndex]);
                      },
                      itemCount: answer.length,
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}

//to display answer by student
Widget answerByStudentDuringEvaluation(
    BuildContext context, QuestionView widget, AudioManager audio,
    {bool isComprehension, int index, bool correctOrNot}) {
  TextEditingController textFreeTextMarkController = TextEditingController();
  List<QuestionOptions> answer = List<QuestionOptions>.from(widget
      .answer.answerDetails[widget.index].answerByStudent
      .map((e) => QuestionOptions(value: e)));
  if (isComprehension) {
    List<TestAnswerDetails> ad = widget
        .answer.answerDetails[widget.index].answers;
    List<QuestionOptions> answerBySTudent = List<QuestionOptions>.from(
        ad[index].answerByStudent.map((e) => QuestionOptions(value: e)));

    if (widget.questionPaper.section[0].section[widget.index].questions[index]
            .questionType.first ==
        'freeText') {
      bool checkMarks() {
        return int.tryParse(textFreeTextMarkController.text) <=
                widget.questionPaper.section[0].section[widget.index].totalMarks
            ? true
            : false;
      }

      int maxLength() {
        int marks =
            widget.questionPaper.section[0].section[widget.index].totalMarks;
        return marks.toString().length;
      }

      displayError() {
        Fluttertoast.showToast(
            msg:
                'The Marks cannot be higher than specified marks for the question');
      }

      sendMarks(int index) {
        final SecureStorage sStorage = SecureStorage();
        int sMark = int.tryParse(textFreeTextMarkController.text);
        String _id = widget.answer.answerDetails[widget.index].id;
        String mainQuestionId =
            widget.questionPaper.section[0].section[widget.index].id;
        String sQuestionId = widget
            .questionPaper.section[0].section[widget.index].questions[index].id;

        sStorage.writeData(mainQuestionId, sQuestionId + sMark.toString());

        // Answer answer = Answer(
        //   correctOrNot: int.tryParse(textFreeTextMarkController.text) >= 0   ? 'yes' : 'no',
        //   questionId: sQuestionId,
        // );
        //
        // BlocProvider.of<QuestionAnswerCubit>(context).updateValues(AnswerDetail(questionId: mainQuestionId,correctOrNot: ,));
      }

      return
         ad[index].answerByStudent.isNotEmpty
          ? Column(
              children: [
                Divider(),
                Container(child: Text(ad[index].answerByStudent.first)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Container(
                    // margin: EdgeInsets.all(4.0),
                    padding: EdgeInsets.all(4.0),
                    // height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey.shade200)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, listIndex) {
                        log(ad[index].answerByStudent.length.toString());
                        return AttachedFile(
                          fileName: List<String>.from(ad[index]
                              .answerByStudent
                              .map((e) => e.toString())).toList(),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                    color: Color(0xffFFC30A),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Reward to Student"),
                              content: ListTile(
                                title: TextField(
                                  maxLength: maxLength(),
                                  controller: textFreeTextMarkController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {},
                                  decoration: const InputDecoration(
                                      hintText: "Write Reward for Student"),
                                ),
                                trailing: Text(
                                    '/ ${widget.questionPaper.section[0].section[widget.index].questions[index].totalMarks}'),
                                dense: true,
                              ),
                              actions: [

                                     FlatButton(
                                      onPressed: () {
                                        checkMarks()
                                            ? sendMarks(index)
                                            : displayError();
                                      },
                                      child: Text("Post"),
                                      color: Color(0xffFFC30A),
                                      textColor: Colors.white,
                                    )
                              ],
                            );
                          });
                    },
                    child: const Text(
                      'Reward',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )),
              ],
            )
          : Container(
              // height: 0,
              child: Text('No Answer'),
            );
    } else {
      return AnswerOptions(context, answerBySTudent, 'Answer By Student',
          isAnswerByStudent: true, correctOrNot: correctOrNot ?? false);
    }
  }
  return AnswerOptions(context, answer, 'Answer By Student',
      isAnswerByStudent: true, correctOrNot: correctOrNot ?? false);
}

//to build the comprehension questions during evaluation
class QuestionBuilderDuringEvaluation extends StatefulWidget {
  const  QuestionBuilderDuringEvaluation(
      {Key key,
      this.i = 0,
      this.questionPaper,
      this.audio,
      this.answer,
      this.questionPaperAnswer})
      : super(key: key);

  final int i;
  final QuestionPaper questionPaper;
  final AudioManager audio;
  final QuestionView answer;
  final QuestionPaperAnswer questionPaperAnswer;

  @override
  _QuestionBuilderDuringEvaluationState createState() =>
      _QuestionBuilderDuringEvaluationState();
}

class _QuestionBuilderDuringEvaluationState
    extends State<QuestionBuilderDuringEvaluation> {
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
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: true,
      itemCount:
          widget.questionPaper.section[0].section[widget.i].questions.length,
      physics: BouncingScrollPhysics(),
      clipBehavior: Clip.hardEdge,
      itemBuilder: (BuildContext context, int index) {
        // var questions = widget.questionList;
        // // if (!"${questions[index].questionType[0]}"
        // //         .toLowerCase()
        // //         .contains(filter.toLowerCase()) &&
        // //     filter != "None") {
        // //   return Container();
        // // }

        List<QuestionSection> section =
            widget.questionPaper.section[0].section[widget.i].questions;
        // ad = List<TestAnswerDetails>.from(widget.questionPaperAnswer.answerDetails[widget.i].answers.map((e) => TestAnswerDetails.fromJson(e)));
        // log(ad[index].answerByStudent[0].toString());
        //  answerBySTudent = List<QuestionOptions>.from(ad[index].answerByStudent.map((e) => QuestionOptions(value: e)));
        // for (var i in widget.questionPaper.section[0].section) {
        //   for (var j in i.questions) {
        //     log(j.totalMarks.toString());
        //     log(j.question[0]);
        //   }
        // }
        // log(widget.answer.answer.toString());
        List<TestAnswerDetails> answerDetails =
                widget.answer.answer.answerDetails[widget.i].answers;
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: MediaQuery.of(context).size.width * 0.01,
            right: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  //     child: TeXViewDocument("Q${index + 1}."  ),
                  //   ),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.73,
                    child:
                    Html(
                        data: section[index].question.first != null
                            ? parseHtmlString(section[index].question.first)
                            : ''),
                    // TeXView(
                    //   renderingEngine: TeXViewRenderingEngine.mathjax(),
                    //   child: TeXViewDocument(section[index].question != null
                    //       ? section[index].question.first
                    //       : ''),
                    // ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xffFFC30A),
                        size: 18,
                      ),
                      Text('${answerDetails[index].obtainedMarks}'),
                      Text('/${section[index].totalMarks ?? 0}'),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i in section[index].matchOptions.column1)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.all(5),
                            child: Text(
                              // Html(
                              (int.tryParse(i.type) ?? 0 + 1).toString() +
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
                        for (var i in section[index].matchOptions.column2)
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
                        for (var i in section[index].matchOptions.column3)
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
                    buildOptionsWidget(context, section[index].options[j],
                        prefix: bulletin[j], audioManager: widget.audio),
              if (widget.answer != null)
                correctAnswerDuringEvaluation(
                    context, widget.answer, widget.audio,
                    isComprehension: true, index: index),
              if (widget.answer != null)
                answerByStudentDuringEvaluation(
                    context, widget.answer, widget.audio,
                    isComprehension: true,
                    index: index,
                    correctOrNot: answerDetails[index].correctOrNot),
              // if (widget.answer == null)
              //   correctAnswerDuringCreation(context,
              //       audio: widget.audio,
              //       mainIndex: widget.i,
              //       paper: widget.questionPaper,
              //       isComprehension: true,
              //       index: index),
            ],
          ),
        );
      },
    );
  }
}

//to display the comprehension question during creation


class SecureStorage {
  final _storage = FlutterSecureStorage();

  Future writeData(String key, String value) async {
    var data = await _storage.write(key: key, value: value);
    return data;
  }

  Future readData(String key) async {
    var readData = await _storage.read(key: key);
    return readData;
  }

  Future deleteData(String key) async {
    var deleteData = await _storage.delete(key: key);
    return deleteData;
  }

  Future readAll() async {
    var data = await _storage.readAll();
    return data;
  }

  Future deleteAll() async {
    var data = await _storage.deleteAll();
    return data;
  }

  Future checkData(String key) async {
    var data = await _storage.containsKey(key: key);
    return data;
  }
}

Future<String> getTeacherId() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String teacherId = _prefs.get('user-id');
  return teacherId;
}

Future<String> getTeacherName() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String name = _prefs.get('user-name');
  return name;
}
