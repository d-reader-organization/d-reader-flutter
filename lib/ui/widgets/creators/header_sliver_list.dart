import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/social_row.dart';
import 'package:d_reader_flutter/ui/widgets/creators/stats_box_row.dart';
import 'package:flutter/material.dart';

class HeaderSliverList extends StatelessWidget {
  final CreatorModel creator;
  const HeaderSliverList({
    super.key,
    required this.creator,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: creator.banner,
                imageBuilder: (context, imageProvider) => Container(
                  height: 196,
                  padding: const EdgeInsets.only(bottom: 8),
                  foregroundDecoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0, 1],
                    ),
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 196,
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Container(
                  height: 196,
                  color: Colors.red,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CreatorAvatar(
                    avatar: creator.avatar,
                    slug: creator.slug,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                creator.name,
                style: textTheme.headlineLarge,
              ),
              const SizedBox(
                width: 10,
              ),
              const Icon(
                Icons.verified,
                color: ColorPalette.dReaderYellow100,
                size: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    width: 1,
                    color: ColorPalette.boxBackground300,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      size: 20,
                      color: ColorPalette.dReaderGrey,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      'Follow',
                      style: textTheme.labelMedium?.copyWith(
                        color: ColorPalette.dReaderGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          9,
                        ),
                        color: ColorPalette.boxBackground300,
                      ),
                      child: Text(
                        '124',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: ColorPalette.dReaderGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    )
                  ],
                ),
              ),
              const SocialRow(),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          StatsBoxRow(
            totalVolume: creator.stats.totalVolume,
            issuesCount: creator.stats.comicIssuesCount,
          ),
          const SizedBox(
            height: 24,
          ),
          DescriptionText(text: creator.description),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}
