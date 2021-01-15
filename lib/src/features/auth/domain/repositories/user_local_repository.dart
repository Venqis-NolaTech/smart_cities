import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/user.dart';

abstract class UserLocalRepository {
  Future<Either<Failure, User>> createUser(User user);
  Either<Failure, User> getCurrentUser();
  Either<Failure, String> getToken();

  Future<Either<Failure, Position>> getCurrentLocation();

  Future<bool> clear();
}
