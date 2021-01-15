import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  LogoutUseCase({
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params,
      {Callback callback}) async {
    try {
      authRepository.logout();
      return Right(null);
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }
}
