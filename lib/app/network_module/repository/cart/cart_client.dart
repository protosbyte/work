import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:whiteproject/app/session/session.dart';
import 'package:whiteproject/network_kit/models/address_list_model.dart';
import 'package:whiteproject/network_kit/models/cart.dart';
import 'package:whiteproject/network_kit/repository/cart/cart_queries.dart';

class CartClient {
  Future<String> applyCoupon(
      {required String cartToken, required String code}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.applyCouponToCart(cartToken, code)),
    );
    final result = await _client.query(options);
    print("Coupon result $result");
    if (result.hasException) {
      return result.exception!.graphqlErrors.first.message;
    } else {
      return "1";
    }
  }

  Future<bool> updateCartItem(
      {required String token,
      required String productID,
      required int quantity}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.updateCartItem(token, productID, quantity)),
    );
    final result = await _client.query(options);
    if (result.hasException) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> removeProductFromCart(
      {required String token, required int productID}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.removeProductFromCart(token, productID)),
    );
    final result = await _client.query(options);
    if (result.hasException) {
      return false;
    } else {
      return true;
    }
  }

  Future<Cart> getCartContent({required String cartToken}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.getCustomerCart(cartToken)),
    );
    final result = await _client.query(options);
    if (result.data == null) {
      return Cart(
          availablePaymentMethods: [],
          shippingAddresses: [],
          prices: Prices.empty,
          items: []);
    } else {
      return Cart.fromJson(result.data!['cart']);
    }
  }

  Future<List<IngAddress>> setShippingAddressesOnCart(
      {required String cartToken,
      required AddressList address,
      required BuildContext context}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.setShippingAddressesOnCart(cartToken, address)),
    );
    final result = await _client.query(options);
    print(result);
    if (result.hasException) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result.exception!.graphqlErrors.first.message)));
      return [];
    } else {
      print(
          'success ${result.data!['setShippingAddressesOnCart']['cart']['shipping_addresses'].length}');
      List<IngAddress> shippingAddresses = [];
      for (var x in result.data!['setShippingAddressesOnCart']['cart']
          ['shipping_addresses']) {
        IngAddress ingAddress = IngAddress.fromJson(x);
        shippingAddresses.add(ingAddress);
      }
      return shippingAddresses;
    }
  }

  Future<String> placeOrder({required String cartToken}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.placeOrder(cartToken)),
    );
    final result = await _client.query(options);
    print("Place order ${result.data}");
    if (result.hasException) {
      return result.exception!.graphqlErrors.first.message;
    } else {
      return "1";
    }
  }

  Future<int> setPaymentMethod(
      {required String cartToken, required String code}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.setPaymentMethode(cartToken, code)),
    );
    final result = await _client.query(options);
    if (result.hasException) {
      print(result);
      print('Error ${result.exception!.graphqlErrors.first}');
      return -1;
    } else {
      return 1;
    }
  }

  Future<int> setShippingMethode(
      {required String cartToken,
      required String carrierCode,
      required String methodeCode}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(
          CartQueries.setShippingMethode(cartToken, carrierCode, methodeCode)),
    );
    final result = await _client.query(options);
    if (result.hasException) {
      print(result);
      print('Error ${result.exception!.graphqlErrors.first}');
      return -1;
    } else {
      return 1;
    }
  }

  Future<int> setBillingAddress(
      {required String cartToken, required AddressList address}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CartQueries.setBillingAddress(cartToken, address)),
    );
    final result = await _client.query(options);
    if (result.hasException) {
      print('Error ${result.exception!.graphqlErrors.first}');
      return -1;
    } else {
      return 1;
    }
  }

  Future<int> clearCustomerCart({required String cartToken}) async {
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
        document: gql(CartQueries.clearCustomerCart(cartToken)),
      ),
    );
    print('Clear cart result ${result}');
    if (result.hasException) {
      return -1;
    } else {
      return 1;
    }
  }
}
