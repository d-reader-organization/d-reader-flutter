import 'package:d_reader_flutter/features/digital_asset/presentation/utils/extensions.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RarityWidget extends StatelessWidget {
  final bool isLarge;
  final String iconPath;
  final DigitalAssetRarity rarity;
  const RarityWidget({
    super.key,
    required this.rarity,
    required this.iconPath,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return rarity == DigitalAssetRarity.none
        ? const SizedBox()
        : Container(
            padding: EdgeInsets.symmetric(
              horizontal: 6,
              vertical: isLarge ? 0 : 1,
            ),
            height: isLarge ? 40 : 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isLarge ? 6 : 4),
              border: Border.all(
                color: rarity.color,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
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
