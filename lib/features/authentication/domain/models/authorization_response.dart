import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorization_response.freezed.dart';
part 'authorization_response.g.dart';

@freezed
class AuthorizationResponse with _$AuthorizationResponse {
  const factory AuthorizationResponse({
    required String accessToken,
    required String refreshToken,
  }) = _AuthorizationResponse;

  factory AuthorizationResponse.fromJson(Map<String, Object?> json) =>
      _$AuthorizationResponseFromJson(json);
}
