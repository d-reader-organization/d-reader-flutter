abstract class TransactionRepository {
  Future<List<dynamic>> mintOneTransaction({
    required String candyMachineAddress,
    required String minterAddress,
    String? label,
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
  Future<List<String>> buyMultipleItems(Map<String, dynamic> query);
  Future<String?> cancelListingTransaction({
    required String nftAddress,
  });
}
