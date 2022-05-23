class UserQueries {

  static getCustomerData() {
    return '''
    query{
  customer{
    allow_remote_shopping_assistance
    created_at
    date_of_birth
    default_billing
    default_shipping
    dob
    email
    firstname
    gender
    group_id
    id
    is_subscribed
    lastname
    middlename
    prefix
    suffix
    taxvat
  }
}
    ''';
  }


  static getCustomerAddresses() {
    return '''
    query{
  customer {
    addresses {
    id
     default_billing
      default_shipping
      firstname
      lastname
      street
      company
      vat_id
      telephone
      postcode
      country_code
      city
      region {
        region_code
        region
      }
    }
  }
}
    ''';
  }

  static getProfileData() {
    return '''
    query{
  customer {
    firstname
    lastname
    suffix
    email
    addresses {
      firstname
      lastname
      street
      city
      region {
        region_code
        region
      }
      postcode
      country_code
      telephone
    }
  }
}
    ''';
  }

  static String loginMutation(String email, String password) {
    return '''
           mutation{generateCustomerToken(email:"$email" password:"$password"){token}}    
        ''';
  }

  static updateCustomerData({required String firstName,required String lastName,required String email}) {
    return '''
mutation {
  updateCustomer(
    input: {
      firstname: "$firstName"
      email: "$email"
      lastname: "$lastName",
      
    }
  ) {
    customer {
      firstname
      lastname
      email
    }
  }
}
    ''';
  }

  static updateCustomerPassword({required String currentPassword,required String newPassword}) {
    return '''
    mutation {
  changeCustomerPassword(
    currentPassword: "$currentPassword"
    newPassword: "$newPassword"
  ) {
    id
    email
  }
}
    ''';
  }
}
