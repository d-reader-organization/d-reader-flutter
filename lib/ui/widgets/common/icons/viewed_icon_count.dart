import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class ViewedIconCount extends StatelessWidget {
  const ViewedIconCount({Key? key}) : super(key: key);

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
          '349',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: ColorPalette.dReaderGrey),
        )
      ],
    );
  }
}
