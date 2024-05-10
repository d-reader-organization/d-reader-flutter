class Receipt {
  final AssetReceipt partialAsset;
  final ReceiptBuyer buyer;
  final int price;
  final String timestamp;
  final String candyMachineAddress;

  Receipt({
    required this.partialAsset,
    required this.buyer,
    required this.price,
    required this.timestamp,
    required this.candyMachineAddress,
  });

  factory Receipt.fromJson(dynamic json) {
    return Receipt(
      partialAsset: AssetReceipt.fromJson(json['asset']),
      buyer: ReceiptBuyer.fromJson(json['buyer']),
      price: json['price'],
      timestamp: json['timestamp'],
      candyMachineAddress: json['candyMachineAddress'],
    );
  }
}

class AssetReceipt {
  final String address;
  final String name;

  AssetReceipt({
    required this.address,
    required this.name,
  });

  factory AssetReceipt.fromJson(dynamic json) {
    return AssetReceipt(
      address: json['address'],
      name: json['name'],
    );
  }
}

// This is same as Seller class
class ReceiptBuyer {
  final int? id;
  final String? avatar, name;
  final String address;

  ReceiptBuyer({
    required this.address,
    this.id,
    this.avatar,
    this.name,
  });

  factory ReceiptBuyer.fromJson(dynamic json) {
    return ReceiptBuyer(
      id: json['id'],
      address: json['address'],
      avatar: json['avatar'],
      name: json['name'],
    );
  }
}

class ReceiptsProviderArg {
  final String address;
  final String? query;

  ReceiptsProviderArg({
    required this.address,
    this.query = 'skip=0&take=10',
  });
}
