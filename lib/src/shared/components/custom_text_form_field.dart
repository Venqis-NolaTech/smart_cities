import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key key,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.controller,
    this.onTap,
    this.readOnly = false,
    this.keyboardType,
    this.labelText,
    this.minLines,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;
  final TextEditingController controller;
  final GestureTapCallback onTap;
  final bool readOnly;
  final TextInputType keyboardType;
  final String labelText;
  final int minLines;
  final int maxLines;
  final Widget prefixIcon;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      controller: controller,
      onTap: onTap,
      readOnly: readOnly,
      minLines: minLines,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        labelText: labelText,
        labelStyle: kNormalStyle.copyWith(
          color: Colors.grey,
        ),
      ),
      style: kNormalStyle,
    );
  }
}
