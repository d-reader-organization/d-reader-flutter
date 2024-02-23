import 'package:d_reader_flutter/core/models/stateless_cover.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:flutter/material.dart';

class RaritiesWidget extends StatelessWidget {
  final List<StatelessCover> covers;
  const RaritiesWidget({
    super.key,
    required this.covers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 237,
      child: ListView.builder(
        itemCount: covers.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                CachedImageBgPlaceholder(
                  imageUrl: covers[index].image,
                  width: 137,
                  height: 197,
                ),
                const SizedBox(
                  height: 16,
                ),
                RarityWidget(
                  rarity: covers[index].rarity?.rarityEnum ?? NftRarity.none,
                  iconPath: 'assets/icons/rarity.svg',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
