import 'package:d_reader_flutter/ui/shared/app_colors.dart';
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
    final textTheme = Theme.of(context).textTheme;
    return CachedImageBgPlaceholder(
      imageUrl: imageUrl,
      cacheKey: '$comicName-$issueName',
      height: 396,
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorPalette.appBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comicName,
                style: textTheme.titleMedium?.copyWith(
                  color: ColorPalette.dReaderYellow100,
                ),
              ),
              Text(
                issueName,
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
