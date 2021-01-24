import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetProfileUseCase implements UseCase<User, NoParams> {
  GetProfileUseCase({
    @required this.userRepository,
  });

  final UserRepository userRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params,
      {Callback callback}) async {
    return userRepository.getProfile();
  }
}
