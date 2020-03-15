import 'package:adactin_hotel_app/base/ensure_visible_when_focused/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';

class AdactinTextFormField extends StatelessWidget {
  final String semanticLabel;
  final TextEditingController textEditingController;
  final FocusNode textFocusNode;
  final String hintText;
  final FormFieldValidator<String> validator;
  final bool enabled;
  final FocusNode nextFocusNode;
  final int maxLines;
  final TextInputType keyboardType;
  final String helperText;

  AdactinTextFormField({
    @required this.semanticLabel,
    @required this.textEditingController,
    @required this.textFocusNode,
    @required this.hintText,
    @required this.validator,
    this.nextFocusNode,
    this.keyboardType,
    this.helperText,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      enabled: true,
      explicitChildNodes: true,
      child: textFocusNode != null
          ? EnsureVisibleWhenFocused(
              focusNode: textFocusNode,
              child: _getFormField(
                context: context,
                semanticLabel: semanticLabel,
                textEditingController: textEditingController,
                textFocusNode: textFocusNode,
                hintText: hintText,
                validator: validator,
                enabled: enabled,
                nextFocusNode: nextFocusNode,
                maxLines: maxLines,
                keyboardType: keyboardType,
                helperText: helperText,
              ))
          : _getFormField(
              context: context,
              semanticLabel: semanticLabel,
              textEditingController: textEditingController,
              textFocusNode: textFocusNode,
              hintText: hintText,
              validator: validator,
              enabled: enabled,
              nextFocusNode: nextFocusNode,
              maxLines: maxLines,
              keyboardType: keyboardType,
              helperText: helperText,
            ),
    );
  }

  Widget _getFormField({
    BuildContext context,
    String semanticLabel,
    TextEditingController textEditingController,
    FocusNode textFocusNode,
    String hintText,
    FormFieldValidator<String> validator,
    bool enabled,
    FocusNode nextFocusNode,
    int maxLines,
    TextInputType keyboardType,
    String helperText,
  }) {
    return TextFormField(
      enabled: enabled,
      maxLines: maxLines,
      controller: textEditingController,
      focusNode: textFocusNode,
      keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
      textInputAction: maxLines > 1
          ? TextInputAction.newline
          : ((nextFocusNode != null)
              ? TextInputAction.next
              : TextInputAction.done),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 22,
        ),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey),
        ),
        fillColor: !enabled ? Colors.grey.withOpacity(0.1) : null,
        filled: !enabled,
        helperText: helperText,
      ),
      validator: validator,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null)
          FocusScope.of(context).requestFocus(nextFocusNode);
      },
      onChanged: (value) {
        if (maxLines > 1) {
          /// For multi line textFormField removing unnecessary spaces or new lines
          /// for an empty text entered
          final String singleLine = value.replaceAll("\n", "");
          final String noSpaces = singleLine.replaceAll(" ", "");
          if (noSpaces.isEmpty) textEditingController.text = "";
        }
      },
    );
  }
}
