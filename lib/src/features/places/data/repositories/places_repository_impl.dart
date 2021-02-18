import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/places/data/models/place_model.dart';
import 'package:smart_cities/src/features/places/domain/repositories/places_repository.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../data/datasource/remote/places_data_source.dart';


class PlaceRepositoryImpl extends PlacesRepository {

  PlaceRepositoryImpl({@required  this.placesDataSource});

  final PlacesDataSource placesDataSource;

  @override
  Future<Either<Failure, PlaceCommentListingModel>> getComments(
      String placeId, {int page, int count}) =>
      _process(
            () => placesDataSource.getPlaceComments(
          placeId,
          page: page,
          count: count,
        ),
      );


  @override
  Future<Either<Failure, PlaceListingModel >> getNearbyPlaces(
          {double latitude,
          double longitude,
          double distance,
          String municipality,
          String category}) =>
      _process(
            () => placesDataSource.getNearbyPlaces(
          latitude: latitude,
          longitude: longitude,
          distance: distance,
          municipality: municipality,
          category: category
        ),
      );



  @override
  Future<Either<Failure, PlaceModel>> getPlace(String placeId) =>
      _process(
            () => placesDataSource.getPlace(placeId),
      );

  @override
  Future<Either<Failure, List<CatalogItem>>> listCategory()=>
      _process(
            () => placesDataSource.getListCategory(),
      );


  @override
  Future<Either<Failure, PlaceListingModel>> listPlaces(String municipality) =>
      _process(
            () => placesDataSource.getPlaces(municipality),
      );

  @override
  Future<Either<Failure, PlaceListingModel>> listPlacesByCategory(String municipality, String category) =>
      _process(
            () => placesDataSource.getPlacesByCategory(municipality, category),
      );


  @override
  Future<Either<Failure, LastCommentModel>> sendComment({String placeId, Map<String, dynamic> request}) =>
      _process(
            () => placesDataSource.createComment(placeId: placeId, request: request),
      );


  //--- private methods ---//
  Future<Either<Failure, T>> _process<T>(Future<T> Function() action) async {
    try {
      final result = await action();

      if (result == null) {
        return Left(UnexpectedFailure());
      }

      return Right(result);
    } catch (e, s) {
      switch (e.runtimeType) {
        case NotConnectionException:
          return Left(NotConnectionFailure());
        case UserNotFoundException:
          return Left(UserNotFoundFailure());
        default:
          FirebaseCrashlytics.instance.recordError(e, s);

          return Left(UnexpectedFailure());
      }
    }
  }
}