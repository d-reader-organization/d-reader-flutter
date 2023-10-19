class NoWalletFoundException implements Exception {
  final String cause;
  NoWalletFoundException(this.cause);
}

class LowPowerModeException implements Exception {
  final String cause;
  LowPowerModeException(this.cause);
}
