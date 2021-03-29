import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../generated/i18n.dart';
import '../app_colors.dart';
import '../constant.dart';
import 'rounded_button.dart';

enum AuthButtonTheme {
  dark,
  light,
}

class DontHaveAccountButton extends StatelessWidget {
  DontHaveAccountButton({
    Key key,
    @required this.onPressed,
    this.theme = AuthButtonTheme.light,
  }) : super(key: key);

  final Function onPressed;
  final AuthButtonTheme theme;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = theme == AuthButtonTheme.light;

    final textColor = isLightTheme ? AppColors.primaryText : Colors.white;

    final highlineColor = isLightTheme ? AppColors.blueLight : Colors.white;

    return FlatButton(
      child: RichText(
        text: TextSpan(
            text: '${S.of(context).noHaveAccount} ',
            style: kNormalStyle.copyWith(color: textColor),
            children: [
              TextSpan(
                text: S.of(context).register,
                style: kNormalStyle.copyWith(color: highlineColor),
              ),
            ]),
      ),
      onPressed: onPressed,
    );
  }
}

class WithoutAccountAndForgetPasswordButton extends StatelessWidget {
  const WithoutAccountAndForgetPasswordButton({
    Key key,
    @required this.withoutAccountOnPressed,
    @required this.forgetPasswordOnPressed,
    this.theme = AuthButtonTheme.light,
  }) : super(key: key);

  final Function withoutAccountOnPressed;
  final Function forgetPasswordOnPressed;
  final AuthButtonTheme theme;

  @override
  Widget build(BuildContext context) {
    final isLightTheme = theme == AuthButtonTheme.light;

    final textColor = isLightTheme ? AppColors.primaryText : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FlatButton(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              S.of(context).loginWithoutQccount,
              textAlign: TextAlign.center,
              style: kNormalStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            onPressed: withoutAccountOnPressed,
          ),
        ),
        Flexible(
          child: FlatButton(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              S.of(context).forgotPassword,
              textAlign: TextAlign.center,
              style: kNormalStyle.copyWith(color: textColor),
            ),
            onPressed: forgetPasswordOnPressed,
          ),
        )
      ],
    );
  }
}

class FacebookButton extends StatelessWidget {
  FacebookButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      title: S.of(context).accessWithFacebook,
      leadingIcon: Icon(
        MdiIcons.facebook,
        color: Colors.white,
      ),
      color: AppColors.blueFacebook,
      onPressed: onPressed,
    );
  }
}

class GoogleButton extends StatelessWidget {
  GoogleButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RoundedButton(
      title: S.of(context).accessWithGoogle,
      leadingIcon: Icon(
        MdiIcons.google,
        color: Colors.white,
      ),
      color: AppColors.blueGoogle,
      onPressed: onPressed,
    );
  }
}
