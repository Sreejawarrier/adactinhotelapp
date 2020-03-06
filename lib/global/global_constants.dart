import 'package:dio/dio.dart';

class GlobalConstants {
  static const String unknown_error =
      "Server error has occurred. Please try again later.";
  static const String network_unavailable = "No Internet connection. "
      "Please check your wifi or mobile network and try again.";
  static const String timeout_error = "Response has timed out. "
      "Please try again.";

  static const int sessionTimeout = 60; // Session timeout

  BaseOptions getDioOptions() {
    return BaseOptions(
      connectTimeout: sessionTimeout,
    );
  }
}
