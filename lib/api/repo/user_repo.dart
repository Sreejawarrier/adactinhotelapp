import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/user_details.dart';
import 'package:adactin_hotel_app/api/repo/error_checks.dart';
import 'package:adactin_hotel_app/base/connectivity/connectivity.dart';
import 'package:adactin_hotel_app/global/global_constants.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<UserDetails> authenticate({String username, String password}) async {
    try {
      final bool isConnected = await AppConnectivity.isConnected();
      if (isConnected) {
        String logInUrl = Constants.baseURL + Constants.loginURL;
        final String encodedUserName = base64.encode(utf8.encode('$username'));
        final String encodedPassword = base64.encode(utf8.encode('$password'));
        logInUrl = logInUrl.replaceAll(Constants.usernameKey, encodedUserName);
        logInUrl = logInUrl.replaceAll(Constants.passwordKey, encodedPassword);

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
          throw ErrorChecks.serviceResponseErrorCheck(data);
        }
      } else {
        throw GlobalConstants.network_unavailable;
      }
    } catch (error) {
      throw ErrorChecks.checkError(error);
    }
  }

  Future<bool> logout({String token}) async {
    try {
      String logoutUrl = Constants.baseURL + Constants.logoutURL;
      logoutUrl = logoutUrl.replaceAll(Constants.userTokenKey, token);

      final String encodedUrl = Uri.encodeFull(logoutUrl);
      print('UserRepository - logout - url - $encodedUrl');
      final Response response =
          await Dio(GlobalConstants().getDioOptions()).get(encodedUrl);
      print('UserRepository - logout - response - $response');
      final Map<String, dynamic> data = json.decode(response.toString());

      return ((data[Constants.logOutSuccessKey] ==
              Constants.logOutSuccessResponse) ||
          (data[Constants.errorResponseKey] == Constants.logOutSessionExpired));
    } catch (error) {
      throw ErrorChecks.checkError(error);
    }
  }
}
