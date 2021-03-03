import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:smart_cities/src/features/auth/presentation/verify_code/providers/verify_code_provider.dart';

import '../../../../../../app.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/usecases/login_use_case.dart';
import '../../../domain/usecases/user_exist_use_case.dart';
import '../../base/providers/phone_number_auth_provider.dart';

class PhoneNumberProvider extends PhoneNumberAuthProvider {
  PhoneNumberProvider({
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

  AuthMethod authMethod;
  String countryCode;



  File _photo;

  File get photo => _photo;

  set photo(File newValue) {
    _photo = newValue;
  }

  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String dni;



  @override
  Future<void> sendPhoneNumber(String phoneNumber) async {
    state = Loading();
    await super.sendPhoneNumber(phoneNumber);
    //state = Loaded();
  }

  @override
  Future<void> signInWithCredential(
      AuthCredential authCredential, Function callback) async {
    /*if (authMethod == AuthMethod.register) {

      print('credenciales '+authCredential.toString());


      final params = RegisterParams(
        credential: authCredential,
        photo: _photo,
        userRegisterRequest: UserRegisterRequest(
          phoneNumber: phoneNumber,
          photoUrl: '',
          firstName: firstName,
          lastName: lastName,
          email: email,
          dni: dni,
          countryCode: countryCode,
          street: '',
          province: '',
          city: '',
          municipality: '',
          number: '',
        ),
      );

      print('datos a enviar '+params.toString());

      state = Loading();
      var result= await registerUserUseCase(params);

      result.fold(
            (failure) {
          state = Error(failure: failure);
        },
            (user) {
          currentUser = user;

          state = Loaded();
          callback();
        },
      );


      return;
    }

    state = Loading();

    final result = await loginUseCase(LoginUseCaseParams(
      authCredential: authCredential,
      countryCode: countryCode,
    ));

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
}
