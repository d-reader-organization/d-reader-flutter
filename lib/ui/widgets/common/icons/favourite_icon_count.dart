import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavouriteIconCount extends HookConsumerWidget {
  final int favouritesCount;
  final bool isFavourite, isContainerWidget;
  final String? slug;
  final int? issueId;

  const FavouriteIconCount({
    Key? key,
    required this.favouritesCount,
    required this.isFavourite,
    this.slug,
    this.issueId,
    this.isContainerWidget = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: (slug != null || issueId != null) &&
              !ref.watch(privateLoadingProvider)
          ? () async {
              final loadingNotifier = ref.read(privateLoadingProvider.notifier);
              loadingNotifier.update((state) => true);
              if (issueId != null) {
                await ref
                    .read(comicIssueRepositoryProvider)
                    .favouritiseIssue(issueId!);
                ref.invalidate(comicIssueDetailsProvider);
                ref.invalidate(paginatedIssuesProvider);
              } else if (slug != null) {
                await ref.read(updateComicFavouriteProvider(slug!).future);
                ref.invalidate(comicSlugProvider);
              }
              loadingNotifier.update((state) => false);
            }
          : null,
      child: isContainerWidget
          ? Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 64),
              decoration: BoxDecoration(
                color: isFavourite
                    ? ColorPalette.dReaderRed.withOpacity(.4)
                    : ColorPalette.appBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFavourite
                      ? Colors.transparent
                      : ColorPalette.greyscale300,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFavourite
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: isFavourite
                        ? ColorPalette.dReaderRed
                        : ColorPalette.greyscale100,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    favouritesCount.toString(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: ColorPalette.greyscale100,
                      letterSpacing: .2,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Icon(
                  isFavourite
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: isFavourite
                      ? ColorPalette.dReaderRed
                      : ColorPalette.dReaderGrey,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  favouritesCount.toString(),
                  style: textTheme.bodySmall?.copyWith(
                    color: ColorPalette.greyscale100,
                  ),
                ),
              ],
            ),
    );
  }
}
