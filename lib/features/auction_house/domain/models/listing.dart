import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';

class ListingModel {
  final int id, price;
  final String assetAddress, name, cover, rarity, sellerAddress, tokenAddress;
  final List<DigitalAssetAttribute> attributes;
  final Seller seller;
  final bool isUsed;
  final bool isSigned;

  ListingModel({
    required this.id,
    required this.assetAddress,
    required this.name,
    required this.cover,
    required this.attributes,
    required this.sellerAddress,
    required this.tokenAddress,
    required this.seller,
    required this.price,
    required this.isUsed,
    required this.isSigned,
    required this.rarity,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
        id: json['id'],
        assetAddress: json['assetAddress'],
        name: json['name'],
        cover: json['cover'],
        attributes: List<DigitalAssetAttribute>.from(
          json['attributes'].map((x) => DigitalAssetAttribute.fromJson(x)),
        ),
        seller: Seller.fromJson(json['seller']),
        sellerAddress: json['sellerAddress'],
        tokenAddress: json['tokenAddress'],
        price: json['price'],
        isUsed: json['isUsed'],
        isSigned: json['isSigned'],
        rarity: json['rarity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['assetAddress'] = assetAddress;
    data['name'] = name;
    data['cover'] = cover;
    data['attributes'] = List<dynamic>.from(attributes.map((x) => x.toJson()));
    data['seller'] = seller.toJson();
    data['tokenAddress'] = tokenAddress;
    data['price'] = price;
    data['isUsed'] = isUsed;
    data['isSigned'] = isSigned;
    data['rarity'] = rarity;
    return data;
  }
}

class Attribute {
  String trait;
  String value;

  Attribute({
    required this.trait,
    required this.value,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
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

class Seller {
  final int? id;
  final String? avatar, displayName, username;

  Seller({
    this.id,
    this.avatar,
    this.displayName,
    this.username,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'],
      avatar: json['avatar'],
      displayName: json['displayName'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['avatar'] = avatar;
    data['displayName'] = displayName;
    data['username'] = username;
    return data;
  }
}

class ListingsProviderArg {
  final int issueId;
  final String query;

  ListingsProviderArg({
    required this.issueId,
    this.query = 'skip=0&take=10',
  });
}
