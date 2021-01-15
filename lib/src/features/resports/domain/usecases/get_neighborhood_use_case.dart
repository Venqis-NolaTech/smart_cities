

import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';


class GetNeighborhoodUseCase extends UseCase<List<CatalogItem>, String> {
  final UserRepository userRepository;

  GetNeighborhoodUseCase({@required this.userRepository});

  @override
  Future<Either<Failure, List<CatalogItem>>> call(String sector, {callback}) {
    return userRepository.getNeighborhood(sector);
  }

}

