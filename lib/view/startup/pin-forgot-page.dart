import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:growonplus_teacher/export.dart';
// import ' /view/home/student-home-page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../custom/progress_button/progress_button.dart';
import '/view/startup/pin-setup-page.dart';

class SetupPinOtpPage extends StatefulWidget {
  final UserInfo userInfo;

  SetupPinOtpPage(this.userInfo);

  @override
  _SetupPinOtpPageState createState() => _SetupPinOtpPageState();
}

class _SetupPinOtpPageState extends State<SetupPinOtpPage> {
  final formKey = GlobalKey<FormState>();

  bool hasError = false;
  StreamController<ErrorAnimationType> errorController;
  String otp;
  Timer timer;
  bool verified = false;

  @override
  void initState() {
    // TODO: implement initState
    timer = runTimer();
    if (timer.tick == 30) {
      timer.cancel();
    }
    if (timer.isActive) {
      print(timer.tick);
      setState(() {});
    }
    super.initState();

    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if (init) {
    //   runTimer();
    //   init = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) async {
        if (state is OtpVerified) {
          verified = true;
          setState(() {});
          // BlocProvider.of<AuthCubit>(context).getUsers(username);
          await Future.delayed(Duration(seconds: 1));
          Navigator.of(context).push(
            createRoute(pageWidget: PinSetupPage(widget.userInfo)),
          );
        } else if (state is OtpNotVerified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid OTP!')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: false,
          title: appMarker(),
          // title: RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         style: const TextStyle(
          //           color: const Color(0xff000000),
          //           fontWeight: FontWeight.w600,
          //           fontFamily: "Poppins",
          //           fontSize: 24.0,
          //         ),
          //         text: "9.",
          //       ),
          //       TextSpan(
          //         style: const TextStyle(
          //           color: kColor,
          //           fontWeight: FontWeight.w600,
          //           fontFamily: "Poppins",
          //           fontStyle: FontStyle.normal,
          //           fontSize: 24.0,
          //         ),
          //         text: "8",
          //       ),
          //     ],
          //   ),
          // ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "You are almost done",
                    style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x40000000),
                                offset: Offset(0, 4),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                          color: const Color(0xffffffff)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 23, bottom: 23),
                        child: Column(
                          children: [
                            Text(
                              "Enter OTP",
                              style: const TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 24.0),
                            ),
                            SizedBox(
                              height: 39,
                            ),
                            Form(
                              key: formKey,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 30),
                                  child: PinCodeTextField(
                                    appContext: context,
                                    pastedTextStyle: TextStyle(
                                      color: kColor,
                                      fontWeight: FontWeight.bold,
                                    ),

                                    length: 4,
                                    animationType: AnimationType.fade,
                                    // validator: (v) {
                                    //   if (v.length < 3) {
                                    //     return "I'm from validator";
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10),
                                      fieldHeight: 42,
                                      fieldWidth: 43,
                                      selectedFillColor: Colors.white,
                                      activeColor: Color(0xffc4c4c4),
                                      borderWidth: 2,
                                      inactiveColor: Color(0xffc4c4c4),
                                      inactiveFillColor: Colors.white,
                                      disabledColor: Colors.white,
                                      selectedColor: Color(0xffc4c4c4),
                                      activeFillColor: hasError
                                          ? Colors.orange
                                          : Colors.white,
                                    ),
                                    showCursor: false,
                                    cursorColor: kColor,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    textStyle:
                                        TextStyle(fontSize: 20, height: 1.6),
                                    backgroundColor: Colors.white,
                                    enableActiveFill: true,
                                    enablePinAutofill: true,
                                    errorAnimationController: errorController,
                                    keyboardType: TextInputType.number,
                                    boxShadows: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.black12,
                                        blurRadius: 10,
                                      )
                                    ],
                                    onCompleted: (v) {
                                      print("Completed");
                                    },
                                    // onTap: () {
                                    //   print("Pressed");
                                    // },
                                    onChanged: (value) {
                                      print(value);
                                      otp = value;
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");

                                      return true;
                                    },
                                  )),
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  child: Text(
                                    'Resend OTP by SMS',
                                    style: buildTextStyle(
                                        size: 12,
                                        color: timer.tick == 30
                                            ? kColor
                                            : Colors.grey),
                                  ),
                                  onPressed: timer.tick == 0
                                      ? () {
                                          print('before');
                                        }
                                      : () {
                                          BlocProvider.of<AuthCubit>(context)
                                              .sendOTP(widget.userInfo);
                                          timer = runTimer();
                                          setState(() {});
                                        },
                                ),
                                Text(
                                    '00:${(30 - timer.tick).toString().length == 2 ? '${30 - timer.tick}' : '0${30 - timer.tick}'}')
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ProgressButton(
                                animate: true,
                                borderRadius: 50,
                                color: kColor,
                                onPressed: () async {
                                  return await handleContinue(context);
                                },
                                width: MediaQuery.of(context).size.width - 120,
                                progressWidget: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                defaultWidget: verified
                                    ? Center(
                                        child: Icon(
                                          Icons.verified,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Verify",
                                            style: const TextStyle(
                                                color: const Color(0xffffffff),
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                                fontSize: 14.0),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 14,
                                            color: Colors.white,
                                          )
                                        ],
                                      )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Timer runTimer() {
    return Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timer.tick == 30) {
          timer.cancel();
        }
        // print(timer.tick);
      });
    });
  }

  Future<void> handleContinue(context) async {
    if (otp == null || otp.length != 4) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
      });
    } else {
      await BlocProvider.of<AuthCubit>(context).verifyOTP(widget.userInfo, otp);
    }
  }
}
