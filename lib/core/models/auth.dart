class AuthWallet {
  String accessToken;
  String refreshToken;

  AuthWallet({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthWallet.fromJson(json) {
    return AuthWallet(
        accessToken: json['accessToken'], refreshToken: json['refreshToken']);
  }
}
