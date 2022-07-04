import 'dart:async';

import 'package:flutter/material.dart';
import 'package:growonplus_teacher/export.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '/view/startup/pin-setup-confirmation.dart';

class PinSetupPage extends StatefulWidget {
  final UserInfo userInfo;

  PinSetupPage(this.userInfo);
  @override
  _PinSetupPageState createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: appMarker(),
        // RichText(
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
                  "Welcome",
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0),
                ),
                Text(
                  widget.userInfo.name,
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0),
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
                          "Setup your Pin Password",
                          style: const TextStyle(
                              color: const Color(0xff000000),
                              fontWeight: FontWeight.w400,
                              fontSize: 24.0),
                        ),
                        Text("Your pin allows you quick access to your account",
                            style: const TextStyle(
                                color: const Color(0xff000000),
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0),
                            textAlign: TextAlign.center),
                        SizedBox(
                          height: 39,
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 30,
                            ),
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
                              cursorColor: Color(0xff6fcf97),
                              animationDuration: Duration(milliseconds: 300),
                              textStyle: TextStyle(fontSize: 20, height: 1.6),
                              backgroundColor: Colors.white,
                              enableActiveFill: true,
                              showCursor: false,
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
                            ),
                          ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Continue",
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
    );
  }

  handleContinue(context) {
    if (pinNumber == null || pinNumber.length != 4) {
      errorController.add(ErrorAnimationType.shake);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PinSetupConfirmation(pinNumber, widget.userInfo)));
    }
  }
}
