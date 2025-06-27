import '../../data/model/user.dart';
import '../repository/auth_repository.dart';

class SignupUseCase {
  final AuthRepository authRepository;

  SignupUseCase({required this.authRepository});

  Future<User?> execute(
    String username,
    String password,
    String name,
    String confirmPassword,
  ) async {
    return authRepository.signUp(username, password, name, confirmPassword);
  }
}
