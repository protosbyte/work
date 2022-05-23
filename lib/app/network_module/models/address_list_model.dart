import 'dart:convert';

AddressList addressListFromJson(String str) => AddressList.fromJson(json.decode(str));

String addressListToJson(AddressList data) => json.encode(data.toJson());

class AddressList {
  AddressList({
    required this.firstname,
    required this.lastname,
    required this.street,
    required this.phone,
    required this.company,
    required this.vatId,
    required this.city,
    required this.region,
    required this.postcode,
    required this.countryCode,
    this.isChecked = false,
    required this.id,
    required this.defaultBilling,
    required this.defaultShipping
  });
  int id;
  String firstname;
  String lastname;
  List<String> street;
  String city;
  Region region;
  String postcode;
  String company;
  String vatId;
  String phone;
  String countryCode;
  bool isChecked;
  bool defaultShipping;
  bool defaultBilling;

  factory AddressList.fromJson(Map<String, dynamic> json) => AddressList(
    firstname: json["firstname"],
    id: json["id"]??0,
    lastname: json["lastname"],
    street: List<String>.from(json["street"].map((x) => x)),
    city: json["city"],
    region: Region.fromJson(json["region"]),
    postcode: json["postcode"]??'',
    countryCode: json["country_code"]??"",
    phone: json["telephone"]??"",
    company: json["company"]??"",
    vatId: json["vat_id"]??"",
    defaultBilling: json["default_billing"]?? false,
    defaultShipping: json["default_shipping"]??false
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "street": List<dynamic>.from(street.map((x) => x)),
    "city": city,
    // "region": region.toJson(),
    // "postcode": postcode,
    // "country_code": countryCode,
    // "telephone": telephone,
  };
}

class Region {
  Region({
   required this.regionCode,
    required this.region,
  });

  String regionCode;
  String region;

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    regionCode: json["region_code"]??'',
    region: json["region"]??'',
  );

  Map<String, dynamic> toJson() => {
    "region_code": regionCode,
    "region": region,
  };
}
