import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:whiteproject/network_kit/models/category.dart';
import 'package:whiteproject/network_kit/repository/category/category_queries.dart';

class CategoryClient {

  Future<List<Category>> getCategories() async {

    Link _link = HttpLink(
      'https://whiteproject.mynet.company.net/graphql',
      defaultHeaders: {
        'User-Agent': 'whiteprojectagent',
      },
    );
    GraphQLClient _client = GraphQLClient(link: _link, cache: GraphQLCache());
    QueryOptions options = QueryOptions(
      document: gql(CategoryQueries.getCategoriesQuery()),
    );
    final result = await _client.query(options);

    if(result.hasException) {
      throw result.exception!.graphqlErrors.first.message;
    } else {
      List<Category> categories = [];
      for(var category in result.data!['categories']['items']) {
        Category mainCategory = Category.fromJson(category);
        categories.add(mainCategory);
      }
      return categories;
    }
  }
}
