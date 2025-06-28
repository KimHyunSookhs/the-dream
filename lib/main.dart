import 'package:flutter/material.dart';
import 'package:front_mission/presentation/board_screen/board_screen.dart';
import 'package:front_mission/presentation/sign_in_screen/sign_in_screen.dart';
import 'package:provider/provider.dart';

import 'core/di/di_setup.dart';
import 'core/provider/auth_provider.dart';

void main() async {
  // Flutter 엔진과 위젯 바인딩이 초기화되었는지 확인합니다.
  WidgetsFlutterBinding.ensureInitialized();
  // 의존성 주입(DI) 설정을 초기화합니다.
  diSetUp();

  // 앱을 실행합니다.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthProvider를 ChangeNotifierProvider로 앱 최상위에 제공합니다.
    // getIt()을 통해 diSetUp에서 싱글톤으로 등록된 AuthProvider 인스턴스를 사용합니다.
    return ChangeNotifierProvider<AuthProvider>.value(
      value: getIt<AuthProvider>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
        title: 'Flutter Mission App', // 앱 타이틀 설정
        theme: ThemeData(
          primarySwatch: Colors.blue, // 앱의 기본 테마 색상 설정
          visualDensity:
              VisualDensity.adaptivePlatformDensity, // 플랫폼에 따른 시각적 밀도 조정
        ),
        // Consumer를 사용하여 AuthProvider의 인증 상태를 구독하고,
        // 로그인 상태에 따라 초기 화면을 조건부로 렌더링합니다.
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            // isAuthenticated가 true면 BoardScreen을, false면 SignInScreen을 보여줍니다.
            if (authProvider.isAuthenticated) {
              return BoardScreen(
                viewModel: getIt(),
              ); // BoardScreen에 ViewModel 주입
            } else {
              return SignInScreen(
                signInViewModel: getIt(),
              ); // SignInScreen에 ViewModel 주입
            }
          },
        ),
      ),
    );
  }
}
