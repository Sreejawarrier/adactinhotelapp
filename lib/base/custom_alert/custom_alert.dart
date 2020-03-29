import 'package:flutter/material.dart';

class CustomAlert {
  static const String alertSemanticKey = 'alert';
  static const String alertTitleSemanticKey = 'alert_title';
  static const String alertMessageSemanticKey = 'alert_message';

  static void displayAlert({
    @required BuildContext context,
    @required String title,
    @required String message,
    @required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Semantics(
          enabled: true,
          explicitChildNodes: true,
          label: alertSemanticKey,
          child: AlertDialog(
            title: Semantics(
              enabled: true,
              explicitChildNodes: true,
              label: alertTitleSemanticKey,
              child: Text(title),
            ),
            content: Semantics(
              enabled: true,
              explicitChildNodes: true,
              container: true,
              label: alertMessageSemanticKey,
              child: Container(child: Text(message), color: Colors.transparent),
            ),
            actions: actions,
          ),
        );
      },
      barrierDismissible: false,
    );
  }
}
