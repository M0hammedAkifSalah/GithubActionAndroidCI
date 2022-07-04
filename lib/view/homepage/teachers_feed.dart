import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '/export.dart';
import '/view/announcements/announcement.dart';
import '/view/event/event.dart';
import '/view/livepoll/livepoll-pending.dart';

var filterVisibilityStreamController = BehaviorSubject<bool>();
PanelController takeActionPanelController = PanelController();

class TeachersFeed extends StatefulWidget {
  final List<Activity> activities;
  final bool toYou;
  final bool saved;
  final bool removeTopBar;
  final ScrollController scrollController;

  TeachersFeed(
    this.activities,
    this.toYou, {
    this.saved = false,
    this.scrollController,
    this.removeTopBar = false,
  });

  @override
  _TeachersFeedState createState() => _TeachersFeedState();
}

class _TeachersFeedState extends State<TeachersFeed> {
  List<Activity> _activities;
  bool init = true;
  bool _loading = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() async {
    if (!init) {
      await Future.delayed(Duration(seconds: 2));
      BlocProvider.of<AuthCubit>(context, listen: false)
          .checkAuthStatus();
      init = true;
    }
    super.didChangeDependencies();
    // _scrollController.addListener(() async {
    //   print('loading 2');
    //   if (_scrollController.position.maxScrollExtent ==
    //       _scrollController.position.pixels) {
    //     print('limit before adding $_limit');
    //     _limit += 5;
    //     print('limit after adding $_limit');
    //     _loading = true;
    //     // setState(() {});

    //     print('loading 1');
    //     // await BlocProvider.of<ActivityCubit>(context, listen: false)
    //     //     .loadActivities(limit: _limit);
    //     print('loading');
    //     _loading = false;
    //     // setState(() {});
    //   }
    // });
    // _scrollController.addListener(() {
    //   if (_scrollController.position.maxScrollExtent ==
    //       _scrollController.position.pixels) {
    //     limit += 5;
    //     setState(() {});
    //     print('loading 1');
    //     BlocProvider.of<ActivityCubit>(context, listen: false)
    //         .loadActivities(limit: limit);
    //     print('loading');
    //   }
    // });
    _activities = widget.activities;
    if (init) {
      // init = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    filterVisibilityStreamController.drain();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
          return false;
        } else
          return true;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: SafeArea(
          top: false,
          child: Container(
            // color: Colors.blue,

            child: ListView(
              shrinkWrap: true,
              controller: widget.scrollController,
              padding: EdgeInsets.only(bottom: 100),
              physics: BouncingScrollPhysics(),
              children: [
                if (!widget.removeTopBar)
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12, left: 14.0, right: 14, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                // focusNode: _focusNode,
                                controller: _searchController,
                                onChanged: (value) {
                                  if(value != null)
                                  _activities = widget.activities.where((act) {
                                    if (act.description != null &&
                                        act.title != null && act.subject != null) {
                                      return act.description
                                              .toLowerCase()
                                              .contains(value) ||
                                          act.activityType
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          act.title
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          act.subject
                                              .toLowerCase()
                                              .contains(value.toLowerCase());
                                    } else if (act.description != null) {
                                      return act.activityType
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          act.description
                                              .toLowerCase()
                                              .contains(value.toLowerCase());
                                    } else if (act.title != null) {
                                      return act.activityType
                                              .toLowerCase()
                                              .contains(value.toLowerCase()) ||
                                          act.title
                                              .toLowerCase()
                                              .contains(value.toLowerCase());
                                    }
                                    return false;
                                  }).toList();

                                  setState(() {});
                                },
                                onSubmitted: (value){
                                  if (_activities.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: 'No Activities');
                                  }
                                  setState(() {});
                                },

                                decoration: InputDecoration(
                                  labelText: 'title, description, type..',
                                  labelStyle: buildTextStyle(
                                    color: Colors.grey,
                                    size: 13,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 2, left: 20),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xffc4c4c4),
                                    ),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(color: Colors.grey[800]),
                                  fillColor: Colors.white70,
                                  suffixIcon: IconButton(
                                    icon: Icon(_searchController.text == ''
                                        ? Icons.search
                                        : Icons.close),
                                    onPressed: () {
                                      setState(() {});
                                      _searchController.clear();
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus &&
                                          currentFocus.focusedChild != null) {
                                        currentFocus.focusedChild.unfocus();
                                      }
                                      _activities = widget.activities;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          // IconButton(
                          //   icon: SvgPicture.asset(
                          //     "assets/svg/menu-feed.svg",
                          //     color: Color(0xffFF5A79),
                          //   ),
                          //   onPressed: () async {
                          //     if (!widget.toYou) {
                          //       // filterVisibilityStreamController.sink.add(true);
                          //       _activities = await Navigator.of(context)
                          //               .push<List<Activity>>(
                          //             createRoute<List<Activity>>(
                          //               pageWidget: SortAndFilter(
                          //                 activities: widget.activities,
                          //               ),
                          //             ),
                          //           ) ??
                          //           widget.activities;
                          //     } else {
                          //       _activities = await Navigator.of(context)
                          //               .push<List<Activity>>(
                          //             createRoute<List<Activity>>(
                          //               pageWidget: SortAndFilterToYou(
                          //                 activities: widget.activities,
                          //               ),
                          //             ),
                          //           ) ??
                          //           widget.activities;
                          //     }
                          //     setState(() {});
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ListView.separated(
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    // controller: _scrollController,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _activities.length,
                    itemBuilder: (BuildContext context, int index) {
                      var activity = _activities[index];

                      return getRespectiveActivity(activity);

                      // if (index == 0) return Assignment();
                      // if (index == 1) return Event();
                      // if (index == 2) return LivePollSubmitted();
                      // if (index == 3) return LivePollPending();
                      // if (index == 4) return Announcement();
                      // return Container(
                      //   child: Text('index $index'),
                      // );
                    }),
                if (_loading)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(

                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getRespectiveActivity(Activity activity) {

    switch (activity.activityType) {
      case 'Assignment':
        return Assignment(activity, widget.saved, !widget.toYou);
      case 'Announcement':
        return Announcement(
          widget.saved,
          !widget.toYou,
          activity: activity,
        );
      case 'LivePoll':
        return LivePollPending(activity, widget.saved, !widget.toYou);

      case 'Event':
        return Event(activity, widget.saved, !widget.toYou);
      case 'Check List':
        return CheckList(activity, widget.saved, !widget.toYou);
      default:
        return Container(
          child: Text(activity.activityType),
        );
    }
  }
}
