import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/crypto/md5.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<Response> authenticate({String username, String password}) async {
    try {
      String logInUrl = Constants.baseURL + Constants.loginURL;
      logInUrl = logInUrl.replaceAll(Constants.usernameKey, username);
      logInUrl =
          logInUrl.replaceAll(Constants.passwordKey, generateMD5(password));
      return await Dio().get(logInUrl);
    } catch (error) {
      throw error;
    }
  }

  Future<Response> logout({String token}) async {
    try {
      String logoutUrl = Constants.baseURL + Constants.logoutURL;
      logoutUrl = logoutUrl.replaceAll(Constants.userTokenKey, token);
      return await Dio().get(logoutUrl);
    } catch (error) {
      throw error;
    }
  }
}
