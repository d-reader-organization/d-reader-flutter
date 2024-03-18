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
