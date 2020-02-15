class Constants {
  static const String baseURL = "https://www.adactin.com/"
      "HotelAdactinWebServices/REST/api.php?action=";

  /// -------------- For login
  static const String usernameKey = "{username}";
  static const String passwordKey = "{password}";
  static const String loginURL = "checkLogin&username=$usernameKey&"
      "password=$passwordKey";
  static const String loginSuccessTokenKey = "Token";
  static const String errorFieldValidationsKey = "Error(HA-FieldValidation)";
  static const String errorStatusKey = "Error(HA-Status)";
  static const String errorResponseKey = "Error(HA-Auth)";
  static const String errorFieldValidationDescription =
      "Please check your username or password";

  /// -------------- For logout
  static const String userTokenKey = "{userToken}";
  static const String logoutURL = "logout&userToken=$userTokenKey";
  static const String logOutSuccessKey = "Logout Response";
  static const String logOutSuccessResponse = "Logout Successfully !!!";
  static const String logOutSessionExpired = "Session Already Expired";
}
