import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/user_exist_use_case.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';

import '../../../../../../app.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/register_user_use_case.dart';

class RegisterProvider extends PhoneNumberAuthProvider {
  RegisterProvider({
    @required this.registerUserUseCase,
    @required FirebaseAuth firebaseAuth,
    @required UserExistUseCase userExistUseCase,
    bool inTest,
  }) : super(
    firebaseAuth: firebaseAuth,
    userExistUseCase: userExistUseCase,
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

  set photo(File newValue) {
    _photo = newValue;
  }

  Function codeSendCallback;
  Function failureCallback;
  Function codeAutoRetrievalTimeoutCallback;
  Function signInWithCredentialCallback;


  bool _isPopulateData = false;
  bool get isPopulateData => _isPopulateData;
  set isPopulateData(bool value) {
    _isPopulateData = value;
    notifyListeners();
  }

  void loading() => state = Loading();

  void loaded() => state = Loaded();

  @override
  Future<void> signInWithCredential(
      AuthCredential credential, Function callback) =>
      _register(callback);

  UserRegisterRequest prepareRequest() {
    return  UserRegisterRequest(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      email: email,
      dni: dni,
    );
  }




  Future<void> _register(Function callback) async {
    final request = prepareRequest();

    final params = RegisterParams(
      credential: authCredential,
      photo: _photo,
      userRegisterRequest: request
    );

    final result = await registerUserUseCase(params);

    result.fold(
          (failure) {
        state = Error(failure: failure);
      },
          (user) {
        currentUser = user;

        print('<<currentUser>>: ${user.toString()}');

        callback();
      },
    );

  }




}
