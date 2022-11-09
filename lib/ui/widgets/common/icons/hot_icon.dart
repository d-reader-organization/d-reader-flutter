import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class HotIcon extends StatelessWidget {
  const HotIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: dReaderYellow,
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            color: dReaderBlack,
          ),
          Text(
            'HOT',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: dReaderBlack,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
