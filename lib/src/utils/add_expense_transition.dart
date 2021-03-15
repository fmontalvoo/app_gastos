import 'package:flutter/material.dart';

class AddExpenseTransition extends PageRouteBuilder {
  final Widget screen;
  final Widget background;

  AddExpenseTransition({this.screen, this.background})
      : super(
            transitionDuration: Duration(microseconds: 1),
            pageBuilder: (context, animation, secondaryAnimation) => screen,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) => Stack(
                      children: [
                        background,
                        screen,
                      ],
                    ));
}
