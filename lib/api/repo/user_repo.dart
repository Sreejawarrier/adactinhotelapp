import 'dart:convert';
import 'dart:io';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/user_details.dart';
import 'package:adactin_hotel_app/base/connectivity/connectivity.dart';
import 'package:adactin_hotel_app/global/global_constants.dart'
    as globalConstants;
import 'package:dio/dio.dart';

class UserRepository {
  Future<UserDetails> authenticate({String username, String password}) async {
    try {
      final bool isConnected = await AppConnectivity.isConnected();
      if (isConnected) {
        String logInUrl = Constants.baseURL + Constants.loginURL;
        logInUrl = logInUrl.replaceAll(Constants.usernameKey, username);
        logInUrl = logInUrl.replaceAll(Constants.passwordKey, password);

        final String encodedUrl = Uri.encodeFull(logInUrl);
        print('UserRepository - authenticate - url - $encodedUrl');
        final Response response = await Dio().get(encodedUrl);
        print('UserRepository - authenticate - response - $response');
        final Map<String, dynamic> data = json.decode(response.toString());

        if (data.containsKey(Constants.loginSuccessTokenKey) &&
            data[Constants.loginSuccessTokenKey] != null) {
          return UserDetails(
            username: username,
            token: data[Constants.loginSuccessTokenKey],
          );
        } else {
          if (data.containsKey(Constants.errorFieldValidationsKey)) {
            throw Constants.errorFieldValidationDescription;
          } else if (data.containsKey(Constants.errorStatusKey)) {
            throw data[Constants.errorStatusKey];
          } else if (data.containsKey(Constants.errorResponseKey)) {
            throw data[Constants.errorResponseKey];
          } else {
            throw globalConstants.GlobalConstants.unknown_error;
          }
        }
      } else {
        throw globalConstants.GlobalConstants.network_unavailable;
      }
    } catch (error) {
      if (error is DioError && error.error is SocketException) {
        if (((error.error as SocketException).osError.errorCode == 51) ||
            ((error.error as SocketException).osError.errorCode == 8) ||
            ((error.error as SocketException).osError.message ==
                globalConstants.GlobalConstants.dio_error_not_known) ||
            ((error.error as SocketException).osError.message ==
                globalConstants.GlobalConstants.dio_error_no_internet)) {
          throw globalConstants.GlobalConstants.network_unavailable;
        } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
            error.type == DioErrorType.SEND_TIMEOUT ||
            error.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw globalConstants.GlobalConstants.sessionTimeout;
        } else {
          throw globalConstants.GlobalConstants.unknown_error;
        }
      } else if (error is String) {
        throw error;
      } else {
        throw globalConstants.GlobalConstants.unknown_error;
      }
    }
  }

  Future<bool> logout({String token}) async {
    try {
      String logoutUrl = Constants.baseURL + Constants.logoutURL;
      logoutUrl = logoutUrl.replaceAll(Constants.userTokenKey, token);

      final String encodedUrl = Uri.encodeFull(logoutUrl);
      print('UserRepository - logout - url - $encodedUrl');
      final Response response =
          await Dio(globalConstants.GlobalConstants().getDioOptions())
              .get(encodedUrl);
      print('UserRepository - logout - response - $response');
      final Map<String, dynamic> data = json.decode(response.toString());

      return ((data[Constants.logOutSuccessKey] ==
              Constants.logOutSuccessResponse) ||
          (data[Constants.errorResponseKey] == Constants.logOutSessionExpired));
    } catch (error) {
      if (error is DioError && error.error is SocketException) {
        if (((error.error as SocketException).osError.errorCode == 51) ||
            ((error.error as SocketException).osError.errorCode == 8) ||
            ((error.error as SocketException).osError.message ==
                globalConstants.GlobalConstants.dio_error_not_known) ||
            ((error.error as SocketException).osError.message ==
                globalConstants.GlobalConstants.dio_error_no_internet)) {
          throw globalConstants.GlobalConstants.network_unavailable;
        } else if (error.type == DioErrorType.CONNECT_TIMEOUT ||
            error.type == DioErrorType.SEND_TIMEOUT ||
            error.type == DioErrorType.RECEIVE_TIMEOUT) {
          throw globalConstants.GlobalConstants.sessionTimeout;
        } else {
          throw globalConstants.GlobalConstants.unknown_error;
        }
      } else if (error is String) {
        throw error;
      } else {
        throw globalConstants.GlobalConstants.unknown_error;
      }
    }
  }
}
