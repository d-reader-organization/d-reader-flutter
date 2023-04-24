class BuyNftInput {
  final String mintAccount, sellerAddress;
  final int price;

  BuyNftInput({
    required this.mintAccount,
    required this.price,
    required this.sellerAddress,
  });
}
