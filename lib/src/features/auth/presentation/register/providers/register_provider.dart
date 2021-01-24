import 'dart:io';

import 'package:meta/meta.dart';

import '../../../../../../app.dart';
import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/register_user_use_case.dart';

class RegisterProvider extends BaseProvider {
  RegisterProvider({
    @required this.registerUserUseCase,
    bool inTest,
  }) : super(
          inTest: inTest,
        );

  final RegisterUserUseCase registerUserUseCase;

  String firstName;
  String lastName;
  String phoneNumber;
  String countryCode;
  String email;
  String dni;

  File _photo;

  File get photo => _photo;


  Function codeSendCallback;
  Function failureCallback;
  Function codeAutoRetrievalTimeoutCallback;
  Function signInWithCredentialCallback;

  set photo(File newValue) {
    _photo = newValue;
  }

  Future<void> register() async {
    final params = RegisterParams(
      photo: _photo,
      userRegisterRequest: UserRegisterRequest(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        email: email,
        dni: dni,
      ),
    );

    state = Loading();
    await registerUserUseCase(params);
    state = Loaded();

    /*result.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        currentUser = user;

        state = Loaded();
      },
    );*/
  }




}
