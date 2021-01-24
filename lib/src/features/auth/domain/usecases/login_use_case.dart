import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginUseCaseParams> {
  final AuthRepository authRepository;

  LoginUseCase({
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(LoginUseCaseParams params,
      {Callback callback}) async {
    final result = await authRepository.login(
      params.authCredential,
      params.countryCode,
    );

    return result.fold(
      (error) => Left(error),
      (userLogged) => Right(userLogged),
    );
  }
}

class LoginUseCaseParams extends Equatable {
  final fAuth.AuthCredential authCredential;
  final String countryCode;

  LoginUseCaseParams({this.authCredential, this.countryCode});

  @override
  List<Object> get props => [authCredential, countryCode];
}
