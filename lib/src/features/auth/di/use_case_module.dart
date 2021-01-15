import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/get_municipality_use_case.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/validate_email_use_case.dart';

import '../domain/usecases/edit_profile_use_case.dart';
import '../domain/usecases/get_current_location_use_case.dart';
import '../domain/usecases/get_params_use_case.dart';
import '../domain/usecases/get_profile_use_case.dart';
import '../domain/usecases/get_token_use_case.dart';
import '../domain/usecases/logged_user_use_case.dart';
import '../domain/usecases/login_use_case.dart';
import '../domain/usecases/logout_use_case.dart';
import '../domain/usecases/refresh_profile_use_case.dart';
import '../domain/usecases/register_device_token_use_case.dart';
import '../domain/usecases/register_user_use_case.dart';
import '../domain/usecases/update_profile_photo_use_case.dart';
import '../domain/usecases/upload_user_photo_use_case.dart';
import '../domain/usecases/user_exist_use_case.dart';

initUseCase(GetIt sl) {
  sl.registerLazySingleton(
    () => RegisterDeviceTokenUseCase(
      userRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UserExistUseCase(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => LoggedUserUseCase(
      firebaseAuth: sl(),
      userLocalRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetTokenUseCase(
      userLocalRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetParamsUseCase(
      userRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetProfileUseCase(
      userRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => EditProfileUseCase(
      userRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UpdateProfilePhotoUseCase(
      userRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => RefreshProfileUseCase(
      userRepository: sl(),
      userLocalRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => LoginUseCase(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => RegisterUserUseCase(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => LogoutUseCase(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => UploadUserPhotoUseCase(
      firebaseAuth: sl(),
      firebaseStorage: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetCurrentLocationUseCase(
      userLocalRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => GetMunicipalityUseCase(
          userRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => ValidateEmailUseCase(
        firebaseAuth: sl(),
        userRepository: sl()
    ),
  );
}
