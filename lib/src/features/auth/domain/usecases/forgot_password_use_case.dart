import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<void, String> {
  final AuthRepository authRepository;

  ForgotPasswordUseCase({
    @required this.authRepository,
  });

  @override
  Future<Either<Failure, void>> call(String email, {Callback callback}) async {
    final result = await authRepository.sendPasswordResetEmail(email);

    return result == null ? Right(null) : Left(result);
  }
}
