import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:whiteproject/network_module/exceptions/NetworkException.dart';
import 'package:whiteproject/network_module/http_client.dart';
import 'package:whiteproject/network_module/models/login/new_account_access_token.dart';

class AuthRepository {
  final Dio dio = HttpClient().createDioMain();

  // "https://whiteproject.mynet.company.net/    rest/all/V1";
  Future<String> logIn ({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);

    try {
      var response = await dio.post(
          "/rest/all/V1/integration/admin/token",
          data:{"username": "$username" ,"password": "$password"},
          );
      // _controller.add(AuthenticationStatus.authenticated);
      return response.data;
    } catch (e) {
      throw NetworkException(e);
    }
  }

  Future<String> attemptAutoLogin() async {
    await Future.delayed(Duration(seconds: 1));
    throw Exception('not signed in');
  }

  Future<String> login({
    @required String username,
    @required String password,
  }) async {
    print('attempting login');
    await Future.delayed(Duration(seconds: 3));
    return 'abc';
  }

  Future<void> signUp({
    @required String username,
    @required String email,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 2));
  }

  Future<String> confirmSignUp({
    @required String username,
    @required String confirmationCode,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return 'abc';
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 2));
  }

}
