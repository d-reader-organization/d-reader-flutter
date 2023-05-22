import 'package:d_reader_flutter/core/providers/app_bar/app_bar_visibility.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EReaderBottomNavigation extends ConsumerWidget {
  final int totalPages;

  const EReaderBottomNavigation({
    super.key,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      opacity: ref.watch(isAppBarVisibleProvider) ? 1 : 0,
      child: BottomAppBar(
        height: 50,
        padding: const EdgeInsets.all(16),
        color: ColorPalette.appBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                RatingIcon(rating: 4.9),
                SizedBox(
                  width: 8,
                ),
                FavouriteIconCount(
                  favouritesCount: 3229,
                  isFavourite: false,
                  slug: 'my-slug',
                ),
              ],
            )

            // Consumer(builder: (context, ref, child) {
            //   final currentEpisode = ref.watch(currentComicEpisodeProvider);
            //   return IconButton(
            //     icon: const Icon(
            //       Icons.arrow_back,
            //       color: Colors.white,
            //     ),
            //     onPressed: currentEpisode > 0
            //         ? () {
            //             ref.read(currentComicEpisodeProvider.notifier).state =
            //                 currentEpisode - 1;
            //           }
            //         : null,
            //   );
            // }),
            // Consumer(builder: (context, ref, child) {
            //   final currentPage = ref.watch(currentComicEpisodeProvider);
            //   return IconButton(
            //     icon: const Icon(
            //       Icons.arrow_forward,
            //       color: Colors.white,
            //     ),
            //     onPressed: currentPage < totalPages - 1
            //         ? () {
            //             ref.read(currentComicEpisodeProvider.notifier).state =
            //                 currentPage + 1;
            //           }
            //         : null,
            //   );
            // }),
          ],
        ),
      ),
    );
  }
}
