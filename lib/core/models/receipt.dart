class Receipt {
  final ReceiptNft nft;
  final ReceiptBuyer buyer;
  final double price;
  final String timestamp;

  Receipt({
    required this.nft,
    required this.buyer,
    required this.price,
    required this.timestamp,
  });

  factory Receipt.fromJson(dynamic json) {
    return Receipt(
      nft: ReceiptNft.fromJson(json['nft']),
      buyer: ReceiptBuyer.fromJson(json['buyer']),
      price: json['price'] is int
          ? json['price'].toDouble()
          : double.parse(json['price']),
      timestamp: json['timestamp'],
    );
  }
}

class ReceiptNft {
  final String address;
  final String name;

  ReceiptNft({
    required this.address,
    required this.name,
  });

  factory ReceiptNft.fromJson(dynamic json) {
    return ReceiptNft(
      address: json['address'],
      name: json['name'],
    );
  }
}

class ReceiptBuyer {
  final String address;
  final String avatar;
  final String label;

  ReceiptBuyer({
    required this.address,
    required this.avatar,
    required this.label,
  });

  factory ReceiptBuyer.fromJson(dynamic json) {
    return ReceiptBuyer(
      address: json['address'],
      avatar: json['avatar'],
      label: json['label'],
    );
  }
}
