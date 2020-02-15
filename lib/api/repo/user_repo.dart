import 'dart:convert';

import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/api/models/user_details.dart';
import 'package:adactin_hotel_app/crypto/md5.dart';
import 'package:adactin_hotel_app/global/constants.dart' as globalConstants;
import 'package:dio/dio.dart';

class UserRepository {
  Future<UserDetails> authenticate({String username, String password}) async {
    try {
      String logInUrl = Constants.baseURL + Constants.loginURL;
      logInUrl = logInUrl.replaceAll(Constants.usernameKey, username);
      logInUrl =
          logInUrl.replaceAll(Constants.passwordKey, generateMD5(password));

      final Response response = await Dio().get(logInUrl);
      final Map<String, dynamic> data = json.decode(response.toString());

      if (data.containsKey(Constants.loginSuccessTokenKey) == true) {
        return UserDetails(
            username: username, token: data[Constants.loginSuccessTokenKey]);
      } else {
        if (data.containsKey(Constants.errorFieldValidationsKey)) {
          throw Constants.errorFieldValidationDescription;
        } else if (data.containsKey(Constants.errorStatusKey)) {
          throw data[Constants.errorStatusKey];
        } else if (data.containsKey(Constants.errorResponseKey)) {
          throw data[Constants.errorResponseKey];
        } else {
          throw globalConstants.Constants.unknownError;
        }
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> logout({String token}) async {
    try {
      String logoutUrl = Constants.baseURL + Constants.logoutURL;
      logoutUrl = logoutUrl.replaceAll(Constants.userTokenKey, token);

      final Response response = await Dio().get(logoutUrl);
      final Map<String, dynamic> data = json.decode(response.toString());

      return ((data[Constants.logOutSuccessKey] ==
              Constants.logOutSuccessResponse) ||
          (data[Constants.errorResponseKey] == Constants.logOutSessionExpired));
    } catch (error) {
      throw error;
    }
  }
}
