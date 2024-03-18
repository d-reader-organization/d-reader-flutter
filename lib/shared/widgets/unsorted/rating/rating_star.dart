import 'package:d_reader_flutter/shared/presentations/providers/common/selected_rating_star_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RatingStar extends ConsumerWidget {
  final int index;
  const RatingStar({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedRatingStarIndex.notifier).state = index;
      },
      child: SvgPicture.asset(
        index <= ref.watch(selectedRatingStarIndex)
            ? 'assets/icons/star_bold.svg'
            : 'assets/icons/star_light.svg',
        width: 24,
        height: 24,
      ),
    );
  }
}
