import 'package:flutter/foundation.dart';

import '../../domain/usecase/signup_use_case.dart';

class SignUpViewModel with ChangeNotifier {
  final SignupUseCase _signupUseCase;

  SignUpViewModel({required SignupUseCase signupUseCase})
    : _signupUseCase = signupUseCase;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> signUp(
    String username,
    String password,
    String name,
    String confirmPassword,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _signupUseCase.execute(username, password, name, confirmPassword);
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }
}
