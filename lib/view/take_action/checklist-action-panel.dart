import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '/bloc/take-action/take-action-cubit.dart';
import '/model/activity.dart';
import '/view/utils/utils.dart';

class CheckListPanel extends StatefulWidget {
  final Activity activity;

  final String route;
  CheckListPanel({this.route, this.activity});

  @override
  _CheckListPanelState createState() => _CheckListPanelState();
}

class _CheckListPanelState extends State<CheckListPanel> {
  ScrollController controller =  ScrollController();
  List<Option> options = [];

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        // if (widget.route == "/saved")
                        //   savedFeedActionPanelController.close();
                        // else
                        //   feedActionPanelController.close();
                      },
                      child: Icon(Icons.close)),
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
                        "Checklist(to-do)",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/points.png",
                        height: 20,
                        width: 20,
                      ),
                      Text(widget.activity.coin.toString())
                    ],
                  )
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
                    // Text(
                    //   '${widget.activity.description}',
                    //   style: const TextStyle(
                    //       color: const Color(0xff000000),
                    //       fontWeight: FontWeight.w400,
                    //       fontSize: 12.0),
                    //   textAlign: TextAlign.justify,
                    // ),
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
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(left: 22.0, right: 22),
                      shrinkWrap: true,
                      itemCount: widget.activity.options.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: const Color(0xfff0f4fc)),
                          child: Row(children: [
                            Checkbox(
                                value: widget.activity.userReacted
                                    ? widget.activity.selectedCheckListByTeacher
                                        .options
                                        .contains(
                                            widget.activity.options[index].text)
                                    : options.contains(
                                        widget.activity.options[index]),
                                onChanged: widget.activity.userReacted
                                    ? (value) {}
                                    : (value) {
                                        setState(() {
                                          if (value) {
                                            options.add(
                                                widget.activity.options[index]);
                                          } else {
                                            options.remove(
                                                widget.activity.options[index]);
                                          }
                                        });
                                      }),
                            Text(
                              widget.activity.options[index].text,
                              style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 11.0),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    RaisedButton(
                        color: const Color(0xff6fcf97),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          handleChecklistSubmit();
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
                        )),
                    SizedBox(
                      height: 8,
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

  void handleChecklistSubmit() {
    if (options.isEmpty && !widget.activity.userReacted) {
      Fluttertoast.showToast(msg: 'Please select a option');
      return;
    }
    // if (BlocProvider.of<AppModeCubic>(context).state is StudentMode) {
    //   List<String> selectedOptions = [];
    //   for (final option in widget.activity.options) {
    //     if (option.checked == "YES") selectedOptions.add(option.text);
    //   }
    //   print("selected options: $selectedOptions");
    if (!widget.activity.userReacted) {
      BlocProvider.of<TakeActionCubit>(context).updateCheckList(
        widget.activity.id,
        SelectedOptions(
          options: options.map((e) => e.text).toList(),
        ),
      );
      widget.activity.userReacted = true;
      Fluttertoast.showToast(msg: 'Action recorded');

      //     feedActionPanelController.close();
    } else {
      Fluttertoast.showToast(msg: "You cannot perform this action");
    }
    // }
  }
}
