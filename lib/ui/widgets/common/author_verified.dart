import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class AuthorVerified extends StatelessWidget {
  final String authorName;
  final double fontSize;
  final bool isVerified;
  const AuthorVerified({
    Key? key,
    required this.authorName,
    required this.isVerified,
    this.fontSize = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          authorName,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: fontSize,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        isVerified
            ? const Icon(
                Icons.verified,
                color: ColorPalette.dReaderYellow100,
                size: 16,
              )
            : const SizedBox(),
      ],
    );
  }
}
