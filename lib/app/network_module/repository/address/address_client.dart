import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:whiteproject/app/session/session.dart';
import 'package:whiteproject/network_kit/models/region.dart';
import 'package:whiteproject/network_kit/repository/address/address_queries.dart';

class AddressClient {
  Future<String> updateAddress(
      {required int id,
      required String streetName,
      required String postCode,
      required String city,
      required bool defaultShipping,
      required bool defaultBilling}) async {
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
        document: gql(AddressQueries.updateCustomerAddress(city, id, postCode,
            defaultShipping, defaultBilling, streetName)), // this
      ),
    );
    if (result.hasException) {
      return result.exception!.graphqlErrors.first.message;
    } else {
      return "1";
    }
  }

  Future<String> createAddress(
      {required int id,
      required String region,
      required String regionCode,
      required String countryCode,
      required String streetName,
      required String postCode,
      required String city,
      required bool defaultShipping,
      required bool defaultBilling,
      required String phone,
      required String company,
      required String vatID}) async {
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
        document: gql(AddressQueries.createCustomerAddress(
            id,
            region,
            regionCode,
            countryCode,
            streetName,
            postCode,
            city,
            defaultShipping,
            defaultBilling,
            phone,
            company,
            vatID)), // this
      ),
    );
    if (result.hasException) {
      return result.exception!.graphqlErrors.first.message;
    } else {
      return "1";
    }
  }

  Future<Country> getRegionInfo() async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(AddressQueries.getRegionInfo()),
    );
    final result = await _client.query(options);
    Country mainRegion = Country.fromJson(result.data!['country']);
    return mainRegion;
  }

  Future<String> deleteAddress({required int id}) async {
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
        document: gql(AddressQueries.deleteCustomerAddress(id)), // this
      ),
    );
    if (result.hasException) {
      return result.exception!.graphqlErrors.first.message;
    } else {
      return "1";
    }
  }
}
