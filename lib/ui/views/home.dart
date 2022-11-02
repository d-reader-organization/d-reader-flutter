import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<String> images = [
  'assets/images/featured.png',
];

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DReaderScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SearchBar(),
            CarouselSlider(
              options: CarouselOptions(
                height: 266.0,
                viewportFraction: 0.9,
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
              height: 8,
            ),
            const SizedBox(
              height: 8,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
