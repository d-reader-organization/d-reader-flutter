import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/genre_card.dart';
import 'package:d_reader_flutter/ui/widgets/search_bar.dart';
import 'package:d_reader_flutter/ui/widgets/section_heading.dart';
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
                                )
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
              height: 24,
            ),
            // Genres section
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
              loading: () => const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
