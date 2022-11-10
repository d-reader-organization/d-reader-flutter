import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ContainerBannerBackground extends StatelessWidget {
  final String banner;
  const ContainerBannerBackground({super.key, required this.banner});

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
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(banner),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
