abstract class AuthRepository {
  Future<dynamic> getOneTimePassword({
    required String address,
    required String apiUrl,
    required String jwtToken,
  });
  Future<void> connectWallet({
    required String address,
    required String encoding,
    required String apiUrl,
    required String jwtToken,
  });
  Future<void> disconnectWallet({
    required String address,
    required String apiUrl,
  });

  Future<dynamic>? signIn({
    required String nameOrEmail,
    required String password,
  });
  Future<dynamic>? signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<String>? refreshToken(String refreshToken);
}
