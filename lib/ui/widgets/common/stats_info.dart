import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class StatsInfo extends StatelessWidget {
  final String title;
  final String stats;
  final Widget? statsWidget;
  final bool isLastItem;
  const StatsInfo({
    super.key,
    required this.title,
    required this.stats,
    this.statsWidget,
    this.isLastItem = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        decoration: isLastItem
            ? null
            : const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 1,
                    color: ColorPalette.greyscale300,
                  ),
                ),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: textTheme.labelSmall?.copyWith(
                color: ColorPalette.greyscale200,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            statsWidget != null
                ? statsWidget!
                : Text(
                    stats,
                    style: textTheme.labelLarge,
                  ),
          ],
        ),
      ),
    );
  }
}
