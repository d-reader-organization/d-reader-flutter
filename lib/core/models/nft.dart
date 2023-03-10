class NftModel {
  final List<NftAttribute> attributes;
  final String address;
  final String uri;
  final String image;
  final String name;
  final String description;
  final String owner;
  final int royalties;
  final bool isMintCondition;
  final bool isSigned;
  final String comicName;
  final String comicIssueName;
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
    required this.isMintCondition,
    required this.isSigned,
    required this.comicName,
    required this.comicIssueName,
    required this.comicIssueId,
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
      royalties: json['royalties'],
      isMintCondition: json['isMintCondition'],
      isSigned: json['isSigned'],
      comicName: json['comicName'],
      comicIssueName: json['comicIssueName'],
      comicIssueId: json['comicIssueId'],
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
}

class WalletAsset {
  final String address;
  final String image;
  final String name;

  WalletAsset({
    required this.address,
    required this.image,
    required this.name,
  });

  factory WalletAsset.fromJson(dynamic json) {
    return WalletAsset(
      address: json['address'],
      image: json['image'],
      name: json['name'],
    );
  }
}
