import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growonplus_teacher/extensions/extension.dart';
import 'package:growonplus_teacher/model/class-schedule.dart';
import 'package:growonplus_teacher/view/test-module/practice.dart';
import 'package:growonplus_teacher/view/test-module/practice3.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/test-model.dart';
import '/bloc/test-module/test-module-cubit.dart';
import '/bloc/test-module/test-module-states.dart';
import '/extensions/utils.dart';
import '/loader.dart';
import '../../const.dart';
import 'constants.dart';

class QuestionPaperPage extends StatefulWidget {
  @override
  _QuestionPaperPageState createState() => _QuestionPaperPageState();
}

class _QuestionPaperPageState extends State<QuestionPaperPage> {
  Subjects _subject;
  SchoolClassDetails _class;
  bool user = true;
  TextEditingController textController = TextEditingController();

  bool subject = false;

  FocusNode focusNode = FocusNode();

  final testPagingController1 =
  PagingController<int, QuestionPaper>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    testPagingController1.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await BlocProvider.of<QuestionPaperCubit>(context)
          .loadAllQuestionPapers(
        searchText: textController.text.toString(),
        isEvaluate: user,
        limit: 5,
        page: pageKey,
        classId: _class != null ? _class.classId: null,
        subject: _subject != null ? _subject.id : null
      );
      final isLastPage = newItems.length < 5;
      if (isLastPage) {
        testPagingController1.appendLastPage(newItems);
      } else {

        final nextPageKey = pageKey + 1;
        testPagingController1.appendPage(newItems, nextPageKey);
      }
    }catch(e){
      log(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        primary: true,
        backgroundColor: kLightColor,
        title: Text(
          "QUESTION PAPERS",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: kDarkColor),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.04,
                top: MediaQuery.of(context).size.height * 0.008,
                bottom: MediaQuery.of(context).size.height * 0.008),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: kGreyColor, width: 0.5),
                  borderRadius: BorderRadius.circular(25.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.person),
                    color: user ? kPrimaryColor : kGreyColor,
                    onPressed: () {
                      user = true;
                      setState(() {});
                      testPagingController1.refresh();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: VerticalDivider(color: Colors.black, thickness: 1),
                  ),
                  IconButton(
                    icon: Icon(Icons.group),
                    color: !user ? kPrimaryColor : kGreyColor,
                    onPressed: () {
                      user = false;
                      setState(() {});
                      testPagingController1.refresh();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: InkWell(
        // shape: RoundedRectangleBorder(),
        onTap: () {
          Navigator.of(context).push(createRoute(
              pageWidget: MultiBlocProvider(providers: [
            BlocProvider(
                create: (context) =>
                    QuestionCategoryCubit()..getAllQuestionCategory()),
            BlocProvider(
                create: (context) =>
                    LearningOutcomeCubit()..getLearningOutcome()),
          ], child: PracticeQuestionPaper())));
        },
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xffF1F5FB),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 3,
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SvgPicture.asset('assets/svg/question.svg'),
              const Text(
                "Create A New",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kBlackColor),
              ),
              const Text(
                "Question Paper",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kBlackColor),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
          Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            focusNode: focusNode,
            controller: textController,
            style: const TextStyle(fontSize: 13),
            onChanged: (value) {
              setState(() {});
              testPagingController1.refresh();

              if(value.isEmpty)
                focusNode.unfocus();
            },
            onSubmitted: (val){
              setState(() {});
              testPagingController1.refresh();
            },
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color(0xffc4c4c4),
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color(0xffc4c4c4),
                    )),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                contentPadding:
                const EdgeInsets.only(top: 6, bottom: 6, left: 8),
                suffixIcon: textController.text != ""
                    ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {});
                      if(focusNode.hasFocus)
                        focusNode.unfocus();
                      textController.clear();
                      // _textEditingControllerStudent.sink.add(null);
                      testPagingController1.refresh();
                    })
                    : const Icon(
                  Icons.search,
                  size: 22,
                ),
                labelText: 'search Name',
                labelStyle:
                const TextStyle(fontSize: 11, color: Colors.grey),
                hintText: 'search Name',
                hintStyle:
                const TextStyle(fontSize: 11, color: Colors.grey),
                fillColor: Colors.white70),
          ),

        ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.centerRight,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // if (selectedOption != null && !subject)
                     classDropDown(context),
                    // classDropDown1(context),
                    if (subject) subjectDropDown(context),
                    // if (filter)
                    //   IconButton(
                    //     color: Colors.red,
                    //     onPressed: () {
                    //       classdrop = true;
                    //       setState(() {});
                    //     },
                    //     alignment: Alignment.centerRight,
                    //     icon: Icon(Icons.filter_list),
                    //     iconSize: 36,
                    //   ),
                    // PopupMenuButton(
                    //   // value: selectedOption,
                    //   // isExpanded: false,
                    //   // underline: Container(
                    //   //   height: 0,
                    //   //   width: 0,
                    //   // ),
                    //   onSelected: (value) {
                    //     selectedOption = value;
                    //     if (value == 'class') {
                    //       subject = false;
                    //     }
                    //     setState(() {});
                    //   },
                    //   itemBuilder: (context) {
                    //     return [
                    //       PopupMenuItem(
                    //         value: 'class',
                    //         child: Text('By class'),
                    //       ),
                    //       PopupMenuItem(
                    //         value: 'subject',
                    //         child: Text('By Subject'),
                    //       ),
                    //     ];
                    //   },
                    //   icon: Icon(
                    //     Icons.filter_list,
                    //     color: Colors.red,
                    //     size: 36,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: PagedListView<int, QuestionPaper>(
                    pagingController: testPagingController1,
                    builderDelegate: PagedChildBuilderDelegate<QuestionPaper>(
                      itemBuilder: (context, item, index) => buildInkWell(context,item),
                    ))
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildInkWell(
      BuildContext context,QuestionPaper paper) {
    return InkWell(
      onTap: () {
        paper.isCreated = true;
        Navigator.of(context).push(
          createRoute(
              pageWidget: SelectQuestionPaper3(paper)),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            bottom: 8),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          //height: 140,
          decoration: BoxDecoration(
              color: kLightColor, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
                right: MediaQuery.of(context).size.width * 0.03,
                bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: kDarkColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              paper.className,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: kWhiteColor),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(),
                        child: Center(
                          child: Text(
                            "#${paper.qid}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  paper.questionTitle,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kBlackColor),
                ),
                Text(
                  'Total Question - ${paper.detailQuestionPaper.totalQuestion}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: kBlackColor),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: kPrimaryColor,
                            ),
                            Text(
                              '${paper.createdBy}',
                              style:
                                  TextStyle(color: kPrimaryColor, fontSize: 13),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              paper.createdAt
                                  .toDateTimeFormat(context),
                              //  DateFormat('d MMM HH:mm').format(state.questionPaper[index].updatedAt)

                              // "Used - 23 times",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              // "Last Used - 29 days ago",
                              '',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kBlackColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column classDropDown(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Class/Grade",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        const SizedBox(height: 2),
        Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(color: kGreyColor, width: 1),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                  ),
                  child:
                      BlocBuilder<TestModuleClassCubit, TestModuleClassStates>(
                          builder: (context, state) {
                    if (state is TestClassesLoaded) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<SchoolClassDetails>(
                          onTap: () {
                            _subject = null;
                          },
                          focusColor: Colors.white,
                          value: _class,
                          //elevation: 5,
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.black,
                          items: (state.classDetails.isEmpty
                                  ? [SchoolClassDetails(className: 'No Class')]
                                  : state.classDetails)
                              .map<DropdownMenuItem<SchoolClassDetails>>(
                                  (SchoolClassDetails value) {
                            return DropdownMenuItem<SchoolClassDetails>(
                              value: value,
                              child: Text(
                                value.className ?? 'class',
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                          hint: const Text(
                            "Class",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: kBlackColor),
                          ),
                          onChanged: (SchoolClassDetails value) {
                            setState(() {
                              _class = value;
                              // if (selectedOption == 'subject') {
                              //   selectedOption = 'subject';
                              subject = true;
                              // log('class id '+_class.classId);
                              // _subject = Subjects(id: '',name: 'No Subject');
                              // }
                            });
                            BlocProvider.of<TestModuleSubjectCubit>(context)
                                .loadAllSubjects(
                                    _class == null ? '' : _class.classId);
                            //  } else {
                           testPagingController1.refresh();
                          },
                        ),
                      );
                    } else {
                      BlocProvider.of<TestModuleClassCubit>(context)
                          .loadAllClasses();

                      return Container(
                        child: loadingBar,
                      );
                    }
                  }),
                ),
              ),
            ))
      ],
    );
  }

  Column subjectDropDown(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Subject",
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
        ),
        const SizedBox(height: 2),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 42,
          decoration: BoxDecoration(
              border: Border.all(color: kGreyColor, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.03,
                ),
                child: BlocBuilder<TestModuleSubjectCubit,
                    TestModuleSubjectStates>(builder: (context, state) {
                  if (state is TestModuleSubjectLoaded) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<Subjects>(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                        },
                        focusColor: Colors.white,
                        isExpanded: true,
                        value: _subject,
                        //elevation: 5,
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: (state.subjects.isEmpty
                                ? [Subjects(name: 'No Subject present')]
                                : state.subjects)
                            .map<DropdownMenuItem<Subjects>>((Subjects value) {
                          return DropdownMenuItem<Subjects>(
                            value: value,
                            child: Text(
                              value.name,
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: const Text(
                          "Subject",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor,
                          ),
                        ),
                        onChanged: (Subjects value) {
                          if (state.subjects.isNotEmpty) {
                            setState(() {
                              _subject = value;
                            });
                           testPagingController1.refresh();
                          }
                        },
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

// Column subjectDropDown(BuildContext context) {
//   return Column(
//     children: [
//       Text(
//         "Subject",
//         style: TextStyle(
//             fontSize: 14, fontWeight: FontWeight.w400, color: kGreyColor),
//       ),
//       SizedBox(
//         height: 2,
//       ),
//       Container(
//         width: MediaQuery.of(context).size.width * 0.4,
//         height: 35,
//         decoration: BoxDecoration(
//             border: Border.all(color: kGreyColor, width: 1),
//             borderRadius: BorderRadius.circular(5)),
//         child: Center(
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.35,
//             alignment: Alignment.center,
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: MediaQuery.of(context).size.width * 0.03,
//               ),
//               child: BlocBuilder<TestModuleSubjectCubit,
//                   TestModuleSubjectStates>(builder: (context, state) {
//                 if (state is TestModuleSubjectLoaded) {
//                   log('Entered');
//                   return DropdownButton<Subjects>(
//                     focusColor: Colors.white,
//                     isExpanded: true,
//                     value:
//                     _subject ??
//                         Subjects(name: 'No Subject Present'),
//                     //elevation: 5,
//                     style: TextStyle(color: Colors.white),
//                     iconEnabledColor: Colors.black,
//                     items: (state.subjects.isEmpty
//                             ? [Subjects(name: 'No Subject present',id: '')]
//                             : state.subjects)
//                         .map<DropdownMenuItem<Subjects>>((Subjects value) {
//                       return DropdownMenuItem<Subjects>(
//                         value: value??Subjects(name: 'No Subject Present'),
//                         child: Text(
//                           value.name ?? 'No Subject Present',
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       );
//                     }).toList(),
//                     hint: const Text(
//                       "Subject",
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w400,
//                         color: kBlackColor,
//                       ),
//                     ),
//                     onChanged: (Subjects value) {
//                       if (state.subjects.isNotEmpty) {
//                         setState(() {
//                           _subject = value;
//                         });
//                         BlocProvider.of<QuestionPaperCubit>(context)
//                             .emit(QuestionPaperLoading());
//                         BlocProvider.of<QuestionPaperCubit>(context)
//                             .loadAllQuestionPapers(data: {
//                           "class_id": _class.classId,
//                           "detail_question_paper.subject": _subject.id,
//                         });
//                       }
//                     },
//                   );
//
//                 }
//                 if(state is TestModuleNoSubjects)
//                   {
//                     return Container();
//                   }
//                 else {
//                   return Container();
//                 }
//               }),
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
}
