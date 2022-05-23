// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      defaultBilling: json['default_billing'] ?? '',
      createdAt: json['created_at'] ?? '',
      createdIn: json['created_in'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      gender: json['gender'] ?? 0,
      storeId: json['store_id'] ?? 0,
      websiteId: json['website_id'] ?? 0,
      disableAutoGroupChange: json['disable_auto_group_change'] ?? 0,
      defaultShipping: json['default_shipping'] ?? "",
      groupId: json['group_id'] ?? 0,
      lastname: json["lastname"]??'',
      addresses: [],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'id': instance.id,
      'username': instance.username,
    };
