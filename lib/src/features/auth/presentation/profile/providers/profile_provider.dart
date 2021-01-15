import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/validate_email_use_case.dart';

import '../../../../../../app.dart';
import '../../../../../core/entities/catalog_item.dart';
import '../../../../../core/usecases/use_case.dart';
import '../../../../../shared/provider/base_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../auth/domain/entities/user.dart';
import '../../../../auth/domain/usecases/edit_profile_use_case.dart';
import '../../../../auth/domain/usecases/get_profile_use_case.dart';
import '../../../domain/usecases/refresh_profile_use_case.dart';
import '../../../domain/usecases/update_profile_photo_use_case.dart';

class NoChanged extends ViewState {}

class ProfileProvider extends BaseProvider {
  ProfileProvider({
    @required this.getProfileUseCase,
    @required this.editProfileUseCase,
    @required this.updateProfilePhotoUseCase,
    @required this.refreshProfileUseCase,
    @required this.validateEmailUseCase
  });

  final GetProfileUseCase getProfileUseCase;
  final EditProfileUseCase editProfileUseCase;
  final UpdateProfilePhotoUseCase updateProfilePhotoUseCase;
  final RefreshProfileUseCase refreshProfileUseCase;
  final ValidateEmailUseCase validateEmailUseCase;


  ViewState _profileState = Idle();

  ViewState get profileState => _profileState;

  set profileState(ViewState newState) {
    _profileState = newState;

    if (!isDispose) notifyListeners();
  }

  //String lastName;
  //String firstName;
  //String nickName;
  //String email;
  //String photoUrl;

  String _municipality;


  String get municipality => _municipality;

  set municipality(String newValue) {
    _municipality = newValue;
  }


  User _user = currentUser;
  User get user => _user;

  File _photo;
  File get photo => _photo;
  set photo(File newValue) {
    _photo = newValue;

    if (_photo != null) _updatePhoto();
  }


  bool _editMode = false;
  bool get editMode => _editMode;
  set editMode(bool value) {
    _editMode = value;

    notifyListeners();
  }



  void getProfile() async {
    profileState = Loading();

    final failureOrUser = await getProfileUseCase(NoParams());

    failureOrUser.fold(
      (failure) => profileState = Error(failure: failure),
      (user) {
        _user = user;
        _municipality= user.municipality.key;

        profileState = Loaded();
      },
    );
  }


  Future<void> updateMunicipio(CatalogItem municipality) async {
    state = Loading();

    _user.municipality=municipality;

    final failureOrUser = await editProfileUseCase(_user);

    failureOrUser.fold(
          (failure) => state = Error(failure: failure),
          (user) {
        _user = user;
        state = Loaded();
      },
    );
  }

  Future<void> editProfile() async {

    /*
    final params = User(
      municipality: municipality
    );

    if (!_validDataChanged(params)) {
      state = NoChanged();

      return;
    }

    if(_user.municipality != params.municipality)
      _user.municipality= params.municipality;

    state = Loading();

    final failureOrUser = await editProfileUseCase(_user);

    failureOrUser.fold(
      (failure) => state = Error(failure: failure),
      (user) {
        _user = user;

        state = Loaded();
      },
    );*/
  }

  Future<void> _updatePhoto() async {
    profileState = Loading();
    final failureOrSuccess = await updateProfilePhotoUseCase(_photo);

    failureOrSuccess.fold(
      (failure) => profileState = Error(failure: failure),
      (user) async {
        _user = user;

        refreshProfileUseCase(user);

        profileState = Loaded();
      },
    );
  }

  bool _validDataChanged(User params) {
    return !(_user.municipality == params.municipality);


    /*return !(_user.firstName == params.firstName &&
        _user.lastName == params.lastName &&
        _user.email == params.email &&
    _user.municipality == params.municipality);*/
  }

  Future<void> validateEmail() async {

    profileState = Loading();

    final failureOrSuccess = await  validateEmailUseCase(NoParams());
    profileState = Loaded();


    /*failureOrSuccess.fold(
      (failure) => profileState = Error(failure: failure),
      (success) async {
        profileState = Loaded();
      },
    );*/
  }
}
