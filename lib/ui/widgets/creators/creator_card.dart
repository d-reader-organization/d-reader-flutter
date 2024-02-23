import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/utils/pluralize_string.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';

class CreatorCard extends StatelessWidget {
  final CreatorModel creator;
  const CreatorCard({
    super.key,
    required this.creator,
  });

  @override
  Widget build(BuildContext context) {
    final width = getCardWidth(MediaQuery.sizeOf(context).width);
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.creatorDetails}/${creator.slug}',
        );
      },
      child: Container(
        width: width,
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
                CachedImageBgPlaceholder(
                  imageUrl: creator.banner,
                  height: 83,
                  overrideBorderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(
                      8,
                    ),
                    topRight: Radius.circular(
                      8,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 4,
                    left: 4,
                    bottom: 5,
                    top: 8,
                  ),
                  child: Column(
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
                  child: CreatorAvatar(
                    avatar: creator.avatar,
                    slug: creator.slug,
                    width: 48,
                    height: 48,
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
