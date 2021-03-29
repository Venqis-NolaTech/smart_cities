import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/features/auth/presentation/selected_municipality/page/selected_municipality_page.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/rounded_button.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/spaces.dart';
import '../providers/email_verification_provider.dart';

class EmailConfirmationPageArgs {
  final bool isSendConfirmation;
  final Function onPressed;

  EmailConfirmationPageArgs({
    this.isSendConfirmation = false,
    this.onPressed,
  });
}

class EmailConfirmationPage extends StatelessWidget {
  static const id = "email_confirmation_page";

  static dynamic pushNavigate(
    BuildContext context, {
    bool replace = false,
    EmailConfirmationPageArgs args,
  }) {
    if (replace) {
      return Navigator.pushNamedAndRemoveUntil(
        context,
        id,
        (route) => false,
        arguments: args,
      );
    } else {
      return Navigator.pushNamed(context, id, arguments: args);
    }
  }

  const EmailConfirmationPage({
    Key key,
    @required this.args,
  }) : super(key: key);

  final EmailConfirmationPageArgs args;

  String _getTitleByStatus(BuildContext context) {
    if (args.isSendConfirmation) {
      return S.of(context).sendEmailConfirmationTitle;
    } else {
      return S.of(context).emailConfirmationYetTitle;
    }
  }

  String _getDescriptionByStatus(BuildContext context) {
    if (args.isSendConfirmation) {
      return S.of(context).sendEmailConfirmationDescripcion;
    } else {
      return S.of(context).emailConfirmationYetDescripcion;
    }
  }

  Widget _getIconByStatus() {
    if (args.isSendConfirmation) {
      return Icon(
        MdiIcons.checkCircle,
        size: 128,
        color: AppColors.blueBtnRegister,
      );
    } else {
      return Icon(
        MdiIcons.alert,
        size: 128,
        color: AppColors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<EmailConfirmationProvider>(
      onProviderReady: (provider) => provider.sendEmailVerification(),
      builder: (context, provider, child) {
        return child;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.red,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.clear,
            ),
            onPressed: () => _goToMain(context)
              //args.onPressed,

          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildIcon(),
              _buildTitle(context),
              _buildDescription(context),
              Spaces.verticalLargest(),
              _buildButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: _getIconByStatus(),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        _getTitleByStatus(context) ?? '',
        textAlign: TextAlign.center,
        style: kBigTitleStyle.copyWith(color: AppColors.blueBtnRegister),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        _getDescriptionByStatus(context) ?? '',
        textAlign: TextAlign.center,
        style: kBigTitleStyle.copyWith(color: AppColors.blueBtnRegister),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: RoundedButton(
        title: S.of(context).next,
        color: AppColors.blueBtnRegister,
        style: kTitleStyle.copyWith(color: Colors.white),
        elevation: 0.0,
        onPressed: ()=> _goToMain(context),
      ),
    );
  }

  void _goToMain(BuildContext context){
    Navigator.pushNamedAndRemoveUntil(
      context,
      SelectedMunicipalityPage.id,
      ModalRoute.withName(EmailConfirmationPage.id),
    );
  }
}
