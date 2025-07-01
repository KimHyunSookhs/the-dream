import 'dart:convert';

import 'package:front_mission/data/model/user_info.dart';

class TokenManager {
  String? _jwtToken; // JWT 토큰을 저장할 변수

  String? get jwtToken => _jwtToken; // 현재 토큰 반환

  // 토큰 설정 메서드
  void setToken(String? token) {
    _jwtToken = token;
    print('TokenManager: JWT 토큰 설정됨 -> ${_jwtToken == null ? "null" : "유효"}');
  }

  // 토큰 초기화 (로그아웃 등)
  void clearToken() {
    _jwtToken = null;
    print('TokenManager: JWT 토큰 초기화됨.');
  }

  Future<UserInfo?> getUserFromToken() async {
    final token = await jwtToken;
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Invalid token format');
      final payload = base64.normalize(parts[1]);
      final decoded = utf8.decode(base64.decode(payload));
      final jsonData = jsonDecode(decoded);

      return UserInfo.fromJson(jsonData);
    } catch (e) {
      print('Token decode error: $e');
      return null;
    }
  }
}
