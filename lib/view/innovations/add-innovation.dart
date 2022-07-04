import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:growon/bloc/innovation/innovation-cubit.dart';
// import 'package:growon/model/innovation.dart';
// import 'package:growon/view/innovations/innovations.dart';

class AddInnovation extends StatefulWidget {
  final ScrollController scrollController;

  AddInnovation(this.scrollController);

  @override
  _AddInnovationState createState() => _AddInnovationState();
}

class _AddInnovationState extends State<AddInnovation> {
  // Innovation innovation =  Innovation();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 22),
      child: Form(
        key: _formKey,
        child: Stack(
          children: [
            ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              controller: widget.scrollController,
              padding:
                  EdgeInsets.only(left: 22, right: 22, top: 60, bottom: 60),
              children: [
                Text(
                  "what is on your mind?",
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      fontSize: 14.0),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return "Enter a title for your innovation";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    // innovation.title = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: 'Name of you innovation',
                    labelStyle: TextStyle(
                        color: const Color(0xffc4c4c4),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Tell us about your innovation",
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      fontSize: 14.0),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return "Enter more details to your innovation";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    // innovation.about = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: 'Add details to your innovation',
                    labelStyle: TextStyle(
                        color: const Color(0xffc4c4c4),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Text(
                  "Add tags",
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      fontSize: 14.0),
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty)
                      return "Enter few tags";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    // innovation.tags = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    labelText: 'Add details to your innovation',
                    labelStyle: TextStyle(
                        color: const Color(0xffc4c4c4),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontSize: 14.0),
                  ),
                ),
                SizedBox(
                  height: 31,
                ),
                // OutlineButton(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(6)),
                //   onPressed: () {},
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "Add to your innovation",
                //         style: const TextStyle(
                //             color: const Color(0xff000000),
                //             fontWeight: FontWeight.w500,
                //             fontSize: 14.0),
                //       ),
                //       Row(
                //         children: [
                //           SvgPicture.asset("assets/svg/in-image.svg"),
                //           SizedBox(
                //             width: 12,
                //           ),
                //           SvgPicture.asset("assets/svg/in-video.svg")
                //         ],
                //       )
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 31,
                ),
                Text(
                  "Add to category",
                  style: const TextStyle(
                      color: const Color(0xff000000),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                      fontSize: 14.0),
                ),
                SizedBox(
                  height: 21,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                            width: 54,
                            height: 54,
                            padding: EdgeInsets.all(15),
                            child: SvgPicture.asset("assets/svg/in-home.svg"),
                            decoration:  BoxDecoration(
                              color: Color(0xff2cb9b0),
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x7f2cb9b0),
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                    spreadRadius: 0)
                              ],
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Home",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: 54,
                            height: 54,
                            padding: EdgeInsets.all(15),
                            child: SvgPicture.asset("assets/svg/in-school.svg"),
                            decoration:  BoxDecoration(
                              color: Color(0xff47a6ff),
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x7f47a6ff),
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                    spreadRadius: 0)
                              ],
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Text("School",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: 54,
                            height: 54,
                            padding: EdgeInsets.all(15),
                            child:
                                SvgPicture.asset("assets/svg/in-community.svg"),
                            decoration:  BoxDecoration(
                              color: Color(0xffc396ff),
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x7fc396ff),
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                    spreadRadius: 0)
                              ],
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Community",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                            width: 54,
                            height: 54,
                            padding: EdgeInsets.all(15),
                            child:
                                SvgPicture.asset("assets/svg/in-hobbies.svg"),
                            decoration:  BoxDecoration(
                              color: Color(0xfff0a35d),
                              borderRadius: BorderRadius.circular(17),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x7ff0a35d),
                                    offset: Offset(0, 4),
                                    blurRadius: 12,
                                    spreadRadius: 0)
                              ],
                            )),
                        SizedBox(
                          height: 4,
                        ),
                        Text("Hobbies",
                            style: TextStyle(
                              color: Color(0xff000000),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ))
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 31,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 34.0, right: 34, bottom: 16, top: 16),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24))),
                    onPressed: () {
                      handleInnovationSubmit();
                    },
                    color: Color(0xff6fcf97),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Submit your innovation",
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w600,
                                fontFamily: "Montserrat",
                                fontSize: 14.0),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.white,
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: Colors.white,
                alignment: Alignment.topCenter,
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Add your innovation",
                        style: const TextStyle(
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                            fontSize: 18.0),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              // panelController.close();
                            })
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleInnovationSubmit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // BlocProvider.of<InnovationCubit>(context).submitInnovation(innovation);
    }
  }
}
