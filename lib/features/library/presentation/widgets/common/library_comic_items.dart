import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/cards/library_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeleton_text/skeleton_text.dart';

class LibraryComicItems extends ConsumerWidget {
  final String letter;
  final List<ComicModel> comics;
  final bool isFavoriteTab;
  const LibraryComicItems({
    super.key,
    required this.letter,
    required this.comics,
    this.isFavoriteTab = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
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
              childAspectRatio: 140 / 195,
            ),
            itemBuilder: (context, index) {
              return LibraryCard(
                comic: comics[index],
                onTap: isFavoriteTab
                    ? () {
                        nextScreenPush(
                          context: context,
                          path:
                              '${RoutePath.comicDetails}/${comics[index].slug}',
                        );
                      }
                    : () {
                        ref
                            .read(selectedOwnedComicProvider.notifier)
                            .update((state) => comics[index]);
                      },
              );
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
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
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
                childAspectRatio: 140 / 195,
              ),
              itemBuilder: (context, index) {
                return const SkeletonCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
