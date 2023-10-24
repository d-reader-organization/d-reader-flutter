abstract class TransactionRepository {
  Future<List<dynamic>> mintOneTransaction({
    required String candyMachineAddress,
    required String minterAddress,
    String? label,
  });
  Future<String> signComicTransaction({
    required String nftAddress,
    required String signerAddress,
  });
  Future<String> useComicIssueNftTransaction({
    required String nftAddress,
    required String ownerAddress,
  });
  Future<String?> listTransaction({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String? printReceipt,
  });
  Future<String> privateBidTransaction({
    required String buyerAddress,
    required String mintAccount,
    required int price,
    String? sellerAddress,
    String? printReceipt,
  });
  Future<String?> instantBuyTransaction({
    required String mintAccount,
    required int price,
    required String sellerAddress,
    required String buyerAddress,
  });
  Future<List<String>> buyMultipleItems(Map<String, dynamic> query);
  Future<String> cancelBidTransaction({
    String? receiptAddress,
    String? nftAddress,
  });
  Future<String?> cancelListingTransaction({
    required String nftAddress,
  });
}
