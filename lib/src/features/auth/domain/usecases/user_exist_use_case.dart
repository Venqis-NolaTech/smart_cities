import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

class UserExistUseCase extends UseCase<bool, String> {
  UserExistUseCase({@required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, bool>> call(String params, {Callback callback}) async {
    final failure = await authRepository.existUser(params);
    return failure == null ? Right(true) : Left(failure);
  }
}
