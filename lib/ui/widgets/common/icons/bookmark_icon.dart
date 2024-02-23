import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/unsorted/bookmark_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
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
    return GestureDetector(
      onTap: ref.watch(bookmarkLoadingProvider)
          ? null
          : () async {
              final loadingNotifier =
                  ref.read(bookmarkLoadingProvider.notifier);
              loadingNotifier.update((state) => true);
              await ref.read(comicRepositoryProvider).bookmarkComic(slug);
              loadingNotifier.update((state) => false);
              ref.invalidate(comicSlugProvider);
            },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: isBookmarked
              ? ColorPalette.dReaderGreen.withOpacity(.4)
              : Colors.transparent,
          border: Border.all(
            color:
                isBookmarked ? Colors.transparent : ColorPalette.greyscale300,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/bookmark_${isBookmarked ? 'saved' : 'unsaved'}.svg',
              colorFilter: ColorFilter.mode(
                isBookmarked
                    ? ColorPalette.dReaderGreen
                    : ColorPalette.greyscale100,
                BlendMode.srcIn,
              ),
              width: 18,
              height: 18,
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
