import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/library/cards/owned_comic_card.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class OwnedComicItems extends StatelessWidget {
  final String letter;
  final List<ComicModel> comics;
  const OwnedComicItems({
    super.key,
    required this.letter,
    required this.comics,
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
            itemCount: comics.length,
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
              return OwnedComicCard(cardWidth: cardWidth, comic: comics[index]);
            },
          ),
        ),
      ],
    );
  }
}

class LoadingOwnedComicItems extends StatelessWidget {
  const LoadingOwnedComicItems({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = getCardWidth(screenWidth);
    bool isTablet = screenWidth > 600;
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
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
                      ColorPalette.greyscale500,
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
      ),
    );
  }
}
