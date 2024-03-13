import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ViewedIconCount extends StatelessWidget {
  final int viewedCount;
  final bool isViewed;

  const ViewedIconCount({
    super.key,
    required this.viewedCount,
    required this.isViewed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/view_icon.svg',
          width: 16,
          height: 16,
          colorFilter: const ColorFilter.mode(
            Color(0xFFE0e0e0),
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          viewedCount.toString(),
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: ColorPalette.dReaderGrey),
        )
      ],
    );
  }
}
