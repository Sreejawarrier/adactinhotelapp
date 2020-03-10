import 'dart:async';

import 'package:adactin_hotel_app/global/global_constants.dart'
    as globalConstants;
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinner extends StatefulWidget {
  final Color spinnerColor;
  final Color backgroundColor;
  final double backgroundOpacity;
  final String title;

  Spinner({
    Key key,
    this.title = '',
    this.spinnerColor = Palette.primaryColor,
    this.backgroundColor = Colors.grey,
    this.backgroundOpacity = 0.5,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpinnerState();
}

class _SpinnerState extends State<Spinner> {
  static const String spinner_semantics = 'Spinner_Semantics';

  Timer _timer;
  bool _showSpinner;

  @override
  void initState() {
    super.initState();

    _showSpinner = true;
    _timer = Timer(
      Duration(seconds: globalConstants.GlobalConstants.spinnerTimeout),
      () {
        _timer?.cancel();
        setState(() {
          _showSpinner = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showSpinner
        ? Positioned.fill(
            child: Semantics(
              label: spinner_semantics,
              enabled: true,
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: widget.backgroundColor
                      .withOpacity(widget.backgroundOpacity),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SpinKitWanderingCubes(
                          color: widget.spinnerColor,
                          size: 60,
                        ),
                      ),
                      Text(
                        widget.title,
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
