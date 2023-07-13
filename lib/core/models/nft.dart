class NftModel {
  //   export enum ComicRarity {
//     None = 'None',
//     Common = 'Common',
//     Uncommon = 'Uncommon',
//     Rare = 'Rare',
//     Epic = 'Epic',
//     Legendary = 'Legendary',
// }
  final List<NftAttribute> attributes;
  final String address,
      comicName,
      comicIssueName,
      uri,
      image,
      name,
      description,
      rarity,
      owner;
  final double royalties;
  final bool isUsed, isSigned, isListed;
  final int comicIssueId;

  NftModel({
    required this.attributes,
    required this.address,
    required this.uri,
    required this.image,
    required this.name,
    required this.description,
    required this.owner,
    required this.royalties,
    required this.isUsed,
    required this.isSigned,
    required this.comicName,
    required this.comicIssueName,
    required this.comicIssueId,
    required this.isListed,
    required this.rarity,
  });

  factory NftModel.fromJson(dynamic json) {
    return NftModel(
      attributes: json['attributes'] != null
          ? List<NftAttribute>.from(
              json['attributes'].map(
                (item) => NftAttribute.fromJson(
                  item,
                ),
              ),
            )
          : [],
      address: json['address'],
      uri: json['uri'],
      image: json['image'],
      name: json['name'],
      description: json['description'],
      owner: json['owner'],
      royalties: json['royalties'] is int
          ? json['royalties'].toDouble()
          : json['royalties'],
      isUsed: json['isUsed'],
      isSigned: json['isSigned'],
      comicName: json['comicName'],
      comicIssueName: json['comicIssueName'],
      comicIssueId: json['comicIssueId'],
      isListed: json['isListed'] ?? false,
      rarity: json['rarity'],
    );
  }
}

class NftAttribute {
  final String trait;
  final String value;

  NftAttribute({
    required this.trait,
    required this.value,
  });

  factory NftAttribute.fromJson(dynamic json) {
    return NftAttribute(
      trait: json['trait'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trait'] = trait;
    data['value'] = value;
    return data;
  }
}
