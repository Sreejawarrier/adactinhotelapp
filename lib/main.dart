import 'package:adactin_hotel_app/app/bloc/app_bloc.dart';
import 'package:adactin_hotel_app/app/bloc/app_tab_bloc.dart';
import 'package:adactin_hotel_app/app/page/adactin_hotel_app_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => startApp();

void startApp() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    SharedPreferences.getInstance().then((preferences) {
      runApp(
        AdactinHotelAppPage(
          appBloc: AppBloc(
            preferences: preferences,
          ),
          appTabBloc: AppTabBloc(),
        ),
      );
    });
  });
}
