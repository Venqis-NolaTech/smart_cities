import 'package:smart_cities/src/features/auth/presentation/forgot_password/providers/forgot_password_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/email_verification_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_in/providers/sign_in_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_up/register/providers/register_provider.dart';
import 'package:smart_cities/src/features/select_sector/provider/select_sector_provider.dart';

import 'package:get_it/get_it.dart';
import '../presentation/phone_number/providers/phone_number_provider.dart';
import '../presentation/verify_code/providers/verify_code_provider.dart';


initProvider(GetIt sl) {
  sl.registerFactory(
    () => PhoneNumberProvider(
      firebaseAuth: sl(),
      loginUseCase: sl(),
      userExistUseCase: sl(),
      registerUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => VerifyCodeProvider(
      firebaseAuth: sl(),
      loginUseCase: sl(),
      userExistUseCase: sl(),
      registerUserUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => RegisterProvider(
      registerUserUseCase: sl(),
      //firebaseAuth: sl(),
      //userExistUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ProfileProvider(
      editProfileUseCase: sl(),
      getProfileUseCase: sl(),
      refreshProfileUseCase: sl(),
      updateProfilePhotoUseCase: sl(),
      validateEmailUseCase: sl(),
      logoutUseCase: sl(),
      getMunicipalityUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => SelectSectorProvider(
          getSectoresUseCase: sl(), 
          loggedUserUseCase: sl(),
    ),
  );

  sl.registerFactory(() => SignInProvider(
    signInUserWithGoogleUseCase: sl(),
    signInUserWithFacebookUseCase: sl(),
    signInWithEmailUseCase: sl(), 
    deviceInfo: sl()
  ));

  sl.registerFactory(() => ForgotPasswordProvider(
      forgotPasswordUseCase: sl()
  ));//

  sl.registerFactory(() => EmailConfirmationProvider(
      sendEmailVerificationUseCase: sl()
  ));
}
