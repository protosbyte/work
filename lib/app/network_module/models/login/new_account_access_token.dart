/// data : {"access_token":"string","expires_in":0,"expires_at":"2020-11-24T17:59:44.334Z","refresh_token":"string"}

class NewAccountAccessToken {
  Data data;

  NewAccountAccessToken({this.data});

  NewAccountAccessToken.fromJson(dynamic json) {
    data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data.toJson();
    }
    return map;
  }
}

/// access_token : "string"
/// expires_in : 0
/// expires_at : "2020-11-24T17:59:44.334Z"
/// refresh_token : "string"

class Data {
  String accessToken;
  int expiresIn;
  String expiresAt;
  String refreshToken;

  Data({this.accessToken, this.expiresIn, this.expiresAt, this.refreshToken});

  Data.fromJson(dynamic json) {
    accessToken = json["access_token"];
    expiresIn = json["expires_in"];
    expiresAt = json["expires_at"];
    refreshToken = json["refresh_token"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["access_token"] = accessToken;
    map["expires_in"] = expiresIn;
    map["expires_at"] = expiresAt;
    map["refresh_token"] = refreshToken;
    return map;
  }

  @override
  String toString() {
    return 'Data{accessToken: $accessToken, expiresIn: $expiresIn, expiresAt: $expiresAt, refreshToken: $refreshToken}';
  }
}
