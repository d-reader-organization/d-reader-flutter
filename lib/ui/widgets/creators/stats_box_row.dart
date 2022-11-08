import 'package:d_reader_flutter/ui/widgets/creators/stats_box.dart';
import 'package:flutter/material.dart';

class StatsBoxRow extends StatelessWidget {
  const StatsBoxRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        StatsBox(
          title: 'TOTAL VOLUME',
          stats: '76.1K ◎',
        ),
        StatsBox(
          title: 'COMIC ISSUES',
          stats: '12',
        ),
      ],
    );
  }
}
