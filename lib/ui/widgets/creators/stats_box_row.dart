import 'package:d_reader_flutter/ui/widgets/creators/stats_box.dart';
import 'package:flutter/material.dart';

class StatsBoxRow extends StatelessWidget {
  final int totalVolume;
  final int issuesCount;
  const StatsBoxRow({
    Key? key,
    required this.totalVolume,
    required this.issuesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatsBox(
          title: 'TOTAL VOLUME',
          stats: '${totalVolume.toString()}K ◎',
        ),
        StatsBox(
          title: 'COMIC ISSUES',
          stats: issuesCount.toString(),
        ),
      ],
    );
  }
}
