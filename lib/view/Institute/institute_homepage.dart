import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growonplus_teacher/bloc/Institute/institute-cubit.dart';
import 'package:growonplus_teacher/bloc/Institute/institute-states.dart';
import 'package:growonplus_teacher/model/InstituteSessionModel.dart';
import 'package:growonplus_teacher/model/user.dart';
import 'package:growonplus_teacher/view/Institute/institute_session.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../bloc/take-action/take-action-cubit.dart';
import '../../const.dart';
import '../../extensions/utils.dart';
import '../../loader.dart';
import '../take_action/take-action.dart';
import 'InstituteCreateSession.dart';
import 'SessionSearch.dart';
import 'activity_feed_listing.dart';
import 'institute_silver_appbar.dart';

PanelController homeTakeActionPanelController = PanelController();

class InstituteHomePage extends StatefulWidget {
  const InstituteHomePage({Key key, this.user}) : super(key: key);

  final UserInfo user;

  @override
  _InstituteHomePageState createState() => _InstituteHomePageState();
}

class _InstituteHomePageState extends State<InstituteHomePage>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  Function searchbarState;

  TabController _tab;
  Timer _debounce;
  bool panelOpen = false;
  TextEditingController searchTextController = TextEditingController();
  BehaviorSubject<String> searchController = BehaviorSubject<String>();
  PanelController addTaskPanelController = PanelController();


  PagingController<int, ReceivedSession> activityPagingController1 =
  PagingController<int, ReceivedSession>(firstPageKey: 1);
  BehaviorSubject<List<String>> activityAssignToStatusController =
  BehaviorSubject<List<String>>()
    ..add(["Pending", "Partially Pending"]);
  BehaviorSubject<List<String>> activityTypeController =
  BehaviorSubject<List<String>>();


  bool showMore = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    searchController.drain();
    activityTypeController.drain();
    activityAssignToStatusController.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {},
        child: Container(
          color: const Color(0xfff0f2f5),
          child: Stack(
            children: [
              Container(
                color: const Color(0xfff0f2f5),
                child: NotificationListener(
                  onNotification: (scrollState) {
                    if (scrollState is ScrollStartNotification) {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        currentFocus.focusedChild.unfocus();
                      }
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    displacement: 250,
                    onRefresh: () async {
                      BlocProvider.of<SessionCubit>(context)
                          .displaySessionForToday(
                        schoolId: widget.user != null
                            ? widget.user.schoolId.id
                            : null,
                        instituteId: widget.user != null
                            ? widget.user.schoolId.institute.id
                            : null,
                      );
                      activityPagingController1.refresh();
                    },
                    child: CustomScrollView(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      slivers: [
                        SliverAppBar(
                          elevation: 0,
                          pinned: true,
                          floating: true,
                          automaticallyImplyLeading: false,
                          expandedHeight: 150,
                          // expandedHeight: 200,
                          flexibleSpace: FlexibleSpaceBar(
                            background:
                            InstituteSilverAppbar(user: widget.user),
                          ),
                          bottom: PreferredSize(
                            // preferredSize: Size.fromHeight(90),
                            preferredSize: Size.fromHeight(40),

                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: [
                                // buildProgressNew(),
                                // buildActivityStatusBar(),
                                buildSearchBar(),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 100,
                                height: 30,
                                alignment: Alignment.center,
                                decoration: const ShapeDecoration(
                                  color: Color(0xffebebeb),
                                  shape: StadiumBorder(),
                                ),
                                child: const Text(
                                  "Today",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                      fontSize: 15.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<SessionCubit, DisplaySessionStates>(
                            builder: (context, state) {
                              if (state is SessionLoading) {
                                return SliverToBoxAdapter(
                                  child: loadingBar,
                                );
                              } else if (state is SessionLoaded) {
                                if (state.session.isNotEmpty) {
                                  return SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 9.0, vertical: 8.0),
                                          child: InstituteSession(
                                            user: widget.user,
                                            session: state.session[index],
                                            onTaskClickHandler: () {
                                              handleActivityClick(state.session[index]);
                                            },
                                          ),
                                        );
                                      },
                                      childCount: state.session.length,
                                    ),
                                  );
                                } else {
                                  return SliverToBoxAdapter(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 10.0),
                                      child: const Text(
                                        "No Sessions Today",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return SliverToBoxAdapter(
                                  child: Container(),
                                );
                              }
                            }),
                        BlocBuilder<SessionCubit, DisplaySessionStates>(
                            builder: (context, state) {
                              return SliverToBoxAdapter(
                                child: state is SessionLoaded && showMore
                                    ? Align(
                                  alignment: Alignment.center,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showMore = false;
                                      });
                                    },
                                    child: const Text(
                                      "Show More",
                                    ),
                                  ),
                                )
                                    : Container(),
                              );
                            }),
                        if (!showMore)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 100,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: const ShapeDecoration(
                                    color: Color(0xffebebeb),
                                    shape: StadiumBorder(),
                                  ),
                                  child: const Text(
                                    "Tomorrow",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                        fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (!showMore)
                          ActivityFeedListing(
                            homeContext: context,
                            sessionPagingController: activityPagingController1,
                            // sessionPagingController: sessionPagingController,
                            onSessionClickedHandler: (session) {
                              handleActivityClick(session);
                            },
                            isFuture: true,
                            user: widget.user,
                          ),
                        // const SliverToBoxAdapter(
                        //   child: SizedBox(
                        //     height: kFloatingActionButtonMargin + 64,
                        //   ),
                        // ),
                        // ActivityFeedListing(
                        //     activityPagingController1,
                        //     context,
                        //     widget.user.schoolId.id,
                        //     widget.user.schoolId.institute.id,
                        //     searchController,
                        //     widget.user.id,
                        //   activityTypeController,
                        //   isToday:true,
                        //
                        // ),
                        // SliverToBoxAdapter(
                        //   child: Center(child: Text('Tomorrow')),
                        // ),
                        // ActivityFeedListing(
                        //     activityPagingController2,
                        //     context,
                        //     widget.user.schoolId.id,
                        //     widget.user.schoolId.institute.id,
                        //     searchController,
                        //     widget.user.id,
                        //     activityTypeController,
                        //   isToday: false,
                        // ),

                        //ActivityFeedListing()
                        // SliverList(
                        //     delegate:
                        //         SliverChildBuilderDelegate((_, int index) {
                        //   return BlocBuilder<SessionCubit,
                        //       DisplaySessionStates>(builder: (context, state) {
                        //     if (state is SessionLoaded) {
                        //       return ActivityFeedListing(
                        //         session: state.session[index],
                        //       );
                        //     } else {
                        //       return loadingBar;
                        //     }
                        //   });
                        // }, childCount: 5)),

                        // Container(color: Colors.redAccent,)
                        //   activityPagingController,
                        //   activityTypeController,
                        //   activityAssignToStatusController,
                        //   publishedWithController,
                        //   searchController,
                        //   context,
                        //   onActivityClickedHandler: (activity) {
                        //     handleActivityClick(activity);
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SlidingUpPanel(
                defaultPanelState: PanelState.CLOSED,
                controller: homeTakeActionPanelController,
                minHeight: 0,
                onPanelOpened: () {},
                maxHeight: 140,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12)),
                backdropEnabled: true,
                panel: TakeActionPanel(context, user: widget.user,
                    activityPagingController1: activityPagingController1),
              ),

              SlidingUpPanel(
                controller: addTaskPanelController,
                defaultPanelState: PanelState.CLOSED,
                minHeight: 0,
                maxHeight: 200,
                onPanelOpened: () {
                  setState(() {
                    panelOpen = true;
                  });
                },
                onPanelClosed: () {
                  setState(() {
                    panelOpen = false;
                  });
                },
                backdropEnabled: true,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                panel: AddTaskPanel(user: widget.user),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: (widget.user.isAuthorized)
          ? panelOpen
          ? Container()
          : FloatingActionButton(
        onPressed: () {
          addTaskPanelController.open();
        },
        backgroundColor: kColor,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      )
          : Container(
        height: 0,
      ),
    );
  }

  buildProgressNew() {
    // return BlocBuilder<ProgressCubit, ProgressStates>(
    //     builder: (context, state) {
    // if (state is StudentTaskProgressLoaded) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
            child: Text(
              'Task Completion 50%',
              // 'Task Completion ${state.totalPercentage.round()}%',
              style: TextStyle(
                // color: state.totalPercentage.round() > 74
                //     ? const Color(0xff27AE60)
                //     : const Color(0xffEB5757),
                  fontWeight: FontWeight.w400,
                  fontSize: 13.0),
              textAlign: TextAlign.center,
            ),
          ),
          LinearPercentIndicator(
            lineHeight: 6.0,
            percent: 0.5,
            // percent: state.totalPercentage.round() / 100,
            padding: EdgeInsets.only(left: 0),
            // progressColor: state.totalPercentage.round() > 74
            //     ? const Color(0xff27AE60)
            //     : const Color(0xffEB5757),
            backgroundColor: Color(0xff1BC5BD).withOpacity(0.2),
          ),
        ],
      ),
    );
    // } else if (state is ParentTaskProgressLoaded) {
    //   return Container(
    //     clipBehavior: Clip.antiAlias,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.only(
    //           bottomLeft: Radius.circular(10),
    //           bottomRight: Radius.circular(10)),
    //       color: Colors.white,
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Padding(
    //           padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
    //           child: Text(
    //             'Task Completion ${state.progress.average.round()}%',
    //             style: TextStyle(
    //                 color: state.progress.average.round() > 74
    //                     ? const Color(0xff27AE60)
    //                     : const Color(0xffEB5757),
    //                 fontWeight: FontWeight.w400,
    //                 fontSize: 13.0),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //         LinearPercentIndicator(
    //           lineHeight: 6.0,
    //           percent: state.progress.average.round() / 100,
    //           padding: EdgeInsets.only(left: 0),
    //           progressColor: state.progress.average.round() > 74
    //               ? const Color(0xff27AE60)
    //               : const Color(0xffEB5757),
    //           backgroundColor: Color(0xff1BC5BD).withOpacity(0.2),
    //         ),
    //       ],
    //     ),
    //   );
    // } else
    // return Container(
    //   clipBehavior: Clip.antiAlias,
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.only(
    //         bottomLeft: Radius.circular(10),
    //         bottomRight: Radius.circular(10)),
    //   ),
    //   height: 50,
    // );
    // });
  }


  buildSearchBar() {
    return StatefulBuilder(builder: (context, setState) {
      searchbarState = setState;
      return Container(
        height: 36.0,
        color: const Color(0xfff0f2f5),
        child: Padding(
          padding:
          const EdgeInsets.only(bottom: 2, top: 2, left: 14.0, right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(
              //   width: 75.0,
              //   height: 36.0,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10.0),
              //     border: Border.all(color: Colors.grey),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       focusColor: Colors.white,
              //       value: searchFilter,
              //       style: TextStyle(color: Colors.white),
              //       iconEnabledColor: Colors.grey,
              //       icon: Icon(
              //         Icons.keyboard_arrow_down_rounded,
              //         color: Colors.grey,
              //       ),
              //       isExpanded: true,
              //       items: ["Title", "Name", "Teacher"]
              //           .map<DropdownMenuItem<String>>((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Padding(
              //             padding: const EdgeInsets.only(left: 5.0),
              //             child: Text(
              //               "$value",
              //               overflow: TextOverflow.ellipsis,
              //               softWrap: true,
              //               style:
              //                   TextStyle(color: Colors.grey, fontSize: 11.0),
              //             ),
              //           ),
              //         );
              //       }).toList(),
              //       hint: Padding(
              //         padding: const EdgeInsets.only(left: 5.0),
              //         child: Text(
              //           "Select",
              //           overflow: TextOverflow.ellipsis,
              //           softWrap: true,
              //           style: const TextStyle(
              //               color: Colors.grey,
              //               fontWeight: FontWeight.w400,
              //               fontFamily: "Poppins",
              //               fontStyle: FontStyle.normal,
              //               fontSize: 11.0),
              //         ),
              //       ),
              //       onChanged: (String value) {
              //         setState(() {
              //           searchFilter = value;
              //         });
              //       },
              //     ),
              //   ),
              // ),
              // SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (contextA) => SessionSearch(user: widget.user)));
                    },
                    child: TextField(
                      enabled: false,
                      onTap: () {

                      },
                      controller: searchTextController,
                      style: TextStyle(fontSize: 13),
                      // onChanged: (value) {
                      //   setState(() {});
                      //   if (_debounce?.isActive ?? false) _debounce.cancel();
                      //   _debounce = Timer(const Duration(microseconds: 1000), () {
                      //     String previousSearchText =
                      //         searchController.valueOrNull;
                      //     String searchText = value.isEmpty ? null : value;
                      //     if (previousSearchText != searchText) {
                      //       searchController.sink.add(searchText);
                      //       activityPagingController1.refresh();
                      //       activityPagingController2.refresh();
                      //     }
                      //   });
                      // },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20.0),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xffc4c4c4),
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(20.0),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xffc4c4c4),
                              )),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding:
                          EdgeInsets.only(top: 6, bottom: 6, left: 8),
                          suffixIcon: searchTextController.text != ""
                              ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {});
                                searchTextController.clear();
                                searchController.sink.add(null);
                                // activityPagingController.refresh();
                              })
                              : Icon(
                            Icons.search,
                            size: 22,
                          ),
                          labelText: 'search title',
                          labelStyle: TextStyle(fontSize: 11, color: Colors.grey),
                          hintText: 'search title',
                          hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
                          fillColor: Colors.white70),
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 4),
              // activityAssignToStatusController.valueOrNull.contains("Pending")
              //     ?
              //     PopupMenuButton(
              //     offset: Offset(-20, 45),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5.0)),
              //     iconSize: 36,
              //     padding: EdgeInsets.zero,
              //     icon: SvgPicture.asset(
              //       "assets/svg/menu-feed.svg",
              //       fit: BoxFit.cover,
              //     ),
              //     itemBuilder: (context) => [
              //       PopupMenuItem(
              //         enabled: false,
              //         padding: EdgeInsets.zero,
              //         child: Container(height: 50.0),
              //         // PopUpFilter(
              //         //   selectedList: pendingSelectedOptionList,
              //         //   studentActivities: [
              //         //     "All",
              //         //     "Announcement",
              //         //     "Assignment",
              //         //     "LivePoll",
              //         //     "Check List",
              //         //     "Event"
              //         //   ],
              //         //   parentActivities: [
              //         //     "All",
              //         //     "Announcement",
              //         //     "LivePoll",
              //         //     "Check List",
              //         //     "Event"
              //         //   ],
              //         //   onClear: () {
              //         //     pendingSelectedOptionList.clear();
              //         //     pendingSelectedOptionList.add("All");
              //         //     pendingSelectedList.clear();
              //         //     pendingSelectedList.addAll(
              //         //         BlocProvider.of<AppModeCubic>(context)
              //         //             .state is ParentMode
              //         //             ? [
              //         //           "Announcement",
              //         //           "LivePoll",
              //         //           "Check List",
              //         //           "Event"
              //         //         ]
              //         //             : [
              //         //           "Announcement",
              //         //           "Assignment",
              //         //           "LivePoll",
              //         //           "Check List",
              //         //           "Event"
              //         //         ]);
              //         //     activityTypeController.sink
              //         //         .add(pendingSelectedList);
              //         //     activityPagingController.refresh();
              //         //     Navigator.pop(context);
              //         //   },
              //         //   onSelected: (selected) {
              //         //     pendingSelectedOptionList.clear();
              //         //     pendingSelectedList.clear();
              //         //     if (selected.contains("All")) {
              //         //       pendingSelectedOptionList.add("All");
              //         //       pendingSelectedList.addAll(
              //         //           BlocProvider.of<AppModeCubic>(context)
              //         //               .state is ParentMode
              //         //               ? [
              //         //             "Announcement",
              //         //             "LivePoll",
              //         //             "Check List",
              //         //             "Event"
              //         //           ]
              //         //               : [
              //         //             "Announcement",
              //         //             "Assignment",
              //         //             "LivePoll",
              //         //             "Check List",
              //         //             "Event"
              //         //           ]);
              //         //     } else {
              //         //       pendingSelectedOptionList.addAll(selected);
              //         //       pendingSelectedList.addAll(selected);
              //         //     }
              //         //     activityTypeController.sink
              //         //         .add(pendingSelectedList);
              //         //     activityPagingController.refresh();
              //         //     Navigator.pop(context);
              //         //   },
              //         // ),
              //       ),
              //     ])
              //     : Container(),
              // activityAssignToStatusController.valueOrNull.contains("Submitted")
              //     ? PopupMenuButton(
              //     offset: Offset(-20, 45),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5.0)),
              //     iconSize: 36,
              //     padding: EdgeInsets.zero,
              //     icon: SvgPicture.asset(
              //       "assets/svg/menu-feed.svg",
              //       fit: BoxFit.cover,
              //     ),
              //     itemBuilder: (context) => [
              //       PopupMenuItem(
              //         enabled: false,
              //         padding: EdgeInsets.zero,
              //         child: Container(height: 50.0),
              //         // PopUpFilter(
              //         //   selectedList: submittedSelectedOptionList,
              //         //   studentActivities: [
              //         //     "All",
              //         //     "Announcement",
              //         //     "Assignment",
              //         //     "LivePoll",
              //         //     "Check List"
              //         //   ],
              //         //   parentActivities: [
              //         //     "All",
              //         //     "Announcement",
              //         //     "LivePoll",
              //         //     "Check List"
              //         //   ],
              //         //   onClear: () {
              //         //     submittedSelectedOptionList.clear();
              //         //     submittedSelectedOptionList.add("All");
              //         //     submittedSelectedList.clear();
              //         //     submittedSelectedList.addAll(
              //         //         BlocProvider.of<AppModeCubic>(context)
              //         //             .state is ParentMode
              //         //             ? [
              //         //           "Announcement",
              //         //           "LivePoll",
              //         //           "Check List"
              //         //         ]
              //         //             : [
              //         //           "Announcement",
              //         //           "Assignment",
              //         //           "LivePoll",
              //         //           "Check List"
              //         //         ]);
              //         //     activityTypeController.sink
              //         //         .add(submittedSelectedList);
              //         //     activityPagingController.refresh();
              //         //     Navigator.pop(context);
              //         //   },
              //         //   onSelected: (selected) {
              //         //     submittedSelectedOptionList.clear();
              //         //     submittedSelectedList.clear();
              //         //     if (selected.contains("All")) {
              //         //       submittedSelectedOptionList.add("All");
              //         //       submittedSelectedList.addAll(
              //         //           BlocProvider.of<AppModeCubic>(context)
              //         //               .state is ParentMode
              //         //               ? [
              //         //             "Announcement",
              //         //             "LivePoll",
              //         //             "Check List"
              //         //           ]
              //         //               : [
              //         //             "Announcement",
              //         //             "Assignment",
              //         //             "LivePoll",
              //         //             "Check List"
              //         //           ]);
              //         //     } else {
              //         //       submittedSelectedOptionList
              //         //           .addAll(selected);
              //         //       submittedSelectedList.addAll(selected);
              //         //     }
              //         //     activityTypeController.sink
              //         //         .add(submittedSelectedList);
              //         //     activityPagingController.refresh();
              //         //     Navigator.pop(context);
              //         //   },
              //         // ),
              //       ),
              //     ])
              //     : Container(),
              // activityTypeController.valueOrNull != null &&
              //     !activityTypeController.valueOrNull
              //         .contains("Assignment") &&
              //     activityAssignToStatusController.valueOrNull
              //         .contains("Evaluated")
              //     ? PopupMenuButton(
              //     offset: Offset(-20, 45),
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(5.0)),
              //     iconSize: 36,
              //     padding: EdgeInsets.zero,
              //     icon: SvgPicture.asset(
              //       "assets/svg/menu-feed.svg",
              //       fit: BoxFit.cover,
              //     ),
              //     itemBuilder: (context) => [
              //       PopupMenuItem(
              //         enabled: false,
              //         padding: EdgeInsets.zero,
              //         child: Container(height: 50.0)
              //         // PopUpFilter(
              //         //   selectedList: evaluatedSelectedOptionList,
              //         //   studentActivities: [
              //         //     "All",
              //         //     "Announcement",
              //         //     "LivePoll",
              //         //     "Check List"
              //         //   ],
              //         //   parentActivities: [
              //         //     "All",
              //         //     "Announcement",
              //         //     "LivePoll",
              //         //     "Check List"
              //         //   ],
              //         //   onClear: () {
              //         //     evaluatedSelectedOptionList.clear();
              //         //     evaluatedSelectedOptionList.add("All");
              //         //     evaluatedSelectedList.clear();
              //         //     evaluatedSelectedList.addAll([
              //         //       "Announcement",
              //         //       "LivePoll",
              //         //       "Check List"
              //         //     ]);
              //         //     activityTypeController.sink
              //         //         .add(evaluatedSelectedList);
              //         //     activityPagingController.refresh();
              //         //     Navigator.pop(context);
              //         //   },
              //         //   onSelected: (selected) {
              //         //     evaluatedSelectedList.clear();
              //         //     evaluatedSelectedOptionList.clear();
              //         //     if (selected.contains("All")) {
              //         //       evaluatedSelectedOptionList.add("All");
              //         //       evaluatedSelectedList.addAll([
              //         //         "Announcement",
              //         //         "LivePoll",
              //         //         "Check List"
              //         //       ]);
              //         //     } else {
              //         //       evaluatedSelectedOptionList
              //         //           .addAll(selected);
              //         //       evaluatedSelectedList.addAll(selected);
              //         //     }
              //         //     activityTypeController.sink
              //         //         .add(evaluatedSelectedList);
              //         //     activityPagingController.refresh();
              //         //     Navigator.pop(context);
              //         //   },
              //         // ),
              //       ),
              //     ])
              //     : Container(),
              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0),
              //   child: PopUpSection(context),
              // ),
            ],
          ),
        ),
      );
    });
  }

  void handleActivityClick(ReceivedSession session, {List<ReceivedSession> sessionList}) {
    if (widget.user.isAuthorized) {
      BlocProvider.of<TakeActionCubit>(context).initializeTakeAction(session);
      homeTakeActionPanelController.open();
    }
  }
}

