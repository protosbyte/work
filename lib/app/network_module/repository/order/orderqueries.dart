
class OrderQueries {

  static getAllOrder() {
    return '''
{
  customer {
    orders(
      pageSize: 300
    )  {
      items {
      number
      id
       comments{
          message
        }
        items{
          product_name
          quantity_ordered
        product_sale_price{
          value
          currency
        }
        }
      order_date
        comments{
          message
        }
      total {
        grand_total {
          value
          currency
        }
        discounts{
          amount {
            value
            currency
          }
        }
        subtotal {
          value
          currency
        }
        total_shipping{
          value
          currency
        }
      }
        payment_methods{
          name
          type
        }
        shipping_method
      status
        shipping_address {
          city
          street
          region_id
          country_code
        }
        payment_methods{
          name
        }
      }
    }
  
  }
}
    ''';
  }

}
