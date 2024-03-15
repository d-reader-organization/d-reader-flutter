class NoWalletFoundException extends AppException {
  NoWalletFoundException({
    super.statusCode = 500,
    super.identifier = '',
    required super.message,
  });
}

class LowPowerModeException extends AppException {
  LowPowerModeException({
    super.statusCode = 500,
    super.identifier = '',
    required super.message,
  });
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
