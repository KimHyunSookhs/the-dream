import 'package:flutter/foundation.dart';

import '../../domain/usecase/sign_in_use_case.dart';

class SignInViewModel with ChangeNotifier {
  final SignInUseCase _signInUseCase;

  SignInViewModel({required SignInUseCase signInUseCase})
    : _signInUseCase = signInUseCase;

  bool _isLoading = false;
  String? _error;
  String? _jwtToken;

  bool get isLoading => _isLoading;

  String? get error => _error;

  String? get jwtToken => _jwtToken;

  Future<String?> signIn(String username, String password) async {
    _isLoading = true;
    _jwtToken = null;
    notifyListeners();
    try {
      final String? token = await _signInUseCase.execute(username, password);
      if (token != null) {
        _jwtToken = token;
        print('로그인성공 $token');
      } else {
        print("로그인 실패");
      }
      return _jwtToken;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }
}
