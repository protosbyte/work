import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:whiteproject/app/session/session.dart';
import 'package:whiteproject/app/utils/constants.dart';
import 'package:whiteproject/network_kit/exceptions/authentication_exception.dart';
import 'package:whiteproject/network_kit/models/address_list_model.dart';
import 'package:whiteproject/network_kit/models/user.dart';
import 'package:whiteproject/network_kit/repository/cart/cart_queries.dart';
import 'package:whiteproject/network_kit/repository/user/user_queries.dart';

class AuthClientGraphQL {

  Future<String> updatePassword(
      {required String newPass,required String oldPass}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());

    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(UserQueries.updateCustomerPassword(currentPassword: oldPass, newPassword: newPass)), // this
        ),
      );
      if(result.hasException) {
        return result.exception!.graphqlErrors.first.message;
      } else {
        return '1';
      }
    } catch (error) {
      throw _handleError(error);
    }
  }

  Future<User> updateCustomerData(
      {required String firstName,required String lastName,required String email}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());

      final result = await _client.mutate(
        MutationOptions(
          document: gql(UserQueries.updateCustomerData(firstName: firstName, lastName: lastName, email: email)), // this
        ),
      );

      if(result.hasException) {
        throw result.exception!.graphqlErrors.first.message;
      } else {
        return User.fromJson(result.data!['updateCustomer']['customer']);
      }
  }

  Future<String> customerCart() async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    try {
      QueryOptions options = QueryOptions(
        document: gql(CartQueries.customerCart()),
      );
      final result = await _client.query(options);
      if (result.hasException) {
        print('error: ${result.exception!.graphqlErrors.first}');
        return 'error';
      } else {
        Constants.items.add(result.data!['customerCart']['items']);
        return result.data!['customerCart']['id'];
      }
    } catch (error) {
      throw _handleError(error);
    }
  }

  Future<String> createCarForUser() async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    final result = await _client.mutate(
      MutationOptions(
        document: gql(CartQueries.createEmptyCart()), // this
      ),
    );
    if (result.data!.isNotEmpty) {
      return result.data!['createEmptyCart'];
    } else {
      return 'Cart disabled for this account';
    }
  }

  Future<User> loginMutation(String email, String password) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    final result = await _client.mutate(
      MutationOptions(
        document: gql(UserQueries.loginMutation(email, password)),
      ),
    );

    if (result.data != null) {
      var token = result.data!['generateCustomerToken']['token'];
      Map<String, dynamic> user = {
        'access_token': token,
        'refresh_token': '',
        'id': '',
        'username': email
      };
      return User.fromJson(user);
    } else {
      throw result.exception!.graphqlErrors.first.message;
    }
  }

  Future<User> me() async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(UserQueries.getProfileData()),
    );
    final result = await _client.query(options);
    if (!result.hasException) {
      User user = User.fromJson(result.data!['customer']);
      return user;
    } else {
      return User.empty;
    }
  }

  Future<List<AddressList>> getMyAddresses() async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    try {
      QueryOptions options = QueryOptions(
        document: gql(UserQueries.getCustomerAddresses()),
      );
      final result = await _client.query(options);
      List<AddressList> addresses = [];
      for (var x in result.data!['customer']['addresses']) {
        AddressList address = AddressList.fromJson(x);
        addresses.add(address);
      }
      return addresses;
    } catch (error) {
      throw _handleError(error);
    }
  }

  Future<List<AddressList>> getMyBillingAddress() async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    try {
      QueryOptions options = QueryOptions(
        document: gql(UserQueries.getCustomerAddresses()),
      );
      final result = await _client.query(options);
      List<AddressList> addresses = [];
      for (var x in result.data!['customer']['addresses']) {
        AddressList address = AddressList.fromJson(x);
        addresses.add(address);
      }
      return addresses;
    } catch (error) {
      throw _handleError(error);
    }
  }

  AuthenticationException _handleError(e) {
    return AuthenticationException(message: 'Error Occurred', errorCode: 500);
  }
}
