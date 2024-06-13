import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mint_state.freezed.dart';

@freezed
sealed class MintState with _$MintState {
  const factory MintState.processing() = _Processing;
  const factory MintState.failed(String message) = _Failed;
  const factory MintState.success(String message) = _Success;
  const factory MintState.verificationNeeded() = _VerificationNeeded;
  const factory MintState.initialized() = _Initialized;
  const factory MintState.failedWithException(AppException exception) =
      _FailedWithException;
}