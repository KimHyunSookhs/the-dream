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
}
