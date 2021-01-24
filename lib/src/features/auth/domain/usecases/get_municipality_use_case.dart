import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';


class GetMunicipalityUseCase extends UseCase<List<CatalogItem>, NoParams> {
  final UserRepository userRepository;

  GetMunicipalityUseCase({@required this.userRepository});

  @override
  Future<Either<Failure, List<CatalogItem>>> call(NoParams params, {callback}) {
    return userRepository.getMunicipality();
  }

}