import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {
  final DateTime date;
  const DateWidget({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String day = '0${date.day}'.substring(0, 2);
    String month = '0${date.month}'.substring(0, 2);
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
          '$day/$month/${date.year}',
          style: Theme.of(context).textTheme.labelSmall,
        )
      ],
    );
  }
}
