import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_mission/data/model/auth_tokens.dart';
import 'package:front_mission/data/model/user.dart';
import 'package:front_mission/domain/repository/auth_repository.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  static final storage = FlutterSecureStorage();

  @override
  Future<void> signOut() async {
    try {
      await storage.delete(key: 'jwtToken');
      await storage.delete(key: 'refreshToken');
      await storage.delete(key: 'username');
      await storage.delete(key: 'password');
    } catch (e) {
      print('로그아웃 중 오류 발생: $e');
    }
  }

  @override
  Future<User?> signUp(
    String username,
    String password,
    String name,
    String confirmPassword,
  ) async {
    final newUser = User(
      username: username,
      password: password,
      name: name,
      confirmPassword: confirmPassword,
    );

    String requestBody = json.encode(newUser.toJson());

    String uri = 'https://front-mission.bigs.or.kr/auth/signup';
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: requestBody,
      );
      if (response.statusCode == 200) {
        print('회원가입 성공');
      } else {
        // 서버로부터 오류 응답 받음
        print(response);
        print('회원가입 실패: ${response.body}');
      }
    } catch (e) {
      print('회원가입 요청 실패: $e');
    }
    return null;
  }

  @override
  Future<String?> getJwtToken(String username, String password) async {
    final String uri = 'https://front-mission.bigs.or.kr/auth/signin';
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: jsonEncode(body),
      );
      await storage.write(key: 'username', value: username);
      await storage.write(key: 'password', value: password);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('accessToken')) {
          final String jwtToken = responseData['accessToken'];
          await storage.write(key: 'jwtToken', value: jwtToken);
          if (responseData.containsKey('refreshToken')) {
            await storage.write(
              key: 'refreshToken',
              value: responseData['refreshToken'],
            );
          }
          return jwtToken;
        } else {
          print('에러 : ${response.body}');
          return null;
        }
      } else {
        print(
          'AuthRepositoryImpl: 로그인 실패 (HTTP ${response.statusCode}): ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('AuthRepositoryImpl: 네트워크 요청 중 예외 발생: $e');
      return null;
    }
  }

  @override
  Future<AuthTokens?> getRefreshToken(String currentRefreshToken) async {
    final String uri = 'https://front-mission.bigs.or.kr/auth/refresh';
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final Map<String, dynamic> body = {'refreshToken': currentRefreshToken};
    try {
      final response = await http.post(
        Uri.parse(uri),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('accessToken') &&
            responseData.containsKey('refreshToken')) {
          print('✅ AuthRepositoryImpl: 토큰 갱신 성공!');
          await storage.write(
            key: 'jwtToken',
            value: responseData['accessToken'],
          );
          await storage.write(
            key: 'refreshToken',
            value: responseData['refreshToken'],
          );
          return AuthTokens.fromJson(responseData);
        } else {
          print('에러 : ${response.body}');
          return null;
        }
      } else {
        print(
          'AuthRepositoryImpl: 로그인 실패 (HTTP ${response.statusCode}): ${response.body}',
        );
        return null;
      }
    } catch (e) {
      print('AuthRepositoryImpl: 네트워크 요청 중 예외 발생: $e');
      return null;
    }
  }

  Future<http.Response> authorizedGet(String url) async {
    String? token = await storage.read(key: 'jwtToken');

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 401) {
      // accessToken 만료됨. 리프레시 시도
      final refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken != null) {
        final newTokens = await getRefreshToken(refreshToken);
        if (newTokens != null) {
          token = newTokens.accessToken;
          // retry request with new token
          return await http.get(
            Uri.parse(url),
            headers: {'Authorization': 'Bearer $token'},
          );
        }
      }
    }

    return response;
  }

  @override
  Future<String?> getStoredJwtToken() async {
    try {
      return await storage.read(key: 'jwtToken');
    } catch (e) {
      print('저장된 JWT 토큰을 읽어오는 중 오류 발생: $e');
      return null;
    }
  }
}
