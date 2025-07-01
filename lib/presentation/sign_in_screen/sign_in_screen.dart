import 'package:flutter/material.dart';
import 'package:front_mission/core/di/di_setup.dart';
import 'package:front_mission/presentation/board_screen/board_screen.dart';
import 'package:front_mission/presentation/sign_in_screen/sign_in_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/validation/validation_form.dart';

class SignInScreen extends StatefulWidget {
  final SignInViewModel signInViewModel;

  const SignInScreen({super.key, required this.signInViewModel});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValidationForm _validationForm = ValidationForm();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '이메일',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              TextFormField(
                focusNode: _emailFocus,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: '이메일을 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                validator: _validationForm.validateEmail,
              ),
              const SizedBox(height: 15),
              const Text(
                '비밀 번호',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              TextFormField(
                focusNode: _passwordFocus,
                controller: _passwordController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: '비밀번호를 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                obscureText: true,
                validator: (value) => _validationForm.validatePassword(value),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    String username = _emailController.text;
                    String password = _passwordController.text;

                    String? jwtToken = await widget.signInViewModel.signIn(
                      username,
                      password,
                    );

                    if (jwtToken != null) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('jwtToken', jwtToken);
                      await prefs.setString('username', username);

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => BoardScreen(viewModel: getIt()),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.signInViewModel.error ??
                                '로그인 실패. 사용자 이름 또는 비밀번호를 확인해주세요.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
