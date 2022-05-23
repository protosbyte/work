mport 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

List<User> usersFromJson(dynamic data) =>
    List<User>.from(data.map((dynamic x) => User.fromJson(x)));

@JsonSerializable()
class User extends Equatable {
  const User(
      {required this.accessToken,
      required this.id,
      required this.username,
      required this.refreshToken,
      required this.defaultBilling,
      required this.createdAt,
      required this.updatedAt,
      required this.createdIn,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.gender,
      required this.storeId,
      required this.websiteId,
      required this.disableAutoGroupChange,
      required this.defaultShipping,
      required this.groupId,
      required this.addresses,
      required this.lastname});

  final String accessToken;
  final String id;
  final String username;
  final String refreshToken;
  final String defaultBilling;
  final String createdAt;
  final String updatedAt;
  final String createdIn;
  final String email;
  final String firstName;
  final String lastName;
  final int gender;
  final int storeId;
  final int groupId;
  final String defaultShipping;
  final int websiteId;
  final int disableAutoGroupChange;
  final String lastname;
  final List<Address> addresses;

  @override
  List<Object> get props => [
        id,
        accessToken,
        username,
        refreshToken,
        defaultShipping,
        defaultBilling,
        createdIn,
        createdAt,
        updatedAt,
        email,
        lastName,
        firstName,
        gender,
        storeId,
        groupId,
        websiteId,
        disableAutoGroupChange
      ];

  String getName() => username;

  static const empty = User(
      id: '-',
      username: '',
      accessToken: '',
      defaultBilling: '',
      createdAt: '',
      createdIn: '',
      updatedAt: '',
      email: '',
      firstName: '',
      lastName: '',
      gender: 0,
      storeId: 0,
      websiteId: 0,
      disableAutoGroupChange: 0,
      refreshToken: '',
      groupId: 0,
      defaultShipping: "",
    addresses: [],
    lastname: '',
  );

  static createForUpdate(bool anonymousProfile, String ageRange, String gender,
          int locationId, bool accept_urgent_mirror_requests) =>
      User(
          id: '-',
          username: '',
          accessToken: '',
          defaultBilling: '',
          createdAt: '',
          createdIn: '',
          updatedAt: '',
          email: '',
          firstName: '',
          lastName: '',
          gender: 0,
          storeId: 0,
          websiteId: 0,
          disableAutoGroupChange: 0,
          refreshToken: '',
          groupId: 0,
          defaultShipping: "",
          addresses: [],
          lastname: '',
      );

  static User copyWith({
    required User input,
    required String accessToken,
    required String refreshToken,
  }) {
    return User(
        id: input.id,
        username: input.username,
        accessToken: accessToken,
        refreshToken: input.refreshToken,
        defaultBilling: input.defaultBilling,
        createdAt: input.createdAt,
        createdIn: input.createdIn,
        updatedAt: input.updatedAt,
        email: input.email,
        firstName: input.firstName,
        lastName: input.lastName,
        gender: input.gender,
        storeId: input.storeId,
        websiteId: input.websiteId,
        disableAutoGroupChange: input.disableAutoGroupChange,
        groupId: input.groupId,
        defaultShipping: input.defaultShipping,
        addresses: input.addresses,
        lastname: input.lastName,
    );
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class Address {
  Address({
    required this.firstname,
    required this.lastname,
    required this.street,
    required this.city,
    required this.region,
    required this.postcode,
    required this.countryCode,
    required this.telephone,
  });

  String firstname;
  String lastname;
  List<String> street;
  String city;
  Region region;
  String postcode;
  String countryCode;
  String telephone;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        firstname: json["firstname"],
        lastname: json["lastname"],
        street: List<String>.from(json["street"].map((x) => x)),
        city: json["city"],
        region: Region.fromJson(json["region"]),
        postcode: json["postcode"],
        countryCode: json["country_code"],
        telephone: json["telephone"],
      );

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "street": List<dynamic>.from(street.map((x) => x)),
        "city": city,
        "region": region.toJson(),
        "postcode": postcode,
        "country_code": countryCode,
        "telephone": telephone,
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
        regionCode: json["region_code"],
        region: json["region"],
      );

  Map<String, dynamic> toJson() => {
        "region_code": regionCode,
        "region": region,
      };
}
