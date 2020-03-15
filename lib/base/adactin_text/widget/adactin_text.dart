import 'package:flutter/material.dart';

class AdactinText extends StatelessWidget {
  final String semanticLabel;
  final String text;

  AdactinText({@required this.semanticLabel, @required this.text});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      enabled: true,
      explicitChildNodes: true,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Text(
          text,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
