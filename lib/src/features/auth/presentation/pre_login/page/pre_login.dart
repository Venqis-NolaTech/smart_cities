import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/base/providers/phone_number_auth_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/auth/presentation/register/pages/register_page.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class PreLogin extends StatelessWidget {
  static const id = "pre_login_page";



  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Container(
            height: size.height * 0.6,
            child: Stack(
              children: [
                Container(width: double.infinity, child: AppImages.step5),
                Center(
                  child: Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: Text(S.of(context).messageStart,
                      style: kTitleStyle.copyWith(
                          color: AppColors.white,
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                )),
              ],
            ),
          ),
          Expanded(child: Spaces.verticalSmall()),
          btnIniciar(context),
          Spaces.verticalMedium(),
          buildSeparator(),
          Spaces.verticalMedium(),
          btnRegister(context),
          Spaces.verticalMedium(),
          btnAccess(context),
          Expanded(child: Spaces.verticalSmall()),
        ],
      ),
    );
  }

  Widget btnIniciar(BuildContext context){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.red,
            title: S.of(context).login.toUpperCase(),
            style: kTitleStyle.copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.bold,  color: AppColors.white),
            onPressed: () => //Navigator.pushNamedAndRemoveUntil(context, PhoneNumberPage.id, ModalRoute.withName(PhoneNumberPage.id))
            Navigator.pushNamed(
              context,
              PhoneNumberPage.id,
              arguments: AuthMethod.login,
            )
        )
    );
  }

  Widget btnRegister(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).register.toUpperCase(),
            style: kTitleStyle.copyWith(fontFamily: 'Roboto', fontWeight: FontWeight.w400, color: AppColors.white,),
            onPressed: () {
              Navigator.pushNamed(context, RegisterPage.id);
            }

        )
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

  Widget btnAccess(BuildContext context) {
    return Padding(
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
    );
  }

}
