import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateProfilePhotoUseCase implements UseCase<User, File> {
  UpdateProfilePhotoUseCase({
    @required this.userRepository,
  });

  final UserRepository userRepository;

  @override
  Future<Either<Failure, User>> call(File file, {Callback callback}) async {
    return userRepository.updatePhoto(file);
  }
}
