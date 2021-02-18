import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/places/data/models/place_model.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';


class GetPlacesByCategoryUseCase extends UseCase<PlaceListingModel, GetPlacesParams>{

  final PlacesRepository placeRepository;

  GetPlacesByCategoryUseCase({@required this.placeRepository});

  @override
  Future<Either<Failure, PlaceListingModel>> call(params, {callback}) {
    return placeRepository.listPlacesByCategory(params.municipality, params.category);
  }

}

class GetPlacesParams extends Equatable{
  final String municipality;
  final String category;

  final double latitude;
  final double longitude;
  final double distance;

  GetPlacesParams({this.municipality, this.category, this.latitude, this.longitude, this.distance});

  @override
  List<Object> get props => [];
}