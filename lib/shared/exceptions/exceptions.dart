class NoWalletFoundException implements Exception {
  final String cause;
  NoWalletFoundException(this.cause);
}

class LowPowerModeException implements Exception {
  final String cause;
  LowPowerModeException(this.cause);
}

class BadRequestException implements Exception {
  final String cause;
  BadRequestException(this.cause);
}

class AppException implements Exception {
  final String message;
  final int statusCode;
  final String identifier;

  AppException({
    required this.message,
    required this.statusCode,
    required this.identifier,
  });
  @override
  String toString() {
    return 'statusCode=$statusCode\nmessage=$message\nidentifier=$identifier';
  }
}
