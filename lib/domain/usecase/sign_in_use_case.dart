import '../repository/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<String?> execute(String username, String password) async {
    final String? token = await authRepository.getJwtToken(username, password);
    return token;
  }
}
