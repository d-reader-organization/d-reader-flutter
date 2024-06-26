import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/custom_response.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/mixins/exception_handler_mixin.dart';
import 'package:dio/dio.dart';

class DioNetworkService extends NetworkService with ExceptionHandlerMixin {
  final Dio dio;

  DioNetworkService({
    required this.dio,
  });

  @override
  String get baseUrl => dio.options.baseUrl;

  @override
  Map<String, Object> get headers => {
        'accept': 'application/json',
        'content-type': 'application/json',
      };

  @override
  Map<String, dynamic> updateHeader(Map<String, dynamic> data) {
    final header = {...data, ...headers};
    dio.options.headers = header;
    return header;
  }

  @override
  Future<Either<AppException, CustomResponse>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) {
    return handleExceptionWrapper(
      endpoint: endpoint,
      handler: () {
        return dio.get(endpoint, queryParameters: queryParams);
      },
    );
  }

  @override
  Future<Either<AppException, CustomResponse>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) {
    return handleExceptionWrapper(
      endpoint: endpoint,
      handler: () {
        return dio.post(
          endpoint,
          data: data,
          options: Options(headers: headers),
        );
      },
    );
  }

  @override
  Future<Either<AppException, CustomResponse>> patch(
    String endpoint, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, dynamic>? headers,
  }) {
    return handleExceptionWrapper(
      endpoint: endpoint,
      handler: () {
        return dio.patch(
          endpoint,
          data: data ?? formData,
          options: Options(headers: headers),
        );
      },
    );
  }
}
