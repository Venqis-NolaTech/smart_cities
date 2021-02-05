import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';



class BtnLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).login.toUpperCase(),
            style: kTitleStyle.copyWith(color: AppColors.white),
            onPressed:
                () =>
            Navigator.pushReplacementNamed(
              context,
              PhoneNumberPage.id,
              arguments: AuthMethod.login,
            )));
  }
}
