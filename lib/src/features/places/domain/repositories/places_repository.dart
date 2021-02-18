import 'package:dartz/dartz.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/places/data/models/place_model.dart';

import '../../../../core/error/failure.dart';


abstract class PlacesRepository{


  Future<Either<Failure, List<CatalogItem>>> listCategory();
  Future<Either<Failure, PlaceListingModel>> listPlaces(String municipality,);

  Future<Either<Failure, PlaceListingModel>> listPlacesByCategory(
      String municipality, String category);

  Future<Either<Failure, PlaceModel>> getPlace(String placeId);

  Future<Either<Failure, LastCommentModel>> sendComment({
      String placeId,
      Map<String, dynamic> request});

  Future<Either<Failure, PlaceCommentListingModel>> getComments(String placeId, {int page, int count});
  //Future<Either<Failure, dynamic>> getMyComments();

  Future<Either<Failure, PlaceListingModel>> getNearbyPlaces(
      {double latitude,
      double longitude,
      double distance,
      String municipality,
      String category});
}