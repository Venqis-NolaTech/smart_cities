import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_up/register/pages/register_page.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/device_info.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/components/phone_number_text_field.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/spaces.dart';
import '../../base/providers/phone_number_auth_provider.dart';
import '../../verify_code/pages/verify_code_page.dart';
import '../../verify_code/providers/verify_code_provider.dart';
import '../providers/phone_number_provider.dart';

class PhoneNumberForm extends StatefulWidget {
  PhoneNumberForm({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final PhoneNumberProvider provider;

  @override
  _PhoneNumberFormState createState() => _PhoneNumberFormState();
}

class _PhoneNumberFormState extends State<PhoneNumberForm> {
  final FocusNode _phoneNumberFocus = FocusNode();

  final validator = sl<Validator>();
  final deviceInfo = sl<DeviceInfo>();

  final _formKey = GlobalKey<FormState>();

  String _phoneNumber;
  String _countryCode;

  @override
  void dispose() {
    _phoneNumberFocus.dispose();

    super.dispose();
  }

  void _sendData() async {
    final provider = widget.provider;

    if (provider.currentState is Loading) return;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      provider.countryCode = _countryCode;
      provider.failureCallback = _showFailure;
      provider.codeSendCallback = _gotoVerifyCode;
      //provider.codeAutoRetrievalTimeoutCallback = _gotoVerifyCode;

      /*final isPhysicalDevice = await deviceInfo.isPhysicalDevice;

      if (!isPhysicalDevice) {
        _gotoMain();

        return;
      }*/

      bool show = false;
      String message;

      final userExist = await provider.userExist(_phoneNumber, '', ''); //este solo aplica para login
      if (userExist) {
        await provider.sendPhoneNumber(_phoneNumber);
      } else {
        show = true;
        message = S.of(context).userNotExistMessage;
      }


      if (show) {
        showDialog(
          context: context,
          builder: (context) {
            return InfoAlertDialog(
              message: message,
            );
          },
        );
      }
    }
  }


  void _gotoVerifyCode() {
    final params = VerifyCodeParams(
      phoneNumber: _phoneNumber,
      countryCode: _countryCode,
      actualCode: widget.provider.actualCode,
      authMethod: AuthMethod.login,
    );

    Navigator.pushNamed(context, VerifyCodePage.id, arguments: params);
  }

  void _showFailure() {
    showDialog(
      context: context,
      builder: (context) {
        return InfoAlertDialog(
          message: S.of(context).unexpectedErrorMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildLabel(),
            Spaces.verticalMedium(),
            _buildPhoneNumberField(),
            Container(color: AppColors.black.withOpacity(0.5), height: 0.8,),
            Spaces.verticalLarge(),
            _buildNextButton(),
            Spaces.verticalMedium(),
            _buildRegister()
          ],
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Text(
          S.of(context).enterPhoneNumber,
          textAlign: TextAlign.left,
          style: kBiggerTitleStyle.copyWith(
              color: AppColors.blueBtnRegister,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return PhoneNumberTextFormField(
      validator: (value) {
        if (!validator.isPhoneNumber(value)) {
          return S.of(context).invalidPhoneNumberMessage;
        }
        return null;
      },
      onSaved: (data) {
        _phoneNumber = data?.numericDigitals ?? "";
        _countryCode = data?.countryCode ?? "";

        _phoneNumberFocus.unfocus();
      },
      focusNode: _phoneNumberFocus,
    );
  }

  Widget _buildNextButton() {
    return RoundedButton(
      color: AppColors.blueBtnRegister,
      title: S.of(context).nextPage.toUpperCase(),
      style: kTitleStyle.copyWith( fontWeight: FontWeight.bold,  color: AppColors.white),
      onPressed: _sendData,
    );
  }


  Widget _buildRegister() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.of(context).dontHaveAccount,
            style: TextStyle(
                color: AppColors.primaryText.withOpacity(0.5),
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500)),

        FlatButton(
            onPressed: () => _register(context),
            child: Text(
              S.of(context).registerMe,
              style: TextStyle(
                  color: AppColors.blueLight,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }

  void _register(BuildContext context) {
    Navigator.pushNamed(context, RegisterPage.id);
  }

}
