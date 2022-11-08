import 'package:flutter/material.dart';

class ImageGradientBackground extends StatelessWidget {
  const ImageGradientBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 196,
      padding: const EdgeInsets.only(bottom: 8),
      foregroundDecoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.transparent,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0, 1],
        ),
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/250?image=15',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
