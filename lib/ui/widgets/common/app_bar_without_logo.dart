import 'package:flutter/material.dart';

class AppBarWithoutLogo extends StatelessWidget {
  final String? title;
  final List<Widget> actions;
  final Color backgroundColor;
  const AppBarWithoutLogo({
    super.key,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.actions = const [
      Icon(
        Icons.more_horiz_outlined,
        size: 16,
        color: Colors.white,
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              '$title',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            )
          : null,
      centerTitle: true,
      actions: actions,
      backgroundColor: backgroundColor,
      shadowColor: Colors.transparent,
    );
  }
}

class AnimatedAppBar extends StatelessWidget {
  final Animation<Color?> animation;
  final String? title;
  final List<Widget> actions;
  const AnimatedAppBar({
    super.key,
    required this.animation,
    this.title,
    this.actions = const [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Icon(
          Icons.more_horiz_outlined,
          size: 16,
          color: Colors.white,
        ),
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final convertedTitle = title != null && title!.length > 20
        ? '${title!.substring(0, 20)}...'
        : title;
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return AppBar(
            title: title != null
                ? Text(
                    '$convertedTitle',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : null,
            centerTitle: true,
            actions: actions,
            backgroundColor: animation.value,
            shadowColor: animation.value,
          );
        });
  }
}
