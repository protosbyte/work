import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class HttpClient {
  static final bool isDebug = true;
  final String _baseUrl = "https://whiteproject.mynet.company.net/";
  Dio? dio;
  DioCacheManager? _dioCacheManager;

  //original Singleton
  static final HttpClient _singleton = HttpClient._internal();
  factory HttpClient() => _singleton;
  HttpClient._internal();

  // static HttpClient get shared {
  //   return _singleton;
  // }

  // getHttpClient() {
  //   return dio ?? createDio();
  // }

  getCacheOptions() {
    return buildCacheOptions(Duration(days: 1));
  }

  deleteCache(String key) async {
    await _dioCacheManager!.deleteByPrimaryKey(key);
  }

  // Dio createDio2() {
  //   dio = new Dio();
  //   dio.options.headers['content-Type'] = 'application/json';
  //   // dio.options.headers['authorization'] = ' token ${token}';
  //   dio.options.baseUrl = _baseUrl;
  //   dio.options.connectTimeout = 5000;
  //   dio.options.connectTimeout = 5000;
  // }

  Dio? createDioMain() {
    dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: 100000,
      receiveTimeout: 100000,
      // 5s
      headers: {
        HttpHeaders.userAgentHeader: "dio",
        // "api": "1.0.0",
        Headers.acceptHeader:"application/json",
        Headers.contentTypeHeader: "application/json"
      },
      responseType: ResponseType.json,
    ));
    dio!.options.headers['User-Agent'] = 'whiteprojectagent';

    // dio.interceptors
    //     .add(LogInterceptor(responseBody: true, error: true, request: true, requestBody: true, requestHeader: true, responseHeader: true));

    dio!.interceptors.add(PrettyDioLogger(
      requestHeader: isDebug,
      requestBody: isDebug,
      responseBody: isDebug,
      responseHeader: isDebug,
      compact: isDebug,
    ));
    return dio;
  }

  // Dio createDio() {
  //   dio = Dio();
  //   //  dio = Dio(BaseOptions(
  //   //   baseUrl: "https://api-mysign.company.net",
  //   //   connectTimeout: 5000,
  //   //   receiveTimeout: 100000,
  //   //   // 5s
  //   //   headers: {
  //   //     HttpHeaders.userAgentHeader: "dio",
  //   //     "api": "1.0.0",
  //   //   },
  //   //   contentType: Headers.jsonContentType,
  //   //   // Transform the response data to a String encoded with UTF8.
  //   //   // The default value is [ResponseType.JSON].
  //   //   responseType: ResponseType.plain,
  //   // ));
  //   _dioCacheManager = DioCacheManager(
  //       CacheConfig(defaultMaxAge: Duration(days: 1), baseUrl: HttpClient().baseUrl, skipDiskCache: true, skipMemoryCache: false));
  //   dio.interceptors.add(_dioCacheManager.interceptor);
  //   dio.interceptors.add(PrettyDioLogger(
  //     requestHeader: isDebug,
  //     requestBody: isDebug,
  //     responseBody: isDebug,
  //     responseHeader: isDebug,
  //     compact: isDebug,
  //   ));
  //
  //   // bool refreshTokenInProgress = false;
  //   dio.interceptors.add(InterceptorsWrapper(onRequest: (RequestOptions options) {
  //     // Do something before request is sent
  //     // options.headers["Authorization"] = tokenType + " " + accessToken;
  //
  //     return options;
  //   }, onResponse: (Response response) {
  //     print("Dio Interceptor : OnResponse = \n" + response.toString());
  //     // Do something with response data
  //     return response; // continue
  //   }, onError: (DioError error) async {
  //     print("Dio Interceptor : onError = \n" + error.toString());
  //     // Do something with response error
  //     if (error.response?.statusCode == 403 /*&& refreshTokenInProgress == false*/) {
  //       // // refreshTokenInProgress = true;
  //       // dio.interceptors.requestLock.lock();
  //       // dio.interceptors.responseLock.lock();
  //       // RequestOptions options = error.response.request;
  //       //
  //       // String accessToken;
  //       // String tokenType;
  //       // AuthenticationRepository authRepo = AuthenticationRepository(AuthClient());
  //       // authRepo.getCurrentUser().then((storedUser) {
  //       //   if (storedUser != null) {
  //       //     accessToken = storedUser.refreshToken;
  //       //     tokenType = storedUser.tokenType;
  //       //   } else {
  //       //     accessToken = LoginManager.shared.currentUser.refreshToken;
  //       //     tokenType = LoginManager.shared.currentUser.tokenType;
  //       //   }
  //       //
  //       //   if (accessToken != null && accessToken.isEmpty == false) {
  //       //     authRepo.logInWithEmailAndPassword(null, null, accessToken, "refresh_token").then((user) {
  //       //       if (user != null) {
  //       //         if (authRepo.getCurrentUser() != null) {
  //       //           user.saveLoginData();
  //       //         }
  //       //         LoginManager.shared.currentUser = user;
  //       //         AuthenticationBloc(authRepo).add(UserLoggedIn(user: user));
  //       //
  //       //         if (user.accessToken != null && user.accessToken.isEmpty == false) {
  //       //           options.headers["Authorization"] = user.tokenType + " " + user.accessToken;
  //       //         }
  //       //
  //       //         dio.interceptors.requestLock.unlock();
  //       //         dio.interceptors.responseLock.unlock();
  //       //         // refreshTokenInProgress = false;
  //       //         return dio.request(options.path, options: options);
  //       //       } else {
  //       //         // refreshTokenInProgress = false;
  //       //         return error;
  //       //       }
  //       //     });
  //       //   } else {
  //       //     // refreshTokenInProgress = false;
  //       //     return error;
  //       //   }
  //       // });
  //     } else {
  //       // refreshTokenInProgress = false;
  //       return error;
  //     }
  //   }));
  //
  //   return dio;
  // }

// Must be top-level function
  _parseAndDecode(String response) {
    return jsonDecode(response);
  }

  parseJson(String text) {
    return compute(_parseAndDecode, text);
  }
}
