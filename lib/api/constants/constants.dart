class Constants {
  static const String baseURL = "https://www.adactin.com/"
      "HotelAdactinWebServices/REST/api.php?action=";

  // For login
  static const String usernameKey = "{username}";
  static const String passwordKey = "{password}";
  static const String loginURL = "checkLogin&username=$usernameKey&"
      "password=$passwordKey";
}