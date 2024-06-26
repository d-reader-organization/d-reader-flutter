import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/presentation/utils/utils.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';

class CreatorCard extends StatelessWidget {
  final CreatorModel creator;
  const CreatorCard({
    super.key,
    required this.creator,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.creatorDetails}/${creator.slug}',
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: creatorBannerAspectratio,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return unsupportedCacheTypesRegex.hasMatch(creator.banner)
                          ? Image.network(
                              creator.banner,
                            )
                          : CachedImageBgPlaceholder(
                              imageUrl: creator.banner,
                              cacheHeight:
                                  constraints.maxHeight.cacheSize(context),
                              cacheWidth:
                                  constraints.maxWidth.cacheSize(context),
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 4,
                      left: 4,
                      bottom: 5,
                      top: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          creator.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          '${creator.stats?.followersCount ?? 0} ${pluralizeString(
                            creator.stats?.followersCount ?? 0,
                            'Follower',
                          )}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: ColorPalette.greyscale100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 3,
                      color: ColorPalette.appBackgroundColor,
                    ),
                    color: ColorPalette.appBackgroundColor,
                    borderRadius: BorderRadius.circular(
                      64,
                    ),
                  ),
                  child: renderAvatar(
                    context: context,
                    creator: creator,
                    height: 48,
                    width: 48,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
