import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class StatsBox extends StatelessWidget {
  final String title;
  final String stats;
  const StatsBox({
    Key? key,
    required this.title,
    required this.stats,
  }) : super(key: key);

  final textStyle = const TextStyle(
    fontSize: 13,
    color: ColorPalette.dReaderGrey,
    fontWeight: FontWeight.w700,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: ColorPalette.boxBackground300,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: textStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            stats,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
