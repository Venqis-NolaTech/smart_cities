import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUserUseCase extends UseCase<User, RegisterParams> {
  RegisterUserUseCase({@required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params,
      {Callback callback}) {

    return authRepository.register(
      photo: params.photo,
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      password: params.password,
    );

    /*return authRepository.register(
      params.credential,
      params.photo,
      userRegisterRequest: params.userRegisterRequest,
    );*/
  }
}
class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String dni;
  final String phoneNumber;
  final String countryCode;
  final File photo;

  RegisterParams({
    this.firstName,
    this.lastName,
    this.email,
    this.password,

    this.dni,
    this.phoneNumber,
    this.countryCode,
    this.photo
  });

  @override
  List<Object> get props => [
    firstName,
    lastName,
    email,
    password,
  ];
}

/*class RegisterParams extends Equatable {
  final fAuth.AuthCredential credential;
  final File photo;
  final UserRegisterRequest userRegisterRequest;

  RegisterParams({
    this.credential,
    this.photo,
    this.userRegisterRequest,
  });

  @override
  List<Object> get props => [
        credential,
        photo,
        userRegisterRequest,
      ];
}*/
