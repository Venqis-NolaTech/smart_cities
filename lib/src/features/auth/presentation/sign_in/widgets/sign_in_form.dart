import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/features/auth/presentation/forgot_password/pages/forgot_password_page.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/pages/email_confirmation_page.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_up/register/pages/register_page.dart';
import 'package:smart_cities/src/features/auth/presentation/selected_municipality/page/selected_municipality_page.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';
import 'package:smart_cities/src/shared/components/auth_buttons.dart';

import '../../../../../../app.dart';
import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/base_form.dart';
import '../../../../../shared/components/password_text_form_field.dart';
import '../../../../../shared/components/rounded_button.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/spaces.dart';
import '../providers/sign_in_provider.dart';

class SignInForm extends StatefulWidget {
  SignInForm({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final SignInProvider provider;

  @override
  _SignInFormState createState() => _SignInFormState(provider);
}

class _SignInFormState extends State<SignInForm> with BaseForm {
  _SignInFormState(this._provider);

  final SignInProvider _provider;
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  @override
  dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();

    super.dispose();
  }

  void _signInWithEmail() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _removeFieldFocus();

      await _provider.accesWithEmail(
        email: _email,
        password: _password,
      );

      _processLogin();
    }
  }

  void _signInWithFacebook() async {
    _removeFieldFocus();

    await _provider.accessWithFacebook();

    _processLogin();
  }

  void _signInWithGoogle() async {
    _removeFieldFocus();

    await _provider.accessWithGoogle();

    _processLogin();
  }

  void _processLogin() async {
    final provider = widget.provider;
    final currentState = provider.currentState;

    if (currentState is Loaded) {
      if (currentUser.emailVerified) {
        _gotoMain();
      } else {
        _gotoEmailConfirmation();
      }
      //SelectedMunicipalityPage.pushNavigate(context);
    } else if (currentState is Error) {
      final failureType = currentState.failure.runtimeType;

      var errorMessage = '';

      switch (failureType) {
        case InvalidCredentialFailure:
          errorMessage = S.of(context).wrongEmailOrPasswordMessage;
          break;
        case UserDisabledFailure:
          errorMessage = S.of(context).emailInvalidFormatMessage;
          break;

        case AccountExistWithDiferentCredentialFailure:
          errorMessage = S.of(context).emailAlreadyInUseMessage;
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

  void _gotoEmailConfirmation() {
    EmailConfirmationPage.pushNavigate(
      context,
      replace: true,
      args: EmailConfirmationPageArgs(
        onPressed: null,
      ),
    );
  }

  void _gotoMain() {

    Navigator.pushNamedAndRemoveUntil(
      context,
      SelectedMunicipalityPage.id,
      ModalRoute.withName(SelectedMunicipalityPage.id),
    );
  }


  void _fieldFocusChange(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _removeFieldFocus() {
    _emailFocus.unfocus();
    _passwordFocus.unfocus();
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
                  Spaces.verticalSmall(),
                  _buildPasswordTextField(),
                  Spaces.verticalLarge(),
                  _buildLoginButton(),
                  ..._buildSocialLogin(),
                  Spaces.verticalLarge(),
                  _buildNoHaveAccountButton(),
                  Spaces.verticalLarge(),
                  _buildBottom()
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
      S.of(context).loginWith,
      style: kBiggerTitleStyle.copyWith(
        color: AppColors.blueBtnRegister,
        fontWeight: FontWeight.bold,
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
      onFieldSubmitted: (term) {
        _fieldFocusChange(_emailFocus, _passwordFocus);
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: S.of(context).email,
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return PasswordTextFormField(
      validator: (value) {
        final val = value?.trim();
        if (!validator.isRequired(val)) {
          return S.of(context).requiredField;
        } else if (!validator.isValidPassword(val)) {
          return S.of(context).passwordInvalidMessage;
        }

        return null;
      },
      onSaved: (value) {
        _password = value?.trim();
      },
      focusNode: _passwordFocus,
      onFieldSubmitted: (_) {
        _passwordFocus.unfocus();

        _signInWithEmail();
      },
      labelText: S.of(context).password,
      textInputAction: TextInputAction.done,
    );
  }

  List<Widget> _buildSocialLogin() {
    final isHideSocialLogin = _provider.isHideSocialLogin;

    if (isHideSocialLogin) return [];

    return [
      Spaces.verticalLarge(),
      _buildOrLabel(),
      Spaces.verticalLarge(),
      _buildFacebookButton(),
      Spaces.verticalMedium(),
      _buildGoogleButton(),
    ];
  }

  Widget _buildLoginButton() {
    return RoundedButton(
      title: S.of(context).login,
      style: kNormalStyle.copyWith(
        color: AppColors.white,
      ),
      color: AppColors.blueBtnRegister,
      onPressed: _signInWithEmail,
    );
  }

  Widget _buildOrLabel() {
    return Text(
      S.of(context).or.toUpperCase(),
      textAlign: TextAlign.center,
      style: kTitleStyle.copyWith(
        color: AppColors.blue,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildFacebookButton() {
    return RoundedButton(
      height: 50,
      title: S.of(context).accessWithFacebook,
      leadingIcon: Icon(
        MdiIcons.facebook,
        color: Colors.white,
      ),
      color: AppColors.blueFacebook,
      style: kNormalStyle.copyWith(
        color: AppColors.white,
      ),
      onPressed: _signInWithFacebook,
    );
  }

  Widget _buildGoogleButton() {
    return RoundedButton(
      height: 50,
      title: S.of(context).accessWithGoogle,
      leadingIcon: Icon(
        MdiIcons.google,
        color: Colors.white,
      ),
      color: AppColors.red,
      style: kNormalStyle.copyWith(
        color: AppColors.white,
      ),
      onPressed: _signInWithGoogle,
    );
  }

  Widget _buildNoHaveAccountButton() {
    return FlatButton(
      child: RichText(
        text: TextSpan(
            text: '${S.of(context).dontHaveAccount} ',
            style: kNormalStyle.copyWith(
              color: AppColors.primaryText,
            ),
            children: [
              TextSpan(
                text: S.of(context).register,
                style: kNormalStyle.copyWith(color: AppColors.blue, fontWeight: FontWeight.bold)
              ),
            ]),
      ),
      onPressed: () => RegisterPage.pushNavigate(context, replace: true),
    );
  }

  Widget _buildBottom() {
    return WithoutAccountAndForgetPasswordButton(
      withoutAccountOnPressed: () =>  MainPage.pushNavigate(context, replace: true),
      forgetPasswordOnPressed: () => ForgotPasswordPage.pushNavigate(
        context,
        args: ForgotPasswordPageArgs(
          anonymousUser: false,
        ),
      ),
    );
  }

  Widget btnLoginWithoutQccount(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        FlatButton(
          child: Text(
              S.of(context).loginWithoutQccount,
              style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.bold)
          ),
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainPage.id,
              ModalRoute.withName(MainPage.id),
            );
          },

        ),

        FlatButton(
          child: Text(
              S.of(context).forgotPassword,
              style: kNormalStyle.copyWith(color: AppColors.primaryText, fontWeight: FontWeight.w400)
          ),
          onPressed: () {

          },

        ),




      ],
    );


    /*return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: RoundedButton(
          color: AppColors.white,
          borderColor: AppColors.white,
          elevation: 0,
          title: S.of(context).loginWithoutQccount,
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.primaryTextLight,),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainPage.id,
              ModalRoute.withName(MainPage.id),
            );
          }
      ),
    );*/
  }


}
