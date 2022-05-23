import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:whiteproject/app/session/session.dart';
import 'package:whiteproject/network_kit/models/product.dart';
import 'package:whiteproject/network_kit/repository/product/product_queries.dart';

class ProductClient {

  Future<String> addProductToCart(
      {required String token, required Product product}) async {
    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
        'Authorization': 'Bearer ' + Session.shared.currentUser.accessToken
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(ProductQueries.productAddToCart(token, product)),
    );
    final result = await _client.query(options);
    if (result.hasException) {
      print(result);
      return 'error';
    } else {
      return 'success';
    }
  }

  Future<List<Product>> getSelectedProducts(
      {required String categoryId,
      required int pageSize,
      required String priceSort}) async {
    List<Product> products = [];

    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document:
          gql(ProductQueries.getSelectedProductList(categoryId, pageSize, priceSort)),
    );
    final result = await _client.query(options);
    if(result.hasException) {
      throw result.exception!.graphqlErrors.first.message;
    } else {
      for (var product in result.data!['products']['items']) {
        Product mainProduct = Product.fromJson(product);
        products.add(mainProduct);
      }
      return products;
    }
  }
}
