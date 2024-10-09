class MintedAsset {
  final String address, image, name, rarity;
  final bool isUsed, isSigned;

  MintedAsset({
    required this.address,
    required this.image,
    required this.name,
    required this.rarity,
    required this.isUsed,
    required this.isSigned,
  });

  factory MintedAsset.fromJson(dynamic json) => MintedAsset(
        address: json['address'],
        image: json['image'],
        name: json['name'],
        rarity: json['name'],
        isUsed: json['isUsed'],
        isSigned: json['isSigned'],
      );
}

class AsssetMintedDataModel {
  final List<MintedAsset> assets;

  AsssetMintedDataModel({
    required this.assets,
  });

  AsssetMintedDataModel.fromJson(dynamic json)
      : assets = List<MintedAsset>.from(
          json['assets'].map(
            (asset) => MintedAsset.fromJson(asset),
          ),
        );
}
