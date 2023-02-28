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
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            color: const Color(0xFFb9b9b9),
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
