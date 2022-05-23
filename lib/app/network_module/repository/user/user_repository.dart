import 'dart:async';
import 'dart:convert';

import 'package:whiteproject/app/utils/my_shared_preferences.dart';
import 'package:whiteproject/network_kit/api/api_client.dart';
import 'package:whiteproject/network_kit/models/user.dart';


class UserRepository {
  static Future<User?> getCurrentUser() async {
    final key = ApiClient.shared.isLiveServer()
        ? 'oop_live_user_data'
        : 'oop_staging_user_data';
    return MySharedPreferences.instance.getStringValue(key).then((_saved) {
      if (_saved.isNotEmpty) {
        return User.fromJson(json.decode(_saved));
        // return compute(parseUser, _saved);
      } else {
        return null;
      }
    });
  }

  // A function that converts a response body into a List<Photo>.
  static User parseUser(String responseBody) {
    return User.fromJson(json.decode(responseBody));
  }

  static void saveLoginData(User user) {
    var _save = json.encode(user.toJson());
    var key = ApiClient.shared.isLiveServer()
        ? 'oop_live_user_data'
        : 'oop_staging_user_data';
    MySharedPreferences.instance.setStringValue(key, _save);
  }

  static void removeLoginData() {
    var key = ApiClient.shared.isLiveServer()
        ? 'oop_live_user_data'
        : 'oop_staging_user_data';
    MySharedPreferences.instance.removeValue(key);
  }
}
