import 'package:front_mission/data/repository/board_list_repository_impl.dart';
import 'package:front_mission/data/repository/write_board_repository_impl.dart';
import 'package:front_mission/domain/repository/board_list_repository.dart';
import 'package:front_mission/domain/repository/write_board_repository.dart';
import 'package:front_mission/domain/usecase/board_list_use_case.dart';
import 'package:front_mission/domain/usecase/sign_in_use_case.dart';
import 'package:front_mission/domain/usecase/write_board_use_case.dart';
import 'package:front_mission/presentation/board_screen/board_screen_view_model.dart';
import 'package:front_mission/presentation/sign_in_screen/sign_in_view_model.dart';
import 'package:front_mission/presentation/write_borad_screen/write_board_view_model.dart';
import 'package:get_it/get_it.dart';

import '../../data/repository/auth_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../presentation/sign_up_screen/sign_up_view_model.dart';
import '../provider/auth_provider.dart';
import '../token_manager.dart';

final getIt = GetIt.instance;

void diSetUp() {
  getIt.registerSingleton<TokenManager>(TokenManager());
  //Repository
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  getIt.registerSingleton<WriteBoardRepository>(
    WriteBoardRepositoryImpl(tokenManager: getIt<TokenManager>()),
  );
  getIt.registerSingleton<BoardListRepository>(
    BoardListRepositoryImpl(tokenManager: getIt<TokenManager>()),
  );

  //UseCase
  getIt.registerSingleton(SignupUseCase(authRepository: getIt()));
  getIt.registerSingleton(SignInUseCase(authRepository: getIt()));
  getIt.registerSingleton(WriteBoardUseCase(writeBoardRepository: getIt()));
  getIt.registerSingleton(BoardListUseCase(repository: getIt()));

  //ViewModel
  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(signupUseCase: getIt()),
  );
  getIt.registerFactory<SignInViewModel>(
    () => SignInViewModel(
      signInUseCase: getIt(),
      authProvider: getIt<AuthProvider>(),
    ),
  );
  getIt.registerFactory<WriteBoardViewModel>(
    () => WriteBoardViewModel(writeBoardUseCase: getIt()),
  );
  getIt.registerFactory<BoardScreenViewModel>(
    () => BoardScreenViewModel(boardListUseCase: getIt()),
  );

  getIt.registerSingleton<AuthProvider>(
    AuthProvider(tokenManager: getIt<TokenManager>()),
  );
}
