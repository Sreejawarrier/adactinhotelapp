class Constants {
  static const String baseURL = "https://www.adactin.com/"
      "HotelAdactinWebServices/REST/api.php?action=";

  /// -------------- User token
  static const String userTokenKey = "{userToken}";

  /// -------------- Error keys
  static const String errorFieldValidationsKey = "Error(HA-FieldValidation)";
  static const String errorStatusKey = "Error(HA-Status)";
  static const String errorResponseKey = "Error(HA-Auth)";

  /// -------------- For login
  static const String usernameKey = "{username}";
  static const String passwordKey = "{password}";
  static const String loginURL = "checkLogin&username=$usernameKey&"
      "password=$passwordKey";
  static const String loginSuccessTokenKey = "Token";
  static const String errorFieldValidationDescription =
      "Please check your username or password";

  /// -------------- For logout
  static const String logoutURL = "logout&userToken=$userTokenKey";
  static const String logOutSuccessKey = "Logout Response";
  static const String logOutSuccessResponse = "Logout Successfully !!!";
  static const String logOutSessionExpired = "Session Already Expired";

  /// -------------- Hotel search
  static const String locationKey = "{location}";
  static const String hotelsKey = "{hotels}";
  static const String roomTypeKey = "{room_type}";
  static const String roomNosKey = "{room_nos}";
  static const String checkInDateKey = "{checkInDate}";
  static const String checkOutDateKey = "{checkOutDate}";
  static const String adultRoomKey = "{adult_room}";
  static const String childRoomKey = "{child_room}";
  static const String hotelSearchURL = "searchHotel&userToken=$userTokenKey&"
      "location=$locationKey&room_nos=$roomNosKey&checkInDate=$checkInDateKey&"
      "checkOutDate=$checkOutDateKey&adult_room=$adultRoomKey";
  static const String hotelSearchHotelsUrl = "&hotels=$hotelsKey";
  static const String hotelSearchRoomTypeUrl = "&room_type=$roomTypeKey";
  static const String hotelSearchChildRoomUrl = "&child_room=$childRoomKey";

  static const String hotelSearchSuccessKey = "searchedResults";
}
