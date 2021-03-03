import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailUseCase
    implements UseCase<User, SignInWithEmailUseCaseParams> {
  final AuthRepository authRepository;

  SignInWithEmailUseCase({
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(SignInWithEmailUseCaseParams params,
      {Callback callback}) async {
    // TODO: recheck email and password are valid.
    final result = await authRepository.signInWithEmail(
      email: params.email,
      password: params.password,
    );

    return result.fold(
      (error) => Left(error),
      (userLogged) => Right(userLogged),
    );
  }
}

class SignInWithEmailUseCaseParams extends Equatable {
  final String email;
  final String password;

  SignInWithEmailUseCaseParams({this.email, this.password});

  @override
  List<Object> get props => [email, password];
}
