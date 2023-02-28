import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/providers/carousel_provider.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Carousel extends ConsumerWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<CarouselModel>> carouselData = ref.watch(carouselProvider);
    TextTheme textTheme = Theme.of(context).textTheme;
    return carouselData.when(
      data: (data) {
        return CarouselSlider(
          options: CarouselOptions(
            height: 266.0,
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(
              seconds: 5,
            ),
          ),
          items: data
              .map(
                (carouselItem) => Stack(
                  children: [
                    CachedImageBgPlaceholder(
                      height: 266,
                      imageUrl: carouselItem.image,
                      cacheKey: '${carouselItem.id}${carouselItem.title}',
                      foregroundDecoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.05, 0.3],
                        ),
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 20,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            carouselItem.title,
                            style: textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            carouselItem.title,
                            style: textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
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
    );
  }
}
