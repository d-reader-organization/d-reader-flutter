import 'package:d_reader_flutter/core/models/nft.dart';

class OwnedComicIssue {
  final int id, number, ownedCopiesCount;
  final String title, slug, cover;
  final PartialNftModel? ownedNft;

  OwnedComicIssue({
    required this.id,
    required this.number,
    required this.ownedCopiesCount,
    required this.title,
    required this.slug,
    required this.cover,
    this.ownedNft,
  });

  factory OwnedComicIssue.fromJson(dynamic json) {
    return OwnedComicIssue(
      id: json['id'],
      number: json['number'],
      ownedCopiesCount: json['ownedCopiesCount'],
      title: json['title'],
      slug: json['slug'],
      cover: json['cover'],
      ownedNft: json['ownedNft'] != null
          ? PartialNftModel.fromJson(json['ownedNft'])
          : null,
    );
  }
}

class PartialNftModel {
  final String address, rarity;
  final bool isUsed, isSigned;
  final List<NftAttribute> attributes;

  PartialNftModel({
    required this.address,
    required this.rarity,
    required this.isSigned,
    required this.isUsed,
    required this.attributes,
  });

  factory PartialNftModel.fromJson(dynamic json) {
    return PartialNftModel(
      address: json['address'],
      rarity: json['rarity'],
      isSigned: json['isSigned'],
      isUsed: json['isUsed'],
      attributes: json['attributes'] != null
          ? List<NftAttribute>.from(
              json['attributes'].map(
                (item) => NftAttribute.fromJson(
                  item,
                ),
              ),
            )
          : [],
    );
  }
}
