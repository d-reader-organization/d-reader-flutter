import 'package:d_reader_flutter/features/comic/domain/providers/comic_provider.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/favorites/favorites_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookmarkIcon extends ConsumerWidget {
  final bool isBookmarked;
  final String slug;
  const BookmarkIcon({
    super.key,
    required this.isBookmarked,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkNotifier =
        ref.watch(bookmarkSelectedProvider(isBookmarked).notifier);
    return GestureDetector(
      onTap: ref.watch(bookmarkLoadingProvider)
          ? null
          : () async {
              final loadingNotifier =
                  ref.read(bookmarkLoadingProvider.notifier);
              loadingNotifier.update((state) => true);
              bookmarkNotifier.update((state) => !state);
              await ref.read(comicRepositoryProvider).bookmarkComic(slug);
              loadingNotifier.update((state) => false);

              ref.invalidate(favoriteComicsProvider);
            },
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ref.watch(bookmarkSelectedProvider(isBookmarked))
              ? ColorPalette.dReaderGreen.withOpacity(.4)
              : Colors.transparent,
          border: Border.all(
            color: ref.watch(bookmarkSelectedProvider(isBookmarked))
                ? Colors.transparent
                : ColorPalette.greyscale300,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/bookmark_${ref.watch(bookmarkSelectedProvider(isBookmarked)) ? 'saved' : 'unsaved'}.svg',
              colorFilter: ColorFilter.mode(
                ref.watch(bookmarkSelectedProvider(isBookmarked))
                    ? ColorPalette.dReaderGreen
                    : ColorPalette.greyscale100,
                BlendMode.srcIn,
              ),
              width: 20,
              height: 20,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              'Favorite',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    letterSpacing: .2,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
