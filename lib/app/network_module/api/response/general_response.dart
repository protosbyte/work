import 'dart:convert';

GeneralResponse responseFromJson(String str) =>
    GeneralResponse.fromJson(json.decode(str) as Map<String, dynamic>);

String profileToJson(GeneralResponse data) => json.encode(data.toJson());

class GeneralResponse {
  String? detail;

  GeneralResponse({this.detail});

  String getDetail() {
    return detail ?? '';
  }

  factory GeneralResponse.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null && json['detail'] is String) {
      return GeneralResponse(detail: json['detail'] as String);
    } else if (json['detail'] != null) {
      try {
        return GeneralResponse(detail: json['detail'][0]['msg'] as String?);
      } catch (e) {}
    }
    return GeneralResponse(detail: '');
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'detail': detail};
}
