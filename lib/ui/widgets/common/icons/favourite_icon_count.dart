import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
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
      onTap: slug != null || issueId != null
          ? () {
              if (issueId != null) {
                ref.read(favouritiseComicIssueProvider(issueId!));
                ref.invalidate(comicIssueDetailsProvider);
              } else if (slug != null) {
                ref.read(updateComicFavouriteProvider(slug!));
                ref.invalidate(comicSlugProvider);
              }
            }
          : null,
      child: isContainerWidget
          ? Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isFavourite
                    ? ColorPalette.dReaderRed.withOpacity(.4)
                    : ColorPalette.appBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isFavourite
                      ? Colors.transparent
                      : ColorPalette.boxBackground400,
                ),
              ),
              child: Row(
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
                    style: textTheme.labelMedium,
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
                  style: textTheme.labelMedium,
                ),
              ],
            ),
    );
  }
}
