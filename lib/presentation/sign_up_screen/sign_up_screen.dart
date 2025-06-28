import 'package:flutter/material.dart';
import 'package:front_mission/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:front_mission/presentation/sign_up_screen/sign_up_view_model.dart';

import '../../core/di/di_setup.dart';
import '../../core/validation/validation_form.dart';

class SignUpScreen extends StatefulWidget {
  final SignUpViewModel viewModel;

  const SignUpScreen({super.key, required this.viewModel});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final ValidationForm _validationForm = ValidationForm();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
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
                '이름',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: '이름을 입력하세요',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                validator: _validationForm.validateName,
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
              const Text(
                '비밀 번호 확인',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  hintText: '비밀번호를 확인해 주세요',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                obscureText: true,
                validator: (value) =>
                    _validationForm.validatePasswordConfirmation(
                      value,
                      _passwordController.text,
                    ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        widget.viewModel.signUp(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text,
                          _passwordConfirmController.text,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignInScreen(signInViewModel: getIt()),
                          ),
                        );
                      }
                    },
                    child: Text('회원 가입'),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignInScreen(signInViewModel: getIt()),
                        ),
                      );
                    },
                    child: Text('로그인'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
