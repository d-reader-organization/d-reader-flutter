import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class AuthorVerified extends StatelessWidget {
  final String authorName;
  const AuthorVerified({
    Key? key,
    required this.authorName,
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
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        const Icon(
          Icons.verified,
          color: ColorPalette.dReaderYellow100,
          size: 16,
        ),
      ],
    );
  }
}
