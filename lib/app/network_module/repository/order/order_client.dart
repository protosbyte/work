import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:whiteproject/app/session/session.dart';
import 'package:whiteproject/network_kit/models/order.dart';
import 'package:whiteproject/network_kit/repository/order/orderqueries.dart';

class OrderClient {

  Future<List<Order>> getOrders() async {

    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(OrderQueries.getAllOrder()),
    );
    final result = await _client.query(options);
    if(result.hasException) {
      throw result.exception!.graphqlErrors.first.message;
    } else {
      List<Order> orders = [];
      for(var order in result.data!['customer']['orders']['items']) {
        Order mainOrder = Order.fromJson(order);
        orders.add(mainOrder);
      }
      return orders;
    }
  }
}
