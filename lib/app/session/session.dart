
import 'package:whiteproject/datakit/models/user.dart';

class Session {
  // singleton
  Session._internal();

  factory Session() => _singleton;

  static final Session _singleton = Session._internal();

  static Session get shared => _singleton;

  User currentUser = User.empty;

  String getCurrentUserId() => currentUser.id;
}
