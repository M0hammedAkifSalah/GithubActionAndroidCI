import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import ' /view/home/student-home-page.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:growonplus_teacher/export.dart';


class PinSetupConfirmation extends StatefulWidget {
  final UserInfo userInfo;
  final String enteredPinNumber;

  PinSetupConfirmation(this.enteredPinNumber, this.userInfo);

  @override
  _PinSetupConfirmationState createState() => _PinSetupConfirmationState();
}

class _PinSetupConfirmationState extends State<PinSetupConfirmation> {
  final formKey = GlobalKey<FormState>();

  bool hasError = false;
  StreamController<ErrorAnimationType> errorController;

  String pinNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          // BlocProvider.of<AuthCubit>(context).getUsers(username);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ActivityCubit>(
                      lazy: false,
                      create: (BuildContext context) => ActivityCubit(),
                    ),
                    // BlocProvider<FeedActionCubit>(
                    //   create: (BuildContext context) => FeedActionCubit(),
                    // ),
                  ],
                  child: TeacherHomePage(), // student home was here
                ),
              ),
              (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: appMarker(),
          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //           style: const TextStyle(
          //               color: const Color(0xff000000),
          //               fontWeight: FontWeight.w600,
          //               fontFamily: "Poppins",
          //               fontSize: 24.0),
          //           text: "9."),
          //       TextSpan(
          //         style: const TextStyle(
          //             color: kColor,
          //             fontWeight: FontWeight.w600,
          //             fontFamily: "Poppins",
          //             fontStyle: FontStyle.normal,
          //             fontSize: 24.0),
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
                            "Re-enter your Pin Password",
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
                                    activeFillColor:
                                        hasError ? Colors.orange : Colors.white,
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
                                    pinNumber = value;
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
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            child: RaisedButton(
                              color: kColor,
                              onPressed: () {
                                handleContinue(context);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Setup & Login",
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
    if (pinNumber == null ||
        pinNumber.length != 4 ||
        pinNumber != widget.enteredPinNumber) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
      });
    } else {
      BlocProvider.of<AuthCubit>(context)
          .setupPinAndLogin(pinNumber, widget.userInfo);
    }
  }
}
