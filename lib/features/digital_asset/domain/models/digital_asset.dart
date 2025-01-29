class CollectibleComicModel {
  final String address,
      comicTitle,
      comicIssueTitle,
      image,
      name,
      description,
      rarity,
      ownerAddress;
  final double royalties;
  final bool isUsed, isSigned, isListed;
  final int comicIssueId;

  CollectibleComicModel({
    required this.address,
    required this.image,
    required this.name,
    required this.description,
    required this.ownerAddress,
    required this.royalties,
    required this.isUsed,
    required this.isSigned,
    required this.comicTitle,
    required this.comicIssueTitle,
    required this.comicIssueId,
    required this.isListed,
    required this.rarity,
  });

  factory CollectibleComicModel.fromJson(dynamic json) {
    return CollectibleComicModel(
      address: json['address'],
      image: json['image'],
      name: json['name'],
      description: json['description'] ?? '',
      ownerAddress: json['ownerAddress'],
      royalties: json['royalties'] is int
          ? json['royalties'].toDouble()
          : json['royalties'],
      isUsed: json['isUsed'],
      isSigned: json['isSigned'],
      comicTitle: json['comicTitle'] ?? '',
      comicIssueTitle: json['comicIssueTitle'] ?? '',
      comicIssueId: json['comicIssueId'],
      isListed: json['isListed'] ?? false,
      rarity: json['rarity'],
    );
  }
}

class DigitalAssetAttribute {
  final String trait;
  final String value;

  DigitalAssetAttribute({
    required this.trait,
    required this.value,
  });

  factory DigitalAssetAttribute.fromJson(dynamic json) {
    return DigitalAssetAttribute(
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
