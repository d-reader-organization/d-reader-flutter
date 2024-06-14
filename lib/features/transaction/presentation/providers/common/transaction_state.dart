import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_state.freezed.dart';

@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState.failed(String message) = _Failed;
  const factory TransactionState.failedWithException(AppException exception) =
      _FailedWithException;
  const factory TransactionState.initialized() = _Initialized;
  const factory TransactionState.processing() = _Processing;
  const factory TransactionState.success(String message) = _Success;
}

@freezed
sealed class TransactionApiResponse<T> with _$TransactionApiResponse<T> {
  const factory TransactionApiResponse.ok(T data) = _Ok;
  const factory TransactionApiResponse.error(String message) = _Error;
}

TransactionApiResponse<T> mapApiResponse<T>(Either<AppException, T> response) =>
    response.fold(
      (exception) => TransactionApiResponse.error(exception.message),
      (data) => TransactionApiResponse.ok(data),
    );
