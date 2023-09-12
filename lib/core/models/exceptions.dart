class NoWalletFoundException implements Exception {
  final String cause;
  NoWalletFoundException(this.cause);
}
