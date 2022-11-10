import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/providers/carousel_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Carousel extends ConsumerWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<CarouselModel>> carouselData = ref.watch(carouselProvider);
    return CarouselSlider(
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
                    child: Text(
                      'Studio NX',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
