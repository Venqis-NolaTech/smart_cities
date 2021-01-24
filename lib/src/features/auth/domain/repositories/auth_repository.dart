import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Failure> existUser(String phoneNumber, String email, String dni);

  Future<Either<Failure, User>> login(
    fAuth.AuthCredential credential,
    String countryCode,
  );

  Future<Either<Failure, User>> register(
    fAuth.AuthCredential credential,
    File photo, {
    @required UserRegisterRequest userRegisterRequest,
  });

  Future<void> logout();
}
