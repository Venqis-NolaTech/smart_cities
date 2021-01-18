

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';


import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';



class GetUserValidateUseCase implements UseCase<User, NoParams> {
  final FirebaseAuth firebaseAuth;

  GetUserValidateUseCase({
    @required this.firebaseAuth,
  });

  @override
  Future<Either<Failure, User>> call(NoParams params, {callback}) async{

    final currentUser = firebaseAuth.currentUser;

    if (currentUser != null) {
      return Right(currentUser);
    }

    return Left(UserNotFoundFailure());
  }


}


