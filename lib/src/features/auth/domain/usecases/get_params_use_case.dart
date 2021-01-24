import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/user_repository.dart';

class GetParamsUseCase extends UseCase<Map<String, dynamic>, String> {
  GetParamsUseCase({@required this.userRepository});

  final UserRepository userRepository;

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String lang,
      {Callback callback}) async {
    return userRepository.getParams(lang);
  }
}
