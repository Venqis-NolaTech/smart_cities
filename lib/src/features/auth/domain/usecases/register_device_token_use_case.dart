import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/user_repository.dart';

class RegisterDeviceTokenUseCase
    implements UseCase<bool, RegisterDeviceTokenParams> {
  RegisterDeviceTokenUseCase({
    @required this.userRepository,
  });

  final UserRepository userRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterDeviceTokenParams params,
      {Callback callback}) async {
    return userRepository.registerDeviceToken(
        deviceToken: params.deviceToken, lang: params.lang);
  }
}

class RegisterDeviceTokenParams extends Equatable {
  final String deviceToken;
  final String lang;

  RegisterDeviceTokenParams({
    this.deviceToken,
    this.lang,
  });

  @override
  List<Object> get props => [
        deviceToken,
        lang,
      ];
}
