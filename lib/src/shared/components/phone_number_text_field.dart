import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_cities/src/shared/app_images.dart';

import '../../../generated/i18n.dart';
import '../app_colors.dart';
import '../constant.dart';
import 'multi_masked_formatter.dart';

const String defaultContryCode = "+507";

class PhoneNumberData {
  final String numericDigitals;
  final String countryCode;

  PhoneNumberData({this.numericDigitals, this.countryCode});
}

class PhoneNumberTextFormField extends StatefulWidget {
  PhoneNumberTextFormField({
    Key key,
    this.style,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChange,
    this.onSaved,
    this.validator,
    this.decoration,
    this.initialContryCode = defaultContryCode,
    this.controller,
    this.showFlag = true,
    this.showFlagMain = true,
    this.enabled = true,
    this.textInputAction= TextInputAction.done,
  }) : super(key: key);

  final TextStyle style;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;
  final ValueChanged<String> onChange;
  final FormFieldSetter<PhoneNumberData> onSaved;
  final FormFieldValidator<String> validator;
  final InputDecoration decoration;
  final String initialContryCode;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final bool showFlag;
  final bool showFlagMain;
  final bool enabled;

  @override
  _PhoneNumberTextFormFieldState createState() =>
      _PhoneNumberTextFormFieldState();
}

class _PhoneNumberTextFormFieldState extends State<PhoneNumberTextFormField> {
  String _prefix;
  bool _obscureText= true;


  void initState() {
    _prefix = widget.initialContryCode;

    super.initState();
  }

  MultiMaskedTextInputFormatter _maskFormatter = MultiMaskedTextInputFormatter(
      masks: ['###-####', '###-###-####', '#################'], separator: '-');

  String _getNumericDigitals(String value) {
    return '$_prefix${value.replaceAll(RegExp(r'[()-]'), '')}';
  }

  void _onCountryChange(CountryCode countryCode) {
    _prefix = countryCode.dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.decoration == null
          ? BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(4.0),
            )
          : null,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CountryCodePicker(
              onChanged: _onCountryChange,
              showFlag: widget.showFlag,
              showFlagMain: widget.showFlagMain,
              initialSelection: widget.initialContryCode,
              onInit: (value) => _prefix = value.dialCode,
              enabled: widget.enabled,
              textStyle: kNormalStyle.copyWith(
                color: widget?.style?.color ?? AppColors.primaryText,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.phone,
              focusNode: widget.focusNode,
              onFieldSubmitted: widget.onFieldSubmitted,
              controller: widget.controller,
              enabled: widget.enabled,
              onChanged: widget.onChange,
              validator: (value) {
                return widget.validator(value);
              },
              onSaved: (value) {
                final numericDigitals = _getNumericDigitals(value);
                final countryCode = _prefix;

                widget.onSaved(PhoneNumberData(
                  numericDigitals: numericDigitals,
                  countryCode: countryCode,
                ));
              },
              inputFormatters: [_maskFormatter],
              decoration: widget.decoration == null
                  ? InputDecoration(
                      hintText: S.of(context).phoneNumber,
                      hintStyle: TextStyle(
                        color: AppColors.primaryText.withAlpha(140),
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    )
                  : widget.decoration,
              style: widget.style,
              textInputAction: widget.textInputAction,
              obscureText: _obscureText,
            )
          ),
          GestureDetector(
              onTap: _toggle,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: _obscureText ? AppImages.eyeOff : AppImages.eye,
              )
          )


        ],
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


}
