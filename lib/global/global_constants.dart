import 'package:dio/dio.dart';

class GlobalConstants {
  static const String audPriceFormat = "AUD \$";

  static const String unknown_error =
      "Server error has occurred. Please try again later.";
  static const String network_unavailable = "No Internet connection. "
      "Please check your wifi or mobile network and try again.";
  static const String timeout_error = "Response has timed out. "
      "Please try again.";

  static const String dio_error_not_known =
      "nodename nor servname provided, or not known";
  static const String dio_error_no_internet = "Network is unreachable";

  static const int userSessionTimerMaxInSeconds = 1800;
  static const int sessionTimeout = 60; // Session timeout
  static const int spinnerTimeout = 60;

  static const String dateFormatWithDash_ddMMyyyy = 'dd-MM-yyyy';
  static const String dateFormatWithForwardSlash_ddMMyyyy = 'dd/MM/yyyy';
  static const String dateFormatWithDot_ddMMyyyy = 'dd.MM.yyyy';
  static const String dateFormat_ddMMM = 'dd MMM';

  BaseOptions getDioOptions() {
    return BaseOptions(
      receiveTimeout: sessionTimeout,
    );
  }
}