class AddTaskPanel extends StatelessWidget {
  const AddTaskPanel({Key key, this.user}) : super(key: key);

  final UserInfo user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          // height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  'Add Task',
                  style: buildTextStyle(),
                ),
              ),
              // CreateTask(
              //   name: 'Announcement',
              //   svgUrl: 'assets/svg/promotion.svg',
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       createRoute(pageWidget: CreateAnnouncement()),
              //     );
              //   },
              // ),
              // if (features['livePoll']['isEnabled'])
              //   CreateTask(
              //     name: 'Live Poll',
              //     svgUrl: 'assets/svg/polling.svg',
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         createRoute(pageWidget: CreateLivePoll()),
              //       );
              //     },
              //   ),
              // CreateTask(
              //   name: 'Event',
              //   svgUrl: 'assets/svg/add-event.svg',
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       createRoute(pageWidget: CreateEvent()),
              //     );
              //   },
              // ),
              // CreateTask(
              //   name: 'Test/Question Paper',
              //   svgUrl: 'assets/svg/question.svg',
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       createRoute(pageWidget: TestModule()),
              //     );
              //   },
              // ),
              // CreateTask(
              //   name: 'Assignment',
              //   svgUrl: 'assets/svg/assignment.svg',
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       createRoute(
              //         pageWidget: MultiBlocProvider(
              //           providers: [
              //             BlocProvider<ClassDetailsCubit>(
              //               create: (context) =>
              //               ClassDetailsCubit()..loadClassDetails(),
              //             ),
              //             BlocProvider<SubjectDetailsCubit>(
              //               create: (context) => SubjectDetailsCubit()
              //                 ..loadAssignmentSubjectDetails(),
              //             ),
              //           ],
              //           child: CreateAssignment(),
              //         ),
              //       ),
              //     );
              //   },
              // ),
              // if (features['checkList']['isEnabled'])
              //   CreateTask(
              //     name: 'Check list (To Do)',
              //     svgUrl: 'assets/svg/checklist.svg',
              //     onPressed: () {
              //       Navigator.of(context).push(
              //         createRoute(pageWidget: CreateCheckList()),
              //       );
              //     },
              //   ),

              CreateTask(
                name: 'Session',
                imageUrl: 'assets/images/session.png',
                onPressed: () {
                  Navigator.of(context).push(
                    createRoute(
                        pageWidget: CreateSession(
                          institute: user.schoolId.institute,
                          isEdit: false,
                          user: user,
                        )),
                  );
                },
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text(
              //         'Quick Access',
              //         style: buildTextStyle(
              //           size: 12,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // CreateTask(
              //   name: features['isBatch']['isEnabled']
              //       ? 'Create Batch'
              //       : 'Create Group',
              //   onPressed: () {
              //     BlocProvider.of<GroupCubit>(context)
              //         .emit(StudentGroupsLoading());
              //     BlocProvider.of<GroupCubit>(context).loadGroups();
              //     Navigator.of(context).push(
              //       createRoute(
              //         pageWidget: CreateGroupPage(),
              //       ),
              //     );
              //   },
              // ),
              // CreateTask(
              //   name: 'Join Class',
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       createRoute(
              //         pageWidget: BlocProvider(
              //             create: (context) => ScheduleClassCubit()
              //               ..getAllClass(
              //                   DateFormat('yyyy-MM-dd').format(DateTime.now()),
              //                   context),
              //             child: ClassSchedule()),
              //       ),
              //     );
              //   },
              // ),
              // CreateTask(
              //   name: 'Evaluate Test',
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       createRoute(
              //         pageWidget: MultiBlocProvider(
              //           providers: [
              //             BlocProvider(
              //               create: (context) => QuestionPaperCubit()
              //                 ..loadAllQuestionPapers(
              //                     data: {'page': 1, 'limit': 5}),
              //             ),
              //           ],
              //           child: TestListingPage(),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateTask extends StatelessWidget {
  const CreateTask({
    @required this.name,
    @required this.onPressed,
    this.svgUrl,
    this.imageUrl,
  });

  final String name;
  final String svgUrl;
  final String imageUrl;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (svgUrl == null && imageUrl == null) Spacer(),
            if (svgUrl != null) SvgPicture.asset(svgUrl),
            if (imageUrl != null) Image.asset(imageUrl),
            Text(
              name,
              style: buildTextStyle(weight: FontWeight.w600),
            )
          ],
        ),
        color: Color(0xffF0F4FC),
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        height: 55,
      ),
    );
  }
}
