
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rxdart/rxdart.dart';
import '../../model/InstituteSessionModel.dart';
import 'institute_session.dart';

typedef OnSessionClickedHandler(ReceivedSession session);

class ActivityFeedListing extends StatefulWidget {
  // final OnActivityClickedHandler onActivityClickedHandler;
  final BehaviorSubject<String> activityTypeController;
  // final BehaviorSubject<List<String>> activityAssignToStatusController;
  // final BehaviorSubject<String> publishedWithController;
  // final BehaviorSubject<String> searchController;
  // // final PagingController<int, Activity> activityPagingController;
  // final BuildContext homeContext;

  // final PagingController<int, ReceivedSession> activityPagingController;
  // final BuildContext homeContext;
  // final String schoolId;
  // final String instituteId;
  // final BehaviorSubject<String> searchController;
  // final String teacherId;
  // final bool isToday;

  final PagingController<int, ReceivedSession> sessionPagingController;
  final BehaviorSubject<String> searchController;
  final BuildContext homeContext;
  final bool isFuture;
  final UserInfo user;
  final OnSessionClickedHandler onSessionClickedHandler;
  

  ActivityFeedListing({this.sessionPagingController, this.homeContext,
      // this.schoolId, this.instituteId,
    this.searchController,
    // this.teacherId,
    this.activityTypeController,
    // this.isToday
    this.isFuture=false,
    this.user,
    this.onSessionClickedHandler,
  });

  @override
  _ActivityFeedListingState createState() => _ActivityFeedListingState();
}

class _ActivityFeedListingState extends State<ActivityFeedListing> {
  static const _pageSize = 5;

  @override
  void initState() {
    super.initState();
    widget.sessionPagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    // try {

    final newItems = await BlocProvider.of<SessionCubit>(widget.homeContext)
        .displaySessionForFuture(
      searchKey: widget.searchController?.valueOrNull,
        instituteId: widget.user.schoolId.institute.id,
        pageKey: pageKey,
        pageSize: _pageSize,
        schoolId: widget.user.schoolId.id,
        teacherId: widget.user.id,
        isFuture: widget.isFuture,
        isDaily: widget.activityTypeController != null ? widget.activityTypeController.valueOrNull == 'daily' ? 'yes' : 'no':'no',
        isWeekly: widget.activityTypeController != null ? widget.activityTypeController.valueOrNull == 'weekly' ? 'yes' : 'no' : 'no',
        // widget.searchController?.valueOrNull,
        // pageKey, _pageSize, widget.isFuture
    );
    final isLastPage = newItems.length < _pageSize;
    if (isLastPage) {
      widget.sessionPagingController.appendLastPage(newItems);
    } else {
      final nextPageKey = pageKey + 1;
      widget.sessionPagingController.appendPage(newItems, nextPageKey);
    }
    // } catch (error) {
    //   widget.activityPagingController.error = error;
    // }

  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 15.0, left: 9.0, right: 9.0),
      sliver: PagedSliverList<int, ReceivedSession>(
          pagingController: widget.sessionPagingController,
          builderDelegate: PagedChildBuilderDelegate<ReceivedSession>(
            itemBuilder: (context, item, index) => InstituteSession(
              user: widget.user,
              session: item,
              onTaskClickHandler: (){
                widget.onSessionClickedHandler(
                    item);
              },
            ),
            noItemsFoundIndicatorBuilder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.45,
              alignment: Alignment.topCenter,
              // padding: const EdgeInsets.only(top: 100),
              child: Center(child: const Text("No session found")),
            ),
            noMoreItemsIndicatorBuilder: (context) => Container(),
            firstPageErrorIndicatorBuilder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 50.0),
              child: const Text("First Page Error"),
            ),
            newPageErrorIndicatorBuilder: (context) => Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 50.0),
              child: const Text("New Page Error"),
            ),
            newPageProgressIndicatorBuilder: (context) => loadingBar,
            firstPageProgressIndicatorBuilder: (context) => loadingBar,
          ),
      ),
    );
    // : item.activityCategory == ActivityType.Test,

    //     ? Padding(
    //   padding: const EdgeInsets.only(
    //       top: 15, left: 9, right: 9),
    //   child: Container(),
    // )
    //     : item.activityCategory == ActivityType.Assignment
    //     ? Padding(
    //   padding: const EdgeInsets.only(
    //       top: 15, left: 9, right: 9),
    //   child: Assignment(
    //     context,
    //     activity: item,
    //     onTaskClickHandler: () {
    //       widget.onActivityClickedHandler(item);
    //     },
    //     isDoubt: true,
    //   ),
    // )
    //     : item.activityCategory == ActivityType.CheckList
    //     ? Padding(
    //   padding: const EdgeInsets.only(
    //       top: 15, left: 9, right: 9),
    //   child: CheckListTodo(
    //     context,
    //     activity: item,
    //     onTaskClickHandler: () {
    //       widget.onActivityClickedHandler(item);
    //     },
    //     isDoubt: true,
    //   ),
    // )
    //     : item.activityCategory ==
    //     ActivityType.livePollSubmitted
    //     ? Padding(
    //   padding: const EdgeInsets.only(
    //       top: 15, left: 9, right: 9),
    //   child: LivePollSubmitted(
    //     context,
    //     activity: item,
    //     onTaskClickHandler: () {
    //       widget
    //           .onActivityClickedHandler(item);
    //     },
    //     isDoubt: true,
    //   ),
    // )
    //     : Container(),
    // noItemsFoundIndicatorBuilder: (context) => Container(
    //   height: MediaQuery.of(context).size.height,
    //   alignment: Alignment.topCenter,
    //   padding: const EdgeInsets.only(top: 50.0),
    //   child: Text("No activities found."),
    // ),
    // noMoreItemsIndicatorBuilder: (context) => Container(),
    // firstPageErrorIndicatorBuilder: (context) => Container(
    //   height: MediaQuery.of(context).size.height,
    //   alignment: Alignment.topCenter,
    //   padding: const EdgeInsets.only(top: 50.0),
    //   child: Text("First Page Error"),
    // ),
    // newPageErrorIndicatorBuilder: (context) => Container(
    //   height: MediaQuery.of(context).size.height,
    //   alignment: Alignment.topCenter,
    //   padding: const EdgeInsets.only(top: 50.0),
    //   child: Text("New Page Error"),
    // ),
    // newPageProgressIndicatorBuilder: (context) => loadingBar,
    // firstPageProgressIndicatorBuilder: (context) => loadingBar,
    //   ),
    // );
  }
}
