import 'dart:io';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/global/global_constants.dart';
import 'package:dio/dio.dart';

class ErrorChecks {
  static String serviceResponseErrorCheck(Map<String, dynamic> dataMap) {
    if (dataMap.containsKey(Constants.errorFieldValidationsKey)) {
      return dataMap[Constants.errorFieldValidationsKey];
    } else if (dataMap.containsKey(Constants.errorStatusKey)) {
      return dataMap[Constants.errorStatusKey];
    } else if (dataMap.containsKey(Constants.errorResponseKey)) {
      return dataMap[Constants.errorResponseKey];
    } else {
      return GlobalConstants.unknown_error;
    }
  }

  static String checkError(dynamic error) {
    if (error is DioError && error.error is SocketException) {
      if (((error.error as SocketException).osError.errorCode == 51) ||
          ((error.error as SocketException).osError.errorCode == 8) ||
          ((error.error as SocketException).osError.message ==
              GlobalConstants.dio_error_not_known) ||
          ((error.error as SocketException).osError.message ==
              GlobalConstants.dio_error_no_internet)) {
        return GlobalConstants.network_unavailable;
      } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
          error.type == DioErrorType.SEND_TIMEOUT ||
          error.type == DioErrorType.RECEIVE_TIMEOUT) {
        return GlobalConstants.timeout_error;
      } else {
        return GlobalConstants.unknown_error;
      }
    } else if (error is String) {
      return error;
    } else {
      return GlobalConstants.unknown_error;
    }
  }
}
