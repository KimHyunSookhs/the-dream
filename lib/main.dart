import 'package:flutter/material.dart';
import 'package:front_mission/presentation/sign_up_screen/sign_up_screen.dart';

import 'core/di/di_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  diSetUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(viewModel: getIt()),
    );
  }
}
