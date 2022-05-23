import 'dart:async';
import 'package:whiteproject/app/session/session.dart';
import 'package:whiteproject/network_kit/models/address_list_model.dart';
import 'package:whiteproject/network_kit/models/user.dart';
import 'package:whiteproject/network_kit/repository/user/auth_client_graphql.dart';
import 'package:whiteproject/network_kit/repository/user/user_repository.dart';

class AuthenticationRepository {
  final AuthClientGraphQL authClientGraphQL = AuthClientGraphQL();

  Future<User> logIn({
    required String email,
    required String password,
  }) async {
    User user = await authClientGraphQL.loginMutation(email, password);
    Session.shared.currentUser = user;
    return user;
  }

  Future<bool> logOut() async {
    Session.shared.currentUser = User.empty;
    UserRepository.removeLoginData();
    return true;
  }

  Future<List<AddressList>> getAddress() async =>
      authClientGraphQL.getMyAddresses();

  Future<List<AddressList>> getBillingAddress() async =>
      authClientGraphQL.getMyBillingAddress();

  Future<User> me() async => authClientGraphQL.me();

  Future<User> getUserData() async {
    User userFromCloud = await authClientGraphQL.me();
    if(userFromCloud == null) {
      return User.empty;
    } else {
      User fixedUser = User(
          accessToken: Session.shared.currentUser.accessToken,
          id: userFromCloud.id,
          username: userFromCloud.username,
          refreshToken: Session.shared.currentUser.accessToken,
          defaultBilling: userFromCloud.defaultBilling,
          email: userFromCloud.email,
          firstName: userFromCloud.firstName,
          lastName: userFromCloud.lastName,
          defaultShipping: userFromCloud.defaultShipping,
          addresses: userFromCloud.addresses,
          lastname: userFromCloud.lastname,
          createdIn: '',
          groupId: 0,
          disableAutoGroupChange: 0,
          websiteId: 0,
          storeId: 0,
          updatedAt: '',
          createdAt: '',
          gender: 0);
      UserRepository.saveLoginData(fixedUser);
      Session.shared.currentUser = fixedUser;
      UserRepository.saveLoginData(fixedUser);
      return fixedUser;
    }
  }


  void doRefreshUser() async {
    UserRepository.getCurrentUser().then((user) async {
      if (user != null && user.accessToken.isNotEmpty) {
        try {
          User updatedUser = User.copyWith(
              input: user,
              accessToken: user.accessToken,
              refreshToken: user.refreshToken);
          UserRepository.saveLoginData(updatedUser);
          Session.shared.currentUser = updatedUser;
        } catch (e) {}
      }
    });
  }
}
