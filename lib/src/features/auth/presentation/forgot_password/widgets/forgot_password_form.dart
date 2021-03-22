import 'package:flutter/material.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/base_form.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/components/rounded_button.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/spaces.dart';
import '../pages/forgot_password_page.dart';
import '../providers/forgot_password_provider.dart';

class ForgotPassordForm extends StatefulWidget {
  ForgotPassordForm({
    Key key,
    @required this.provider,
    @required this.args,
  }) : super(key: key);

  final ForgotPasswordProvider provider;
  final ForgotPasswordPageArgs args;

  @override
  _ForgotPassordFormState createState() =>
      _ForgotPassordFormState(provider, args);
}

class _ForgotPassordFormState extends State<ForgotPassordForm> with BaseForm {
  _ForgotPassordFormState(this._provider, this._args);

  final ForgotPasswordProvider _provider;
  final ForgotPasswordPageArgs _args;

  final FocusNode _emailFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String _email;

  @override
  dispose() {
    _emailFocus.dispose();

    super.dispose();
  }

  void _sendEmail() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _removeFieldFocus();

      await _provider.sendEmail(_email);

      _process();
    }
  }

  void _process() async {
    final provider = widget.provider;
    final currentState = provider.currentState;

    if (currentState is Loaded) {
      _showSuccessDialog();
    } else if (currentState is Error) {
      final failureType = currentState.failure.runtimeType;

      var errorMessage = '';

      switch (failureType) {
        case UserDisabledFailure:
          errorMessage = S.of(context).emailInvalidFormatMessage;
          break;
        case UserNotFoundFailure:
          errorMessage = S.of(context).emailNotExistMessage;
          break;
        default:
          errorMessage = S.of(context).unexpectedErrorMessage;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  void _removeFieldFocus() {
    _emailFocus.unfocus();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return InfoAlertDialog(
          message: S.of(context).recoveryPasswordMessage,
          confirmTitle: S.of(context).ok,
          onConfirm: () => Navigator.maybePop(context, _args.anonymousUser),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Scrollbar(
          child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTitle(),
                  Spaces.verticalLarge(),
                  _buildEmailTextField(),
                  Spaces.verticalMedium(),
                  _buildBottom(),
                ],
              ),
            ),
          ),
        ),
      ));
    });
  }

  Widget _buildTitle() {
    return Text(
      S.of(context).forgotPasswordMessage,
      textAlign: TextAlign.center,
      style: kNormalStyle.copyWith(
        color: AppColors.blueBtnRegister,
      ),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      validator: (value) {
        final val = value?.trim();
        if (!validator.isRequired(val)) {
          return S.of(context).requiredField;
        } else if (!validator.isEmail(val)) {
          return S.of(context).emailInvalidFormatMessage;
        }
        return null;
      },
      onSaved: (value) {
        _email = value?.trim();
      },
      focusNode: _emailFocus,
      onFieldSubmitted: (_) => _removeFieldFocus(),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: S.of(context).email,
      ),
    );
  }

  Widget _buildBottom() {
    return RoundedButton(
      title: S.of(context).send,
      style: kTitleStyle.copyWith(fontWeight: FontWeight.bold,  color: AppColors.white),
      color: AppColors.blueBtnRegister,
      onPressed: _sendEmail,
    );
  }
}
