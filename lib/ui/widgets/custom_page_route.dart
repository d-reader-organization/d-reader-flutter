import 'package:flutter/material.dart';

class CustomPageRoute<T> extends PageRouteBuilder<Offset> {
  final Widget child;
  CustomPageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (
            BuildContext context,
            Animation animation,
            Animation secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation animation,
            Animation secondaryAnimation,
            Widget child,
          ) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            final tween = Tween(begin: begin, end: end);
            final offsetAnimation = animation.drive(tween);
            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}
