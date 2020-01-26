import 'package:adactin_hotel_app/app.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adactin Hotel App',
      theme: ThemeData(
        primaryColor: Palette.primaryColor,
        primaryColorBrightness: Brightness.dark,
        cursorColor: Palette.primaryColor,
      ),
      home: App(),
    );
  }
}
