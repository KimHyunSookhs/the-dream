import 'package:flutter/material.dart';
import 'package:front_mission/presentation/sign_up_screen/sign_up_screen.dart';
import 'package:provider/provider.dart';

import 'core/di/di_setup.dart';
import 'core/provider/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  diSetUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>.value(
      value: getIt<AuthProvider>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return SignUpScreen(viewModel: getIt());
          },
        ),
      ),
    );
  }
}
