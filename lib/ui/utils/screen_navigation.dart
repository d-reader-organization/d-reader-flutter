import 'package:flutter/material.dart';

void nextScreenPush(BuildContext context, Widget page) {
  Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (BuildContext context, _, __) => page,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      }));
}

void nextScreenCloseOthers(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
