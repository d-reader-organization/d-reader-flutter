import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/favorites/favorites_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/utils/utils.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/common/library_comic_items.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FavoritesTab extends ConsumerWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(favoriteComicsProvider);
    return provider.when(
      data: (data) {
        if (data.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/bunny_in_the_hole.svg'),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Nothing to see in here!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Favoritize comic first',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.greyscale100,
                ),
              ),
            ],
          );
        }
        return FavoriteComicsListBuilder(comics: data);
      },
      error: (error, stackTrace) {
        return const CarrotErrorWidget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
      },
      loading: () {
        return const LoadingOwnedComicItems();
      },
      onGoingLoading: (items) {
        return FavoriteComicsListBuilder(comics: items);
      },
      onGoingError: (items, Object? e, StackTrace? stk) {
        return FavoriteComicsListBuilder(comics: items);
      },
    );
  }
}

class FavoriteComicsListBuilder extends ConsumerWidget {
  final List<ComicModel> comics;
  const FavoriteComicsListBuilder({
    super.key,
    required this.comics,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, int> sortedLetters = sortAndGetLetterOccurences([...comics]);
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.1;
          if (maxScroll - currentScroll <= delta) {
            ref.read(favoriteComicsProvider.notifier).fetchNext();
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (ref.watch(environmentProvider).user?.id != null) {
            ref.invalidate(favoriteComicsProvider);
          }
        },
        backgroundColor: ColorPalette.dReaderYellow100,
        color: ColorPalette.appBackgroundColor,
        child: ListView.separated(
          itemCount: sortedLetters.keys.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final (startAt, endAtLimit) =
                getSublistBorders(sortedLetters, index);
            return Container(
              margin: const EdgeInsets.only(
                top: 16,
                bottom: 16,
              ),
              child: LibraryComicItems(
                letter: sortedLetters.keys.elementAt(index),
                comics: comics.sublist(
                  startAt,
                  endAtLimit,
                ),
                isFavoriteTab: true,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              thickness: 1,
              color: ColorPalette.greyscale400,
            );
          },
        ),
      ),
    );
  }
}
