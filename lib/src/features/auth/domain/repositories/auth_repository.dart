import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Failure> existUser(String phoneNumber);

  Future<Either<Failure, User>> signInWithEmail({
    @required String email,
    @required String password,
  });

  Future<Either<Failure, User>> signInWithFacebook();

  Future<Either<Failure, User>> signInWithGoogle();

  Future<Either<Failure, User>> register({
    File photo,
    @required String firstName,
    @required String lastName,
    @required String email,
    @required String password,
  });

  Future<Failure> sendPasswordResetEmail(String email);

  Future<Failure> sendEmailVerification();

  Future<void> logout();
}
