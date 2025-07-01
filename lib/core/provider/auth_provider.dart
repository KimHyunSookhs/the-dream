import 'package:flutter/foundation.dart';
import 'package:front_mission/core/token_manager.dart';

class AuthProvider extends ChangeNotifier {
  final TokenManager _tokenManager; // TokenManager에 의존성 주입

  AuthProvider({required TokenManager tokenManager})
    : _tokenManager = tokenManager;

  // 현재 토큰 상태를 외부에 노출 (UI에서 사용)
  String? get jwtToken => _tokenManager.jwtToken;

  // // 로그인 여부 (UI에서 사용)
  // bool get isAuthenticated =>
  //     _tokenManager.jwtToken != null && _tokenManager.jwtToken!.isNotEmpty;

  /// 로그인 성공 시 토큰을 설정하고 모든 리스너에게 알립니다.
  void setToken(String token) {
    _tokenManager.setToken(token); // TokenManager에 토큰 설정
    notifyListeners(); // 상태 변경 알림
  }

  /// 로그아웃 시 토큰을 초기화하고 모든 리스너에게 알립니다.
  void clearAuth() {
    _tokenManager.clearToken(); // TokenManager에서 토큰 초기화
    notifyListeners(); // 상태 변경 알림
  }
}
