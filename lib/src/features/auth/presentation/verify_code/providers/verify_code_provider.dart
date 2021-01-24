import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/providers/phone_number_provider.dart';

import '../../../../../shared/provider/view_state.dart';
import '../../../domain/usecases/login_use_case.dart';
import '../../../domain/usecases/user_exist_use_case.dart';
import '../../base/providers/phone_number_auth_provider.dart';

class VerifyCodeParams {
  //para registro
  final String name;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String countryCode;
  final String dni;



  final File photo;

  //para login
  final String actualCode;

  //provider
  final PhoneNumberProvider provider;

  final AuthMethod authMethod;

  VerifyCodeParams({this.provider, this.actualCode, this.photo, this.dni, this.name, this.lastName, this.email, this.phoneNumber, this.countryCode,
    @required this.authMethod,
  });
}

/*class VerifyCodeProvider extends PhoneNumberAuthProvider {
  VerifyCodeProvider({
    @required FirebaseAuth firebaseAuth,
    @required UserExistUseCase userExistUseCase,
    @required this.loginUseCase,
    bool inTest,
  }) : super(
          firebaseAuth: firebaseAuth,
          userExistUseCase: userExistUseCase,
          inTest: inTest,
        );

  final LoginUseCase loginUseCase;

  VerifyCodeParams _params;

  set params(VerifyCodeParams newParams) {
    _params = newParams;
  }

  @override
  Future<void> signInWithCredential(AuthCredential authCredential, Function callback) async {
    switch (_params.authMethod) {
      case AuthMethod.login:
        state = Loading();

        final result = await loginUseCase(LoginUseCaseParams(
          authCredential: authCredential,
          countryCode: _params.countryCode,
        ));

        result.fold((failure) {
          state = Error(failure: failure);
        }, (_) {
          state = Loaded();

          callback();
        });

        break;
      case AuthMethod.register:
        callback();
        break;
    }
  }
}*/
