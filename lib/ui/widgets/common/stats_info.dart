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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: isLastItem
            ? null
            : const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: 1,
                    color: Color(0xFF414756),
                  ),
                ),
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            statsWidget != null
                ? statsWidget!
                : Text(
                    stats,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
