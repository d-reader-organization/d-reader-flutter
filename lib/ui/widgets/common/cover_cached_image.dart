import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CoverCachedImage extends StatelessWidget {
  final String imageUrl;
  const CoverCachedImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        height: 200,
        width: 200,
        color: Colors.grey,
      ),
      errorWidget: (context, url, error) => Container(
        height: 200,
        width: 200,
        color: Colors.red,
      ),
    );
  }
}
