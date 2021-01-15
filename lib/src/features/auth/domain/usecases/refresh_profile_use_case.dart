import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_local_repository.dart';
import '../repositories/user_repository.dart';

class RefreshProfileUseCase implements UseCase<User, User> {
  RefreshProfileUseCase({
    @required this.userRepository,
    @required this.userLocalRepository,
  });

  final UserRepository userRepository;
  final UserLocalRepository userLocalRepository;

  @override
  Future<Either<Failure, User>> call(User user, {Callback callback}) async {
    if (user != null) return userLocalRepository.createUser(user);

    final failureOrProfile = await userRepository.getProfile();

    return failureOrProfile.fold(
      (failure) => Left(failure),
      (profile) => userLocalRepository.createUser(profile),
    );
  }
}
