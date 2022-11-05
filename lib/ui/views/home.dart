import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/search_bar.dart';
import 'package:d_reader_flutter/ui/widgets/home/comic_card.dart';
import 'package:d_reader_flutter/ui/widgets/home/comic_issues_grid.dart';
import 'package:d_reader_flutter/ui/widgets/home/d_reader_scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/home/genre_card.dart';
import 'package:d_reader_flutter/ui/widgets/home/section_heading.dart';
import 'package:d_reader_flutter/ui/widgets/home/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/home/skeleton_genre_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<String> images = [
  'assets/images/featured.png',
];

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<GenreModel>> genres = ref.watch(genreProvider);
    AsyncValue<List<ComicModel>> comics = ref.watch(comicProvider);
    return DReaderScaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            const SearchBar(),
            const SizedBox(
              height: 24,
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 266.0,
                viewportFraction: 1,
                enlargeCenterPage: true,
              ),
              items: images
                  .map(
                    (img) => ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          16.0,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Image.asset(
                            img,
                          ),
                          Positioned(
                            left: 16.0,
                            bottom: 60.0,
                            child: Text(
                              'Rise Of The Gorecats',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ),
                          Positioned(
                            left: 16.0,
                            bottom: 40,
                            child: Row(
                              children: [
                                Text(
                                  'Studio NX',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Icon(
                                  Icons.verified,
                                  color: dReaderYellow,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 32,
            ),
            SectionHeading(
              title: AppLocalizations.of(context)?.genres ?? 'Genres',
            ),
            const SizedBox(
              height: 16,
            ),
            genres.when(
              data: (data) {
                return SizedBox(
                  height: 90,
                  child: ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GenreCard(
                        title: data[index].name,
                      );
                    },
                  ),
                );
              },
              error: (err, stack) => Text('Error: $err'),
              loading: () => SizedBox(
                height: 90,
                child: ListView.builder(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => const SkeletonGenreCard(),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            SectionHeading(
              title: AppLocalizations.of(context)?.newComics ?? 'New Comics',
            ),
            const SizedBox(
              height: 16,
            ),
            comics.when(
              data: (data) {
                return SizedBox(
                  height: 255,
                  child: ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => ComicCard(
                      title: data[index].name,
                      authorName: 'Studio NX',
                      likesCount: 49,
                      issuesCount: index + 2,
                    ),
                  ),
                );
              },
              error: (err, stack) => Text(
                'Error: $err',
                style: const TextStyle(color: Colors.red),
              ),
              loading: () => SizedBox(
                height: 90,
                child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => const SkeletonCard(),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            SectionHeading(
              title: AppLocalizations.of(context)?.popularIssues ??
                  'Popular Issues',
            ),
            const SizedBox(
              height: 16,
            ),
            const ComicIssuesGrid(),
            const SizedBox(
              height: 32,
            ),
            SectionHeading(
              title:
                  AppLocalizations.of(context)?.topCreators ?? 'Top Creators',
            ),
          ],
        ),
      ),
    );
  }
}
