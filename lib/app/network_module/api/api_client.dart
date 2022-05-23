import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';


class ApiClient {
  ApiClient._internal();

  factory ApiClient() => _singleton;

  static const bool isDebug = true;


  final String baseUrl = 'https://baseurl.net';

  static final ApiClient _singleton = ApiClient._internal();
  Dio? dio;

  static ApiClient get shared => _singleton;

  Dio getHttpClient() {
    return dio ?? _createDio();
  }

  bool isLiveServer() {
    if (baseUrl == 'https://baseurl.net') {
      return true;
    }
    return false;
  }

  Dio _createDio() {
    dio = Dio();
    if (isDebug) {
      dio!.interceptors.add(PrettyDioLogger(
        request: isDebug,
        requestHeader: isDebug,
        requestBody: isDebug,
        responseBody: isDebug,
        responseHeader: isDebug,
        error: isDebug,
        compact: isDebug,
      ));
    }
    dio!.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      // Do something before request is sent
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      // Do something with response data
      return _handleResponse(dio!, response, handler);
    }, onError: (DioError error, handler) async {
      return handler.next(error);
    }));
    return dio!;
  }

  static _handleResponse(
      Dio dio, Response? response, ResponseInterceptorHandler handler) {
    // Do something with response error
    if (response?.statusCode == 401) {
      // refreshTokenInProgress = true;
      dio.interceptors.requestLock.lock();
      dio.interceptors.requestLock.lock();
      RequestOptions options = response!.requestOptions;

      String refreshToken;
      AuthenticationRepository authenticationRepository =
          AuthenticationRepository();
    }
    return handler.next(response!);
  }

  static void _notifyLogout() async {
    StreamingSharedPreferences.instance
        .then((preferences) => preferences.setBool('LOGOUT', true));
  }

  static Dio createSimpleDio() {
    var dio = Dio();
    return dio;
  }

// Must be top-level function
  _parseAndDecode(String response) {
    return jsonDecode(response);
  }

  parseJson(String text) {
    return compute(_parseAndDecode, text);
  }
}
