import 'package:flutter/material.dart';

class EpisodeCircle extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final double? height;
  const EpisodeCircle({
    Key? key,
    required this.text,
    this.color = Colors.white,
    this.fontSize = 12,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
