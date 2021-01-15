import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/widgets/tittle_app_bar_login.dart';
import 'package:smart_cities/src/features/auth/presentation/register/pages/register_page.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../../../../../shared/app_colors.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../base/providers/phone_number_auth_provider.dart';
import '../providers/verify_code_provider.dart';
import '../widgets/verify_code_form.dart';

class VerifyCodePage extends StatelessWidget {
  static const id = "verify_code_page";

  VerifyCodePage({
    Key key,
    @required this.params,
  }) : super(key: key);

  final VerifyCodeParams params;


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: params.provider.phoneAuthState == PhoneAuthState.started ||
          params.provider.currentState is Loading,

      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.red,
            title: tittleAppBarLogin(onRegister:  ()=> Navigator.pushReplacementNamed(context, RegisterPage.id), onLogin: ()=> Navigator.pushReplacementNamed(context, PhoneNumberPage.id)),
            leading: IconButton(
              icon: Icon(MdiIcons.close),
              color: AppColors.white,
              onPressed: () => Navigator.pop(context),
            )),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(bottom: 24.0, left: 24.0, right: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //..._buildBackground(context),
                _buildLabel(context),
                Spaces.verticalLargest(),
                Container(
                  alignment: Alignment.center,
                  child: VerifyCodeForm(
                    params: params,
                    provider: params.provider,
                  ),
                ),
                Spaces.verticalMedium(),
                _buildRegister(context)

              ],
            ),
          ),
        ),
      ),
    );

  }

  Widget _buildRegister(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(S.of(context).dontHaveAccount, style: TextStyle(
            color: AppColors.primaryText.withOpacity(0.5),
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500)),

        FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, RegisterPage.id),
            child: Text(
              S.of(context).registerMe,
              style: TextStyle(color: AppColors.blueLight,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }


  Widget _buildLabel(BuildContext context) {
    return Row(
      children: [
        Text(S.of(context).codeSend,
          textAlign: TextAlign.left,
          style: kBiggerTitleStyle.copyWith(
              color: AppColors.blueBtnRegister,
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }


}
