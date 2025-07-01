import 'package:flutter/foundation.dart';
import 'package:front_mission/core/token_manager.dart';

class AuthProvider extends ChangeNotifier {
  final TokenManager _tokenManager;

  AuthProvider({required TokenManager tokenManager})
    : _tokenManager = tokenManager;

  String? get jwtToken => _tokenManager.jwtToken;

  void setToken(String token) {
    _tokenManager.setToken(token);
    notifyListeners();
  }

  void clearAuth() {
    _tokenManager.clearToken();
    notifyListeners();
  }
}
