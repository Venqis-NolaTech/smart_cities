import 'dart:io';

import 'package:meta/meta.dart';

import '../../../../../../../app.dart';
import '../../../../../../shared/provider/base_provider.dart';
import '../../../../../../shared/provider/view_state.dart';
import '../../../../domain/usecases/register_user_use_case.dart';

class RegisterProvider extends BaseProvider {
  RegisterProvider({
    @required this.registerUserUseCase,
  });

  final RegisterUserUseCase registerUserUseCase;

  String firstName;
  String lastName;
  String email;
  String password;


  File _photo;

  File get photo => _photo;

  set photo(File newValue) {
    _photo = newValue;
  }

  bool _isPopulateData = false;
  bool get isPopulateData => _isPopulateData;
  set isPopulateData(bool value) {
    _isPopulateData = value;
    notifyListeners();
  }

  void loading() => state = Loading();

  void loaded() => state = Loaded();

  Future<void> register() async {
    state = Loading();

    final params = RegisterParams(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      photo: photo
    );

    final result = await registerUserUseCase(params);

    result.fold(
      (failure) {
        state = Error(failure: failure);
      },
      (user) {
        currentUser = user;

        state = Loaded();
      },
    );
  }
}
