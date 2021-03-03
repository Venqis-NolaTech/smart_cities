import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/auth_repository.dart';

class UserExistUseCase extends UseCase<bool, String> {
  UserExistUseCase({@required this.authRepository});

  final AuthRepository authRepository;

  @override
  Future<Either<Failure, bool>> call(String params, {Callback callback}) async {
    //final failure = await authRepository.existUser(params.phoneNumber, params.email, params.dni);
    //return failure == null ? Right(true) : Left(failure);
    final failure = await authRepository.existUser(params);
    return failure == null ? Right(true) : Left(failure);
  }
}

class UserExistParam extends Equatable{
  final String email;
  final String dni;
  final String phoneNumber;

  UserExistParam({this.email, this.dni, this.phoneNumber});

  @override
  // TODO: implement props
  List<Object> get props => [
    email, dni, phoneNumber
  ];
}
