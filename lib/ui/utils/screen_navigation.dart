import 'package:flutter/cupertino.dart';

void nextScreenPush(BuildContext context, Widget page) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(context,
      CupertinoPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(BuildContext context, Widget page) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => page));
}
