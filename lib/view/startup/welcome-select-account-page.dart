import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/bloc/auth/auth-cubit.dart';
import '/bloc/auth/auth-states.dart';
import '/extensions/extension.dart';
import '/loader.dart';
import '/model/user.dart';
import '/view/startup/pin-forgot-page.dart';
import '/view/startup/pin-login-page.dart';
import '/view/utils/utils.dart';

class WelcomeSelectAccountPage extends StatefulWidget {
  @override
  _WelcomeSelectAccountPageState createState() =>
      _WelcomeSelectAccountPageState();
}

class _WelcomeSelectAccountPageState extends State<WelcomeSelectAccountPage> {
  UserInfo selectedUser;

  String error = '';
  double painterScreenHeight;

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    painterScreenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    return KeyboardDismissOnTap(
      child: Scaffold(

        body: BlocBuilder<AuthCubit, AuthStates>(builder: (context, state) {
          if (state is AccountsLoaded) {
            String str = state.user.schoolId == null  ? null : state.user.schoolId.schoolImage;
            return Center(
              child: Container(
                width:  screenwidth > 600 ? MediaQuery.of(context).size.width * 0.50 : MediaQuery.of(context).size.width * 0.99,
                color: const Color(0xfff4f8fe),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: appMarker(),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.12,
                            ),
                            Container(

                              // height: painterScreenHeight * 0.50,
                              width: MediaQuery.of(context).size.width * 0.8,
                              margin: EdgeInsets.only(left: 44, right: 44),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x40000000),
                                    offset: Offset(0, 4),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                  )
                                ],
                                color: const Color(0xffffffff),
                              ),
                              child: Column(

                                // fit: StackFit.loose,
                                // alignment: Alignment.topCenter,
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child:  state.users[0].schoolId.schoolImage == null ||
                                              state.users[0].schoolId.schoolImage == ''
                                          ? SvgPicture.asset(
                                              "assets/svg/logo-svg.svg",
                                              fit: BoxFit.cover,
                                            )
                                          : CachedImage(
                                              height: screenwidth > 600 ? 200 : 300,
                                              imageUrl: state.user.schoolId != null ? state.user.schoolId.schoolImage:'')
                                      // Image.network(
                                      //         state.users[0].schoolImage,
                                      //       ),
                                      ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Center(
                                      child: Text(

                                        "${state.users[0].schoolId.schoolName == null || state.users[0].schoolId.schoolName == '' ? '' : state.users[0].schoolId.schoolName.toTitleCase()}",
                                        style: const TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 16.0, right: 16),
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    child: DropdownButton<UserInfo>(
                                      value: selectedUser,
                                      icon: Icon(
                                        Icons.add_circle_outline_sharp,
                                        color: kColor,
                                      ),
                                      iconSize: 24,
                                      isExpanded: true,
                                      elevation: 16,
                                      hint: Text('Select an account'),
                                      style: const TextStyle(
                                          color: const Color(0xff1b1a57),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Montserrat",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                      underline: Container(
                                        height: 2,
                                        color: kColor,
                                      ),
                                      onChanged: (UserInfo newValue) {
                                        print(newValue.profileType);
                                        if (newValue.profileType.roleName
                                                .toLowerCase() ==
                                            "school_admin")
                                          showDialogueInvalidUser(context);
                                        else {
                                          setState(() {
                                            selectedUser = newValue;
                                            error = '';
                                          });
                                        }
                                      },
                                      items: [
                                        for (var i in state.users)
                                          DropdownMenuItem<UserInfo>(
                                            value: i,
                                            child: Text(i.name),
                                          )
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      error,
                                      style: const TextStyle(
                                          color: const Color(0xff000000),
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Montserrat",
                                          fontSize: 12.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    child: RaisedButton(
                                      color: kColor,
                                      onPressed: () {
                                        handleContinue();
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else
            return Container();
        }),
      ),
    );
  }

  void handleContinue() {
    if (selectedUser == null) {
      error = 'Please select an account to continue';
      setState(() {});
    } else {
      print('pin password = ${selectedUser.pin}');
      if (selectedUser.pin == "" ||
          selectedUser.pin == null ||
          selectedUser.pin == "null") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => AuthCubit()..sendOTP(selectedUser),
                child: SetupPinOtpPage(selectedUser)),
          ),
        );
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PinLoginPage(selectedUser)));
      }
    }
  }
}
