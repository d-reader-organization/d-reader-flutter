import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class ViewedIconCount extends StatelessWidget {
  final int viewedCount;
  const ViewedIconCount({
    Key? key,
    required this.viewedCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.remove_red_eye,
          color: Color(0xFFE0e0e0),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          viewedCount.toString(),
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: ColorPalette.dReaderGrey),
        )
      ],
    );
  }
}
