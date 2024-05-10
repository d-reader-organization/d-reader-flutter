import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart' show Colors, Color;

extension RarityExtension on DigitalAssetRarity {
  static const rarityNames = {
    DigitalAssetRarity.none: 'None',
    DigitalAssetRarity.common: 'Common',
    DigitalAssetRarity.uncommon: 'Uncommon',
    DigitalAssetRarity.rare: 'Rare',
    DigitalAssetRarity.epic: 'Epic',
    DigitalAssetRarity.legendary: 'Legendary',
  };

  String get name => rarityNames[this] ?? 'None';

  static const rarityColors = {
    DigitalAssetRarity.none: Colors.transparent,
    DigitalAssetRarity.common: Colors.white,
    DigitalAssetRarity.uncommon: ColorPalette.dReaderYellow200,
    DigitalAssetRarity.rare: ColorPalette.dReaderLightGreen,
    DigitalAssetRarity.epic: ColorPalette.dReaderPink,
    DigitalAssetRarity.legendary: Color(0xFF8377F2),
  };

  Color get color => rarityColors[this] ?? Colors.white;
}

extension RarityFromString on String {
  static const rarities = {
    'None': DigitalAssetRarity.none,
    'Common': DigitalAssetRarity.common,
    'Uncommon': DigitalAssetRarity.uncommon,
    'Rare': DigitalAssetRarity.rare,
    'Epic': DigitalAssetRarity.epic,
    'Legendary': DigitalAssetRarity.legendary,
  };
  DigitalAssetRarity get rarityEnum =>
      rarities[this] ?? DigitalAssetRarity.none;
}
