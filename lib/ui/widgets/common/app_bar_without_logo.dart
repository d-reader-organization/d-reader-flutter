import 'package:flutter/material.dart';

class AppBarWithoutLogo extends StatelessWidget {
  final String? title;
  final Color backgroundColor;
  const AppBarWithoutLogo(
      {super.key, this.title, this.backgroundColor = Colors.transparent});

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
      actions: const [
        Icon(
          Icons.more_horiz_outlined,
          size: 16,
          color: Colors.white,
        ),
      ],
      backgroundColor: backgroundColor,
      shadowColor: Colors.transparent,
    );
  }
}
