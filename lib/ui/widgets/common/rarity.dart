import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RarityWidget extends StatelessWidget {
  final bool isLarge;
  final String iconPath;
  final NftRarity rarity;
  const RarityWidget({
    super.key,
    required this.rarity,
    required this.iconPath,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return rarity == NftRarity.none
        ? const SizedBox()
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: isLarge ? 0 : 1,
            ),
            height: isLarge ? 40 : 24,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isLarge ? 6 : 4),
              border: Border.all(
                color: rarity.color,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: isLarge ? 14 : 10,
                  colorFilter: ColorFilter.mode(
                    rarity.color,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  rarity.name,
                  style: TextStyle(
                    fontSize: isLarge ? 14 : 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
  }
}
