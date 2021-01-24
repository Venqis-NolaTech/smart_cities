import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/api/auth_client.dart';
import 'package:smart_cities/src/core/api/base_http_client.dart';

import '../../../../../core/api/public_http_client.dart';
import '../../../../../core/entities/response_model.dart';
import '../../../../../core/util/flavor_config.dart';
import '../../../domain/entities/post.dart';
import '../../models/post_new_model.dart';
import '../../models/post_training_model.dart';

abstract class BlogDataSource {
  Future<PostListingsModel> getAllPosts({
    PostKind kind,
    int page,
    int count,
  });

  Future<PostListingsModel> getLastPosts({
    int page,
    int count,
  });

  Future<PostModel> getPostNewsDetail(String postId);

  Future<PostTrainingModel> getPostAnnouncementDetail(String postId);

  Future<PostTrainingModel> getPostTrainingDetail(String postId);

  Future<PostModel> like(String postId);
}

class BlogDataSourceImpl extends BlogDataSource {
  BlogDataSourceImpl({
    @required this.publicHttpClient,
    @required this.authHttpClient,
  });

  final PublicHttpClient publicHttpClient;
  final AuthHttpClient authHttpClient;

  String get baseApiUrl => FlavorConfig.instance?.values?.baseApiUrl ?? "";

  @override
  Future<PostListingsModel> getAllPosts({
    PostKind kind,
    int page,
    int count,
  }) async {
    final queryParams = Map<String, String>();

    if (kind != null) {
      queryParams['kind'] = '${kind.value}';
    }

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    final response = await _getRequest(
      '/api/notice/notice/private',
      queryParams,
      authHttpClient,
    );

    final body = ResponseModel<Map<String, dynamic>>.fromJson(
      json.decode(response.body),
    );

    return PostListingsModel.fromJson(body.data);
  }

  @override
  Future<PostListingsModel> getLastPosts({
    int page,
    int count,
  }) async {
    final queryParams = Map<String, String>();

    if (page != null && count != null) {
      queryParams['page'] = '$page';
      queryParams['count'] = '$count';
    }

    final response = await _getRequest(
      '/api/notice/last',
      queryParams,
      publicHttpClient,
    );

    final body = ResponseModel<Map<String, dynamic>>.fromJson(
      json.decode(response.body),
    );

    return PostListingsModel.fromJson(body.data);
  }

  @override
  Future<PostModel> getPostNewsDetail(String postId) async {
    final response =
        await publicHttpClient.get('$baseApiUrl/api/notice/news/$postId');

    var body = ResponseModel<Map<String, dynamic>>.fromJson(
      json.decode(response.body),
    );

    return PostModel.fromJson(body.data);
  }

  @override
  Future<PostTrainingModel> getPostAnnouncementDetail(String postId) async {
    final response = await publicHttpClient
        .get('$baseApiUrl/api/notice/announcement/$postId');

    var body = ResponseModel<Map<String, dynamic>>.fromJson(
      json.decode(response.body),
    );

    return PostTrainingModel.fromJson(body.data);
  }

  @override
  Future<PostTrainingModel> getPostTrainingDetail(String postId) async {
    final response =
        await publicHttpClient.get('$baseApiUrl/api/notice/training/$postId');

    var body = ResponseModel<Map<String, dynamic>>.fromJson(
      json.decode(response.body),
    );

    return PostTrainingModel.fromJson(body.data);
  }

  @override
  Future<PostModel> like(String postId) async {
    final response =
        await authHttpClient.post('$baseApiUrl/api/notice/notice/$postId/like');

    var body = ResponseModel<Map<String, dynamic>>.fromJson(
      json.decode(response.body),
    );

    return PostModel.fromJson(body.data);
  }

  // private methods --
  Future<http.Response> _getRequest(
    String urlPath,
    Map<String, String> queryParams,
    BaseHttpClient client,
  ) {
    final authority = baseApiUrl.replaceAll(RegExp(r'https://|http://'), '');
    final uri = Uri.https(authority, urlPath, queryParams);

    return client.get(uri);
  }

  // -- private methods
}
