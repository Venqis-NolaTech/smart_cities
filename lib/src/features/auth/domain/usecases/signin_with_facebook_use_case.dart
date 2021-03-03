import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class SignInWithFacebookUseCase implements UseCase<User, NoParams> {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  SignInWithFacebookUseCase({
    @required this.userRepository,
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(NoParams params, {Callback callback}) =>
      authRepository.signInWithFacebook();
}
