import 'dart:developer';

// import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/view/test-module/TestUtils.dart';
import 'package:just_audio/just_audio.dart';

import '../../bloc/test-module/test-module-states.dart';
import '../file_viewer.dart';

// import 'package:just_audio/just_audio.dart';

class QuestionView extends StatefulWidget {
  const QuestionView(
      {Key key, this.questionPaper, this.answer, this.index,this.count})
      : super(key: key);

  final QuestionPaper questionPaper;
  final QuestionPaperAnswer answer;
  final int index;
  final int count;

  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
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
  String buttonText = 'Reward';

  AudioManager audio;

  final SecureStorage sStorage = SecureStorage();

  int submittedMarks = 0;

  TextEditingController textFreeTextMarkController = TextEditingController();
  bool status = false;
  int index;
  @override
  void initState() {
    // TODO: implement initState

    String statusText = widget.answer.status;

    if (statusText != null) {
      status = statusText == 'Evaluated' ? true : false;
    }



    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // audio.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var section = widget.questionPaper.section[0].section;
     index = widget.index;
    // var question = section[index].question[0];

    var answer = widget.answer.answerDetails[index].answer;
    var studentAnswer = widget.answer.answerDetails[index].answerByStudent;

    var questionType = section[index].questionType[0];
    var questionMarks = section[index].totalMarks;

    return Card(
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getQuestionType(questionType),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(0xffFFC30A),
                    ),
                    Text(widget.answer.answerDetails[widget.index].negativeMarks != 0 ? '${
                           -widget.answer.answerDetails[widget.index]
                                .negativeMarks
                          }'
                        : '${
                              widget.answer.answerDetails[widget.index]
                                  .obtainedMarks
                            }' ?? '0'),
                    // Text(widget.answer.answerDetails[widget.index].obtainedMarks.toString()),
                    Text('/$questionMarks'),
                  ],
                )
              ],
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height ,
            child: Column(
              children: [
                ListTile(
                  leading: Text("Q${widget.index + 1}."),
                  title: Html(data:parseHtmlString(widget.questionPaper.section[0].section[widget.index].question[0])),
                  trailing: questionType == 'freeText'
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.17,
                          // height: 25,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xffFFC30A),
                              ),
                              Text('${widget.answer.answerDetails[index].obtainedMarks??BlocProvider.of<SubmitMarksCubit>(context).state.answerDetails.firstWhere((element) => element.questionId == section[index].id,orElse: ()=>AnswerDetail(obtainedMarks: 0)).obtainedMarks}'),
                              Text('/$questionMarks'),
                            ],
                          ),
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                ),
                //if the question type is of Comprehension then another widget will be built
                if (questionType == 'comprehension')
                  Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: QuestionBuilderDuringEvaluation(
                        audio: audio,
                        i: index,
                        questionPaper: widget.questionPaper,
                        answer: widget,
                      )),

                //if the question has columns (two/three column question) then this widget will be called
                buildColumns(section, index),

                //if the question has options then this widget is called
                if (section[index].options != null)
                  for (int j = 0; j < section[index].options.length; j++)
                    if (section[index].options[j].value != null)
                      buildOptionsWidget(context, section[index].options[j],
                          prefix: bulletin[j], audioManager: audio),
                SizedBox(
                  height: 10,
                ),

