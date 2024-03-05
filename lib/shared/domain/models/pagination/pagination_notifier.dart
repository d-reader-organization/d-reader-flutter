abstract class IPaginationNotifier {
  void init();
  Future<void> fetchNext();
  Future<void> initialFetch();
  String buildQueryString();
}
