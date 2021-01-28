import 'package:smart_cities/src/features/places/data/models/place_model.dart';

import '../../../../../core/models/catalog_item_model.dart';


abstract class PlacesDataSource{
  Future<List<CatalogItemModel>> getListCategory();

  Future<PlaceListingModel> getPlaces(String municipality);

  Future<PlaceListingModel> getPlacesByCategory(String municipality, String category);

  Future<PlaceModel> getPlace(String id);

  Future<LastCommentModel> createComment({
    String placeId,
    Map<String, dynamic> request,
  });

  Future<PlaceCommentListingModel> getPlaceComments( //ReportCommentListingModel
      String placeId, {
        int page,
        int count,
      });

  Future<PlaceCommentListingModel> getMyComments( //ReportCommentListingModel
      String placeId, {
        int page,
        int count,
      });


  Future<List<PlaceModel>> getNearbyPlaces({ //ReportModel
    double latitude,
    double longitude,
    double distance,
    String municipality
  });

}