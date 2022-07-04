import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/utils.dart';
import '/bloc/auth/auth-cubit.dart';
import '/bloc/auth/auth-states.dart';
import '/loader.dart';
import '/view/startup/welcome-select-account-page.dart';

class MobileAuthenticationPage extends StatefulWidget {
  @override
  _MobileAuthenticationPageState createState() =>
      _MobileAuthenticationPageState();
}

class _MobileAuthenticationPageState extends State<MobileAuthenticationPage> {
  String error = '';
  bool enableButton = false;
  Map _source = {ConnectivityResult.none: false};
  // final MyConnectivity _connectivity = MyConnectivity.instance;

  TextEditingController mobileTextEditingController =
       TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _connectivity.initialise();
    // _connectivity.myStream.listen((source) {
    //   setState(() => _source = source);
    // });
  }
  @override
  void dispose() {
    // _connectivity.disposeStream();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    // if(checkInternet())
    //   {
    //     Fluttertoast.showToast(msg: 'Internet Unavailable...Please check your Internet Connection');
    //   }
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AccountsLoaded) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WelcomeSelectAccountPage(),
            ),
          );
        } else if (state is AccountsNotLoaded)
          setState(() {
            error =
                "OOPS... We did not find your account.Make sure you have entered the registered mobile number. ";
          });
      },
      child: KeyboardDismissOnTap(
        child: Scaffold(
          body: Center(

            child: SingleChildScrollView(
              child: Container(
                width:  screenwidth > 600 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 80,
                margin: EdgeInsets.only(left: 27, right: 27),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x40000000),
                      offset: Offset(0, 0),
                      blurRadius: 15,
                      spreadRadius: 0,
                    )
                  ],
                  color: const Color(0xffffffff),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(
                          "assets/svg/login-back.svg",
                          color: kColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Mobile Number",
                        style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Enter your registered phone number",
                        style: const TextStyle(
                            color: const Color(0xff828282),
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0),
                      ),
                      SizedBox(
                        height: 31,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/call.svg",
                            height: 15,
                            width: 15,
                            color: kColor,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "+91",
                            style: const TextStyle(
                              color: const Color(0xff828282),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(
                            width: 11,
                          ),
                          Expanded(
                            child: TextField(
                              maxLength: 10,
                              cursorColor: kColor,
                              onChanged: (value) {
                                if (value.length == 10 ) {
                                  enableButton = true;
                                  error = '';
                                } else
                                  enableButton = false;

                                setState(() {});
                              },
                              style: const TextStyle(
                                  color: const Color(0xff1b1a57),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Montserrat",
                                  fontSize: 14.0),
                              keyboardType: TextInputType.number,
                              controller: mobileTextEditingController,
                              decoration: InputDecoration(
                                counterText: "",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                alignLabelWithHint: true,
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: kColor,
                      ),
                      SizedBox(
                        height: 46,
                      ),
                      Center(
                        child: RaisedButton(
                          elevation: 0,
                          color: enableButton ? kColor : Colors.grey[400],
                          onPressed: () {
                            handleContinue(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
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
                      ),
                      SizedBox(
                        height: 27,
                      ),
                      Center(
                        child: Text(
                          error,
                          style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Montserrat",
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleContinue(context) {
    if (enableButton) {
      BlocProvider.of<AuthCubit>(context, listen: false)
          .getUsers(mobileTextEditingController.text);
    } else {
      setState(() {
        error = 'Enter a valid mobile number';
      });
    }
  }

  bool checkInternet()
  {
    switch (_source.keys.toList()[0]) {
      case ConnectivityResult.mobile:
        return true;
        break;
      case ConnectivityResult.wifi:
       return true;
        break;
      case ConnectivityResult.none:
      default:
       return false;
    }
  }
}
