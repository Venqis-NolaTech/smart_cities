import 'package:flutter/material.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/providers/phone_number_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/selected_municipality/page/selected_municipality_page.dart';
import 'package:smart_cities/src/features/auth/presentation/verify_code/pages/verify_code_page.dart';
import 'package:smart_cities/src/features/auth/presentation/verify_code/providers/verify_code_provider.dart';
import 'package:smart_cities/src/shared/components/phone_number_text_field.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/components/rounded_gradiend_button.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/components/multi_masked_formatter.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/user.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final PhoneNumberProvider provider;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneTextController = TextEditingController();
  final _dniTextController = TextEditingController();

  final _nameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _dniFocus = FocusNode();

  final validator = sl<Validator>();

  final _formKey = GlobalKey<FormState>();

  final _dniFormater = MultiMaskedTextInputFormatter(
    masks: kDNIMasks,
    separator: '-',
  );

  String _name;
  String _lastName;
  String _email;
  String _phoneNumber;
  String _countryCode;

  String _dni;


  bool isPopulateData = false;

  var validDNI= false;
  var validEmail= false;
  var validName= false;
  var validLastName= false;
  var validPhoneNumber= false;

  @override
  void dispose() {
    _nameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();
    _phoneTextController.dispose();
    _dniTextController.dispose();

    _nameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _dniFocus.dispose();

    super.dispose();
  }

  void _sendData() async {
    final provider = widget.provider;

    if (provider.currentState is Loading) return;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      provider.firstName = _name;
      provider.lastName = _lastName;
      provider.phoneNumber = _phoneNumber;
      provider.countryCode = _countryCode;
      provider.dni = _dni;
      provider.email = _email;


      provider.signInWithCredentialCallback = _gotoMain;
      provider.failureCallback = _showFailure;
      provider.codeSendCallback = _gotoVerifyCode;
      provider.authMethod= AuthMethod.register;


      final userExist = await provider.userExist(_phoneNumber, _dni, _email);
      if (!userExist) {
        await provider.sendPhoneNumber(_phoneNumber);
      } else {
        var errorMessage= S.of(context).allreadyExistMessage;

        final failureType = (provider.currentState as Error).failure.runtimeType;

        switch (failureType) {
          case DniExistFailure:
            errorMessage = S.of(context).dniExist;
            break;
          case EmailExistFailure:
            errorMessage = S.of(context).emailExist;
            break;
          default:
            errorMessage = S.of(context).allreadyExistMessage;
        }

        showDialog(
          context: context,
          builder: (context) {
            return InfoAlertDialog(
              message: errorMessage ,
            );
          },
        );
      }


    }
  }

  void _gotoMain() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SelectedMunicipalityPage.id,
      ModalRoute.withName(SelectedMunicipalityPage.id),
    );
  }

  void _gotoVerifyCode() {
    final params = VerifyCodeParams(
      name: _name,
      lastName: _lastName,
      email: _email,
      phoneNumber: _phoneNumber,
      countryCode: _countryCode,
      dni: _dni,
      photo:  widget.provider.photo,
      authMethod: AuthMethod.register,
      provider: widget.provider
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

  void _setControllerValue(TextEditingController controller, String value) {
    controller.text = value;

    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentState = widget.provider.currentState;

    if (currentState is Loaded<UserIdentification> && !isPopulateData) {
      final userIndentification = currentState.value;

      _setControllerValue(_nameTextController, userIndentification.fullName);
      _setControllerValue(_dniTextController, userIndentification.dni);

      isPopulateData = true;
    }

    return Container(
      padding: EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Spaces.verticalLarge(),
            _buildNameField(),
            Spaces.verticalMedium(),
            _buildLastNameField(),
            Spaces.verticalMedium(),
            _buildEmailField(),
            Spaces.verticalMedium(),
            _buildPhoneTextField(), //celular
            Container(color: AppColors.black.withOpacity(0.5), height: 0.8,),
            Spaces.verticalMedium(),
            _buildDniTextField(),//cedula
            Spaces.verticalLargest(),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Stack(
      children: [
        TextFormField(
          validator: (value) {
            if (!validator.isValidName(value)) {
              return S.of(context).invalidNameMessage;
            }
            return null;
          },
          onSaved: (value) {
            _name = value;

            _nameFocus.unfocus();
          },
          focusNode: _nameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value){
            FocusScope.of(context).requestFocus(_lastNameFocus);
          },
          style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500),
          onChanged: (value){
            validName= validator.isValidName(value);
            setState(() {

            });
          },
          decoration: InputDecoration(
            hintText: '${S.of(context).name}*',
            errorMaxLines: 3,
          ),
          controller: _nameTextController,
        ),

        validName ? Positioned(
          right: 15,
          top: 15,
          child: Icon(Icons.check_circle, color: AppColors.blueButton)
        ): Container()


      ],
    );
  }


  Widget _buildLastNameField() {
    return Stack(
      children: [
        TextFormField(
          validator: (value) {
            if (!validator.isValidName(value)) {
              return S.of(context).invalidNameMessage;
            }
            return null;
          },
          onSaved: (value) {
            _lastName = value;
            _lastNameFocus.unfocus();
          },
          style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500),
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value){
            FocusScope.of(context).requestFocus(_emailFocus);
          },
          onChanged: (value){
            validLastName= validator.isValidName(value);
            setState(() {

            });
          },
          decoration: InputDecoration(
            hintText: '${S.of(context).lastName}*',
            errorMaxLines: 3,
          ),
          controller: _lastNameTextController,
        ),

        validLastName ? Positioned(
            right: 15,
            top: 15,
            child: Icon(Icons.check_circle, color: AppColors.blueButton)
        ) : Container()
      ],
    );
  }


  Widget _buildEmailField() {
    return Stack(
      children: [
        TextFormField(
          validator: (value) {
            if (!validator.isEmail(value)) {
              return S.of(context).invaliEmailMessage;
            }
            return null;
          },
          onSaved: (value) {
            _email= value;
          },
          style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500),
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value){
            FocusScope.of(context).requestFocus(_phoneFocus);
          },
          onChanged: (value){
            validEmail=validator.isEmail(value);
            setState(() {

            });
          },
          decoration: InputDecoration(
            hintText: '${S.of(context).email}*',
            errorMaxLines: 3,
          ),
          controller: _emailTextController,
        ),

        validEmail ? Positioned(
            right: 15,
            top: 15,
            child: Icon(Icons.check_circle, color: AppColors.blueButton)
        ): Container()
      ],
    );
  }





  Widget _buildDniTextField() {
    return Stack(
      children: [
        TextFormField(
          maxLength: 14,
          validator: (value) {
            if (!validator.isValidDni(value)) {
              return S.of(context).invalidDniMessage;
            }
            return null;
          },
          onSaved: (value) {
            _dni = value;
          },
          style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500),
          keyboardType: TextInputType.text,
          focusNode: _dniFocus,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (term) {
            _dniFocus.unfocus();
          },
          onChanged: (value){
            setState(() {
              validDNI= validator.isValidDni(value);
            });
          },
          inputFormatters: [_dniFormater],
          decoration: InputDecoration(
            hintText: '${S.of(context).dni}*',
          ),
          controller: _dniTextController,
        ),

        validDNI ? Positioned(
            right: 15,
            top: 15,
            child: Icon(Icons.check_circle, color: AppColors.blueButton)
        ): Container()
      ],
    );
  }


  Widget _buildPhoneTextField() {
    return PhoneNumberTextFormField(
      validator: (value) {
        if (!validator.isPhoneNumber(value)) {
          return S.of(context).phoneNumber;
        }
        return null;
      },
      onSaved: (data) {
        _phoneNumber = data?.numericDigitals ?? "";
        _countryCode = data?.countryCode ?? "";
      },
      style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500),
      focusNode: _phoneFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (value){
        FocusScope.of(context).requestFocus(_dniFocus);
      },
      onChange: (value){
        setState(() {
          validPhoneNumber= validator.isPhoneNumber(value);
        });
      },
      controller: _phoneTextController,
    );
  }

  Widget _buildNextButton() {
    return validateData()
        ? RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).register.toUpperCase(),
            style: kTitleStyle.copyWith(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              color: AppColors.white,
            ),
            onPressed: _sendData)
        : RoundedGradientButton(
            colors: <Color>[
              AppColors.greyButtom.withOpacity(0.45),
              AppColors.greyButtom,
            ],
            title: S.of(context).register.toUpperCase(),
            onPressed: null,
          );
  }

  bool validateData(){

    if(validPhoneNumber && validName && validLastName && validEmail && validDNI)
      return true;
    else
       return false;
  }

}
