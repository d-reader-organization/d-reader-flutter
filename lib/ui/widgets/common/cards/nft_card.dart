import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';

class NfTCard extends StatelessWidget {
  final String imageUrl;
  final String comicName;
  final String issueName;
  const NfTCard({
    super.key,
    required this.imageUrl,
    required this.comicName,
    required this.issueName,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 338 / 232,
      child: CachedImageBgPlaceholder(
        imageUrl: imageUrl,
        bgImageFit: BoxFit.scaleDown,
        placeholder: const SizedBox(),
      ),
    );
  }
}
