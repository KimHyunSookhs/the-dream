import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front_mission/data/model/user.dart';
import 'package:front_mission/domain/repository/auth_repository.dart';
import 'package:front_mission/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
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
        MaterialPageRoute(builder: (context) => SignInScreen());
      } else {
        // 서버로부터 오류 응답 받음
        print(response);
        print('회원가입 실패: ${response.body}');
      }
    } catch (e) {
      print('회원가입 요청 실패: $e');
    }
  }
}
