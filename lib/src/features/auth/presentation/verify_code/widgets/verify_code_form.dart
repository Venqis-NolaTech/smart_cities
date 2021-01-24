import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/providers/phone_number_provider.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/spaces.dart';
import '../../base/providers/phone_number_auth_provider.dart';
import '../providers/verify_code_provider.dart';

class VerifyCodeForm extends StatefulWidget {
  VerifyCodeForm({
    Key key,
    @required this.params,
    @required this.provider,
  }) : super(key: key);

  final VerifyCodeParams params;
  final PhoneNumberProvider provider;

  @override
  _VerifyCodeFormState createState() => _VerifyCodeFormState();
}

class _VerifyCodeFormState extends State<VerifyCodeForm> {
  final FocusNode _codeFocus = FocusNode();

  final validator = sl<Validator>();

  final _formKey = GlobalKey<FormState>();

  String _code;

  Timer _countDownTimer;
  int _countDown = 60;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 250), () => _startCountDownTimer());
  }

  @override
  void dispose() {
    _codeFocus.dispose();
    _countDownTimer.cancel();

    super.dispose();
  }

  void _startCountDownTimer() {
    const oneSec = const Duration(seconds: 1);
    _countDownTimer = new Timer.periodic(
      oneSec,
      (timer) => setState(() {
        if (_countDown < 1) {
          timer.cancel();
        } else {
          _countDown = _countDown - 1;
        }
      }),
    );
  }

  void _restarCounDownTimer() {
    _countDown = 60;
    _startCountDownTimer();
  }

  void _resendCode() async {
    await widget.provider.resendCode(widget.params.phoneNumber);

    _restarCounDownTimer();
  }

  void _sigIn() async {
    print(widget.params.authMethod);
    final provider = widget.provider;

    provider.authMethod= widget.params.authMethod;

    if (provider.currentState is Loading) return;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if(widget.params.authMethod== AuthMethod.register){
        provider.firstName= widget.params.name;
        provider.lastName= widget.params.lastName;
        provider.phoneNumber= widget.params.phoneNumber;
        provider.email= widget.params.email;
        provider.dni= widget.params.dni;
      }

      await provider.signInWithSMSCode(_code);


      _process(provider);
    }
  }

  void _process(PhoneNumberAuthProvider provider) {
    if (provider.currentState is Error) {
      final failureType = (provider.currentState as Error).failure.runtimeType;

      String errorMessage = '';

      switch (failureType) {
        case UserDisabledFailure:
          errorMessage = S.of(context).userDisabledMessage;
          break;
        case AccountExistWithDiferentCredentialFailure:
          errorMessage = S.of(context).allreadyExistMessage;
          break;
        case InvalidCredentialFailure:
        default:
          errorMessage = S.of(context).unexpectedErrorMessage;
      }

      showDialog(
        context: context,
        builder: (context) {
          return InfoAlertDialog(
            message: errorMessage,
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Spaces.verticalSmall(),
            _buildPinField(),
            Spaces.verticalMedium(),
            _buildResendCodeButton(),
            Spaces.verticalMedium(),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }


  Widget _buildPinField() {
    return PinInputTextFormField(
      validator: (value) {
        if (!validator.isRequired(value)) {
          return S.of(context).invalidPhoneNumberMessage;
        }
        return null;
      },
      onSaved: (value) {
        _code = value;

        _codeFocus.unfocus();
      },
      focusNode: _codeFocus,
      pinLength: 6,
      decoration: BoxLooseDecoration(
        textStyle: kMediumTitleStyle.copyWith(
          color: AppColors.borderEbonyClay,
        ),
        bgColorBuilder: PinListenColorBuilder(
          AppColors.white,
          AppColors.white,
        ),
        strokeColorBuilder: PinListenColorBuilder(
          AppColors.borderEbonyClay,
          AppColors.borderEbonyClay,
        ),
        gapSpace: 4.0,
        radius: Radius.circular(4.0),
      ),
    );
  }

  Widget _buildResendCodeButton() {
    final title = _countDown > 0
        ? '${S.of(context).resendCodeIn} $_countDown'
        : S.of(context).resendCode;

    return FlatButton(
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.primaryText.withOpacity(_countDown == 0 ? 1 : 0.5),
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: _countDown == 0 ? _resendCode : null,
    );
  }

  Widget _buildNextButton() {

    return RoundedButton(
      color: AppColors.blueBtnRegister,
      title: S.of(context).login.toUpperCase(),
      style: kTitleStyle.copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.bold,  color: AppColors.white),
      onPressed: _sigIn,
    );
  }
}
