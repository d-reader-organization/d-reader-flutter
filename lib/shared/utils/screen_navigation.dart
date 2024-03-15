import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void nextScreenPush({
  required BuildContext context,
  required String path,
  bool homeSubRoute = true,
  Object? extra,
}) {
  context.push(homeSubRoute ? '/$path' : path, extra: extra);
}

void nextScreenCloseOthers({
  required BuildContext context,
  required String path,
}) {
  while (context.canPop()) {
    context.pop();
  }
  context.pushReplacement(path);
}

void nextScreenReplace({
  required BuildContext context,
  required String path,
  required bool homeSubRoute,
  Object? extra,
}) {
  context.pushReplacement(
    homeSubRoute ? '/$path' : path,
    extra: extra,
  );
}
