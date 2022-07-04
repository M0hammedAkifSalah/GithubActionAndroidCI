import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:growonplus_teacher/export.dart';
import '../drawer/drawer_menu.dart';
import '../profile/teacher-profile-page.dart';

class InstituteSilverAppbar extends StatefulWidget {
  final UserInfo user;
  const InstituteSilverAppbar({Key key, this.user}) : super(key: key);

  @override
  _InstituteSilverAppbarState createState() => _InstituteSilverAppbarState();
}

class _InstituteSilverAppbarState extends State<InstituteSilverAppbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // : MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8, left: 14.0, right: 0),
                    child: appMarker(),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 75,
                        height: 52,
                        padding: const EdgeInsets.only(top: 6, right: 5),
                        child: InkWell(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   createRoute(pageWidget: InstituteHomePage()),
                            // );
                          },
                          child: TeacherProfileAvatar(
                            imageUrl: widget.user.schoolId.institute.id != null ? widget.user.schoolId.institute.profileImage : 'Text',
                          ),
                          // child: Container(
                          //   decoration: BoxDecoration(
                          //     image: DecorationImage(
                          //       image:
                          //           new AssetImage("assets/images/mferd.png"),
                          //       fit: BoxFit.fill,
                          //     ),
                          //     borderRadius: BorderRadius.circular(25),
                          //   ),
                          //   height: 45,
                          //   width: 80,
                          // ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          // bool open = await Navigator.of(context).push<bool>(
                          //   createRoute(pageWidget: DrawerMenu()),
                          // );
                          // if (open != null) {
                          //   if (open) {
                          //     panelController.open();
                          //   }
                          // }
                          // Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(Icons.close),
                        // Container(
                        //   height: 25,
                        //   width: 28,
                        //   child: SvgPicture.asset(
                        //     "assets/svg/menu.svg",
                        //   ),
                        // ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(pageWidget: TeacherProfilePage()),
                          );
                        },
                        child: TeacherProfileAvatar(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user != null ? widget.user.name.toTitleCase() : 'No Name',
                            // state is LoginSuccess
                            //     ? ''
                            //     : state is AccountsLoaded
                            //     ? state.user.name.toTitleCase()
                            //     : '',
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.user != null
                                ? widget.user.profileType.roleName.toTitleCase()
                                : '',
                            // state is AccountsLoaded
                            //     ? state.user.profileType.roleName.toTitleCase()
                            //     : '',
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
