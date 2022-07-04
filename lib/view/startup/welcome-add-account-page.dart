import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:growonplus_teacher/main.dart';
import 'package:growonplus_teacher/view/utils/utils.dart';

import '/loader.dart';
import '/view/startup/mobile-authentication-page.dart';

class WelcomeAddAccountPage extends StatefulWidget {
  @override
  _WelcomeAddAccountPageState createState() => _WelcomeAddAccountPageState();
}

class _WelcomeAddAccountPageState extends State<WelcomeAddAccountPage> {
  String accountSelection = "Add Account";

  double painterScreenHeight;

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    painterScreenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        color: const Color(0xfff4f8fe),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                appMarker(),
                SizedBox(
                  height: painterScreenHeight * 0.15,
                ),
                Container(
                  width:  screenwidth > 600 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 80,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x40000000),
                          offset: Offset(0, 4),
                          blurRadius: 10,
                          spreadRadius: 0)
                    ],
                    color: const Color(0xffffffff),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 12, right: 11, left: 11),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            "assets/svg/welcome-image.svg",
                            height: (MediaQuery.of(context).size.height * 0.50 -
                                    27) *
                                0.78,
                          ),
                        ),
                        Container(
                          height:
                              (MediaQuery.of(context).size.height * 0.50 - 27) *
                                  0.22,
                          alignment: Alignment.bottomLeft,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "",
                                style: const TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 18.0),
                              ),
                              Text(
                                "",
                                style: const TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24.0),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width:  screenwidth > 600 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 80,
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 120,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MobileAuthenticationPage(),
                            ),
                          );
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Add Account",
                                    style: const TextStyle(
                                      color: const Color(0xff1b1a57),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Montserrat",
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Icon(
                                    Icons.add_circle_outline_sharp,
                                    color: kColor,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                height: 2,
                                width: MediaQuery.of(context).size.width - 30,
                                color: kColor,
                              )
                            ],
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
}
