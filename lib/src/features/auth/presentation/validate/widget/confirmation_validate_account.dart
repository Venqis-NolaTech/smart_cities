import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/auth/presentation/register/pages/register_page.dart';
import 'package:smart_cities/src/features/auth/presentation/validate/page/validate_account_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class ConfirmationAccount extends StatelessWidget {

  final Function onValidate;

  const ConfirmationAccount({Key key, this.onValidate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.of(context).questionNotAccount, style: kTitleStyle),
            Spaces.verticalSmall(),
            Text(S.of(context).accessAccount, style: kNormalStyle, textAlign: TextAlign.center),
            Spaces.verticalSmall(),

            FlatButton(
                onPressed: () => Navigator.pushReplacementNamed(context, RegisterPage.id),
                color: AppColors.blueBtnRegister,
                textColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(S.of(context).register)
            ),
            Spaces.verticalMedium(),
            buildSeparator(),
            Spaces.verticalMedium(),
            Text(S.of(context).questionAccount, style: kTitleStyle),
            //Spaces.verticalSmall(),
            //Text(S.of(context).meesageValidate, style: kNormalStyle, textAlign: TextAlign.center),
            Spaces.verticalSmall(),
            FlatButton(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  PhoneNumberPage.id,
                  arguments: AuthMethod.login,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColors.blueLight)),
                child: Text(
                  S.of(context).login,
                  style: kNormalStyle.copyWith(
                    color: AppColors.blueLight,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildSeparator() {
    return Row(
      children: [
        Expanded(child: Divider()),
        Spaces.horizontalMedium(),
        Text('O', style: TextStyle(color: AppColors.primaryText.withOpacity(0.5))),
        Spaces.horizontalMedium(),
        Expanded(child: Divider()),
      ],
    );


  }

}




