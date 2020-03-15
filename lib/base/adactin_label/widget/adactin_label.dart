import 'package:adactin_hotel_app/base/adactin_label/constants/adactin_label_content.dart';
import 'package:adactin_hotel_app/theme/palette.dart';
import 'package:flutter/material.dart';

class AdactinLabel extends StatelessWidget {
  final String labelData;
  final bool isRequiredField;
  final double leftPadding;

  AdactinLabel({
    @required this.labelData,
    @required this.isRequiredField,
    this.leftPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Semantics(
        enabled: true,
        explicitChildNodes: true,
        label: labelData,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: RichText(
            text: TextSpan(
              text: labelData,
              style: TextStyle(
                color: Palette.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              children: isRequiredField
                  ? [
                      TextSpan(
                        text: AdactinLabelContent.asterisk,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}
