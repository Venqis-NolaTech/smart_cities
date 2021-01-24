import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_local_repository.dart';

class LoggedUserUseCase implements UseCase<User, NoParams> {
  LoggedUserUseCase({
    @required this.userLocalRepository,
    @required this.firebaseAuth,
  });

  final UserLocalRepository userLocalRepository;
  final fAuth.FirebaseAuth firebaseAuth;

  @override
  Future<Either<Failure, User>> call(NoParams params,
      {Callback callback}) async {
    final currentUser = firebaseAuth.currentUser;

    if (currentUser != null) {
      return userLocalRepository.getCurrentUser();
    }

    return Left(UserNotFoundFailure());
  }
}
