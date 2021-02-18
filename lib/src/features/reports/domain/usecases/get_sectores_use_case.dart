

import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/repositories/user_local_repository.dart';
import 'package:smart_cities/src/features/auth/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';


class GetSectoresUseCase extends UseCase<List<CatalogItem>, NoParams> {
  final UserRepository userRepository;
  final UserLocalRepository userLocalRepository;

  GetSectoresUseCase({
    @required this.userRepository,
    @required this.userLocalRepository,
  });

  @override
  Future<Either<Failure, List<CatalogItem>>> call(NoParams params, {callback}) async  {

    final failureOrUser = userLocalRepository.getCurrentUser();

    return failureOrUser.fold(
            (failure) => Left(failure),
            (user) async {
              return await userRepository.getSectores(user.municipality.key);
            }
    );
  }

}

