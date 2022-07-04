import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/bloc/take-action/take-action-cubit.dart';
import '/model/activity.dart';
import '/view/utils/utils.dart';

class LivePollActionPanel extends StatefulWidget {
  final Activity activity;

  final String route;
  LivePollActionPanel({this.route, this.activity});

  @override
  _LivePollActionPanelState createState() => _LivePollActionPanelState();
}

class _LivePollActionPanelState extends State<LivePollActionPanel> {
  String choice;
  ScrollController controller =  ScrollController();
  SelectedOptions selectedOptions = SelectedOptions();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 22, left: 22, right: 22),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // if (widget.route == "/saved")
                        //   savedFeedActionPanelController.close();
                        // else
                        //   feedActionPanelController.close();                  },
                      },
                      child: Icon(Icons.close)),
                  Spacer(
                    flex: 3,
                  ),
                  Column(
                    children: [
                      Text(
                        "Take Action",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0),
                      ),
                      Text(
                        "Live Poll",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      )
                    ],
                  ),
                  Spacer(
                    flex: 4,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(top: 22, left: 22, right: 22),
              child: Text(
                widget.activity.title,
                style: const TextStyle(
                    color: const Color(0xff000000),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Scrollbar(
                controller: controller,
                trackVisibility: true,
                child: ListView(
                  controller: controller,
                  padding: EdgeInsets.only(left: 22, right: 22),
                  children: [
                    Text(
                      widget.activity.description != null
                          ? "${widget.activity.description}"
                          : "",
                      style: const TextStyle(
                          color: const Color(0xff000000),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            FileListing(widget.activity.files),
            Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    widget.activity.userReacted != null &&
                            widget.activity.userReacted
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding:
                                const EdgeInsets.only(left: 22, right: 22.0),
                            shrinkWrap: true,
                            itemCount: widget.activity.options.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: const Color(0xfff0f4fc)),
                                child: Row(children: [
                                  Radio(
                                    value: widget.activity.options[index].text,
                                    groupValue: widget.activity
                                        .selectedLivePollByTeacher.options[0],
                                    onChanged: (value) {
                                      // selectedOptions.options = [value];
                                      // setState(() {});
                                    },
                                  ),
                                  Text(widget.activity.options[index].text,
                                      style: const TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11.0)),
                                ]),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding:
                                const EdgeInsets.only(left: 22, right: 22.0),
                            shrinkWrap: true,
                            itemCount: widget.activity.options.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: const Color(0xfff0f4fc)),
                                child: Row(children: [
                                  Radio(
                                    value: widget.activity.options[index].text,
                                    groupValue: choice,
                                    onChanged: (String value) {
                                      setState(() {
                                        choice =
                                            widget.activity.options[index].text;
                                        selectedOptions.options = [value];
                                      });
                                    },
                                  ),
                                  Text(widget.activity.options[index].text,
                                      style: const TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 11.0))
                                ]),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 22,
                    ),
                    // widget.activity.userReacted == null || (widget.activity.userReacted != null && !widget.activity.userReacted)?
                    RaisedButton(
                      color: const Color(0xff6fcf97),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        handleLivePollSubmit();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Text(
                          "Submit",
                          style: const TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleLivePollSubmit() {
    // if (BlocProvider.of<AppModeCubic>(context).state is StudentMode) {
    if ((selectedOptions.options == null || selectedOptions.options.isEmpty) &&
        !widget.activity.userReacted) {
      Fluttertoast.showToast(msg: "Choose your option");
      return;
    }
    if (!widget.activity.userReacted) {
      BlocProvider.of<TakeActionCubit>(context)
          .updateLivePoll(widget.activity.id, selectedOptions);
      Navigator.of(context).pop();

      // feedActionPanelController.close();
    }
    if (widget.activity.userReacted) {
      Fluttertoast.showToast(msg: "You cannot perform this action");
    }
  }
}
