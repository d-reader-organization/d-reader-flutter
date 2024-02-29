import 'dart:developer';
import 'dart:io';

import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:d_reader_flutter/shared/domain/models/custom_response.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

mixin ExceptionHandlerMixin on NetworkService {
  Future<Either<AppException, CustomResponse>>
      handleExceptionWrapper<T extends Object>({
    required Future<Response<dynamic>> Function() handler,
    String endpoint = '',
  }) async {
    try {
      final res = await handler();

      return Right(
        CustomResponse(
          statusCode: res.statusCode ?? 200,
          data: res.data,
          statusMessage: res.statusMessage,
        ),
      );
    } catch (exception) {
      String message = '', identifier = '';
      int statusCode = 500;
      log(exception.runtimeType.toString());

      if (exception is SocketException) {
        message = 'Unable to connect to the server.';
        statusCode = 500;
        identifier =
            'Socket Exception ${exception.message}\n at endpoint $endpoint';
      } else if (exception is DioException) {
        statusCode = exception.response?.statusCode ?? 500;
        identifier =
            'Dio Exception ${exception.message}\n at endpoint $endpoint';

        final exceptionMessage = exception.response?.data?['message'];
        message = exceptionMessage != null
            ? exceptionMessage is List
                ? exceptionMessage.join('. ')
                : exceptionMessage
            : exception.response?.data.toString();
      } else {
        message = 'Unknown error occurred';
        statusCode = 500;
        identifier = 'Unknown error ${exception.toString()}\n at $endpoint';
      }
      Sentry.captureException(exception, stackTrace: 'endpoint: $endpoint');
      return Left(
        AppException(
          message: message,
          statusCode: statusCode,
          identifier: identifier,
        ),
      );
    }
  }
}
