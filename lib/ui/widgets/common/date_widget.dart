import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;
  const DateWidget({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_rounded,
          color: Colors.white,
          size: 12,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          Formatter.formatDate(date),
          style: Theme.of(context).textTheme.labelSmall,
        )
      ],
    );
  }
}
