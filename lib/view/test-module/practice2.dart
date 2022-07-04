import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:growonplus_teacher/view/test-module/question_view.dart';
import '/bloc/auth/auth-cubit.dart';
import '/bloc/auth/auth-states.dart';
import '/const.dart';
import '/extensions/utils.dart';
import '/model/test-model.dart';
import '/view/homepage/home_sliver_appbar.dart';
import '/view/test-module/practice3.dart';
import 'TestUtils.dart';
import 'constants.dart';

class SelectQuestionPaper extends StatefulWidget {
  final List<QuestionType> questionList;
  final QuestionPaper questionPaper;

  SelectQuestionPaper(this.questionList, this.questionPaper, {Key key})
      : super(key: key) {
    questionPaper.isCreated = false;
  }

  @override
  _SelectQuestionPaperState createState() => _SelectQuestionPaperState();
}

class _SelectQuestionPaperState extends State<SelectQuestionPaper> {
  bool ques1 = false;
  String filter = 'None';
  String ddValue = 'None';

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

  Widget checkbox(QuestionType currentQues) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
          value: currentQues.selected,
          activeColor: kPrimaryColor,
          onChanged: (bool newValue) {
            setState(() {
              currentQues.selected = newValue;
            });
            // if (newValue) {
            //   widget.questionList.remove(currentQues);
            // } else {
            //   widget.questionList.add(currentQues);
            // }
            Text('Remember me');
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(audio != null)
    audio.dispose();
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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kBlackColor,
          ),
        ),
      ),
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            // audio.dispose();
            return true;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
                  if (state is AccountsLoaded) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      height: MediaQuery.of(context).size.height * 0.23,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40)),
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                              leading: TeacherProfileAvatar(),
                              title: Text('Created By'),
                              subtitle: Text(widget.questionPaper.createdBy ??
                                  state.user.name),
                              trailing: Container(
                                width: 100.0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 20,
                                      child: Text(
                                          'Marks : ${widget.questionPaper.section[0].section[0].totalMarks}'
                                          //     'Marks : ${widget.questionPaper.section[0].section.fold(
                                          //   0,
                                          //   (previousValue, element) =>
                                          //       previousValue +
                                          //       element.totalMarks +
                                          //       element.questions.fold(
                                          //           0,
                                          //           (previousValue2, element2) =>
                                          //               previousValue2 +
                                          //               element2.totalMarks),
                                          // )}'
                                          ),
                                    ),
                                    Container(
                                      height: 20,
                                      child: Text(
                                          'Coins : ${widget.questionPaper.coin}'),
                                    ),
                                    Container(
                                      height: 16,
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
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Question Title:  ',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          alignment: Alignment.bottomCenter,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom:
                                                      BorderSide(width: 1))),
                                          child: Text(
                                              '${widget.questionPaper.questionTitle}'),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
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
                                                      bottom: BorderSide(
                                                          width: 1))),
                                              child: Text(
                                                  '${widget.questionPaper.detailQuestionPaper.className}'),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 5,
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
                                                      bottom: BorderSide(
                                                          width: 1))),
                                              child: Text(
                                                  '${widget.questionPaper.detailQuestionPaper.subject[0].name}'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Column(
                                //   children: [
                                //     Container(
                                //       height: 50,
                                //       width: 100,
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           // border: Border.all(
                                //           //     width: 0, color: Colors.black)
                                //           ),
                                //       child: Text(
                                //           'Marks : ${widget.questionPaper.section[0].section.fold(
                                //         0,
                                //         (previousValue, element) =>
                                //             previousValue +
                                //             element.totalMarks +
                                //             element.questions.fold(
                                //                 0,
                                //                 (previousValue2, element2) =>
                                //                     previousValue2 +
                                //                     element2.totalMarks),
                                //       )}'),
                                //     ),
                                //     Container(
                                //       height: 50,
                                //       width: 100,
                                //       alignment: Alignment.center,
                                //       decoration: BoxDecoration(
                                //           // border: Border.all(
                                //           //     width: 0, color: Colors.black)
                                //           ),
                                //       child: Text(
                                //           'Coins : ${widget.questionPaper.coin} \nRewards : ${widget.questionPaper.award}'),
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    BlocProvider.of<AuthCubit>(context)
                        .checkAuthStatus();
                    return Container();
                  }
                }),

                // Container(
                //   decoration: BoxDecoration(
                //       border: Border.all(color: kGreyColor, width: 1),
                //       borderRadius: BorderRadius.circular(5)),
                //   width: MediaQuery.of(context).size.width * 0.9,
                //   child: Padding(
                //     padding: EdgeInsets.only(
                //       left: MediaQuery.of(context).size.width * 0.03,
                //       right: MediaQuery.of(context).size.width * 0.03,
                //     ),
                //     child: CustomTextFieldTags(
                //       initialTags: widget.questionPaper.detailQuestionPaper
                //           .learningOutcome[0].outcome,
                //       suggestionList: [],
                //       tagsStyler: TagsStyler(
                //         tagCancelIcon: const Icon(
                //           Icons.cancel,
                //           size: 18.0,
                //           color: Colors.black,
                //         ),
                //         tagDecoration: BoxDecoration(
                //           color: Color(0xffFFF2C9),
                //         ),
                //       ),
                // enabled: false,
                // initialValue: widget.questionPaper.detailQuestionPaper
                //     .learningOutcome[0].outcome
                //     .join(' '),
                // maxLines: 2,
                // cursorColor: kGreyColor,
                // textFieldStyler: TextFieldStyler(
                //   textFieldEnabled: false,
                //   // decoration: InputDecoration(
                //   hintText: "Learning Outcome",
                //   // hintStyle: TextStyle(
                //   //     color: kGreyColor,
                //   //     fontSize: 12,
                //   //     fontWeight: FontWeight.w400),
                //   textFieldFilledColor: kLightColor,
                //   hintStyle: TextStyle(
                //       color: kGreyColor,
                //       fontSize: 10,
                //       fontWeight: FontWeight.w400),
                // textFieldEnabledBorder: UnderlineInputBorder(
                //   borderSide: BorderSide(color: kLightColor),
                // ),
                // textFieldFocusedBorder: UnderlineInputBorder(
                //   borderSide: BorderSide(color: kLightColor),
                // ),
                //       ),
                //       onTag: (String tag) {},
                //       onDelete: (String tag) {},
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
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
                      children: [
                        Icon(
                          Icons.folder_open_outlined,
                          size: 20,
                          color: kBlackColor,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Question Bank",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: kBlackColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          height: 20,
                          decoration: BoxDecoration(
                              border: Border.all(color: kGreyColor, width: 0.5),
                              borderRadius: BorderRadius.circular(5),
                              color: kWhiteColor),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            isDense: false,
                            underline: Container(),
                            focusColor: Colors.white,
                            value: ddValue,
                            //elevation: 5,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.black,
                            items: <String>[
                              "None",
                              "MCQ",
                              "Two Column Matching",
                              "Objectives",
                              "Fill In The Blanks",
                              "Three Column Matching",
                              "True Or False",
                              "Free Text",
                              "Numerical Range",
                              "Comprehension",
                              'Option Level Scoring',
                              'Three Column Option Level'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            hint: const Text(
                              "Filter",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor,
                              ),
                            ),
                            onChanged: (String value) {

                              switch (value) {
                                case 'None':
                                  filter = 'None';
                                  break;
                                case "MCQ":
                                  filter = "mcq";
                                  break;
                                case "Two Column Matching":
                                  filter = "twoColMtf";
                                  break;
                                case "Objectives":
                                  filter = "objectives";
                                  break;
                                case "Fill In The Blanks":
                                  filter = "fillInTheBlanks";
                                  break;
                                case "Three Column Matching":
                                  filter = "threeColMtf";
                                  break;
                                case "True Or False":
                                  filter = "trueOrFalse";
                                  break;
                                case "Free Text":
                                  filter = "freeText";
                                  break;
                                case "Numerical Range":
                                  filter = "NumericalRange";
                                  break;
                                case "Comprehension":
                                  filter = "comprehension";
                                  break;
                                case 'Option Level Scoring':
                                  filter = 'optionLevelScoring';
                                  break;
                                case 'Three Column Option Level':
                                  filter = '3colOptionLevelScoring';
                                  break;
                                default:
                                  filter = "None";
                              }

                              ddValue = value;

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // SvgPicture.string("<p>1<svg style=\"vertical-align: -0.25ex\" xmlns=\"http://www.w3.org/2000/svg\" width=\"30px\" height=\"23px\" role=\"img\" focusable=\"false\" viewBox=\"0 -949.5 1353 1060\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"><defs><path id=\"MJX-1-TEX-N-221A\" d=\"M95 178Q89 178 81 186T72 200T103 230T169 280T207 309Q209 311 212 311H213Q219 311 227 294T281 177Q300 134 312 108L397 -77Q398 -77 501 136T707 565T814 786Q820 800 834 800Q841 800 846 794T853 782V776L620 293L385 -193Q381 -200 366 -200Q357 -200 354 -197Q352 -195 256 15L160 225L144 214Q129 202 113 190T95 178Z\"></path><path id=\"MJX-1-TEX-N-35\" d=\"M164 157Q164 133 148 117T109 101H102Q148 22 224 22Q294 22 326 82Q345 115 345 210Q345 313 318 349Q292 382 260 382H254Q176 382 136 314Q132 307 129 306T114 304Q97 304 95 310Q93 314 93 485V614Q93 664 98 664Q100 666 102 666Q103 666 123 658T178 642T253 634Q324 634 389 662Q397 666 402 666Q410 666 410 648V635Q328 538 205 538Q174 538 149 544L139 546V374Q158 388 169 396T205 412T256 420Q337 420 393 355T449 201Q449 109 385 44T229 -22Q148 -22 99 32T50 154Q50 178 61 192T84 210T107 214Q132 214 148 197T164 157Z\"></path></defs><g stroke=\"currentColor\" fill=\"currentColor\" stroke-width=\"0\" transform=\"scale(1,-1)\"><g data-mml-node=\"math\"><g data-mml-node=\"msqrt\"><g transform=\"translate(853,0)\"><g data-mml-node=\"mn\"><use data-c=\"35\" xlink:href=\"#MJX-1-TEX-N-35\"></use></g></g><g data-mml-node=\"mo\" transform=\"translate(0,89.5)\"><use data-c=\"221A\" xlink:href=\"#MJX-1-TEX-N-221A\"></use></g><rect width=\"500\" height=\"60\" x=\"853\" y=\"829.5\"></rect></g></g></g></svg></p>"),
                // SvgPicture.string(""""<svg width="240px" height="240px" viewBox="0 0 24 24" role="img" xmlns="http://www.w3.org/2000/svg"><title>Blackberry icon</title><path d="M2.05 3.54L1.17 7.7H4.45C6.97 7.7 7.73 6.47 7.73 5.36C7.73 4.54 7.26 3.54 5.21 3.54H2.05M10.54 3.54L9.66 7.7H12.94C15.5 7.7 16.22 6.47 16.22 5.36C16.22 4.54 15.75 3.54 13.7 3.54H10.54M18.32 7.23L17.39 11.39H20.67C23.24 11.39 24 10.22 24 9.05C24 8.23 23.53 7.23 21.5 7.23H18.32M.88 9.8L0 13.96H3.28C5.85 13.96 6.56 12.73 6.56 11.62C6.56 10.8 6.09 9.8 4.04 9.8H.88M9.43 9.8L8.5 13.96H11.77C14.34 13.96 15.11 12.73 15.11 11.62C15.11 10.8 14.64 9.8 12.59 9.8H9.42M17.09 13.73L16.22 17.88H19.5C22 17.88 22.77 16.71 22.77 15.54C22.77 14.72 22.3 13.73 20.26 13.73H17.09M8.2 16.3L7.32 20.46H10.6C13.11 20.46 13.87 19.23 13.87 18.12C13.87 17.3 13.41 16.3 11.36 16.3H8.2Z"/></svg>"""),
                // Html(data: """<svg width="240px" height="240px" viewBox="0 0 24 24" role="img" xmlns="http://www.w3.org/2000/svg"><title>Blackberry icon</title><path d="M2.05 3.54L1.17 7.7H4.45C6.97 7.7 7.73 6.47 7.73 5.36C7.73 4.54 7.26 3.54 5.21 3.54H2.05M10.54 3.54L9.66 7.7H12.94C15.5 7.7 16.22 6.47 16.22 5.36C16.22 4.54 15.75 3.54 13.7 3.54H10.54M18.32 7.23L17.39 11.39H20.67C23.24 11.39 24 10.22 24 9.05C24 8.23 23.53 7.23 21.5 7.23H18.32M.88 9.8L0 13.96H3.28C5.85 13.96 6.56 12.73 6.56 11.62C6.56 10.8 6.09 9.8 4.04 9.8H.88M9.43 9.8L8.5 13.96H11.77C14.34 13.96 15.11 12.73 15.11 11.62C15.11 10.8 14.64 9.8 12.59 9.8H9.42M17.09 13.73L16.22 17.88H19.5C22 17.88 22.77 16.71 22.77 15.54C22.77 14.72 22.3 13.73 20.26 13.73H17.09M8.2 16.3L7.32 20.46H10.6C13.11 20.46 13.87 19.23 13.87 18.12C13.87 17.3 13.41 16.3 11.36 16.3H8.2Z"/></svg>"""),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.questionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var questions = widget.questionList;

                        if (!"${questions[index].questionType[0]}"
                                .contains(filter) &&
                            filter != "None") {
                          return Container();
                        }
                        var section = widget.questionPaper.section[0].section;

                        return Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              // left: MediaQuery.of(context).size.width * 0.02,
                              // right: MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(

                                  children: [
                                    // Container(),
                                    Text(checkQuestionType(section[index].questionType.first), style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: kGreyColor),),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: kPrimaryColor,
                                        ),
                                        Text(
                                          "${questions[index].totalMarks}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: kBlackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Q${index+1}",style: buildTextStyle(weight: FontWeight.bold,size: 12,),),
                               Flexible(
                              fit: FlexFit.tight,
                              child: Container(
                                  child:
                                  // Html(data: """<p>Explain this Equation&nbsp;<svg style="vertical-align: -0.25ex" xmlns="http://www.w3.org/2000/svg" width="30.61" height="23.98" role="img" focusable="false" viewBox="0 -949.5 1353 1060" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><path id="MJX-1-TEX-N-221A" d="M95 178Q89 178 81 186T72 200T103 230T169 280T207 309Q209 311 212 311H213Q219 311 227 294T281 177Q300 134 312 108L397 -77Q398 -77 501 136T707 565T814 786Q820 800 834 800Q841 800 846 794T853 782V776L620 293L385 -193Q381 -200 366 -200Q357 -200 354 -197Q352 -195 256 15L160 225L144 214Q129 202 113 190T95 178Z"></path><path id="MJX-1-TEX-N-35" d="M164 157Q164 133 148 117T109 101H102Q148 22 224 22Q294 22 326 82Q345 115 345 210Q345 313 318 349Q292 382 260 382H254Q176 382 136 314Q132 307 129 306T114 304Q97 304 95 310Q93 314 93 485V614Q93 664 98 664Q100 666 102 666Q103 666 123 658T178 642T253 634Q324 634 389 662Q397 666 402 666Q410 666 410 648V635Q328 538 205 538Q174 538 149 544L139 546V374Q158 388 169 396T205 412T256 420Q337 420 393 355T449 201Q449 109 385 44T229 -22Q148 -22 99 32T50 154Q50 178 61 192T84 210T107 214Q132 214 148 197T164 157Z"></path></defs><g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="msqrt"><g transform="translate(853,0)"><g data-mml-node="mn"><use data-c="35" xlink:href="#MJX-1-TEX-N-35"></use></g></g><g data-mml-node="mo" transform="translate(0,89.5)"><use data-c="221A" xlink:href="#MJX-1-TEX-N-221A"></use></g><rect width="500" height="60" x="853" y="829.5"></rect></g></g></g></svg> , in Detail<svg style="vertical-align: -0.05ex" xmlns="http://www.w3.org/2000/svg" width="33.88" height="22.54" role="img" focusable="false" viewBox="0 -974.1 1497.7 996.1" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><path id="MJX-1-TEX-N-35" d="M164 157Q164 133 148 117T109 101H102Q148 22 224 22Q294 22 326 82Q345 115 345 210Q345 313 318 349Q292 382 260 382H254Q176 382 136 314Q132 307 129 306T114 304Q97 304 95 310Q93 314 93 485V614Q93 664 98 664Q100 666 102 666Q103 666 123 658T178 642T253 634Q324 634 389 662Q397 666 402 666Q410 666 410 648V635Q328 538 205 538Q174 538 149 544L139 546V374Q158 388 169 396T205 412T256 420Q337 420 393 355T449 201Q449 109 385 44T229 -22Q148 -22 99 32T50 154Q50 178 61 192T84 210T107 214Q132 214 148 197T164 157Z"></path><path id="MJX-1-TEX-N-32" d="M109 429Q82 429 66 447T50 491Q50 562 103 614T235 666Q326 666 387 610T449 465Q449 422 429 383T381 315T301 241Q265 210 201 149L142 93L218 92Q375 92 385 97Q392 99 409 186V189H449V186Q448 183 436 95T421 3V0H50V19V31Q50 38 56 46T86 81Q115 113 136 137Q145 147 170 174T204 211T233 244T261 278T284 308T305 340T320 369T333 401T340 431T343 464Q343 527 309 573T212 619Q179 619 154 602T119 569T109 550Q109 549 114 549Q132 549 151 535T170 489Q170 464 154 447T109 429Z"></path><path id="MJX-1-TEX-N-33" d="M127 463Q100 463 85 480T69 524Q69 579 117 622T233 665Q268 665 277 664Q351 652 390 611T430 522Q430 470 396 421T302 350L299 348Q299 347 308 345T337 336T375 315Q457 262 457 175Q457 96 395 37T238 -22Q158 -22 100 21T42 130Q42 158 60 175T105 193Q133 193 151 175T169 130Q169 119 166 110T159 94T148 82T136 74T126 70T118 67L114 66Q165 21 238 21Q293 21 321 74Q338 107 338 175V195Q338 290 274 322Q259 328 213 329L171 330L168 332Q166 335 166 348Q166 366 174 366Q202 366 232 371Q266 376 294 413T322 525V533Q322 590 287 612Q265 626 240 626Q208 626 181 615T143 592T132 580H135Q138 579 143 578T153 573T165 566T175 555T183 540T186 520Q186 498 172 481T127 463Z"></path></defs><g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="msup"><g data-mml-node="mn"><use data-c="35" xlink:href="#MJX-1-TEX-N-35"></use></g><g data-mml-node="mrow" transform="translate(533,363) scale(0.707)"><g data-mml-node="mn"><use data-c="32" xlink:href="#MJX-1-TEX-N-32"></use></g><g data-mml-node="mfrac" transform="translate(500,0)"><g data-mml-node="mn" transform="translate(220,394) scale(0.707)"><use data-c="33" xlink:href="#MJX-1-TEX-N-33"></use></g><g data-mml-node="mn" transform="translate(220,-345) scale(0.707)"><use data-c="32" xlink:href="#MJX-1-TEX-N-32"></use></g><rect width="553.6" height="60" x="120" y="220"></rect></g></g></g></g></g></svg> <svg style="vertical-align: -0.681ex" xmlns="http://www.w3.org/2000/svg" width="48.08" height="28.26" role="img" focusable="false" viewBox="0 -948 2125.2 1248.9" xmlns:xlink="http://www.w3.org/1999/xlink"><defs><path id="MJX-1-TEX-I-1D700" d="M190 -22Q124 -22 76 11T27 107Q27 174 97 232L107 239L99 248Q76 273 76 304Q76 364 144 408T290 452H302Q360 452 405 421Q428 405 428 392Q428 381 417 369T391 356Q382 356 371 365T338 383T283 392Q217 392 167 368T116 308Q116 289 133 272Q142 263 145 262T157 264Q188 278 238 278H243Q308 278 308 247Q308 206 223 206Q177 206 142 219L132 212Q68 169 68 112Q68 39 201 39Q253 39 286 49T328 72T345 94T362 105Q376 103 376 88Q376 79 365 62T334 26T275 -8T190 -22Z"></path><path id="MJX-1-TEX-SO-2211" d="M61 748Q64 750 489 750H913L954 640Q965 609 976 579T993 533T999 516H979L959 517Q936 579 886 621T777 682Q724 700 655 705T436 710H319Q183 710 183 709Q186 706 348 484T511 259Q517 250 513 244L490 216Q466 188 420 134T330 27L149 -187Q149 -188 362 -188Q388 -188 436 -188T506 -189Q679 -189 778 -162T936 -43Q946 -27 959 6H999L913 -249L489 -250Q65 -250 62 -248Q56 -246 56 -239Q56 -234 118 -161Q186 -81 245 -11L428 206Q428 207 242 462L57 717L56 728Q56 744 61 748Z"></path><path id="MJX-1-TEX-N-32" d="M109 429Q82 429 66 447T50 491Q50 562 103 614T235 666Q326 666 387 610T449 465Q449 422 429 383T381 315T301 241Q265 210 201 149L142 93L218 92Q375 92 385 97Q392 99 409 186V189H449V186Q448 183 436 95T421 3V0H50V19V31Q50 38 56 46T86 81Q115 113 136 137Q145 147 170 174T204 211T233 244T261 278T284 308T305 340T320 369T333 401T340 431T343 464Q343 527 309 573T212 619Q179 619 154 602T119 569T109 550Q109 549 114 549Q132 549 151 535T170 489Q170 464 154 447T109 429Z"></path><path id="MJX-1-TEX-N-33" d="M127 463Q100 463 85 480T69 524Q69 579 117 622T233 665Q268 665 277 664Q351 652 390 611T430 522Q430 470 396 421T302 350L299 348Q299 347 308 345T337 336T375 315Q457 262 457 175Q457 96 395 37T238 -22Q158 -22 100 21T42 130Q42 158 60 175T105 193Q133 193 151 175T169 130Q169 119 166 110T159 94T148 82T136 74T126 70T118 67L114 66Q165 21 238 21Q293 21 321 74Q338 107 338 175V195Q338 290 274 322Q259 328 213 329L171 330L168 332Q166 335 166 348Q166 366 174 366Q202 366 232 371Q266 376 294 413T322 525V533Q322 590 287 612Q265 626 240 626Q208 626 181 615T143 592T132 580H135Q138 579 143 578T153 573T165 566T175 555T183 540T186 520Q186 498 172 481T127 463Z"></path></defs><g stroke="currentColor" fill="currentColor" stroke-width="0" transform="scale(1,-1)"><g data-mml-node="math"><g data-mml-node="mi"><use data-c="1D700" xlink:href="#MJX-1-TEX-I-1D700"></use></g><g data-mml-node="mstyle" transform="translate(632.7,0)"><g data-mml-node="munderover"><g data-mml-node="mo"><use data-c="2211" xlink:href="#MJX-1-TEX-SO-2211"></use></g><g data-mml-node="mn" transform="translate(1089,477.1) scale(0.707)"><use data-c="32" xlink:href="#MJX-1-TEX-N-32"></use></g><g data-mml-node="mn" transform="translate(1089,-285.4) scale(0.707)"><use data-c="33" xlink:href="#MJX-1-TEX-N-33"></use></g></g></g></g></g></svg></p>"""),
                                  Html(data:parseHtmlString(section[index].question.first,fontSize: 14),shrinkWrap: true,
                                  ),
                              ),
                            ),
                                    // Flexible(
                                    //   fit: FlexFit.tight,
                                    //   child:TeXView(
                                    //     renderingEngine: TeXViewRenderingEngine.mathjax(),
                                    //     child: TeXViewDocument("Q${index + 1}.${section[index].question.first}"),
                                    //   ),
                                    // ),
                                    // Container(
                                    //   width: MediaQuery.of(context).size.width *
                                    //       0.69,
                                    //   child:
                                    //   Flexible(
                                    //     fit: FlexFit.tight,
                                    //     child:TeXView(
                                    //       renderingEngine: TeXViewRenderingEngine.mathjax(),
                                    //       child: TeXViewDocument(section[index].question.first),
                                    //     ),
                                    //
                                    //     // Html(
                                    //     //     data: section[index].question[0]),
                                    //   ),
                                    // ),

                                    checkbox(questions[index]),
                                    // SizedBox(width: 5,)
                                  ],
                                ),
                                if (section[index].questionType.first ==
                                    'comprehension')
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: createComprehensionQuestion(itemCount: section[index].questions.length,
                                    paper: widget.questionPaper,
                                        mainIndex: index,
                                        audio: audio,
                                        // widget.questionPaper.section[0].section[widget.i].questions
                                    ),
                                    // QuestionBuilderDuringCreation(
                                    //   questionPaper: widget.questionPaper,
                                    //   i: index,
                                    //   audio: audio,
                                    // ),
                                  ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var i in section[index]
                                              .matchOptions
                                              .column1)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              margin: EdgeInsets.all(5),
                                              child: Text(
                                                (int.parse(i.type) + 0)
                                                        .toString() +
                                                    " - " +
                                                    i.value,
                                                style: buildTextStyle(
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var i in section[index]
                                              .matchOptions
                                              .column2)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              margin: EdgeInsets.all(5),
                                              child: Text(
                                                i.type + " - " + i.value,
                                                style: buildTextStyle(
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          for (var i in section[index]
                                              .matchOptions
                                              .column3)
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              padding: EdgeInsets.all(8),
                                              margin: EdgeInsets.all(5),
                                              child: Text(
                                                i.type + " - " + i.value,
                                                style: buildTextStyle(
                                                  color: Colors.white,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                        ],
                                      )
                                    ]),
                                  ),
                                ),
                                // if(section[index].questionType.first.toLowerCase() != 'fillintheblanks' && section[index].questionType.first.toLowerCase() != 'numericalrange' )
                                if (section[index].options != null)
                                  for (int i = 0;
                                      i < section[index].options.length;
                                      i++)
                                    if (section[index].options[i].value != null)
                                      buildOptionsWidget(
                                          context, section[index].options[i],
                                          // prefix: section[index].options[i].prefix,
                                          prefix: bulletin[i],
                                          audioManager: audio,
                                      answer: section[index].answer,type: section[index].optionsType),
                                if(section[index].questionType.first == 'trueOrFalse')
                                  Text('Answer: '+section[index].answer.first.value)
                                // if(section[index].reason != null)
                                //   Text(section[index].reason)
                                // if (section[index].questionType.first !=
                                //         'comprehension' &&
                                //     section[index].questionType.first !=
                                //         'freeText')
                                //   correctAnswerDuringCreation(
                                //       // paper: widget.questionPaper.section[0].section.,
                                //       mainIndex: index,
                                //       // sectionList: widget.questionPaper.section,
                                //       questionSection: widget.questionPaper.section[0].section,
                                //       audio: audio,
                                //       isComprehension: false,
                                //       index: index)
                                // Html(data: section[index].answer.first.value),
                              ],
                            )));
                      }),
                ),
                InkWell(
                  onTap: () {
                    widget.questionPaper.section[0].section =
                        widget.questionList
                            .where((element) => element.selected)
                            .toList()
                            .map((e) => QuestionSection(
                          reason: e.reason,
                                  id: e.id,
                                  answer: e.answer,
                                  duration: e.duration,
                                  matchOptions: e.matchOption,
                                  negativeScore: e.negativeScore.toString(),
                                  questions: e.questions
                                      .map(
                                        (v) => QuestionSection(
                                          reason: v.reason,
                                            id: v.id,
                                            answer: v.answer,
                                            matchOptions: v.matchOption,
                                            negativeScore:
                                                v.negativeScore.toString(),
                                            question: v.question,
                                            options: v.options,
                                            questionType: v.questionType,
                                            totalMarks: v.totalMarks,
                                            negativeMarks: v.negativeMarks,
                                            optionsType: v.optionType,
                                            duration: v.duration,
                                            // e.questions.fold(
                                            //     0,
                                            //     (previousValue, element) =>
                                            //         previousValue + element.totalMarks),
                                            ),
                                      )
                                      .toList(),
                                  options: e.options,
                                  question: e.question,
                                  optionsType: e.optionType,
                                  questionType: e.questionType,
                                  totalMarks: e.totalMarks,
                          negativeMarks: e.negativeMarks
                                ))
                            .toList();
                    print(widget.questionPaper.section[0].information +
                        ' - section-information');
                    widget.questionPaper.section.forEach((element) {
                      element.section.forEach((element2) {
                        log(element2.totalMarks.toString());
                      });
                    });
                    Navigator.of(context).push(
                      createRoute(
                        pageWidget: SelectQuestionPaper3(widget.questionPaper),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 60,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kBlackColor,
                          ),
                        ),
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





  // static TeXViewWidget _teXViewWidget(String title, String body) {
  //   return TeXViewColumn(
  //       style: const TeXViewStyle(
  //           margin: TeXViewMargin.all(10),
  //           padding: TeXViewPadding.all(10),
  //           borderRadius: TeXViewBorderRadius.all(10),
  //           border: TeXViewBorder.all(TeXViewBorderDecoration(
  //               borderWidth: 2,
  //               borderStyle: TeXViewBorderStyle.groove,
  //               borderColor: Colors.green))),
  //       children: [
  //         TeXViewDocument(title,
  //             style: const TeXViewStyle(
  //                 padding: TeXViewPadding.all(10),
  //                 borderRadius: TeXViewBorderRadius.all(10),
  //                 textAlign: TeXViewTextAlign.center,
  //                 width: 250,
  //                 margin: TeXViewMargin.zeroAuto(),
  //                 backgroundColor: Colors.green)),
  //         TeXViewDocument(body,
  //
  //             style: const TeXViewStyle(margin: TeXViewMargin.only(top: 10)),)
  //       ]);
  // }

  createComprehensionQuestion({int itemCount,QuestionPaper paper,int mainIndex,AudioManager audio}){
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

    return ListView.builder(
      controller: controller,
      shrinkWrap: true,
      itemCount:itemCount,
      physics: BouncingScrollPhysics(),
      clipBehavior: Clip.hardEdge,
      itemBuilder: (BuildContext context, int index) {
        var section = paper.section[0].section;
        return Padding(
          padding: EdgeInsets.only(
            top: 10,
            // left: MediaQuery.of(context).size.width * 0.01,
            // right: MediaQuery.of(context).size.width * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(checkQuestionType(section[mainIndex].questions[index].questionType.first), style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kGreyColor),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "C ${index + 1}",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kBlackColor),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.73,
                    child: Html(
                        data:
                        section[mainIndex].questions != null
                            ? section[mainIndex].questions[index].question.first
                            : ''),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(0xffFFC30A),
                        size: 18,
                      ),
                      Text(
                          '${section[mainIndex].questions[index].totalMarks ?? 0}'),
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
                        for (var i in section[mainIndex].questions[index].matchOptions.column1)
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
                        for (var i in section[mainIndex].questions[index].matchOptions.column2)
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
                        for (var i in section[mainIndex].questions[index].matchOptions.column3)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(80),
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
              // if(section[mainIndex].questions[index].questionType.first.toLowerCase() != 'fillintheblanks' && section[mainIndex].questions[index].questionType.first.toLowerCase() != 'numericalrange' )
                if (section[mainIndex].questions[index].options != null)
                for (int j = 0; j < section[mainIndex].questions[index].options.length; j++)
                  if (section[mainIndex].questions[index].options[j].value != null)
                    buildOptionsWidget(context, section[mainIndex].questions[index].options[j],
                        prefix: bulletin[j], audioManager: audio,answer: section[mainIndex].questions[index].answer),

              // if (widget.answer != null)
              //   buildCorrectAnswer1(context, widget.answer, widget.audio,
              //     isComprehension: true,
              //     index: index,
              //     // correctOrNot: answerDetails[index].correctOrNot
              //   ),
              // if (widget.questionPaper != null)
              //   correctAnswerDuringCreation(context,
              //       audio: audio,
              //       mainIndex: mainIndex,
              //       isComprehension: true,
              //       index: index),
              // if (section[mainIndex].questions[index].questionType.first !=
              //     'comprehension' &&
              //     section[mainIndex].questions[index].questionType.first !=
              //         'freeText')
              // correctAnswerDuringCreation(mainIndex: mainIndex,audio: audio,index: index,isComprehension: true,questionSection: section  )
            ],
          ),
        );
      },
    );
  }

  String checkQuestionType(String first) {
    switch (first) {
      case 'None':
        return 'None';
        break;
      case "mcq":
        return "MCQ";
        break;
      case "twoColMtf":
        return "Two Column Matching";
        break;
      case "objectives":
        return "Objective";
        break;
      case "fillInTheBlanks":
        return "Fill In The Blanks";
        break;
      case "threeColMtf":
        return "Three Column Matching";
        break;
      case "trueOrFalse":
        return "True Or False";
        break;
      case "freeText":
        return "Free Text";
        break;
      case "NumericalRange":
        return "Numerical Range";
        break;
      case "comprehension":
        return "Comprehension";
        break;
      case 'optionLevelScoring':
        return 'Option Level Scoring';
        break;
      case '3colOptionLevelScoring':
        return 'Three Column Option Level';
        break;
      default:
        return "None";
    }
  }
  // Widget correctAnswerDuringCreation(
  //     {
  //       int mainIndex,
  //       AudioManager audio,
  //       bool isComprehension,
  //       int index,
  //       List<QuestionSection> questionSection,
  //
  //     }) {
  //   if (isComprehension) {
  //     return AnswerOptions(
  //         context,
  //         questionSection[mainIndex].questions[index].answer,
  //         'Correct Answer',
  //         isAnswerByStudent: false);
  //   } else {
  //     return AnswerOptions(
  //         context, questionSection[index].answer, 'Correct Answer',
  //         isAnswerByStudent: false);
  //   }
  // }
}
