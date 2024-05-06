import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/models/stateless_cover.dart';
import 'package:d_reader_flutter/features/nft/presentation/utils/extensions.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/rarity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                GestureDetector(
                  onTap: () {
                    nextScreenPush(
                      context: context,
                      path: RoutePath.comicIssueCover,
                      extra: covers[index].image,
                    );
                  },
                  child: CachedImageBgPlaceholder(
                    imageUrl: covers[index].image,
                    width: 137,
                    height: 197,
                  ),
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
