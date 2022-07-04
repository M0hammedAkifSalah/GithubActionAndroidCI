import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

import '/export.dart';
import '/view/test-module/test-result.dart';

class TestEvaluateWidget extends StatefulWidget {
  final QuestionPaper questionPaper;


  TestEvaluateWidget({this.questionPaper});

  @override
  State<TestEvaluateWidget> createState() => _TestEvaluateWidgetState();
}

class _TestEvaluateWidgetState extends State<TestEvaluateWidget> {

  final testPagingController1 =
  PagingController<int, QuestionPaperAnswer>(firstPageKey: 0);



  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await BlocProvider.of<QuestionAnswerCubit>(context)
          .getAllSubmittedAnswer(widget.questionPaper.id, pageKey, 5);
      final isLastPage = newItems.length < 5;
      if (isLastPage) {
        testPagingController1.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        testPagingController1.appendPage(newItems, nextPageKey);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: 60,
          // width: 100,
          margin: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.questionPaper.questionTitle}',
                      style: buildTextStyle(),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                width: 50,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/points.png',
                        height: 20,
                        width: 20,
                      ),
                    ),
                    Text('${widget.questionPaper.coin}'),
                  ],
                ),
              ),
              Container(
                height: 60,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: SvgPicture.asset(
                        'assets/svg/trophy.svg',
                        height: 20,
                        width: 20,
                      ),
                    ),
                    Text('${widget.questionPaper.award}')

                  ],
                ),
              ),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LAST DATE FOR SUBMISSION',
                style: buildTextStyle(size: 15, color: Colors.grey),
              ),
              Text(
                widget.questionPaper.dueDate != null
                    ? DateFormat('d MMM').format(widget.questionPaper.dueDate) ?? ''
                    : '',
                style: buildTextStyle(),
              ),
            ],
          ),
        ),

        SizedBox(
          height: 10,
        ),
        acknowledgedByStudent(context),
      ],
    );
  }

  Widget acknowledgedByStudent(BuildContext context) {
    return Container(
      color: Color(0xffEEFFF5),
      height: MediaQuery.of(context).size.height * 0.60,
      child: PagedListView<int, QuestionPaperAnswer>(
        pagingController: testPagingController1,
        builderDelegate: PagedChildBuilderDelegate<QuestionPaperAnswer>(
          itemBuilder: (context, item, index)
          {
            return ListTile(
              title: Text(
                item.createdBy,
                style: buildTextStyle(
                  size: 16,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  createRoute(
                    pageWidget: BlocProvider(
                      create: (context) =>
                          SubmitMarksCubit()..initiateFreeTextEvaluation(),
                      child: TestResultPage(
                        questionPaper: widget.questionPaper,
                        questionPaperAnswer: item,
                      ),
                    ),
                  ),
                );
              },
              leading: TeacherProfileAvatar(
                imageUrl: ' ' ?? 'text',
              ),
              subtitle: Text(item.rank == 1
                  ? '1st'
                  : item.rank == 2
                      ? '2nd'
                      : item.rank == 3
                          ? '3rd'
                          : ''),
              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.13,
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/trophy.svg',
                      height: 20,
                      width: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('${item.marksObtained}'),
                  ],
                ),
              ),
            );
          },
          newPageProgressIndicatorBuilder: (context) => loadingBar,
          firstPageProgressIndicatorBuilder: (context) => loadingBar,
        ),

      ) ,

    );
  }

  @override
  void initState() {
    super.initState();
    testPagingController1.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }
}
