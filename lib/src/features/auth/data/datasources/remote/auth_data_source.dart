import 'dart:convert';

import 'package:meta/meta.dart';

import '../../../../../core/api/public_http_client.dart';
import '../../../../../core/entities/response_model.dart';
import '../local/user_data_source.dart';

abstract class AuthDataSource {
  Future<bool> login(String firebaseToken);
  Future<bool> register(String firebaseToken, {Map<String, dynamic> request});
  Future<bool> userExist(String phoneNumber);
  Future<bool> validation(String firebaseToken);
}

class AuthDataSourceImpl extends AuthDataSource {
  AuthDataSourceImpl({
    @required this.publicHttpClient,
    @required this.userLocalDataSource,
  });

  final PublicHttpClient publicHttpClient;
  final UserLocalDataSource userLocalDataSource;

  //String get baseApiUrl => FlavorConfig.instance?.values?.baseApiUrl ?? "";

  @override
  Future<bool> login(String firebaseToken) async {
    var payload = json.encode({
      'firebaseToken': '$firebaseToken',
    });

    final response = await publicHttpClient.post('/api/auth/login',
        body: payload);

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    _setTokes(body);

    return body.success;
  }

  @override
  Future<bool> register(
    String firebaseToken, {
    Map<String, dynamic> request,
  }) async {
    final Map<String, dynamic> payload = {'firebaseToken': '$firebaseToken'};
    print('---- firebaseToken -------');
    print('$firebaseToken');

    if (request != null && request.isNotEmpty)
      payload.addAll({'payload': request});

    final response = await publicHttpClient.post('/api/auth/register', body: json.encode(payload));

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    _setTokes(body);

    return body.success;
  }

  @override
  Future<bool> userExist(String phoneNumber) async {
    var payload = json.encode(
      {
        'phoneNumber': '$phoneNumber',
      },
    );

    var response = await publicHttpClient.post(
      '/api/auth/validphone',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return body.data['register_firebase'] ?? false;
  }

  @override
  Future<bool> validation(String firebaseToken) async {
    var payload = json.encode(
      {
        'firebaseToken': '$firebaseToken',
      },
    );

    var response = await publicHttpClient.post(
      '/api/auth/validation',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return body.data['register'] ?? false;
  }

  // private methods --
  void _setTokes(ResponseModel<Map<String, dynamic>> body) {
    if (body.success) {
      userLocalDataSource.setRefreshToken(body.data['refreshToken']);
      print('---- refreshToken -------');
      print(body.data['refreshToken']);
      userLocalDataSource.setToken(body.data['token']);
      print('---- token -------');
      print(body.data['token']);
    }
  }
  // -- private methods
}
