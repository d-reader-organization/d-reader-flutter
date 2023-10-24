import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/follow_box.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/social_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatorDetailsHeaderSliverList extends StatelessWidget {
  final CreatorModel creator;
  const CreatorDetailsHeaderSliverList({
    super.key,
    required this.creator,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          CachedImageBgPlaceholder(
            height: 250,
            imageUrl: creator.banner,
            borderRadius: 0,
            foregroundDecoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorPalette.appBackgroundColor,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0, 1.05],
              ),
            ),
          ),
          Positioned.fill(
            child: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CreatorAvatar(
                  avatar: creator.avatar,
                  slug: creator.slug,
                  height: 96,
                  width: 96,
                  radius: 64,
                ),
                Text(
                  creator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsDescriptionWidget extends StatelessWidget {
  final CreatorModel creator;
  const StatsDescriptionWidget({
    super.key,
    required this.creator,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: ColorPalette.greyscale400,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/coin.svg',
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    FollowBox(
                      followersCount: creator.stats?.followersCount ?? 0,
                      isFollowing: creator.myStats?.isFollowing ?? false,
                      slug: creator.slug,
                    ),
                  ],
                ),
                SocialRow(
                  creator: creator,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                DescriptionText(
                  text: creator.description,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 8,
                ),
                const Divider(
                  thickness: 1,
                  color: ColorPalette.greyscale400,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StatsBoxContainer(
                        title: 'TOTAL VOLUME',
                        value: creator.stats?.totalVolume != null
                            ? formatPriceWithSignificant(
                                creator.stats!.totalVolume,
                              )
                            : '-',
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        thickness: 1,
                        color: ColorPalette.greyscale400,
                      ),
                    ),
                    Expanded(
                      child: StatsBoxContainer(
                        title: 'COMIC ISSUES',
                        value: '${creator.stats?.comicIssuesCount ?? '-'}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsBoxContainer extends StatelessWidget {
  final String title, value;
  const StatsBoxContainer({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: ColorPalette.greyscale200,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
