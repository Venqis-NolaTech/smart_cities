
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';

class GetPlaceByIdUseCase extends UseCase<Place, String>{
  final PlacesRepository placeRepository;

  GetPlaceByIdUseCase({@required this.placeRepository});

  @override
  Future<Either<Failure, Place>> call(String params, {callback}) {
    return placeRepository.getPlace(params);
  }

}