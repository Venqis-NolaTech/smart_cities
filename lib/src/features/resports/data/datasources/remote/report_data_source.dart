import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../../../../core/api/auth_client.dart';
import '../../../../../core/api/public_http_client.dart';
import '../../../../../core/models/catalog_item_model.dart';
import '../../../../../core/models/response_model.dart';
import '../../models/report_model.dart';

abstract class ReportDataSource {
  Future<ReportModel> createReport(Map<String, dynamic> request);

  Future<ReportModel> updateReport(String id, Map<String, dynamic> request);

  Future<ReportListingModel> getGeneralReports({int page, int count, String municipality});

  Future<List<ReportModel>> getNearbyReports({
    double latitude,
    double longitude,
    double distance,
    String municipality
  });

  Future<ReportListingModel> getMyReports({int page, int count});

  Future<ReportModel> getReportById(String id);

  Future<ReportCommentListingModel> getReportComments(
    String reportId, {
    int page,
    int count,
  });

  Future<ReportModel> likeReport(String reportId);

  Future<ReportCommentModel> createComment({
    String reportId,
    Map<String, dynamic> request,
  });

  Future<ReportCommentModel> updateComment({
    String reportId,
    String commentId,
    Map<String, dynamic> request,
  });


  Future<List<CatalogItemModel>> getCategory();

}

class ReportDataSourceImpl implements ReportDataSource {
  ReportDataSourceImpl({
    @required this.authHttpClient,
    @required this.publicHttpClient,
  });

  final AuthHttpClient authHttpClient;
  final PublicHttpClient publicHttpClient;

  //String get baseApiUrl => FlavorConfig.instance?.values?.baseApiUrl ?? "";

  @override
  Future<ReportModel> createReport(Map<String, dynamic> request) async {
    var payload = json.encode(request);

    var response = await authHttpClient.post(
      '/api/report',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return ReportModel.fromJson(body.data);
  }

  @override
  Future<ReportModel> updateReport(
      String id, Map<String, dynamic> request) async {
    var payload = json.encode(request);

    var response = await authHttpClient.put(
      '/api/report/$id',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return ReportModel.fromJson(body.data);
  }


  @override
  Future<ReportListingModel> getMyReports({int page, int count}) {
    final queryParams = Map<String, String>();

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    return _listingsRequest('/api/report/my', queryParams);
  }

  @override
  Future<List<ReportModel>> getNearbyReports({
    double latitude,
    double longitude,
    double distance,
    String municipality
  }) async {
    final queryParams = Map<String, String>();

    if (latitude != null && longitude != null && distance != null) {
      queryParams['latitude'] = '$latitude';
      queryParams['longitude'] = '$longitude';
      queryParams['distanceRadius'] = '$distance';
    }

    return _reportsRequest('/api/report/municipality/$municipality/nearby', queryParams);
  }


  @override
  Future<ReportModel> getReportById(String id) async {
    final response =
        await authHttpClient.get('/api/report/$id');

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return ReportModel.fromJson(body.data);
  }

  @override
  Future<ReportModel> likeReport(String reportId) async {
    final response =
        await authHttpClient.post('/api/report/$reportId/follow');

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return ReportModel.fromJson(body.data);
  }

  @override
  Future<ReportCommentListingModel> getReportComments(
    String reportId, {
    int page,
    int count,
  }) {
    final queryParams = Map<String, String>();

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    return _commentsRequest(
        '/api/report/$reportId/comment', queryParams);
  }

  @override
  Future<ReportCommentModel> createComment({
    String reportId,
    Map<String, dynamic> request,
  }) async {
    var payload = json.encode(request);

    var response = await authHttpClient.post(
      '/api/report/$reportId/comment',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return ReportCommentModel.fromJson(body.data);
  }


  @override
  Future<ReportCommentModel> updateComment({String reportId, String commentId, Map<String, dynamic> request}) async {
    var payload = json.encode(request);

    var response = await authHttpClient.put(
      '/api/report/$reportId/comment/$commentId',
      body: payload,
    );

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return ReportCommentModel.fromJson(body.data);
  }


  @override
  Future<List<CatalogItemModel>> getCategory() async {
    final response = await publicHttpClient.get('/api/report/category');

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    final list = body.data.containsKey('reportcategory') ? body.data['reportcategory'] as List : [];

    return list.map((json) => CatalogItemModel.fromJson(json)).toList();
  }

  //--- private methods ---//
  Future<ReportListingModel> _listingsRequest(
      String urlPath, Map<String, String> queryParams) async {
    final response = await _getRequest(urlPath, queryParams);

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return ReportListingModel.fromJson(body.data);
  }

  Future<List<ReportModel>> _reportsRequest(
      String urlPath, Map<String, String> queryParams) async {
    final response = await _getRequest(urlPath, queryParams);

    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    final list =
        body.data.containsKey('reports') ? body.data['reports'] as List : [];

    return list.map((json) => ReportModel.fromJson(json)).toList();
  }

  Future<ReportCommentListingModel> _commentsRequest(
      String urlPath, Map<String, String> queryParams) async {
    final response = await _getRequest(urlPath, queryParams);

    var body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);

    return ReportCommentListingModel.fromJson(body.data);
  }

  Future<Response> _getRequest(
      String urlPath, Map<String, String> queryParams) {
    //final authority = baseApiUrl.replaceAll('https://', '');
    //final uri = Uri.https(authority, urlPath, queryParams);

    return authHttpClient.get(urlPath, headers: queryParams);
  }


  @override
  Future<ReportListingModel> getGeneralReports({int page, int count, String municipality}) async {
    final queryParams = Map<String, String>();

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    return _listingsRequest('/api/report/municipality/$municipality', queryParams);
  }

}
