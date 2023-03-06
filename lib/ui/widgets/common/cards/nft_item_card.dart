import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';

class NftItemCard extends StatelessWidget {
  final NftModel nft;
  const NftItemCard({
    super.key,
    required this.nft,
  });

  @override
  Widget build(BuildContext context) {
    return CachedImageBgPlaceholder(
      imageUrl: nft.image,
      cacheKey: '#-124',
      height: 190,
      overrideBorderRadius: BorderRadius.circular(12),
      bgImageFit: BoxFit.fill,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: ColorPalette.appBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            shortenNftName(nft.name),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
