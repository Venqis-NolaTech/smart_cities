import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/features/auth/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';

class EditProfileUseCase implements UseCase<User, User> {
  EditProfileUseCase({
    @required this.userRepository,
  });

  final UserRepository userRepository;

  @override
  Future<Either<Failure, User>> call(User user, {Callback callback}) async {
    return userRepository.editProfile(user);
  }
}
