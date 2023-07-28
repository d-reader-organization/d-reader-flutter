import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class AuthorVerified extends StatelessWidget {
  final String authorName;
  final double fontSize;
  final bool isVerified, displayFullName;
  final Color textColor;
  final MainAxisAlignment mainAxisAlignment;
  const AuthorVerified({
    Key? key,
    required this.authorName,
    required this.isVerified,
    this.fontSize = 12,
    this.textColor = Colors.white,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.displayFullName = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Expanded(
          child: Text(
            authorName,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: fontSize,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        const Icon(
          Icons.verified,
          color: ColorPalette.dReaderYellow100,
          size: 14,
        ),
      ],
    );
  }
}
