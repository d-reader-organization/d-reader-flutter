import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    final favoriteNotifier = useState<bool>(isFavourite);
    final countNotifier = useState(favouritesCount);
    return GestureDetector(
      onTap: (slug != null || issueId != null) &&
              !ref.watch(privateLoadingProvider)
          ? () async {
              final loadingNotifier = ref.read(privateLoadingProvider.notifier);
              loadingNotifier.update((state) => true);
              favoriteNotifier.value = !favoriteNotifier.value;
              countNotifier.value = favoriteNotifier.value
                  ? ++countNotifier.value
                  : --countNotifier.value;
              if (issueId != null) {
                await ref
                    .read(comicIssueRepositoryProvider)
                    .favouritiseIssue(issueId!);
              } else if (slug != null) {
                await ref.read(updateComicFavouriteProvider(slug!).future);
              }
              loadingNotifier.update((state) => false);
            }
          : null,
      child: isContainerWidget
          ? Container(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 64, minHeight: 42),
              decoration: BoxDecoration(
                color: favoriteNotifier.value
                    ? ColorPalette.dReaderRed.withOpacity(.4)
                    : ColorPalette.appBackgroundColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: favoriteNotifier.value
                      ? Colors.transparent
                      : ColorPalette.greyscale300,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    favoriteNotifier.value
                        ? 'assets/icons/heart.svg'
                        : 'assets/icons/heart_light.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    Formatter.formatCount(countNotifier.value),
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
                  favoriteNotifier.value
                      ? 'assets/icons/heart.svg'
                      : 'assets/icons/heart_light.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  Formatter.formatCount(countNotifier.value),
                  style: textTheme.bodySmall?.copyWith(
                    color: ColorPalette.greyscale100,
                  ),
                ),
              ],
            ),
    );
  }
}
