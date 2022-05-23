import 'package:whiteproject/network_kit/models/address_list_model.dart';

class CartQueries {

  static applyCouponToCart(String cartToken, String coupon) {
    return '''
    mutation {
  applyCouponToCart(
    input: {
      cart_id: "$cartToken",
      coupon_code: "$coupon"
    }
  ) {
    cart {
      items {
        product {
          name
        }
        quantity
      }
      applied_coupons {
        code
      }
      prices {
        grand_total{
          value
          currency
        }
      }
    }
  }
}
    ''';
  }

  static getCustomerCart(String cartToken) {
    return '''
    {
  cart(cart_id: "$cartToken") {
    email
    billing_address {
      city
      country {
        code
        label
      }
      firstname
      lastname
      postcode
      region {
        code
        label
      }
      street
      telephone
    }
    shipping_addresses {
      firstname
      lastname
      street
      city
      region {
        code
        label
      }
      country {
        code
        label
      }
      telephone
      available_shipping_methods {
        amount {
          currency
          value
        }
        available
        carrier_code
        carrier_title
        error_message
        method_code
        method_title
        price_incl_tax {
          value
          currency
        }
      }
      selected_shipping_method {
        amount {
          value
          currency
        }
        carrier_code
        carrier_title
        method_code
        method_title
      }
    }
    items {
      uid
      id
      prices {
        price {
          value
          currency
        }
      }
      product {
        name
        sku
      }
      quantity
    }
    available_payment_methods {
      code
      title
    }
    selected_payment_method {
      code
      title
    }
    applied_coupons {
      code
    }
    prices {
      subtotal_excluding_tax {
        value
        currency
      }
      subtotal_including_tax {
        value
        currency
      }
        discounts {
        amount {
          value
        }
        label
      }
      applied_taxes {
        amount {
          value
        }
        label
      }
      grand_total {
        value
        currency
      }
    }
  }
}

    ''';
  }

  static setBillingAddress(String cartToken, AddressList address) {
    return '''
    mutation {
  setBillingAddressOnCart(
    input: {
      cart_id: "$cartToken"
      billing_address: {
        address: {
            firstname: "${address.firstname}"
            lastname: "${address.lastname}"
            company: "none"
            street: "${address.street}"
            city: "${address.city}"
            region:  "${address.region.regionCode}"
            postcode: "${address.postcode}"
            country_code:  "${address.countryCode}"
            telephone:  "${address.phone}"
            save_in_address_book: false
          }
        same_as_shipping: false
      }
    }
  ) {
    cart {
      billing_address {
        firstname
        lastname
        company
        street
        city
        region{
          code
          label
        }
        postcode
        telephone
        country{
          code
          label
        }
      }
    }
  }
}
    ''';
  }

  static setShippingMethode(String cartToken, String carrierCode, String methodeCode) {
    return '''
    mutation {
  setShippingMethodsOnCart(
    input: {
      cart_id: "$cartToken",
      shipping_methods: [
        {
          carrier_code: "$carrierCode"
          method_code: "$methodeCode"
        }
      ]
    }
  ) {
    cart {
      shipping_addresses {
        selected_shipping_method {
          carrier_code
          carrier_title
          method_code
          method_title
          amount {
            value
            currency
          }
        }
      }
    }
  }
}
    ''';
  }

  static clearCustomerCart(String cartToken) {
    return '''
    {
  clearCustomerCart(
      cartUid: "$cartToken"
    ) {
        status
    }
}
    ''';
  }

  static customerCart() {
    return '''
    {
  customerCart {
    id
    items {
      id
      product {
        name
        sku
      }
      quantity
    }
  }
}
    ''';
  }

  static setPaymentMethode(String cartToken, String paymentMethodCode) {
    return '''
    mutation {
  setPaymentMethodOnCart(input: {
      cart_id: "$cartToken"
      payment_method: {
          code: "$paymentMethodCode"
      }
  }) {
    cart {
      selected_payment_method {
        code
        title
      }
    }
  }
}
    ''';
  }

  static placeOrder(String cartToken) {
    return '''
    mutation {
  placeOrder(
    input: {
      cart_id: "$cartToken"
    }
  ) {
    order {
      order_number
    }
  }
}
    ''';
  }

  static setShippingAddressesOnCart(String cartToken, AddressList address) {
    return '''
      mutation {
  setShippingAddressesOnCart(
    input: {
      cart_id: "$cartToken"
      shipping_addresses: [
        {
          address: {
            firstname: "${address.firstname}"
            lastname: "${address.lastname}"
            company: "${address.company}"
            street: "${address.street}"
            city: "${address.city}"
            region:  "${address.region.regionCode}"
            postcode: "${address.postcode}"
            country_code:  "${address.countryCode}"
            telephone:  "${address.phone}"
            save_in_address_book: false
          }
        }
      ]
    }
  ) {
    cart {
      shipping_addresses {
          available_shipping_methods {
        amount {
          currency
          value
        }
        available
        carrier_code
        carrier_title
        error_message
        method_code
        method_title
        price_excl_tax {
          value
          currency
        }
        price_incl_tax {
          value
          currency
        }
      }
        firstname
        lastname
        company
        street
        city
        region {
          code
          label
        }
        postcode
        telephone
        country {
          code
          label
        }
      }
    }
  }
}

    ''';
  }

  static updateCartItem(String token, String cartItemUID, int quantity) {
    return '''
    mutation{updateCartItems(input:{cart_id:"$token" cart_items:[{cart_item_uid:"$cartItemUID",quantity:$quantity}]}){cart{items{uid product{name}quantity}prices{grand_total{value currency}}}}}
    ''';
  }

  static removeProductFromCart(String token, int productId) {
    return '''
    mutation{removeItemFromCart(input:{cart_id:"$token",cart_item_id:$productId}){cart{items{id product{name}quantity}prices{grand_total{value currency}}}}}
    ''';
  }



  static createEmptyCart() {
    return '''
    mutation {createEmptyCart}
    ''';
  }
}
