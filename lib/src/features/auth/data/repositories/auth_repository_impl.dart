import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/user_utils.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_local_repository.dart';
import '../datasources/remote/auth_data_source.dart';
import '../datasources/remote/user_data_source.dart';
import '../models/user_model.dart';

class FirebaseAuthErrorCode {
  static const ERROR_USER_DISABLED = "ERROR_USER_DISABLED";
  static const ERROR_INVALID_CREDENTIAL = "ERROR_INVALID_CREDENTIAL";
  static const ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL =
      "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL";
}

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    @required this.firebaseAuth,
    @required this.firebaseStorage,
    @required this.authDataSource,
    @required this.userDataSource,
    @required this.userLocalRepository,
  });

  final fAuth.FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;
  final UserLocalRepository userLocalRepository;

  @override
  Future<Failure> existUser(String phoneNumber, String email, String dni) async {
    try {
      final exist = await authDataSource.userExist(phoneNumber, email, dni);

      if(exist['register_firebase'] == true )
        return UserExistFailure();

      if(exist['register_dni'] == true )
        return DniExistFailure();

      if(exist['register_email'] == true )
        return EmailExistFailure();

      return null;
      //return exist == true ? null : UserNotFoundFailure();
    } catch (e, s) {
      return _handlerFailure(e, s);
    }
  }

  @override
  Future<Either<Failure, User>> login(
      fAuth.AuthCredential credential, String countryCode) async {
    try {
      final result = await firebaseAuth.signInWithCredential(credential);

      var firebaseUser = result?.user;

      if (firebaseUser != null) {
        final firebaseToken = (await firebaseUser.getIdToken());
        print('firebase token $firebaseToken');
        print('countryCode $countryCode');

        final success = await authDataSource.login(
          firebaseToken: firebaseToken,
          countryCode: countryCode,
        );

        return Right(await _saveUser(success));
      }
    } catch (e, s) {
      return Left(_handlerFailure(e, s));
    }

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, User>> register(
    fAuth.AuthCredential credential,
    File photo, {
    @required UserRegisterRequest userRegisterRequest,
  }) async {
    try {
      final result = await firebaseAuth.signInWithCredential(credential);

      var firebaseUser = result?.user;

      if (firebaseUser != null) {
        final firebaseToken = (await firebaseUser.getIdToken());

        final photoURL = await UserUtils.uploadUserPhoto(
          firebaseStorage,
          firebaseUser.uid,
          photo,
        );
        userRegisterRequest.photoUrl= photoURL;

        print('==============  USUARIO A REGISTRAR  =====================');
        print(UserRegisterRequestModel.fromEntity(userRegisterRequest).toJson());
        print('==============  TOKEN  =====================');
        print(firebaseToken);

        final success = await authDataSource.register(
          firebaseToken,
          UserRegisterRequestModel.fromEntity(userRegisterRequest),
        );

        return Right(await _saveUser(success));
      }
    } catch (e, s) {
      return Left(_handlerFailure(e, s));
    }

    return Left(UnexpectedFailure());
  }

  @override
  Future<Failure> logout() async {
    final success = await userLocalRepository.clear();

    if (success == true) {
      firebaseAuth.signOut();

      return null;
    }

    return UnexpectedFailure();
  }

  // ---- private methods ---- //
  Future<User> _saveUser(bool success) async {
    if (success) {
      final user = await userDataSource.getProfile();

      final userSaved = _eitherFailureOrUser(
        await userLocalRepository.createUser(user),
      );

      return userSaved;
    } else {
      throw AuthUserException();
    }
  }

  User _eitherFailureOrUser(Either either) {
    return either.fold(
      (failure) => throw CreateUserException(),
      (user) => user,
    );
  }

  Failure _handlerFailure(e, StackTrace s) {
    if (e is PlatformException) {
      switch (e.code) {
        case FirebaseAuthErrorCode.ERROR_INVALID_CREDENTIAL:
          return InvalidCredentialFailure();
        case FirebaseAuthErrorCode.ERROR_USER_DISABLED:
          return UserDisabledFailure();
        case FirebaseAuthErrorCode
            .ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL:
          return AccountExistWithDiferentCredentialFailure();
        default:
          FirebaseCrashlytics.instance.recordError(e, s);
          return UnexpectedFailure();
      }
    }

    FirebaseCrashlytics.instance.recordError(e, s);
    return UnexpectedFailure();
  }
  // ---- private methods ---- //
}
