import 'package:connectivity/connectivity.dart';

class AppConnectivity {
  static Future<bool> isConnected() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.wifi)) {
      // I am connected to a mobile network. Or
      // I am connected to a wifi network.
      return true;
    }

    return false;
  }
}
