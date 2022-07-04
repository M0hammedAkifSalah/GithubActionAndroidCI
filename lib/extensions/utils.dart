import 'package:flutter/material.dart';

PageRouteBuilder<T> createRoute<T>({
  Widget pageWidget,
}) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) {
      return pageWidget;
    },
    transitionDuration: Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // return Align(
      //   child: SizeTransition(
      //     sizeFactor: animation,
      //     child: child,
      //     axisAlignment: 0.0,
      //   ),
      // );
      // return ScaleTransition(
      //   scale: animation,
      //   child: child,
      // );

      // return FadeTransition(
      //   opacity: animation,
      //   child: child,
      // );
      return SlideTransition(
        position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
            .animate(animation),
        child: child,
      );
    },
  );
}
