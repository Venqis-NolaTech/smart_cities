import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
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
            Text(S.of(context).questionValidate, style: kTitleStyle),
            Spaces.verticalSmall(),
            Text(S.of(context).accessAccount, style: kNormalStyle, textAlign: TextAlign.center),
            Spaces.verticalSmall(),

            FlatButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, ValidateAccountPage.id);
                  onValidate();
                },
                color: AppColors.blueBtnRegister,
                textColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Text(S.of(context).validate)
            ),
            Spaces.verticalMedium(),
            buildSeparator(),
            Spaces.verticalMedium(),
            Text(S.of(context).questionValidateAccount, style: kTitleStyle),
            Spaces.verticalSmall(),
            Text(S.of(context).meesageValidate, style: kNormalStyle, textAlign: TextAlign.center),
            Spaces.verticalSmall(),
            FlatButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColors.blueLight)),
                child: Text(
                  S.of(context).logout,
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




