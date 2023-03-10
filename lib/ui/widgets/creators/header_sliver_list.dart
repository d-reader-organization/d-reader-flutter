import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/follow_box.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/social_row.dart';
import 'package:d_reader_flutter/ui/widgets/creators/stats_box_row.dart';
import 'package:flutter/material.dart';

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
            cacheKey: 'banner ${creator.slug}',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CreatorAvatar(
                  avatar: creator.avatar,
                  slug: creator.slug,
                  height: 96,
                  width: 96,
                  radius: 64,
                ),
                AuthorVerified(
                  authorName: creator.name,
                  isVerified: creator.isVerified,
                  fontSize: 24,
                  mainAxisAlignment: MainAxisAlignment.center,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FollowBox(
                followersCount: creator.stats?.followersCount ?? 0,
                isFollowing: creator.myStats?.isFollowing ?? false,
                slug: creator.slug,
              ),
              const SocialRow(),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          StatsBoxRow(
            totalVolume: creator.stats?.totalVolume ?? 0,
            issuesCount: creator.stats?.comicIssuesCount ?? 0,
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DescriptionText(
              text: creator.description,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
