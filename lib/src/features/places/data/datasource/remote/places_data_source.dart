import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import 'package:smart_cities/src/features/places/data/models/place_model.dart';
import 'package:smart_cities/src/core/api/auth_client.dart';
import 'package:smart_cities/src/core/util/flavor_config.dart';


import '../../../../../core/api/public_http_client.dart';
import '../../../../../core/models/catalog_item_model.dart';
import '../../../../../core/models/response_model.dart';

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


  Future<PlaceListingModel> getNearbyPlaces({ //ReportModel
    double latitude,
    double longitude,
    double distance,
    String municipality,
    String category
  });

}


class PlacesDataSourceImpl extends PlacesDataSource{
  final PublicHttpClient publicHttpClient;
  final AuthHttpClient authHttpClient;

  PlacesDataSourceImpl({
    @required this.publicHttpClient,
    @required  this.authHttpClient
  });

  @override
  Future<LastCommentModel> createComment({String placeId, Map<String, dynamic> request}) async  {
    var payload = json.encode(request);

    var response = await authHttpClient.post(
      '/api/place/$placeId/rating',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return LastCommentModel.fromJson(body.data);
  }

  @override
  Future<List<CatalogItemModel>> getListCategory() async {
    final response = await publicHttpClient.get('/api/place/category');

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    final list = body.data.containsKey('placecategory') ? body.data['placecategory'] as List : [];

    return list.map((json) => CatalogItemModel.fromJson(json)).toList();

  }

  @override
  Future<PlaceCommentListingModel> getMyComments(String placeId, {int page, int count}) {


  }

  @override
  Future<PlaceListingModel> getNearbyPlaces(
      {double latitude,
      double longitude,
      double distance,
      String municipality,
      String category}) async {
    final queryParams = Map<String, String>();

    if (latitude != null && longitude != null && distance != null) {
      queryParams['latitude'] = '$latitude';
      queryParams['longitude'] = '$longitude';
      queryParams['distanceRadius'] = '$distance';
      queryParams['category'] = '$category';
    }

    return _placesRequest('/api/place/municipality/$municipality/nearby', queryParams);

  }

  Future<PlaceCommentListingModel> _placesCommentRequest(
      String urlPath, Map<String, String> queryParams) async {
    final response = await _getRequest(urlPath, queryParams);

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return PlaceCommentListingModel.fromJson(body.data);
  }

  Future<PlaceListingModel> _placesRequest(
      String urlPath, Map<String, String> queryParams) async {
    final response = await _getRequest(urlPath, queryParams);

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return PlaceListingModel.fromJson(body.data);
  }

  String get _apiBaseUrl => FlavorConfig?.instance?.values?.baseApiUrl ?? "";

  Future<Response> _getRequest(
      String urlPath, Map<String, String> queryParams) {

    final authority = _apiBaseUrl.replaceAll(RegExp(r'https://|http://'), '');
    final uri = Uri.https(authority, urlPath, queryParams);

    return publicHttpClient.getUri(uri);
  }


  @override
  Future<PlaceModel> getPlace(String id) async  {
    final response = await publicHttpClient.get('/api/place/$id');

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return PlaceModel.fromJson(body.data);

  }

  @override
  Future<PlaceCommentListingModel> getPlaceComments(String placeId, {int page, int count}) {
    final queryParams = Map<String, String>();

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    return _placesCommentRequest('/api/place/$placeId/rating', queryParams);

  }

  @override
  Future<PlaceListingModel> getPlaces(String municipality) {


  }

  @override
  Future<PlaceListingModel> getPlacesByCategory(String municipality, String category)  async {
    final queryParams = Map<String, String>();

    if (category != null ) {
      queryParams['category'] = '$category';
    }

    return _placesRequest('/api/place/municipality/$municipality', queryParams);
  }

}