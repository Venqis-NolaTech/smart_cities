import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/widgets/tittle_app_bar_login.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_up/register/pages/register_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';

import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/view_state.dart';
import '../providers/sign_in_provider.dart';
import '../widgets/sign_in_form.dart';

class SignInPage extends StatelessWidget {
  static const id = "sign_in_page";

  static pushNavigate(BuildContext context) {
    Navigator.pushReplacementNamed(context, id);
  }

  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SignInProvider>(
      onProviderReady: (provider) => provider.checkHideSocialLogin(),
      builder: (context, provider, child) {
        return ModalProgressHUD(
          inAsyncCall: provider.currentState is Loading,
          child: Scaffold(
            appBar: AppBar(
                backgroundColor: AppColors.red,
                title: tittleAppBarLogin(onLogin: null, onRegister: ()=> Navigator.pushReplacementNamed(context, RegisterPage.id)),
                leading: IconButton(
                  icon: Icon(MdiIcons.close),
                  color: AppColors.white,
                  onPressed: () => Navigator.pop(context),
                )),
            body: SignInForm(provider: provider),
          ),
        );
      },
    );
  }
}
