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

  /// -------------- Common
  static const String locationKey = "{location}";
  static const String roomTypeKey = "{room_type}";
  static const String roomNosKey = "{room_nos}";

  /// -------------- Hotel search
  static const String hotelsKey = "{hotels}";
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

  static const String hotelSearchSuccessMessage =
      "Hotels Searched Successfully  !!!";
  static const String hotelResultValueKey = "Result";

  /// -------------- Book hotel
  static const String hotelNameKey = "{hotelName}";
  static const String arrDateKey = "{arr_date}";
  static const String depDateKey = "{dep_date}";
  static const String adultNoKey = "{adult_no}";
  static const String childNoKey = "{child_no}";
  static const String priceNightKey = "{price_night}";
  static const String totalPriceKey = "{total_price}";
  static const String firstNameKey = "{firstname}";
  static const String lastNameKey = "{lastname}";
  static const String addressKey = "{address}";
  static const String cCardNoKey = "{ccardno}";
  static const String cCardTypeKey = "{ccardtype}";
  static const String expiryMonthKey = "{expiryMonth}";
  static const String expiryYearKey = "{expiryYear}";
  static const String cvvNumKey = "{cvvNum}";
  static const String statusKey = "{status}";

  static const String bookHotelURL = "bookHotel&userToken=$userTokenKey&"
      "hotelName=$hotelNameKey&location=$locationKey&room_type=$roomTypeKey&"
      "room_nos=$roomNosKey&arr_date=$arrDateKey&dep_date=$depDateKey&"
      "adult_no=$adultNoKey&price_night=$priceNightKey&"
      "total_price=$totalPriceKey&firstname=$firstNameKey&lastname=$lastNameKey&"
      "address=$addressKey&ccardno=$cCardNoKey&ccardtype=$cCardTypeKey&"
      "expiryMonth=$expiryMonthKey&expiryYear=$expiryYearKey&"
      "cvvNum=$cvvNumKey&status=$statusKey";

  static const String bookHotelChildNoUrl = "&child_no=$childNoKey";

  static const String bookingSuccessMessage = "Booking Confirmation !!!";
  static const String bookingDetailsKey = "Booking Details";

  /// -------------- Booked itinerary
  static const String bookedItinerariesURL =
      "getBookings&userToken=$userTokenKey";
  static const String bookedItinerarySearchSuccessKey = "SearchResults";
  static const String bookedItineraryResultValueKey = "Booking";

  /// -------------- Cancel booking
  static const String orderIdKey = "{orderId}";

  static const String cancelBookingURL = "cancelBooking&"
      "userToken=$userTokenKey&orderId=$orderIdKey";

  static const String bookingCancelledKey = "CancelBookingMessage";
  static const String bookingCancellationMessage =
      "Cancellation Confirmed for Order ID";
}
