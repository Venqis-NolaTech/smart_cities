import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:meta/meta.dart';

import '../../features/auth/data/datasources/local/user_data_source.dart';
import '../models/response_model.dart';
import '../util/jwt_util.dart';
import 'base_dio_client.dart';
import 'public_http_client.dart';

class AuthHttpClient extends BaseDioClient {
  AuthHttpClient({
    @required this.userLocalDataSource,
    @required this.publicHttpClient,
    @required DataConnectionChecker dataConnectionChecker,
  }) : super(
          dataConnectionChecker,
        );

  final UserLocalDataSource userLocalDataSource;
  final PublicHttpClient publicHttpClient;


  @override
  Future<String> getToken() async {
    return userLocalDataSource.getToken();
  }

  @override
  Future<String> checkToken(String token) async {
    if (JwtUtils.isTokenExpired(token)) {
      await _refreshToken();
      return getToken();
    }
    return token;
  }

  Future<void> _refreshToken() async {
    final refreshToken = userLocalDataSource.getRefreshToken();

    final payload = json.encode({'refreshToken': refreshToken});

    final response = await publicHttpClient.post('/api/auth/refresh', body: payload);

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    userLocalDataSource.setToken(body.data['token']);
  }
}
