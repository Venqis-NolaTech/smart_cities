import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';

import '../../../../../../app.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/usecases/login_use_case.dart';
import '../../../domain/usecases/register_user_use_case.dart';
import '../../../domain/usecases/user_exist_use_case.dart';
import '../../base/providers/phone_number_auth_provider.dart';

class VerifyCodeProvider extends PhoneNumberAuthProvider {
  VerifyCodeProvider({
    @required FirebaseAuth firebaseAuth,
    @required UserExistUseCase userExistUseCase,
    @required this.loginUseCase,
    @required this.registerUserUseCase,
    bool inTest,
  }) : super(
          firebaseAuth: firebaseAuth,
          userExistUseCase: userExistUseCase,
          inTest: inTest,
        );

  final LoginUseCase loginUseCase;
  final RegisterUserUseCase registerUserUseCase;

  VerifyCodeParams _params;

  set params(VerifyCodeParams newParams) {
    _params = newParams;
    actualCode = newParams.actualCode;
  }

  @override
  Future<void> signInWithCredential(
    AuthCredential credential,
    Function callback,
  ) async {
    switch (_params.authMethod) {
      case AuthMethod.login:
        _login(credential, callback);

        break;
      case AuthMethod.register:
        _register(credential, callback);

        break;
    }
  }

  Future<void> _register(AuthCredential credential, Function callback) async {
    /*inal params = RegisterParams(
      credential: credential,
      userRegisterRequest: _params.request,
    );

    state = Loading();

    final result = await registerUserUseCase(params);

    result.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        currentUser = user;

        state = Loaded();

        callback();
      },
    );*/
  }

  Future<void> _login(AuthCredential credential, Function callback) async {
    state = Loading();

    final result = await loginUseCase(LoginUseCaseParams(
      authCredential: credential,
      countryCode: _params.countryCode,
    ));

    result.fold((failure) {
      state = Error(failure: failure);
    }, (_) {
      state = Loaded();

      callback();
    });
  }
}

class VerifyCodeParams {
  final String phoneNumber;
  final String countryCode;
  final String actualCode;
  final AuthMethod authMethod;
  final UserRegisterRequest request;
  final File photo;

  VerifyCodeParams({
    @required this.phoneNumber,
    @required this.countryCode,
    @required this.actualCode,
    @required this.authMethod,
    this.request,
    this.photo
  });
}
