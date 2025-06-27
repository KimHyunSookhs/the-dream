import 'package:get_it/get_it.dart';

import '../../data/repository/auth_repository_impl/auth_repository_impl.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/signup_use_case.dart';
import '../../presentation/sign_up_screen/sign_up_view_model.dart';

final getIt = GetIt.instance;

void diSetUp() {
  //Repository
  getIt.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  //UseCase
  getIt.registerSingleton(SignupUseCase(authRepository: getIt()));
  //ViewModel
  getIt.registerFactory<SignUpViewModel>(
    () => SignUpViewModel(signupUseCase: getIt()),
  );
}
