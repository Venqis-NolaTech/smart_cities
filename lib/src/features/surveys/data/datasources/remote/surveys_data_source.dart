import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/api/base_dio_client.dart';
import 'package:smart_cities/src/core/api/public_http_client.dart';

import '../../../../../core/api/auth_client.dart';
import '../../../../../core/models/response_model.dart';
import '../../../../../core/util/flavor_config.dart';
import '../../models/survey_model.dart';

abstract class SurveysDataSource {
  Future<SurveyModel> createSurvey(SurveyModel survey);

  Future<SurveyModel> publishSurvey(String surveyId);

  Future<SurveyModel> disableSurvey(String surveyId);

  Future<SurveyModel> updateSurvey(String surveyId, SurveyModel survey);

  Future<SurveyModel> detailsSurvey(String surveyId);

  Future<bool> deleteSurvey(String surveyId);

  Future<SurveyListingsModel> getAllSurveys({
    int page,
    int count,
  });

  Future<SurveyListingsModel> getMySurveys({
    int page,
    int count,
  });

}

class SurveysDataSourceImpl implements SurveysDataSource {
  final AuthHttpClient authHttpClient;
  final PublicHttpClient publicHttpClient ;

  SurveysDataSourceImpl({@required this.authHttpClient, @required  this.publicHttpClient, });


  @override
  Future<SurveyModel> createSurvey(SurveyModel survey) async {
    final payload = json.encode(survey.toPayload());

    print('payload nueva encuesta ${payload}');
    final response = await authHttpClient.post(
      '/api/poll',
      body: payload,
    );

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return SurveyModel.fromJson(body.data);
  }

  @override
  Future<bool> deleteSurvey(String surveyId) async {
    final response =
        await authHttpClient.delete('/api/poll/$surveyId');

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return body.success;
  }

  @override
  Future<SurveyModel> updateSurvey(String surveyId, SurveyModel survey) async {
    final payload = json.encode(survey.toPayload());

    return _updateSurvey(surveyId: surveyId, payload: payload);
  }

  @override
  Future<SurveyModel> detailsSurvey(String surveyId) async {
    final response = await authHttpClient.get(
      '/api/poll/$surveyId'
    );

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return SurveyModel.fromJson(body.data);
  }  
  

  @override
  Future<SurveyModel> publishSurvey(String surveyId) async {
    final payload = json.encode({"isPublic": true});

    return _updateSurvey(surveyId: surveyId, payload: payload);
  }

  @override
  Future<SurveyModel> disableSurvey(String surveyId) async {
    final payload = json.encode({"isPublic": false});

    return _updateSurvey(surveyId: surveyId, payload: payload);
  }

  @override
  Future<SurveyListingsModel> getAllSurveys({int page, int count}) async {
    final queryParams = Map<String, String>();

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    final response =
        await _getRequest('/api/poll/public', queryParams, publicHttpClient);

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return SurveyListingsModel.fromJson(body.data);
  }

  // private methods --
  /*Future<http.Response> _getRequest(
      String urlPath, Map<String, String> queryParams) {
    final authority = _baseApiUrl.replaceAll(RegExp(r'https://|http://'), '');
    final uri = Uri.https(authority, urlPath, queryParams);

    return authHttpClient.get(uri);
  }*/

  Future<SurveyModel> _updateSurvey({String surveyId, String payload}) async {
    final response = await authHttpClient.put(
      '/api/poll/$surveyId',
      body: payload,
    );

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return SurveyModel.fromJson(body.data);
  }  
  
  
  @override
  Future<SurveyListingsModel> getMySurveys({int page, int count}) async  {

   final queryParams = Map<String, String>();

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    final response =
        await _getRequest('/api/poll/my', queryParams, authHttpClient);

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return SurveyListingsModel.fromJson(body.data);
  }
  // -- private methods


  // private methods --
  Future<Response> _getRequest(
      String urlPath,
      Map<String, String> queryParams,
      BaseDioClient client,
      ) {
    //final authority = baseApiUrl.replaceAll(RegExp(r'https://|http://'), '');
    //final uri = Uri.https(authority, urlPath, queryParams);

    return client.get(urlPath, headers: queryParams);
  }



}
