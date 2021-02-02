import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:smart_cities/src/core/util/flavor_config.dart';
//import 'package:smart_cities/src/core/api/dio_interceptor.dart';

import '../error/exception.dart';

abstract class BaseDioClient {
  final DataConnectionChecker _connectionChecker;
  Dio _instance;

  BaseDioClient(
    this._connectionChecker,
  );

  String get _apiBaseUrl => FlavorConfig?.instance?.values?.baseApiUrl ?? "";

  Future<String> getToken();


  Future<Dio> getDio() async {
    //await checkDeviceConnected();
    _instance = Dio();
    _instance.options.baseUrl = _apiBaseUrl;
    _instance.options.connectTimeout = 12000;
    _instance.options.headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${await _getToken()}"
    };

    //final performanceInterceptor = DioFirebasePerformanceInterceptor();
    //_instance.interceptors.add(DioInterceptor());
    _instance.interceptors.add(DioCacheManager(CacheConfig(baseUrl: _apiBaseUrl)).interceptor);

    return _instance;
  }

  Future<String> _getToken() async {
    final token = await getToken();

    if (token == null) throw NotTokenException();

    return token;
  }


  Future<Response> get(url, {Map<String, String> headers}) async {
    if(_instance==null)
      await getDio();

    final response = await _instance.get(url, queryParameters: headers ?? null, options: buildCacheOptions(Duration(days: 7)));
    return _processResponse(response);
  }

  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) async {
    if(_instance==null)
      await getDio();

    final response = await _instance.post(url, data: body, queryParameters: headers ?? null, options: buildCacheOptions(Duration(days: 7)));

    return _processResponse(response);
  }

  Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) async {
    if(_instance==null)
      await getDio();

    final response = await _instance.put(url, data: body, queryParameters: headers ?? null, options: buildCacheOptions(Duration(days: 7)));

    return _processResponse(response);
  }


  Future<Response> delete(url, {Map<String, String> headers}) async {
    if(_instance==null)
      await getDio();

    final response = await _instance.delete(url, queryParameters: headers ?? null, options: buildCacheOptions(Duration(days: 7)));

    return _processResponse(response);
  }

  Future<void> checkDeviceConnected() async {
    final isDeviceConnected = await _connectionChecker.hasConnection;

    if (!isDeviceConnected) {
      throw (NotConnectionException(
          "No Internet, Reason: ${_connectionChecker?.lastTryResults?.toString() ?? ""}"));
    }
  }

  Future<String> checkToken(String token) async {
    return _getToken();
  }




  Response _processResponse(Response response) {
    var statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode <= 300) {
      return response;
    } else if (statusCode == 400) {
      throw BadRequestException(response.data.toString());
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorisedException(response.data.toString());
    } else {
      throw ServerException(
          'Error occured while Communication with Server with StatusCode : $statusCode');
    }
  }
}
