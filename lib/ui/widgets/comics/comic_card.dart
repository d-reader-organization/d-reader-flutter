import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/utils/pluralize_string.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicCard extends ConsumerWidget {
  final ComicModel comic;
  const ComicCard({
    super.key,
    required this.comic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final double cardWidth = getCardWidth(MediaQuery.sizeOf(context).width);
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.comicDetails}/${comic.slug}',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        width: cardWidth,
        constraints: const BoxConstraints(maxWidth: 190),
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedImageBgPlaceholder(
                  imageUrl: comic.cover,
                  width: cardWidth,
                  height: 134,
                  opacity: .4,
                  padding: EdgeInsets.zero,
                  overrideBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      8,
                    ),
                    topRight: Radius.circular(
                      8,
                    ),
                  ),
                ),
                Positioned.fill(
                  top: 0,
                  left: 0,
                  child: Stack(
                    children: [
                      comic.isPopular ? const HotIconSmall() : const SizedBox(),
                      comic.logo.isNotEmpty
                          ? Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: comic.logo,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comic.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textTheme.titleMedium,
                        ),
                        AuthorVerified(
                          authorName: comic.creator?.name ?? '',
                          isVerified: comic.creator?.isVerified ?? false,
                          fontSize: 14,
                          textColor: ColorPalette.greyscale100,
                        ),
                      ],
                    ),
                    Text(
                      '${comic.stats?.issuesCount ?? 0} ${pluralizeString(comic.stats?.issuesCount ?? 0, 'EP')}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
