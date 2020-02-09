import 'package:adactin_hotel_app/app/page/app.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const String mainTitle = 'Adactin Hotel App';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mainTitle,
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
        primaryColorBrightness: Brightness.dark,
        cursorColor: Palette.primaryColor,
      ),
      home: App(),
    );
  }
}
