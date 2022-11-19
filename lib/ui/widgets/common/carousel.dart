import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/providers/carousel_provider.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                (carouselItem) => ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      16.0,
                    ),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 266,
                        width: double.infinity,
                        child: CommonCachedImage(
                          imageUrl: carouselItem.image,
                          cacheKey: '${carouselItem.id}${carouselItem.title}',
                        ),
                      ),
                      Positioned(
                        left: 16.0,
                        bottom: 60.0,
                        child: Text(
                          carouselItem.title,
                          style: textTheme.titleMedium,
                        ),
                      ),
                      Positioned(
                        left: 16.0,
                        bottom: 40,
                        child: Text(
                          carouselItem.title,
                          style: textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
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
