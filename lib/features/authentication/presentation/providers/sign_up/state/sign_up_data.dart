import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_data.freezed.dart';

@freezed
sealed class SignUpData with _$SignUpData {
  const factory SignUpData(
      {@Default('') String email,
      @Default('') String password,
      @Default('') String username,
      @Default('') String googleAccessToken,
      @Default(false) bool isSuccess}) = _SignUpData;
}
