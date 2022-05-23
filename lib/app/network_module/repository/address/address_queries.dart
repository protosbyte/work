import 'package:whiteproject/app/session/session.dart';

class AddressQueries {
  static updateCustomerAddress(String city, int id, String postCode,
      bool defaultShipping, bool defaultBilling, String streetName) {
    return '''
    mutation {
  updateCustomerAddress(id:$id, input: {
    city: "$city"
    postcode: "$postCode"
    default_billing: $defaultBilling
    default_shipping: $defaultShipping
    street: ["$streetName"]
    
  }) {
    id
    city
    postcode
  }
}
    ''';
  }

  static deleteCustomerAddress(int id) {
    return '''
    mutation {
  deleteCustomerAddress(id: $id)
}
    ''';
  }

  static createCustomerAddress(
      int id,
      String region,
      String regionCode,
      String countryCode,
      String streetName,
      String postCode,
      String city,
      bool defaultShipping,
      bool defaultBilling,
      String phone,
      String company,
      String vatID) {
    return '''
    mutation {
  createCustomerAddress(input: {
    region: {
      region_id: $id
      region: "$region"
      region_code: "$regionCode"
    }
    country_code: $countryCode
    street: ["$streetName"]
    postcode: "$postCode"
    city: "$city"
    firstname: "${Session.shared.currentUser.firstName}"
    lastname: "${Session.shared.currentUser.lastName}"
    telephone: "$phone"
    company: "$company"
    vat_id: "$vatID"
    default_shipping: $defaultShipping
    default_billing: $defaultBilling
  }) {
    id
    region {
      region
      region_code
    }
    country_code
    street
    telephone
    postcode
    city
    default_shipping
    default_billing
  }
}
    ''';
  }

  static getRegionInfo() {
    return '''
    query{
  country(id: "RO") {
    id
    available_regions {
      id
      code
      name
    }
  }
}
    ''';
  }
}
