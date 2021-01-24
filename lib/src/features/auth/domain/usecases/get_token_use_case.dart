import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/user_local_repository.dart';

class GetTokenUseCase implements UseCase<String, NoParams> {
  GetTokenUseCase({
    @required this.userLocalRepository,
  });

  final UserLocalRepository userLocalRepository;

  @override
  Future<Either<Failure, String>> call(NoParams params,
      {Callback callback}) async {
    return userLocalRepository.getToken();
  }
}
