import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

class SendEmailVerificationUseCase implements UseCase<void, NoParams> {
  final AuthRepository authRepository;

  SendEmailVerificationUseCase({
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params,
      {Callback callback}) async {
    final result = await authRepository.sendEmailVerification();

    return result == null ? Right(null) : Left(result);
  }
}
