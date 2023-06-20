class StatelessCover {
  final String artist, image;
  final String? rarity;
  final int? share;
  final bool isDefault;

  StatelessCover({
    required this.artist,
    required this.image,
    required this.isDefault,
    this.rarity,
    this.share,
  });

  factory StatelessCover.fromJson(dynamic json) {
    return StatelessCover(
      artist: json['artist'],
      isDefault: json['isDefault'],
      rarity: json['rarity'],
      image: json['image'],
      share: json['share'],
    );
  }
}
  // rarity
  // Common: 'Common',
  // Uncommon: 'Uncommon',
  // Rare: 'Rare',
  // Epic: 'Epic',
  // Legendary: 'Legendary'