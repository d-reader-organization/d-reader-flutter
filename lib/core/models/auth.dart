class AuthorizationResponse {
  String accessToken;
  String refreshToken;

  AuthorizationResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthorizationResponse.fromJson(json) {
    return AuthorizationResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
