import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';

class AdactinButton extends StatelessWidget {
  final String semanticKey;
  final String title;
  final VoidCallback onPressed;
  final Color btnColor;

  AdactinButton({
    @required this.semanticKey,
    @required this.title,
    @required this.onPressed,
    this.btnColor = Palette.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticKey,
      enabled: true,
      explicitChildNodes: true,
      child: RaisedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        color: btnColor,
        highlightColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
