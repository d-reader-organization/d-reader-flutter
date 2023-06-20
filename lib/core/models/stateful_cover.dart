class StatefulCover {
  final String artist, image;
  final bool isSigned, isUsed;
  final String? rarity;

  StatefulCover({
    required this.artist,
    required this.image,
    required this.isSigned,
    required this.isUsed,
    this.rarity,
  });

  factory StatefulCover.fromJson(dynamic json) {
    return StatefulCover(
      artist: json['artist'],
      isSigned: json['isSigned'],
      isUsed: json['isUsed'],
      rarity: json['rarity'],
      image: json['image'],
    );
  }
}
