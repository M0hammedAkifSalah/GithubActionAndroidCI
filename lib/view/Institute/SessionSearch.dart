import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';
import 'package:growonplus_teacher/view/Institute/activity_feed_listing.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../take_action/take-action.dart';
import 'institute_homepage.dart';

PanelController searchTakeActionPanelController = PanelController();

class SessionSearch extends StatefulWidget {
  const SessionSearch({Key key, this.user}) : super(key: key);

  final UserInfo user;

  @override
  State<SessionSearch> createState() => _SessionSearchState();
}

class _SessionSearchState extends State<SessionSearch> with TickerProviderStateMixin {
  final sessionPagingController = PagingController<int, ReceivedSession>(firstPageKey: 1);
  BehaviorSubject<String> searchController = BehaviorSubject<String>();
  TextEditingController searchTextController = TextEditingController();
  BehaviorSubject<String> activityTypeController =
  BehaviorSubject<String>();

  Timer _debounce;
  FocusNode focusNode = FocusNode();
  TabController activityTypeTabController;
  var activityStatusTabColor;
  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    activityTypeTabController =
        TabController(length: 3, vsync: this, initialIndex: 0);
    activityStatusTabColor = const Color(0xffBB6BD9);
  }

  @override
  void dispose() {
    searchController.close();
    activityTypeTabController.dispose();
    activityTypeController.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: NotificationListener(
          onNotification: (scrollState) {
            if (scrollState is ScrollStartNotification) {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
                currentFocus.focusedChild.unfocus();
              }
            }
            return true;
          },
          child:
              // SlidingUpPanel(
              //       defaultPanelState: PanelState.CLOSED,
              //       controller: homeTakeActionPanelController,
              //       minHeight: 0,
              //       onPanelOpened: () {},
              //       maxHeight: 140,
              //       borderRadius: const BorderRadius.vertical(
              //           top: Radius.circular(12)),
              //       backdropEnabled: true,
              //       panel: TakeActionPanel(context, user: widget.user,
              //           activityPagingController1: sessionPagingController),
              //   body:
              Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    iconTheme: IconThemeData(color: Colors.black),
                    elevation: 0,
                    // pinned: true,
                    floating: true,
                    titleSpacing: -10,
                    title: Container(
                      height: 36.0,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextField(
                        focusNode: focusNode,
                        controller: searchTextController,
                        style: const TextStyle(fontSize: 13),
                        onChanged: (value) {
                          setState(() {});
                          if (_debounce?.isActive ?? false) _debounce.cancel();
                          _debounce = Timer(const Duration(microseconds: 1000), () {
                            String previousSearchText = searchController.valueOrNull;
                            String searchText = value.isEmpty ? null : value;
                            if (previousSearchText != searchText) {
                              searchController.sink.add(searchText);
                              sessionPagingController.refresh();
                            }
                          });
                        },
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
                            suffixIcon: searchTextController.text != ""
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {});
                                      searchTextController.clear();
                                      searchController.sink.add(null);
                                      sessionPagingController.refresh();
                                    })
                                : const Icon(
                                    Icons.search,
                                    size: 22,
                                  ),
                            labelText: 'search title',
                            labelStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                            hintText: 'search title',
                            hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                            fillColor: Colors.white70),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: buildActivityStatusBar(),
                  ),
                  ActivityFeedListing(
                    onSessionClickedHandler: (session) {
                      handleActivityClick(session);
                    },
                    searchController: searchController,
                    homeContext: context,
                    sessionPagingController: sessionPagingController,
                    isFuture: false,
                    user: widget.user,
                    activityTypeController: activityTypeController,
                  ),
                ],
              ),
              SlidingUpPanel(
                defaultPanelState: PanelState.CLOSED,
                controller: searchTakeActionPanelController,
                minHeight: 0,
                onPanelOpened: () {
                  BlocProvider.of<SessionCubit>(context)
                      .displaySessionForToday(
                    schoolId: widget.user != null
                        ? widget.user.schoolId.id
                        : null,
                    instituteId: widget.user != null
                        ? widget.user.schoolId.institute.id
                        : null,
                  );
                },
                maxHeight: 140,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                backdropEnabled: true,
                panel: TakeActionPanel(context,
                    user: widget.user,
                    activityPagingController1: sessionPagingController),
              ),
            ],
          ),
          // ),
        ),
      ),
    );
  }

  buildActivityStatusBar() {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 10,
          bottom: 10,
        ),
        child: Container(
          height: 32,
          child: TabBar(
            physics: const BouncingScrollPhysics(),
            isScrollable: true,
            indicatorWeight: 0,
            controller: activityTypeTabController,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 5),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: activityStatusTabColor,
            ),
            onTap: (index) {
              searchController.sink.add(null);
              searchTextController.clear();
              Color selectedColor;
              switch (index) {
                case 0:
                  // selectedColor = const Color(0xffBB6BD9);
                  activityTypeController.sink.add("all");

                  break;
                case 1:
                  // selectedColor = const Color(0xff9B51E0);
                  activityTypeController.sink.add("daily");
                  break;
                  case 2:
                  // selectedColor = const Color(0xff9B51E0);
                    activityTypeController.sink.add("weekly");
                  break;
              }
              setState(() {
                activityStatusTabColor = Color(0xff9B51E0);
              });

              sessionPagingController.refresh();
            },
            tabs: [
              Tab(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                    Border.all(color: const Color(0xff9B51E0), width: 1),
                  ),
                  child: Text(
                    "All",
                    style: TextStyle(
                        color: activityTypeTabController.index == 0
                            ? const Color(0xffffffff)
                            : const Color(0xff9B51E0),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                    Border.all(color: const Color(0xff9B51E0), width: 1),
                  ),
                  child: Text(
                    "Daily",
                    style: TextStyle(
                        color: activityTypeTabController.index == 1
                            ? const Color(0xffffffff)
                            : const Color(0xff9B51E0),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border:
                    Border.all(color:const Color(0xff9B51E0), width: 1),
                  ),
                  child: Text(
                    "Weekly",
                    style: TextStyle(
                        color: activityTypeTabController.index == 2
                            ? const Color(0xffffffff)
                            : const Color(0xff9B51E0),
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleActivityClick(ReceivedSession session, {List<ReceivedSession> sessionList}) {
    if (widget.user.isAuthorized) {
      BlocProvider.of<TakeActionCubit>(context).initializeTakeAction(session);
      searchTakeActionPanelController.open();
    }
  }
}
