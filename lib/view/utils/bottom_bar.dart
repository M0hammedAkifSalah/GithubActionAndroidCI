import 'package:flutter/material.dart';
import '/export.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    this.icon,
    this.onPressed,
    @required this.title,
    this.check = true,
  });
  final String title;
  final IconData icon;
  final Function onPressed;
  final bool check;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomRaisedButton(
            onPressed: onPressed,
            title: title,
            icon: icon,
            check: check,
          ),
        ],
      ),
    );
  }
}

class CustomRaisedButton extends StatelessWidget {
  const CustomRaisedButton({
    Key key,
    @required this.onPressed,
    @required this.title,
    this.check = true,
    this.icon,
    this.bgColor,
    this.textColor,
    this.height,
    this.width,
  }) : super(key: key);

  final Function onPressed;
  final String title;
  final bool check;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      disabledColor: Colors.grey,
      elevation: 0,
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal: 25),
      onPressed: check ? onPressed ?? null : null,
      color: bgColor ?? const Color(0xffFFC30A),
      child: Container(
        width: width ?? 160,
        height:height?? 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: buildTextStyle(
                size: 15,
                family: 'Montserrat',
                color: textColor ?? Colors.black,
              ),
            ),
            Icon(
              icon ?? Icons.navigate_next,
              color: textColor ?? Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
