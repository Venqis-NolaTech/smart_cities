import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/widgets/tittle_app_bar_login.dart';
import 'package:smart_cities/src/features/auth/presentation/pre_login/page/pre_login.dart';
import 'package:smart_cities/src/features/auth/presentation/register/pages/register_page.dart';

import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../base/providers/phone_number_auth_provider.dart';
import '../providers/phone_number_provider.dart';
import '../widgets/phone_number_form.dart';

class PhoneNumberPage extends StatelessWidget {
  static const id = "phone_number_page";

  PhoneNumberPage({
    Key key,
    @required this.authMethod,
  }) : super(key: key);

  final AuthMethod authMethod;

  @override
  Widget build(BuildContext context) {
    return BaseView<PhoneNumberProvider>(
      builder: (context, provider, child) {
        return ModalProgressHUD(
          inAsyncCall: provider.currentState is Loading,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
                backgroundColor: AppColors.red,
                title: tittleAppBarLogin(onLogin: null,onRegister: ()=> Navigator.pushReplacementNamed(context, RegisterPage.id)),
                leading: IconButton(
                  icon: Icon(MdiIcons.close),
                  color: AppColors.white,
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, PreLogin.id, ModalRoute.withName(PhoneNumberPage.id)),
                )),
            body: _buildContentSection(
              context,
              provider,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    PhoneNumberProvider provider,
  ) {
    return PhoneNumberForm(
      provider: provider,
      authMethod: authMethod,
    );
  }
}

