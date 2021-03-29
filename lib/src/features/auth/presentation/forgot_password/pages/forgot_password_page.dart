import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/app_colors.dart';
import '../providers/forgot_password_provider.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPageArgs {
  final bool anonymousUser;

  ForgotPasswordPageArgs({this.anonymousUser = false});
}

class ForgotPasswordPage extends StatelessWidget {
  static const id = "forgot_password_page";

  static Future<T> pushNavigate<T extends Object>(
    BuildContext context, {
    ForgotPasswordPageArgs args,
  }) =>
      Navigator.pushNamed(context, ForgotPasswordPage.id, arguments: args);

  const ForgotPasswordPage({
    Key key,
    @required this.args,
  }) : super(key: key);

  final ForgotPasswordPageArgs args;

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordProvider>(
      builder: (context, provider, child) {
        return ModalProgressHUD(
          inAsyncCall: provider.currentState is Loading,
          child: Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).forgotPassword),
              centerTitle: true,
              backgroundColor: AppColors.red,
            ),
            body: ForgotPassordForm(
              provider: provider,
              args: args,
            ),
          ),
        );
      },
    );
  }
}
