import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/texts/author_verified.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/icons/hot_icon.dart';
import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final ComicModel comic;
  const ComicCard({
    super.key,
    required this.comic,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.comicDetails}/${comic.slug}',
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _ComicCoverStack(
                comic: comic,
              ),
            ),
            _ComicInfoContainer(comic: comic),
          ],
        ),
      ),
    );
  }
}

class _ComicCoverStack extends StatelessWidget {
  final ComicModel comic;
  const _ComicCoverStack({
    required this.comic,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: comicAspectRatio,
          child: LayoutBuilder(builder: (context, constraint) {
            return CachedImageBgPlaceholder(
              width: constraint.maxWidth.toDouble(),
              cacheHeight: constraint.maxHeight.cacheSize(context),
              cacheWidth: constraint.maxWidth.cacheSize(context),
              imageUrl: comic.cover,
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
            );
          }),
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
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: AspectRatio(
                        aspectRatio: comicLogoAspectRatio,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return CachedNetworkImage(
                            imageUrl: comic.logo,
                            memCacheHeight:
                                (constraints.maxHeight * .6).cacheSize(context),
                          );
                        }),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ComicInfoContainer extends StatelessWidget {
  final ComicModel comic;
  const _ComicInfoContainer({required this.comic});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            comic.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: textTheme.titleMedium,
          ),
          const SizedBox(
            height: 4,
          ),
          AuthorVerified(
            authorName: comic.creator?.name ?? '',
            isVerified: comic.creator?.isVerified ?? false,
            fontSize: 14,
            textColor: ColorPalette.greyscale100,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${comic.stats?.issuesCount ?? 0} ${pluralizeString(comic.stats?.issuesCount ?? 0, 'EP')}',
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
