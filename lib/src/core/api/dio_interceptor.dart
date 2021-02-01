import 'dart:async';

import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {

  DateTime beginTime;
  DateTime endTime;

  @override
  Future onRequest(RequestOptions options) async {

    beginTime = DateTime.now();

    print('***************************************************');
    print('REQUEST: ${options.uri}');
    print('***************************************************');

    return options;
  }

  @override
  Future onResponse(Response response) async {
    endTime = DateTime.now();

    print('===================================================');
    print('execution time: ${beginTime.difference(endTime).inMilliseconds.abs()} milliseconds');
    print('---------------------------------------------------');
    print('===================================================');

  }

  @override
  Future onError(DioError e) async {
    print('onError: $e');
  }
}

