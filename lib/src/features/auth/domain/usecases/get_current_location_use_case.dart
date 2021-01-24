import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_local_repository.dart';

class GetCurrentLocationUseCase extends UseCase<Position, NoParams> {
  final UserLocalRepository userLocalRepository;

  GetCurrentLocationUseCase({@required this.userLocalRepository});

  @override
  Future<Either<Failure, Position>> call(
    NoParams params, {
    Callback callback,
  }) async {
    return await userLocalRepository.getCurrentLocation();
  }
}
