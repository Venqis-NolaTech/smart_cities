
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/core/usecases/use_case.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/get_current_location_use_case.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_nearby_places_by_category_use_case.dart';
import 'package:smart_cities/src/features/places/domain/usescase/get_places_by_category_use_case.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/paginated_provider.dart';

class NearbyPlacesProvider extends PaginatedProvider<Place>{

  NearbyPlacesProvider({
    @required this.getNearbyPlacesByCategoryUseCase,
    @required this.getCurrentLocationUseCase,

  });

  final GetNearbyPlacesByCategoryUseCase getNearbyPlacesByCategoryUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  String municipality;
  String category;
  Position currentLocation;
  final distance = 5000.0;

  @override
  Future<Either<Failure, PageData<Place>>> get processRequest async {
    if (currentLocation == null)
      await getCurrentLocation(notify: false);


    final params = GetPlacesParams(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude,
        distance: distance,
        municipality: municipality,
        category: category
    );

    final failureOrListings = await getNearbyPlacesByCategoryUseCase(params);


    return failureOrListings.fold(
          (failure) => Left(failure),
          (listings) => Right(
        PageData(
          totalCount: listings.totalCount,
          items: listings.places,
        ),
      ),
    );

  }

  Future<Position> getCurrentLocation({bool notify = true}) async {

    final failureOrLocation = await getCurrentLocationUseCase(NoParams());

    final location = failureOrLocation.fold(
          (_) => Position(
        latitude: kDefaultLocation.latitude,
        longitude: kDefaultLocation.longitude,
      ),
          (location) => location,
    );

    currentLocation = location;
    return currentLocation;
  }

}