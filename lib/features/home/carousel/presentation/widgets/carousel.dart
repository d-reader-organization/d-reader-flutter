import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/features/home/carousel/domain/models/carousel.dart';
import 'package:d_reader_flutter/features/home/carousel/presentation/providers/carousel_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Carousel extends ConsumerWidget {
  const Carousel({super.key});
  final double carouselHeight = 360;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<CarouselModel>> carouselData = ref.watch(carouselProvider);
    TextTheme textTheme = Theme.of(context).textTheme;

    return carouselData.when(
      data: (data) {
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  ref
                      .read(sliderDotsIndicatorPosition.notifier)
                      .update((state) => index);
                },
                height: carouselHeight,
                viewportFraction: 1,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(
                  seconds: 5,
                ),
              ),
              items: data
                  .map(
                    (carouselItem) => GestureDetector(
                      onTap: () {
                        ref
                            .read(carouselControllerProvider.notifier)
                            .handleItemTap(
                              carouselItem: carouselItem,
                              context: context,
                            );
                      },
                      child: Stack(
                        children: [
                          CachedImageBgPlaceholder(
                            height: carouselHeight,
                            cacheHeight: carouselHeight.cacheSize(context),
                            cacheWidth: MediaQuery.sizeOf(context)
                                .width
                                .cacheSize(context),
                            imageUrl: carouselItem.image,
                            borderRadius: 0,
                            foregroundDecoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(31, 34, 42, 0.0),
                                  ColorPalette.appBackgroundColor,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.5579, 1],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            bottom: 20,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  carouselItem.title,
                                  textAlign: TextAlign.center,
                                  style: textTheme.headlineLarge,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  carouselItem.subtitle,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodySmall,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ref.watch(sliderDotsIndicatorPosition) == entry.key
                        ? const Color(0xFFD9D9D9)
                        : ColorPalette.greyscale400,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => const SkeletonCard(
        height: 320,
        width: double.infinity,
      ),
    );
  }
}
