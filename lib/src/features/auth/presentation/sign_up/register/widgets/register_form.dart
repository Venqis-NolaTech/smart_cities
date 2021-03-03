import 'package:flutter/material.dart';

import '../../../../../../../generated/i18n.dart';
import '../../../../../../shared/components/base_form.dart';
import '../../../../../../shared/components/keyboard_done_action/keyboard_done_action.dart';
import '../../../../../../shared/components/password_text_form_field.dart';
import '../../../../../../shared/spaces.dart';
import '../providers/register_provider.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({
    Key key,
    @required this.formKey,
    @required this.provider,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final RegisterProvider provider;

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with BaseForm {
  final _fisrtNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _dniTextController = TextEditingController();

  final _phoneNumberFocus = FocusNode();

  @override
  void dispose() {
    _fisrtNameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _dniTextController.dispose();

    _phoneNumberFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDoneAction(
      platform: PlatfromSupport.ios,
      focusNodes: [_phoneNumberFocus],
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFirstNameField(),
            Spaces.verticalSmall(),
            _buildLastNameField(),
            Spaces.verticalSmall(),
            _buildEmailField(),
            Spaces.verticalSmall(),
            _buildPasswordField(),
            Spaces.verticalSmall(),
          ],
        ),
      ),
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      validator: (value) {
        if (!validator.isRequired(value)) {
          return S.of(context).requiredField;
        }
        return null;
      },
      onSaved: (value) => widget.provider.firstName = value,
      decoration: InputDecoration(
        labelText: '${S.of(context).name}*',
      ),
      controller: _fisrtNameTextController,
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      validator: (value) {
        if (!validator.isRequired(value)) {
          return S.of(context).requiredField;
        }
        return null;
      },
      onSaved: (value) => widget.provider.lastName = value,
      decoration: InputDecoration(
        labelText: '${S.of(context).lastName}*',
      ),
      controller: _lastNameTextController,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (value) {
        if (!validator.isEmail(value)) {
          return S.of(context).invaliEmailMessage;
        }
        return null;
      },
      onSaved: (value) => widget.provider.email = value,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: '${S.of(context).email}*',
      ),
      controller: _emailTextController,
    );
  }

  Widget _buildPasswordField() {
    return PasswordTextFormField(
      validator: (value) {
        if (!validator.isValidPassword(value)) {
          return S.of(context).passwordInvalidMessage;
        }
        return null;
      },
      onSaved: (value) => widget.provider.password = value,
      labelText: '${S.of(context).password}*',
      controller: _passwordTextController,
    );
  }
}
