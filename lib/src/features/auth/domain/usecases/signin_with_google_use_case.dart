import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';

import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

class SignInWithGoogleUseCase implements UseCase<User, NoParams> {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  SignInWithGoogleUseCase({
    @required this.userRepository,
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, User>> call(NoParams params, {Callback callback}) =>
      authRepository.signInWithGoogle();
}
