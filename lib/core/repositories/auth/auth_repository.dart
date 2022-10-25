abstract class AuthRepository {
  Future<bool> signIn();
  Future<bool> signOut();
}
