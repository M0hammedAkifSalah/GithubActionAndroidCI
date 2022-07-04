import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growonplus_teacher/export.dart';
// import ' /view/home/student-home-page.dart';
// import ' /view/home/student-home-page.dart';
// import ' /view/startup/pin-setup-confirmation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/view/startup/pin-forgot-page.dart';

class PinLoginPage extends StatefulWidget {
  final UserInfo userInfo;

  PinLoginPage(this.userInfo);

  @override
  _PinLoginPageState createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final formKey = GlobalKey<FormState>();

  bool hasError = false;
  StreamController<ErrorAnimationType> errorController;
  TextEditingController textEditingController = TextEditingController();
  String pinNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Future.delayed(Duration(seconds: 4));
          // BlocProvider.of<UserProfileCubit>(context).loadStudentProfile();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider<ActivityCubit>(
                      create: (BuildContext context) => ActivityCubit()),
                  // BlocProvider<FeedActionCubit>(
                  //   create: (BuildContext context) => FeedActionCubit(),
                  // ),
                ],
                child: TeacherHomePage(), // student home was here.
              ),
            ),
            (route) => false,
          );
        } else {
          textEditingController.clear();
          formKey.currentState.reset();
          errorController.add(ErrorAnimationType.shake);
        }
      },
      child: KeyboardDismissOnTap(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 23.0),
                  child: SvgPicture.asset(
                    "assets/svg/login-back.svg",
                    color: kColor,
                  ),
                ),
              ),
            ],
            title: appMarker(),
            //   RichText(
            //   text: TextSpan(
            //     children: [
            //       TextSpan(
            //         style: const TextStyle(
            //             color: const Color(0xff000000),
            //             //fontWeight: FontWeight.w600,
            //             fontFamily: "Poppins",
            //             fontSize: 24.0),
            //         text: "9.",
            //       ),
            //       TextSpan(
            //         style: const TextStyle(
            //             color: kColor,
            //             //fontWeight: FontWeight.w600,
            //             fontFamily: "Poppins",
            //             fontStyle: FontStyle.normal,
            //             fontSize: 24.0),
            //         text: "8",
            //       ),
            //     ],
            //   ),
            // ),
          ),
          body: Center(
            child: Container(
              width:  screenwidth > 600 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 0.99,
              child: ListView(
                padding: const EdgeInsets.only(top: 30.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      "Welcome",
                      style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Text(
                      widget.userInfo.name,
                      style: const TextStyle(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Center(
                      child: Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 16),
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
                      color: const Color(0xffffffff),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15, top: 23, bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter your Pin Password to login",
                            style: const TextStyle(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontSize: 24.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 39,
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20),
                              child: PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: kColor,
                                  fontWeight: FontWeight.bold,
                                ),

                                controller: textEditingController,
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
                                  borderWidth: 1,
                                  inactiveColor: Color(0xffc4c4c4),
                                  inactiveFillColor: Colors.white,
                                  disabledColor: Colors.white,
                                  selectedColor: Color(0xffc4c4c4),
                                  activeFillColor: Colors.white,
                                ),
                                cursorColor: kColor,
                                obscureText: true,
                                obscuringCharacter: "•",
                                animationDuration: Duration(milliseconds: 300),
                                textStyle: TextStyle(fontSize: 20, height: 1.6),
                                backgroundColor: Colors.white,
                                enableActiveFill: true,
                                showCursor: false,

                                enablePinAutofill: true,
                                errorAnimationController: errorController,
                                keyboardType: TextInputType.number,
                                // boxShadows: [
                                //   BoxShadow(
                                //     offset: Offset(0, 1),
                                //     color: Colors.black12,
                                //     blurRadius: 10,
                                //   )
                                // ],
                                onCompleted: (v) {
                                  print("Completed");
                                },
                                // onTap: () {
                                //   print("Pressed");
                                // },
                                onChanged: (value) {
                                  print(value);
                                  pinNumber = value;
                                },
                                beforeTextPaste: (text) {
                                  print("Allowing to paste $text");
                                  return true;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          FlatButton(
                            child: Text(
                              'Forgot Pin?',
                              style: buildTextStyle(color: kColor, size: 14),
                            ),
                            onPressed: () {
                              BlocProvider.of<AuthCubit>(context)
                                  .sendOTP(widget.userInfo);
                              Navigator.of(context).push(
                                createRoute(
                                  pageWidget: SetupPinOtpPage(widget.userInfo),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 100,
                              child: RaisedButton(
                                color: kColor,
                                onPressed: () {
                                  handleContinue(context);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Login",
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
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleContinue(context) {
    if (pinNumber == null || pinNumber.length != 4) {
      errorController.add(ErrorAnimationType.shake);
    } else {
      BlocProvider.of<AuthCubit>(context, listen: false)
          .login(widget.userInfo, pinNumber);
    }
  }
}
