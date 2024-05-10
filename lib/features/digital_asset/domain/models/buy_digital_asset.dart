class BuyDigitalAsset {
  final String mintAccount, sellerAddress, buyerAddress;
  final int price;

  BuyDigitalAsset({
    required this.mintAccount,
    required this.price,
    required this.sellerAddress,
    required this.buyerAddress,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mintAccount'] = mintAccount;
    data['sellerAddress'] = sellerAddress;
    data['buyerAddress'] = buyerAddress;
    data['price'] = price;
    return data;
  }
}
