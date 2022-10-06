import 'package:flutter/widgets.dart';

class ConstantTypes {
  static int SMALL_LIMIT = 10;
  static int NORMAL_LIMIT = 20;
  static int MAX_FILE_SIZE = 10485760;
  static String DROPDOWN_SELECT_RESPONSE = 'Give feedback';

  static Map<String, String> AGE_RANGE = <String, String>{
    'range1': '18-25',
    'range2': '26-32',
    'range3': '33-40',
    'range4': '41-48',
    'range5': '49-57',
    'range6': '58-65',
    'range7': '65+'
  };

  static String getAgeRangeKeyByValue(String value) =>
      AGE_RANGE.entries.where((element) => element.value == value).first.key;

  static String getAgeRangeKeyByKey(String key) =>
      AGE_RANGE[key] ?? AGE_RANGE.keys.first;

  static String getGenderKeyByValue(String value) =>
      GENDER.entries.where((element) => element.value == value).first.key;

  static String getGenderKeyByKey(String key) =>
      GENDER[key] ?? GENDER.keys.first;

  static Map<String, String> GENDER = <String, String>{
    'male': 'Male',
    'female': 'Female',
    'other': 'Non-Binary',
    'not_specified': 'Prefer not to disclose'
  };
  static Map<int, String> EXPIRATION_DATE = <int, String>{
    24: 'In a Day',
    168: 'In a Week',
    720: 'In a Month',
    0: 'Whenever'
  };
  static int getExpirationDayByValue(String value) => EXPIRATION_DATE.entries
      .where((element) => element.value == value)
      .first
      .key;

  static String getClosestExpirationByHour(int value) {
    if (EXPIRATION_DATE.keys.any((element) => element == value)) {
      return EXPIRATION_DATE[value]!;
    } else {
      if (value <= 24) return EXPIRATION_DATE[24]!;
      if (value > 24 && value <= 168) return EXPIRATION_DATE[168]!;
      if (value > 168 && value <= 720) return EXPIRATION_DATE[720]!;
    }
    return EXPIRATION_DATE[0]!;
  }

  static Map<String, String> POST_RESPONSE_TYPE = <String, String>{
    'rating': 'Standard',
    'response': 'Customized'
  };

  static String getResponseTypeKeyValue(String value) =>
      POST_RESPONSE_TYPE.entries
          .where((element) => element.value == value)
          .first
          .key;

  static String getResponseTypeValueByKey(String key) =>
      POST_RESPONSE_TYPE[key] ?? POST_RESPONSE_TYPE.keys.first;

  static Map<String, String> POST_SORT_BY = <String, String>{
    'most_recent': 'Most Recent',
    'most_popular': 'Most Popular'
  };
  static String getSortKeyByValue(String value) =>
      POST_SORT_BY.entries.where((element) => element.value == value).first.key;
  static String getSortValueByKey(String key) =>
      POST_SORT_BY[key] ?? GENDER.keys.first;

  static List<String> RATING_FEEDBACK = <String>['dont', 'like', 'wow', 'fire'];
}

class MyColors {
  static const Color blue = const Color(0xff05BDE9);
  static const Color lightBlue = const Color(0x5005BDE9);
  static const Color red = const Color(0xffEF4565);
  static const Color lightGray = const Color(0xff3E3F51);
  static const Color gray = const Color(0xff2A2A39);
  static const Color green = const Color(0xff01B05A);
}

class ResourceTypes {
  static const String resourceTypeOrganization = "organizations";
  static const String resourceTypeJobs = "job_posts";
  static const String resourceTypePosts = "posts";
  static const String resourceTypeUsers = "users";
  static const String resourceTypeProfiles = "profiles";
  static const String resourceTypeComments = "comments";
  static const String resourceTypeChats = "chats";
}
