import 'package:d_reader_flutter/shared/domain/models/custom_response.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

abstract class NetworkService {
  String get baseUrl;

  Map<String, Object> get headers;

  Map<String, dynamic> updateHeader(Map<String, dynamic> data);

  Future<Either<AppException, CustomResponse>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  });

  Future<Either<AppException, CustomResponse>> post(
    String endpoint, {
    Map<String, dynamic>? data,
  });

  Future<Either<AppException, CustomResponse>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  });
}
