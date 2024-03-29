import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart' show Colors, Color;

extension RarityExtension on NftRarity {
  static const rarityNames = {
    NftRarity.none: 'None',
    NftRarity.common: 'Common',
    NftRarity.uncommon: 'Uncommon',
    NftRarity.rare: 'Rare',
    NftRarity.epic: 'Epic',
    NftRarity.legendary: 'Legendary',
  };

  String get name => rarityNames[this] ?? 'None';

  static const rarityColors = {
    NftRarity.none: Colors.transparent,
    NftRarity.common: Colors.white,
    NftRarity.uncommon: ColorPalette.dReaderYellow200,
    NftRarity.rare: Color(0xFF3926B4),
    NftRarity.epic: Color(0xFFC413E0),
    NftRarity.legendary: Color(0xFF8377F2),
  };

  Color get color => rarityColors[this] ?? Colors.white;
}

extension RarityFromString on String {
  static const rarities = {
    'None': NftRarity.none,
    'Common': NftRarity.common,
    'Uncommon': NftRarity.uncommon,
    'Rare': NftRarity.rare,
    'Epic': NftRarity.epic,
    'Legendary': NftRarity.legendary,
  };
  NftRarity get rarityEnum => rarities[this] ?? NftRarity.none;
}
