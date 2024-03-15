import 'package:flutter/material.dart';

class AuthorVerified extends StatelessWidget {
  final String authorName;
  final double fontSize;
  final bool isVerified, displayFullName;
  final Color textColor;
  final MainAxisAlignment mainAxisAlignment;

  const AuthorVerified({
    super.key,
    required this.authorName,
    required this.isVerified,
    this.fontSize = 12,
    this.textColor = Colors.white,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.displayFullName = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      authorName,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: textTheme.bodySmall?.copyWith(
        color: textColor,
      ),
    );
  }
}
