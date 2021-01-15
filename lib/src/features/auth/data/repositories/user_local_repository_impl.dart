import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/util/string_util.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_local_repository.dart';
import '../datasources/local/user_data_source.dart';
import '../models/user_model.dart';

class UserLocalRepositoryImpl implements UserLocalRepository {
  final UserLocalDataSource userLocalDataSource;

  UserLocalRepositoryImpl({
    @required this.userLocalDataSource,
  });

  @override
  Future<Either<Failure, User>> createUser(User user) async {
    final userModel = UserModel.fromEntity(user);

    final created = await userLocalDataSource.setUser(userModel);
    return created ? Right(user) : Left(UnexpectedFailure());
  }

  @override
  Either<Failure, User> getCurrentUser() {
    try {
      final user = userLocalDataSource.getUser();
      return Right(user);
    } catch (e, s) {
      if (e is UserNotFoundException) return Left(UserNotFoundFailure());

      FirebaseCrashlytics.instance.recordError(e, s);

      return Left(UnexpectedFailure());
    }
  }

  @override
  Either<Failure, String> getToken() {
    try {
      final token = userLocalDataSource.getToken();
      if (token.isNotNullOrNotEmpty) {
        return Right(token);
      } else {
        return Left(UnexpectedFailure());
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);

      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      final result = await userLocalDataSource.getCurrentLocation();
      if (result != null) {
        return Right(result);
      } else {
        return Left(UnexpectedFailure());
      }
    } catch (e, s) {
      if (e is LocationServiceException) return Left(LocationServiceFailure());

      FirebaseCrashlytics.instance.recordError(e, s);

      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<bool> clear() {
    return userLocalDataSource.clear();
  }
}
