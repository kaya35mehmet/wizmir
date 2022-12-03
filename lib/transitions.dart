import 'package:flutter/material.dart';

class ScaleTransitions extends PageRouteBuilder {
  final Widget page;

  ScaleTransitions(this.page)
      : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: const Duration(milliseconds: 1000),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          parent: animation,
          reverseCurve: Curves.fastOutSlowIn);
      return ScaleTransition(
        alignment: Alignment.topCenter,
        scale: animation,
        child: child,
      );
    },
  );
}