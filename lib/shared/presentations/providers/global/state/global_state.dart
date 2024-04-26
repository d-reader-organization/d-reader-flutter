import 'package:freezed_annotation/freezed_annotation.dart';

part 'global_state.freezed.dart';

@freezed
abstract class GlobalState with _$GlobalState {
  const factory GlobalState({
    required bool isLoading,
    @Default('') String signatureMessage,
  }) = _GlobalState;
}
