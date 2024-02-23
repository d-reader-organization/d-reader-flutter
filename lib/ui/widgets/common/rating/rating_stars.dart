import 'package:d_reader_flutter/ui/widgets/common/rating/rating_star.dart';
import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        5,
        (index) => RatingStar(
          index: index,
        ),
      ),
    );
  }
}
