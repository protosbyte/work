
import 'package:whiteboard/datakit/models/product.dart';

class ProductQueries {
  static productAddToCart(String token, Product product) {
    return '''
    mutation{addSimpleProductsToCart(input:{cart_id:"$token" cart_items:[{data:{quantity:1,sku:"${product.sku}"}}]}){cart{items{id product{name sku}quantity}}}}
    ''';
  }

  static String getSelectedProductList(
      String categoryId, int pageSize, String priceSort) {
    return '''
        query{products(search:"" filter:{category_id:{eq:"$categoryId"}}pageSize:$pageSize sort:{price:$priceSort}){items{size price_tiers{quantity final_price{value currency}discount{amount_off}}id description{html}thumbnail{url}special_price sku special_to_date short_description{html}country_of_manufacture manufacturer material name only_x_left_in_stock price_range{maximum_price{regular_price{value currency}}minimum_price{regular_price{value currency}}}stock_status}}}
        ''';
  }
}