class BuyNftInput {
  final String mintAccount, seller;
  final int price;

  BuyNftInput({
    required this.mintAccount,
    required this.price,
    required this.seller,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mintAccount'] = mintAccount;
    data['seller'] = seller;
    data['price'] = price;
    return data;
  }
}
