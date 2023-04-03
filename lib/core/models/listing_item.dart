import 'package:d_reader_flutter/core/models/nft.dart';

class ListingItemModel {
  final int id;
  final String nftAddress;
  final String name;
  final String cover;
  final List<NftAttribute> attributes;
  final Seller seller;
  final String tokenAddress;
  final int price;
  final bool isUsed;
  final bool isSigned;

  ListingItemModel({
    required this.id,
    required this.nftAddress,
    required this.name,
    required this.cover,
    required this.attributes,
    required this.seller,
    required this.tokenAddress,
    required this.price,
    required this.isUsed,
    required this.isSigned,
  });

  factory ListingItemModel.fromJson(Map<String, dynamic> json) {
    return ListingItemModel(
      id: json['id'],
      nftAddress: json['nftAddress'],
      name: json['name'],
      cover: json['cover'],
      attributes: List<NftAttribute>.from(
        json['attributes'].map((x) => NftAttribute.fromJson(x)),
      ),
      seller: Seller.fromJson(json['seller']),
      tokenAddress: json['tokenAddress'],
      price: json['price'],
      isUsed: json['isUsed'],
      isSigned: json['isSigned'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nftAddress'] = nftAddress;
    data['name'] = name;
    data['cover'] = cover;
    data['attributes'] = List<dynamic>.from(attributes.map((x) => x.toJson()));
    data['seller'] = seller.toJson();
    data['tokenAddress'] = tokenAddress;
    data['price'] = price;
    data['isUsed'] = isUsed;
    data['isSigned'] = isSigned;
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
  String address;
  String avatar;
  String label;

  Seller({
    required this.address,
    required this.avatar,
    required this.label,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      address: json['address'],
      avatar: json['avatar'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['avatar'] = avatar;
    data['label'] = label;
    return data;
  }
}

List<ListingItemModel> dummyData = [
  ListingItemModel(
    id: 123,
    nftAddress: "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
    name: "My NFT",
    cover:
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    attributes: [
      NftAttribute(trait: "used", value: "true"),
      NftAttribute(trait: "signed", value: "true"),
    ],
    seller: Seller(
      address: "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
      avatar: "",
      label: "Custom",
    ),
    tokenAddress: "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
    price: 1000000000,
    isUsed: true,
    isSigned: true,
  ),
  ListingItemModel(
    id: 123,
    nftAddress: "dsadasdasdsa323131",
    name: "My NFT",
    cover:
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    attributes: [
      NftAttribute(trait: "used", value: "false"),
      NftAttribute(trait: "signed", value: "true"),
    ],
    seller: Seller(
      address: "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
      avatar: "",
      label: "Custom",
    ),
    tokenAddress: "dsadasdasdsa323131",
    price: 1230000000,
    isUsed: false,
    isSigned: true,
  ),
  ListingItemModel(
    id: 123,
    nftAddress: "12321321xcxc",
    name: "My NFT",
    cover:
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    attributes: [
      NftAttribute(trait: "used", value: "true"),
      NftAttribute(trait: "signed", value: "false"),
    ],
    seller: Seller(
      address: "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
      avatar: "",
      label: "Custom",
    ),
    tokenAddress: "12321321xcxc",
    price: 1230000000,
    isUsed: true,
    isSigned: false,
  )
];
