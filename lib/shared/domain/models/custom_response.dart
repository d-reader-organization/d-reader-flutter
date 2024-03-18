import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

class CustomResponse {
  final int statusCode;
  final String? statusMessage;
  final dynamic data;

  CustomResponse({
    required this.statusCode,
    this.statusMessage,
    this.data = const {},
  });
  @override
  String toString() {
    return 'statusCode=$statusCode\nstatusMessage=$statusMessage\n data=$data';
  }
}

extension ResponseExtension on CustomResponse {
  Right<AppException, CustomResponse> get toRight => Right(this);
}
