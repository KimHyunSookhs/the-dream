import 'package:front_mission/data/model/auth_tokens.dart';

import '../../data/model/user.dart';

abstract interface class AuthRepository {
  Future<User?> signUp(
    String username,
    String password,
    String name,
    String confirmPassword,
  );

  Future<String?> getJwtToken(String username, String password);

  Future<AuthTokens?> getRefreshToken(String currentRefreshToken);

  Future<String?> getStoredJwtToken();

  Future<void> signOut();
}
