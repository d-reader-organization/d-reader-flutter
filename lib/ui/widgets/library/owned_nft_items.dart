import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class OwnedNftItems extends StatelessWidget {
  final String letter;
  final ComicModel comic;
  const OwnedNftItems({
    super.key,
    required this.letter,
    required this.comic,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = getCardWidth(screenWidth);
    bool isTablet = screenWidth > 600;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: GridView.builder(
            itemCount: 5,
            primary: false,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 190,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  // margin: const EdgeInsets.only(right: 16),
                  width: cardWidth,
                  constraints: const BoxConstraints(maxWidth: 190),
                  decoration: BoxDecoration(
                    color: ColorPalette.boxBackground200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedImageBgPlaceholder(
                        height: 125,
                        imageUrl: comic.cover,
                        // 'https://img.freepik.com/free-photo/cool-geometric-triangular-figure-neon-laser-light-great-backgrounds-wallpapers_181624-9331.jpg?w=2000',
                        opacity: .4,
                        overrideBorderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: comic.logo.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: comic.logo,
                              )
                            : null,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comic.title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${comic.stats?.issuesCount ?? 0} EP',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class LoadingOwnedNftItems extends StatelessWidget {
  const LoadingOwnedNftItems({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = getCardWidth(screenWidth);
    bool isTablet = screenWidth > 600;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: SkeletonAnimation(
            shimmerDuration: 1000,
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                color: ColorPalette.dReaderGrey,
              ),
              foregroundDecoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorPalette.boxBackground200,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0, 0.8],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: GridView.builder(
            itemCount: 5,
            primary: false,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 190,
            ),
            itemBuilder: (context, index) {
              return SkeletonCard(
                height: 190,
                width: cardWidth,
              );
            },
          ),
        ),
      ],
    );
  }
}
