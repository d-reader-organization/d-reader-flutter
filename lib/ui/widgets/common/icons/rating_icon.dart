import 'package:d_reader_flutter/ui/widgets/common/confirmation_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/common/rating_stars.dart';
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
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return const ConfirmationDialog(
              title: 'Rate the episode',
              subtitle: 'Tap a star to give ratings!',
              additionalChild: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: RatingStars(),
              ),
            );
          },
        );
      },
      child: Row(
        children: [
          const Icon(
            Icons.star_outline_outlined,
            color: Colors.white,
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
      ),
    );
  }
}
