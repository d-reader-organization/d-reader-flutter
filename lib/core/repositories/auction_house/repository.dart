abstract class AuctionHouseRepository {
  Future<String?> listItem({
    required String mintAccount,
    required double price,
    String? printReceipt,
  });
}
