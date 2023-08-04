class AuthSignInResponse {
  String accessToken;
  String refreshToken;

  AuthSignInResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthSignInResponse.fromJson(json) {
    return AuthSignInResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
