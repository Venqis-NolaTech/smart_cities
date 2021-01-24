import 'dart:convert';

import 'package:smart_cities/src/core/models/response_model.dart';
import 'package:meta/meta.dart';

import '../../../../../core/api/public_http_client.dart';
import '../../../../../core/util/flavor_config.dart';
import '../../models/user_model.dart';
import '../local/user_data_source.dart';

abstract class AuthDataSource {
  Future<bool> login({String firebaseToken, String countryCode});
  Future<bool> register(String firebaseToken, UserRegisterRequestModel request);
  Future<Map<String, dynamic>> userExist(String phoneNumber, String email, String dni);
}

class AuthDataSourceImpl extends AuthDataSource {
  AuthDataSourceImpl({
    @required this.publicHttpClient,
    @required this.userLocalDataSource,
  });

  final PublicHttpClient publicHttpClient;
  final UserLocalDataSource userLocalDataSource;

  String get baseApiUrl => FlavorConfig.instance?.values?.baseApiUrl ?? "";

  @override
  Future<bool> login({String firebaseToken, String countryCode}) async {
    var payload = json.encode({
      'firebaseToken': '$firebaseToken',
      'countryCode': '$countryCode',
    });

    final response = await publicHttpClient.post('$baseApiUrl/api/auth/login',
        body: payload);

    var body = ResponseModel<Map<String, dynamic>>.fromJson(
        json.decode(response.body));

    _setTokes(body);

    return body.success;
  }

  @override
  Future<bool> register(String firebaseToken,
      UserRegisterRequestModel userRegisterRequest) async {
    var payload = json.encode({
      'firebaseToken': '$firebaseToken',
      'payload': userRegisterRequest.toJson(),
    });

    final response = await publicHttpClient
        .post('$baseApiUrl/api/auth/register', body: payload);

    var body = ResponseModel<Map<String, dynamic>>.fromJson(
        json.decode(response.body));

    _setTokes(body);

    return body.success;
  }

  @override
  Future<Map<String, dynamic>> userExist(String phoneNumber,  String email, String dni) async {
    var payload = json.encode(
      {
        'phoneNumber': '$phoneNumber',
        'email': email,
        'dni': dni
      },
    );

    var response = await publicHttpClient.post(
      '$baseApiUrl/api/auth/validphone',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(
      json.decode(response.body),
    );

    return body.data;
  }

  // private methods --
  void _setTokes(ResponseModel<Map<String, dynamic>> body) {
    if (body.success) {
      print('=======TOKEN==========');
      print(body.data['token']);
      userLocalDataSource.setRefreshToken(body.data['refreshToken']);
      userLocalDataSource.setToken(body.data['token']);
    }
  }
  // -- private methods
}
