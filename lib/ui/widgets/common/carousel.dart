import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> images = [
  'assets/images/featured.png',
];

class Carousel extends StatelessWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
