import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/places/data/models/place_model.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_places_by_category_use_case.dart';

class GetNearbyPlacesByCategoryUseCase extends UseCase<PlaceListingModel, GetPlacesParams>{

  final PlacesRepository placeRepository;

  GetNearbyPlacesByCategoryUseCase({@required this.placeRepository});

  @override
  Future<Either<Failure, PlaceListingModel>> call(params, {callback}) {
    return placeRepository.listPlacesByCategory(params.municipality, params.category);
    return placeRepository.getNearbyPlaces(municipality: params.municipality,
        category: params.category, latitude: params.latitude,
        longitude: params.longitude, distance: params.distance);
  }
}