import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldSetter<String> onChanged;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String labelText;
  final String initialValue;
  final Widget icon;

  PasswordTextFormField({
    this.onSaved,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.focusNode,
    this.textInputAction,
    this.controller,
    this.labelText,
    this.initialValue,
    this.icon,
  });

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      obscureText: obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      initialValue: widget.initialValue,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        icon: widget.icon,
        errorMaxLines: 2,
        suffixIcon: SizedBox(
          height: 24,
          width: 24,
          child: FlatButton(
            child: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
        fillColor: Colors.white,
      ),
    );
  }
}
