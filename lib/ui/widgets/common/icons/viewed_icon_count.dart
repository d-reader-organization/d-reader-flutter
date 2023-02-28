import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class ViewedIconCount extends StatelessWidget {
  final int viewedCount;
  final bool isViewed;
  const ViewedIconCount({
    Key? key,
    required this.viewedCount,
    required this.isViewed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isViewed ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
          color: const Color(0xFFE0e0e0),
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