// If the question type is not FreeText and Comprehension the code below is used to build the answer by student module

                if (questionType != 'freeText' &&
                    questionType != 'comprehension')
                  answerByStudentDuringEvaluation(context, widget, audio,
                      isComprehension: false,
                      correctOrNot: widget.answer.answerDetails[widget.index]
                              .correctOrNot ??
                          false),

                // If the question type is not FreText and Comprehession the code below is used build the correct answer module
                if (questionType != 'freeText' &&
                    questionType != 'comprehension')
                  correctAnswerDuringEvaluation(context, widget, audio,
                      isComprehension: false),
              ],
            ),
          ),
          // if the question is of type freeText then widget is built to display answer by student and attachments
          if (questionType == 'freeText')
            Column(
              children: [
                Divider(),
                Container(
                  child:
                  Text(studentAnswer.isNotEmpty ? studentAnswer[0]:''),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(4.0),
                    // height: MediaQuery.of(context).size.height * 0.25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey.shade200)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: 1,
                      // itemCount: answer.length,
                      itemBuilder: (context, index) {
                        studentAnswer.forEach((element) {
                          log(element.toString()+'file');
                        });
                        return AttachedFile(
                          fileName: List<String>.from(
                              studentAnswer.map((e) => e.toString())).toList(),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                status
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : BlocBuilder<SubmitMarksCubit,SubmitMarksStates>(
                      builder: (context,state) {
                        if(state is FreeTextAnswerSubmission)
                          {
                            // log('entered');
                            // print(state.answerDetails);
                            // state.answerDetails.forEach((element) {
                            //   log(element.questionId.toString()+'question id');
                            //   log(element.obtainedMarks.toString());
                            //   log(section[index].id);
                            // });
                            submittedMarks = state.answerDetails.firstWhere((element) => element.questionId == section[index].id,orElse: (){
                              // log('obtained marks');
                              return AnswerDetail(obtainedMarks: 0);

                            }).obtainedMarks;
                            return CustomRaisedButton(
                              title: buttonText+'  ($submittedMarks)',
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
                                              decoration: InputDecoration(
                                                  hintText: "Write Reward for Student"),
                                            ),
                                            trailing: Text('/ $questionMarks'),
                                            dense: true,
                                          ),
                                          actions: [
                                            FlatButton(

                                              onPressed: () {
                                                checkMarks()
                                                    ? submit(id: widget.answer.answerDetails[index].id,questionId: section[index].id,state: state,correctOrNot: int.tryParse(textFreeTextMarkController.text) >= 0   ? 'yes' : 'no',mark: int.tryParse(textFreeTextMarkController.text))
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
                               );
                          }
                        else
                          {
                            return Container(height: 0,);
                          }

                      }
                    ),
              ],
            ),
        ],
      ),
    );
  }

  // bool checkId({String id,FreeTextAnswerSubmission state})
  // {
  //   state.answerDetails.forEach((element) {
  //     if(element.questionId == id)
  //       {
  //         return false;
  //       }
  //     else
  //       {
  //         return true;
  //       }
  //   });
  //   return false;
  // }

  void submit({String id,String questionId,FreeTextAnswerSubmission state,String correctOrNot,int mark}){

    AnswerDetail answerDetail = AnswerDetail(
      id: id,
      questionId: questionId,
      correctOrNot: correctOrNot,
      obtainedMarks: mark
    );
        BlocProvider.of<SubmitMarksCubit>(context).updateValues(answerDetail);
        // print(BlocProvider.of<SubmitMarksCubit>(context).state.answerDetails);
      submittedMarks = BlocProvider.of<SubmitMarksCubit>(context).state.answerDetails.firstWhere((element) => element.questionId == questionId).obtainedMarks;
    setState(() {

    });
    Navigator.pop(context);



  }



  int maxLength() {
    int marks =
        widget.questionPaper.section[0].section[widget.index].totalMarks;
    return marks.toString().length;
  }

  bool checkMarks() {
    return int.tryParse(textFreeTextMarkController.text) <=
            widget.questionPaper.section[0].section[widget.index].totalMarks
        ? true
        : false;
  }

  String getCurrentQuestion() {
    return HtmlParser.parseHTML(
            parseHtmlString(widget.questionPaper.section[0].section[widget.index].question[0]))
        .body
        .text
        .trim();
  }

  String getQuestionType(String type) {
    String questionType;
    switch (type) {
      case 'twoColMtf':
        questionType = 'Two Column Match the Following';
        break;
      case 'threeColMtf':
        questionType = 'Three Column Match the Following';
        break;
      case 'mcq':
        questionType = 'MCQ';
        break;
      case 'objectives':
        questionType = 'Objectives';
        break;
      case 'fillInTheBlanks':
        questionType = 'Fill In The Blanks';
        break;
      case 'trueOrFalse':
        questionType = 'True Or False';
        break;
      case 'freeText':
        questionType = 'Free Text';
        break;
      case 'comprehension':
        questionType = 'Comprehension';
        break;
      case 'NumericalRange':
        questionType = 'Numerical Range';
        break;
      case 'optionLevelScoring':
        questionType = 'Option Level Scoring';
        break;
      case '3colOptionLevelScoring':
        questionType = 'Three Column Option Level';
        break;
      default:
        questionType = '';
    }
    return questionType;
  }

  displayError() {
    Fluttertoast.showToast(
        msg:
            'The Marks cannot be higher than specified marks for the question');
  }

  // sendMarks(String questionId,int marksObtained,) {
  //
  //   AnswerDetail answerDetail = AnswerDetail(
  //     questionId: questionId,
  //     correctOrNot:
  //   );
  //
  //
  //   // FreeText freeText = FreeText(
  //   //     marksObtained: int.tryParse(textFreeTextMarkController.text),
  //   //     studentId: widget.answer.studentDetails.studentId,
  //   //     questionId: widget.questionPaper.section[0].section[widget.index].id,
  //   //     id: widget.answer.answerDetails[widget.index].id);
  //   //
  //   // sStorage.writeData(freeText.questionId,
  //   //     freeText.id + ',' + freeText.marksObtained.toString());
  //   Navigator.of(context).pop();
  // }

  buildColumns(List<QuestionSection> section, int index) {
    return SingleChildScrollView(
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
    );
  }
}

