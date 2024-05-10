class DigitalAssetModel {
  final List<DigitalAssetAttribute> attributes;
  final String address,
      comicName,
      comicIssueName,
      uri,
      image,
      name,
      description,
      rarity,
      ownerAddress;
  final double royalties;
  final bool isUsed, isSigned, isListed;
  final int comicIssueId;

  DigitalAssetModel({
    required this.attributes,
    required this.address,
    required this.uri,
    required this.image,
    required this.name,
    required this.description,
    required this.ownerAddress,
    required this.royalties,
    required this.isUsed,
    required this.isSigned,
    required this.comicName,
    required this.comicIssueName,
    required this.comicIssueId,
    required this.isListed,
    required this.rarity,
  });

  factory DigitalAssetModel.fromJson(dynamic json) {
    return DigitalAssetModel(
      attributes: json['attributes'] != null
          ? List<DigitalAssetAttribute>.from(
              json['attributes'].map(
                (item) => DigitalAssetAttribute.fromJson(
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
      ownerAddress: json['ownerAddress'],
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
