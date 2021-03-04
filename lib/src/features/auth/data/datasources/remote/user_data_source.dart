import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/models/catalog_item_model.dart';

import '../../../../../core/api/auth_client.dart';
import '../../../../../core/api/public_http_client.dart';
import '../../../../../core/models/response_model.dart';
import '../../../../../core/util/flavor_config.dart';
import '../../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getProfile();

  Future<UserModel> editProfile(UserModel user);

  Future<UserModel> updatePhoto(String photoURL);

  Future<bool> registerDeviceToken({String deviceToken, String lang});

  Future<Map<String, dynamic>> getParams(String lang);

  Future<List<CatalogItem>> getMunicipality();

  Future<List<CatalogItem>> getProvince();

  Future<List<CatalogItem>> getSectores(String keyMunicipality);

  Future<List<CatalogItem>> getNeighborhood(String keySector);

}

class UserDataSourceImpl extends UserDataSource {
  UserDataSourceImpl({
    @required this.authHttpClient,
    @required this.publicHttpClient,
  });

  final AuthHttpClient authHttpClient;
  final PublicHttpClient publicHttpClient;

  String get baseApiUrl => FlavorConfig.instance?.values?.baseApiUrl ?? "";

  @override
  Future<UserModel> getProfile() async {
    final response = await authHttpClient.get('/api/user');

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return UserModel.fromJson(body.data);
  }

  @override
  Future<UserModel> editProfile(UserModel user) async {
    var payload = json.encode(user.toJsonRequest());

    final response = await authHttpClient.put(
      '/api/user',
      body: payload,
    );

    final body = ResponseModel.fromJson(response.data);

    return UserModel.fromJson(body.data);
  }

  @override
  Future<UserModel> updatePhoto(String photoURL) async {
    var payload = json.encode({'photoURL': photoURL});

    final response = await authHttpClient.put(
      '/api/user',
      body: payload,
    );

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return UserModel.fromJson(body.data);
  }

  @override
  Future<bool> registerDeviceToken({String deviceToken, String lang}) async {
    var payload = json.encode({
      "token": deviceToken,
      "lang": lang,
    });

    final response = await authHttpClient.post(
      '/api/user/messagingtoken/add',
      body: payload,
    );

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return body.success;
  }

  @override
  Future<Map<String, dynamic>> getParams(String lang) async {
    var payload = {
      "lang": lang,
    };

    final authority = baseApiUrl.replaceAll('https://', '');

    final uri = Uri.https(authority, '/api/utils/getparam', payload);

    final response = await publicHttpClient.getUri(uri);

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    final params = Map<String, dynamic>();

    if (body.data.containsKey("params")) {
      final data = body.data["params"] as List<dynamic>;

      final entries = data.map((e) => MapEntry(e["key"], e["value"]));
      entries.forEach((e) => params[e.key] = e.value);
    }

    return params;
  }

  @override
  Future<List<CatalogItem>> getMunicipality() async {
    final response = await publicHttpClient.get('/api/user/municipality');
    print('listado de municipios'+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return List<CatalogItem>.from(body.data['municipality'].map((x) => CatalogItemModel.fromJson(x)));
  }

  @override
  Future<List<CatalogItem>> getNeighborhood(String keySector) async {
    final response = await publicHttpClient.get('/api/user/sector/${keySector}/neighborhood');
    print('listado de sectores '+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
      return List<CatalogItem>.from(body.data['neighborhood'].map((x) => CatalogItemModel.fromJson(x)));
  }

  @override
  Future<List<CatalogItem>> getProvince() async {
    final response = await publicHttpClient.get('/api/user/province');
    print('listado de provincias '+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return List<CatalogItem>.from(body.data['province'].map((x) => CatalogItemModel.fromJson(x)));
  }

  @override
  Future<List<CatalogItem>> getSectores(String keyMunicipality) async {
    final response = await publicHttpClient.get('/api/user/sector?municipality=$keyMunicipality');
    print('listado de sectores '+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return List<CatalogItem>.from(body.data['sector'].map((x) => CatalogItemModel.fromJson(x)));
  }

}
