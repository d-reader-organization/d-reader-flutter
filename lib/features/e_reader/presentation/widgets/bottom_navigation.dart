import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/providers/e_reader_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/icons/favorite_icon_count.dart';
import 'package:d_reader_flutter/shared/widgets/icons/rating_icon.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/widgets/reading_mode_icon.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EReaderBottomNavigation extends ConsumerWidget {
  final int totalPages, favouritesCount, issueId;
  final double rating;
  final bool isFavourite;
  const EReaderBottomNavigation({
    super.key,
    required this.totalPages,
    required this.issueId,
    required this.rating,
    required this.favouritesCount,
    required this.isFavourite,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(comicIssueDetailsProvider(issueId));

    return provider.maybeWhen(
      orElse: () {
        return Container(
          height: 50,
          color: ColorPalette.appBackgroundColor,
        );
      },
      data: (issue) {
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
                  children: [
                    RatingIcon(
                      initialRating: issue.stats?.averageRating ?? 0,
                      issueId: issueId,
                      isRatedByMe: issue.myStats?.rating != null,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    FavoriteIconCount(
                      favouritesCount: favouritesCount,
                      isFavourite: isFavourite,
                      issueId: issueId,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ReadingModeIcon(
                      isActive: !ref.watch(isPageByPageReadingMode),
                      iconPath: 'assets/icons/scroll_icon.svg',
                      onTap: () {
                        ref
                            .read(isPageByPageReadingMode.notifier)
                            .update((state) => false);
                      },
                    ),
                    Switch(
                      value: ref.watch(isPageByPageReadingMode),
                      activeTrackColor: ColorPalette.greyscale300,
                      activeColor: Colors.white,
                      trackColor: const MaterialStatePropertyAll<Color>(
                        ColorPalette.greyscale300,
                      ),
                      onChanged: (value) {
                        ref
                            .read(isPageByPageReadingMode.notifier)
                            .update((state) => value);
                      },
                    ),
                    ReadingModeIcon(
                      isActive: ref.watch(isPageByPageReadingMode),
                      iconPath: 'assets/icons/page_by_page.svg',
                      onTap: () {
                        ref
                            .read(isPageByPageReadingMode.notifier)
                            .update((state) => true);
                      },
                    ),
                  ],
                ),
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
      },
    );
  }
}
