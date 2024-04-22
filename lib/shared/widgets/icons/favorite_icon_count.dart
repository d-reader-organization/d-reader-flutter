import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoriteIconCount extends HookConsumerWidget {
  final int favouritesCount;
  final bool isFavourite, isContainerWidget;
  final String? slug;
  final int? issueId;

  const FavoriteIconCount({
    super.key,
    required this.favouritesCount,
    required this.isFavourite,
    this.slug,
    this.issueId,
    this.isContainerWidget = false,
  });

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
              constraints: const BoxConstraints(minWidth: 64, minHeight: 42),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    isFavourite
                        ? 'assets/icons/heart.svg'
                        : 'assets/icons/heart_light.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    Formatter.formatCount(favouritesCount),
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
                SvgPicture.asset(
                  isFavourite
                      ? 'assets/icons/heart.svg'
                      : 'assets/icons/heart_light.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  Formatter.formatCount(favouritesCount),
                  style: textTheme.bodySmall?.copyWith(
                    color: ColorPalette.greyscale100,
                  ),
                ),
              ],
            ),
    );
  }
}