class AttachedFile extends StatelessWidget {
  const AttachedFile({Key key, this.fileName}) : super(key: key);

  final List<String> fileName;

  @override
  Widget build(BuildContext context) {
    fileName.forEach((element) {
      log(element.toString()+'file');
    });
    return Container(
      margin: EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Column(
        children: [
          const Text(
            "ATTACHMENTS",
            style: TextStyle(
              color: Color(0xff828282),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
              fontStyle: FontStyle.normal,
              fontSize: 13.0,
            ),
            textAlign: TextAlign.left,
          ),
          Container(
            // height: 75.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(colors: [
                  Colors.grey.shade400,
                  Colors.grey.shade50,
                ])),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: fileName.skip(1).toList().isNotEmpty
                        ? FileListing(fileName.skip(1).toList())
                        : Text('No Attachment'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

AudioManager audioManagerObject;

class AudioManager {
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  AudioPlayer _audioPlayer;

  AudioManager(MediaResourceType resourceType, String url) {
    _init(resourceType, url);
  }

  void _init(MediaResourceType resourceType, String url) async {
    // initialize the song
    _audioPlayer = AudioPlayer();
    if (resourceType == MediaResourceType.url) {
      await _audioPlayer.setUrl(url);
    } else {
      await _audioPlayer.setFilePath(url);
    }
    // listen for changes in player state
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    // listen for changes in play position
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    // listen for changes in the buffered position
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    // listen for changes in the total audio duration
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() async {
    if (audioManagerObject != null && audioManagerObject.isPlaying()) {
      audioManagerObject.pause();
    }
    _audioPlayer.play();
    audioManagerObject = this;
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void forward(Duration duration) {
    if (_audioPlayer.duration.inSeconds - _audioPlayer.position.inSeconds <
        10) {
      seek(_audioPlayer.duration);
    } else {
      seek(_audioPlayer.position + duration);
    }
  }

  void replay(Duration duration) {
    if (_audioPlayer.position.inSeconds < 10) {
      seek(Duration.zero);
    } else {
      seek(_audioPlayer.position - duration);
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  bool isPlaying() => _audioPlayer.playing;
}

class ProgressBarState {
  ProgressBarState({
    @required this.current,
    @required this.buffered,
    @required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}

enum ButtonState { paused, playing, loading }
