import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../shared/user_utils.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_local_repository.dart';
import '../datasources/remote/auth_data_source.dart';
import '../datasources/remote/user_data_source.dart';

class AuthErrorCode {
  static const ERROR_USER_DISABLED = "ERROR_USER_DISABLED";
  static const ERROR_INVALID_CREDENTIAL = "ERROR_INVALID_CREDENTIAL";
  static const ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL =
      "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL";

  static const ERROR_ACCOUNT_ALREADY_REGISTERED = "User is already registered";
}

class AuthRepositoryImpl implements AuthRepository {
  static const int _SEND_EMAIL_VERIFICATION_TIME = 12;

  AuthRepositoryImpl({
    @required this.firebaseAuth,
    @required this.facebookAuth,
    @required this.googleSignIn,
    @required this.firebaseStorage,
    @required this.authDataSource,
    @required this.userDataSource,
    @required this.userLocalRepository,
  });

  final fAuth.FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseStorage firebaseStorage;
  final AuthDataSource authDataSource;
  final UserDataSource userDataSource;
  final UserLocalRepository userLocalRepository;

  @override
  Future<Failure> existUser(String phoneNumber) async {
    try {
      final exist = await authDataSource.userExist(phoneNumber);
      return exist == true ? null : UserNotFoundFailure();
    } catch (e, s) {
      return _handleFailure(e, s);
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var firebaseUser = result?.user;

      if (firebaseUser != null) {
        final firebaseToken = (await firebaseUser.getIdToken());
        print("firebase token $firebaseToken");

        return Right(await _handleUser(
          firebaseToken,
          request: {
            'registerMethod': "EMAIL",
          },
        ));
      }
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, User>> signInWithFacebook() async {
    try {
      final facebookLoginResult = await facebookAuth.login();

      final credential = fAuth.FacebookAuthProvider.credential(
        facebookLoginResult.token,
      );

      final result = await firebaseAuth.signInWithCredential(credential);

      var firebaseUser = result?.user;

      if (firebaseUser != null) {
        final userData = await facebookAuth.getUserData();

        final firebaseToken = (await firebaseUser.getIdToken());
        print("firebase token $firebaseToken");

        final fbNames = userData['name']?.toString()?.split(" ") ?? [];

        return Right(
          await _handleUser(
            firebaseToken,
            request: {
              'firstName': fbNames?.first ?? "",
              'lastName': fbNames?.last ?? "",
              'email': userData['email'] ?? "",
              'registerMethod': "FACEBOOK",
            },
          ),
        );
      }
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final googleResult = await googleSignIn.signIn();

      final googleAuth = await googleResult.authentication;

      final credential = fAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await firebaseAuth.signInWithCredential(credential);

      var firebaseUser = result?.user;

      if (firebaseUser != null) {
        final firebaseToken = (await firebaseUser.getIdToken());
        print("firebase token $firebaseToken");
        final googleNames = googleResult?.displayName?.split(" ") ?? [];

        return Right(
          await _handleUser(
            firebaseToken,
            request: {
              'firstName': googleNames?.first ?? "",
              'lastName': googleNames?.last ?? "",
              'email': googleResult.email ?? "",
              'registerMethod': "GOOGLE",
            },
          ),
        );
      }
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }

    return Left(UnexpectedFailure());
  }

  @override
  Future<Either<Failure, User>> register({
    File photo,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String password,
  }) async {
    try {
      final Map<String, dynamic> request = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'registerMethod': "EMAIL",
      };

      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      var firebaseUser = result?.user;

      if (firebaseUser != null) {
        final firebaseToken = (await firebaseUser.getIdToken());

        if (photo != null) {
          final photoURL = await UserUtils.uploadUserPhoto(
            firebaseStorage,
            firebaseUser.uid,
            photo,
          );

          request.addAll({'photoURL': photoURL});
        }

        final success =
            await authDataSource.register(firebaseToken, request: request);

        return Right(await _saveUser(success));
      }
    } catch (e, s) {
      return Left(_handleFailure(e, s));
    }

    return Left(UnexpectedFailure());
  }

  @override
  Future<Failure> logout() async {
    final success = await userLocalRepository.clear();

    if (success == true) {
      firebaseAuth.signOut();
      facebookAuth.logOut();
      googleSignIn.signOut();

      return null;
    }

    return UnexpectedFailure();
  }

  // ---- private methods ---- //
  Future<User> _handleUser(
    String firebaseToken, {
    Map<String, dynamic> request,
  }) async {
    final isRegisted = await authDataSource.validation(firebaseToken);

    final success = !isRegisted
        ? (await authDataSource.register(firebaseToken, request: request))
        : (await authDataSource.login(firebaseToken));

    return await _saveUser(success,
        verified:  request['registerMethod']=='FACEBOOK' || request['registerMethod']=='GOOGLE');
  }

  Future<User> _saveUser(bool success, {bool verified}) async {
    if (success) {
      User user = await userDataSource.getProfile();
      var emailVerified = false;

      if (verified != null) {
        emailVerified = verified;
      }else
        emailVerified = firebaseAuth?.currentUser?.emailVerified;


      final lastSignInTime =
          firebaseAuth?.currentUser?.metadata?.lastSignInTime;

      user = user.copy(
        emailVerified: emailVerified,
        lastSignInTime: lastSignInTime?.toIso8601String(),
      );

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

  Failure _handleFailure(e, StackTrace s) {
    if (e is PlatformException) {
      switch (e.code) {
        case AuthErrorCode.ERROR_INVALID_CREDENTIAL:
          return InvalidCredentialFailure();
        case AuthErrorCode.ERROR_USER_DISABLED:
          return UserDisabledFailure();
        case AuthErrorCode.ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL:
          return AccountExistWithDiferentCredentialFailure();
        default:
          FirebaseCrashlytics.instance.recordError(e, s);
          return UnexpectedFailure();
      }
    } else if (e is BadRequestException) {
      final value = json.decode(e.toString());

      if (value['message'] == AuthErrorCode.ERROR_ACCOUNT_ALREADY_REGISTERED)
        return AccountExistWithDiferentCredentialFailure();
    }

    FirebaseCrashlytics.instance.recordError(e, s);
    return UnexpectedFailure();
  }

  @override
  Future<Failure> sendEmailVerification() async {
    try {
      final sentTime =
          (userLocalRepository.getTimeSentEmailConfirmation()).fold(
        (_) => null,
        (time) => time,
      );

      final allowSend = sentTime == null ||
          sentTime.difference(DateTime.now()).inHours >=
              _SEND_EMAIL_VERIFICATION_TIME;

      if (allowSend) {
        userLocalRepository.setTimeSentEmailConfirmation(DateTime.now());

        await firebaseAuth.currentUser.sendEmailVerification();
      }

      return null;
    } catch (e, s) {
      return _handleFailure(e, s);
    }
  }

  @override
  Future<Failure> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e, s) {
      return _handleFailure(e, s);
    }
  }
  // ---- private methods ---- //
}
