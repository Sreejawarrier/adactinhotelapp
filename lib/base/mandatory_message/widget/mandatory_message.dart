import 'package:adactin_hotel_app/base/mandatory_message/constants/mandatory_message_content.dart';
import 'package:adactin_hotel_app/base/mandatory_message/constants/mandatory_message_semantic_keys.dart';
import 'package:flutter/material.dart';

class MandatoryMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Semantics(
        enabled: true,
        explicitChildNodes: true,
        label: MandatoryMessageSemanticKeys.message,
        child: RichText(
          text: TextSpan(
            text: MandatoryMessageContent.allFields,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.normal,
              fontSize: 12,
            ),
            children: [
              TextSpan(
                text: MandatoryMessageContent.asterisk,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              TextSpan(
                text: MandatoryMessageContent.mandatory,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
