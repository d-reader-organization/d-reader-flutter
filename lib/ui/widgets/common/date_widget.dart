import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;

  const DateWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          Formatter.formatDate(date),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorPalette.greyscale100,
                letterSpacing: 1.2,
              ),
        )
      ],
    );
  }
}
