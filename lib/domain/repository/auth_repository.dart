import '../../data/model/user.dart';

abstract interface class AuthRepository {
  Future<User?> signUp(
    String username,
    String password,
    String name,
    String confirmPassword,
  );

  Future<void> signOut();
}
