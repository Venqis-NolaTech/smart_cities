
import 'dart:convert';

import 'package:smart_cities/src/core/api/auth_client.dart';
import 'package:smart_cities/src/core/entities/response_model.dart';
import 'package:smart_cities/src/features/help_line/data/model/streaming_model.dart';

abstract class StreamingDataSource{
  Future<StreamingModel> getDataConnect(String canal, double latitude, double longitude);
}



class StreamingDataSourceImpl implements StreamingDataSource{
  final AuthHttpClient authHttpClient;

  StreamingDataSourceImpl({this.authHttpClient});

  @override
  Future<StreamingModel> getDataConnect(String canal, double latitude, double longitude) async{
    var payload = json.encode({
      "role" : "PUBLISHER",
      "channel" : canal,
      "latitude" : latitude,
      "longitude": longitude
    });
    
    final response = await authHttpClient.post(
        '/api/streaming/token',
        body: payload);

    print('streaming token '+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return StreamingModel.fromJson(body.data);
  }

}



