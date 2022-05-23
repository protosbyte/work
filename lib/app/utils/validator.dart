class Validator {
  static bool isUsernameValid(String username) => username.isNotEmpty;
  static bool isPasswordValid(String password) => password.isNotEmpty;
  static bool isPhoneValid(String phone) => phone.isNotEmpty;
  static bool hasValue(String value) => value.isNotEmpty;
}
