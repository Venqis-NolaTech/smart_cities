import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;

import '../../core/util/string_util.dart';
import '../error/exception.dart';

abstract class BaseHttpClient {
  final http.Client _client;
  final DataConnectionChecker _connectionChecker;

  BaseHttpClient(
    this._client,
    this._connectionChecker,
  );

  Future<String> getToken();

  Future<http.Response> get(url, {Map<String, String> headers}) async {
    final preparedHeaders = await _prepareHeaders(headers);

    final response = await _client.get(url, headers: preparedHeaders);

    return _processResponse(response);
  }

  Future<http.Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    final preparedHeaders = await _prepareHeaders(headers);

    final response = await _client.post(url,
        headers: preparedHeaders, body: body, encoding: encoding);

    return _processResponse(response);
  }

  Future<http.Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) async {
    final preparedHeaders = await _prepareHeaders(headers);

    final response = await _client.put(url,
        headers: preparedHeaders, body: body, encoding: encoding);

    return _processResponse(response);
  }

  Future<http.Response> postMultipartRequest(
    Uri url, {
    Map<String, String> headers,
    List<http.MultipartFile> files,
    Map<String, String> fields,
  }) async {
    final request = http.MultipartRequest("POST", url);

    final token = await _getToken();
    final tokenChecked = await checkToken(token);

    final overrideHeaders = Map<String, String>();

    if (headers != null) overrideHeaders.addAll(headers);

    if (tokenChecked.isNotNullOrNotEmpty) {
      overrideHeaders[HttpHeaders.authorizationHeader] =
          'Bearer ${tokenChecked.replaceAll('"', '')}';
    }

    request.headers.addAll(overrideHeaders);
    request.files.addAll(files);
    request.fields.addAll(fields);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    return _processResponse(response);
  }

  Future<http.Response> delete(url, {Map<String, String> headers}) async {
    final preparedHeaders = await _prepareHeaders(headers);

    final response = await _client.delete(url, headers: preparedHeaders);

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

  Future<String> _getToken() async {
    final token = await getToken();

    if (token == null) throw NotTokenException();

    return token;
  }

  Future<Map<String, String>> _buildHeader({
    String token,
    Map<String, String> headers,
  }) async {
    String tokenChecked = await checkToken(token);

    final overrideHeaders = Map<String, String>();

    if (headers != null) overrideHeaders.addAll(headers);

    overrideHeaders[HttpHeaders.authorizationHeader] =
        'Bearer ${tokenChecked.replaceAll('"', '')}';
    overrideHeaders[HttpHeaders.contentTypeHeader] = 'application/json';
    return overrideHeaders;
  }

  Future<Map<String, String>> _prepareHeaders(
      Map<String, String> headers) async {
    await checkDeviceConnected();

    final token = await _getToken();

    final buildedHeaders = await _buildHeader(token: token, headers: headers);

    return buildedHeaders;
  }

  http.Response _processResponse(http.Response response) {
    var statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode <= 300) {
      return response;
    } else if (statusCode == 400) {
      throw BadRequestException(response.body.toString());
    } else if (statusCode == 401 || statusCode == 403) {
      throw UnauthorisedException(response.body.toString());
    } else {
      throw ServerException(
          'Error occured while Communication with Server with StatusCode : $statusCode');
    }
  }
}
