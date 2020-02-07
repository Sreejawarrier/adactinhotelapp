import 'package:adactin_hotel_app/api/constants/constants.dart';
import 'package:adactin_hotel_app/crypto/md5.dart';
import 'package:dio/dio.dart';

class UserRepository {
  Future<void> authenticate({String username, String password}) async {
    try {
      String logInUrl = Constants.baseURL + Constants.loginURL;
      logInUrl = logInUrl.replaceAll(Constants.usernameKey, username);
      logInUrl =
          logInUrl.replaceAll(Constants.passwordKey, generateMD5(password));
      print('Calling $logInUrl');
      Response response = await Dio().get(logInUrl);
      print(response);
    } catch (error) {
      print(error);
    }
  }
}
