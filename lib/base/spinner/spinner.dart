import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatelessWidget {
  final Color spinnerColor;

  Spinner({
    Key key,
    this.spinnerColor = Palette.primaryColor,
  }) : super(key: key);

  static const String spinner_semantics = 'Spinner_Semantics';

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Semantics(
        label: spinner_semantics,
        enabled: true,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.grey.withOpacity(0.5),
            child: SpinKitWanderingCubes(
              color: spinnerColor,
              size: 60,
            ),
          ),
        ),
      ),
    );
  }
}
