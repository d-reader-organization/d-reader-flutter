import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class RatingIcon extends StatelessWidget {
  final double rating;
  const RatingIcon({
    Key? key,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: ColorPalette.dReaderYellow100,
          size: 16,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          rating > 0.0 ? rating.toString() : '--',
          style: textTheme.labelMedium,
        ),
      ],
    );
  }
}
