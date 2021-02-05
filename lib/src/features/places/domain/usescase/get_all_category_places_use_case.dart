import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';

class GetAllCategoryPlacesUseCase extends UseCase<List<CatalogItem>, NoParams>{

  final PlacesRepository placeRepository;

  GetAllCategoryPlacesUseCase({@required this.placeRepository});

  @override
  Future<Either<Failure, List<CatalogItem>>> call(params, {callback}) {
    return placeRepository.listCategory();
  }



}