import 'package:flutter/material.dart';
import 'package:front_mission/domain/repository/auth_repository.dart';
import 'package:front_mission/domain/usecase/sign_in_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final AuthRepository _authRepository;
  String? _accessToken;
  String? _refreshToken;
  String? _username;
  String? _name;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  String? get accessToken => _accessToken;

  String? get refreshToken => _refreshToken;

  String? get username => _username;

  String? get name => _name;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  AuthProvider({
    required SignInUseCase signInUseCase,
    required AuthRepository authRepository, // 주입
  })
      : _signInUseCase = signInUseCase,
        _authRepository = authRepository {
    _loadTokens(); // 앱 시작 시 토큰 로드
  }

  Future<void> _loadTokens() async {
    _isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('jwtToken');
    _refreshToken = prefs.getString('refreshToken');
    _username = prefs.getString('username');
    _name = prefs.getString('name');

    if (_accessToken != null && _refreshToken != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
      print('자동 로그인 실패: 토큰 없음');
    }
    _isLoading = false;
    notifyListeners();
  }

}
