import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/pages/phone_number_page.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/widgets/tittle_app_bar_login.dart';
import 'package:smart_cities/src/features/auth/presentation/pre_login/page/pre_login.dart';
import 'package:smart_cities/src/features/auth/presentation/register/providers/register_provider.dart';
import 'package:smart_cities/src/shared/image_utils.dart';
import 'package:smart_cities/src/shared/spaces.dart';


import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/view_state.dart';
import '../widgets/register_form.dart';

class RegisterPageParams {
  final AuthCredential authCredential;
  final String phoneNumber;
  final String countryCode;

  RegisterPageParams({
    @required this.authCredential,
    @required this.phoneNumber,
    @required this.countryCode,
  });
}

class RegisterPage extends StatelessWidget {
  static const id = "register_page";


  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterProvider>(
      builder: (context, provider, child) {
        return ModalProgressHUD(
          inAsyncCall: provider.currentState is Loading,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
                backgroundColor: AppColors.red,
                title: tittleAppBarLogin(onRegister: null, onLogin: ()=> Navigator.pushReplacementNamed(context, PhoneNumberPage.id)),
                leading: IconButton(
                  icon: Icon(MdiIcons.close),
                  color: AppColors.white,
                  onPressed: () => Navigator.pushReplacementNamed(context, PreLogin.id),
                )),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildUserPhoto(context, provider),
                    Spaces.verticalMedium(),
                    _buildContentSection(context, provider),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserPhoto(BuildContext context, RegisterProvider provider) {

    return Container(
      padding: EdgeInsets.only(top: 16.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            width: 116,
            height: 116,
            padding: EdgeInsets.all(8.0),
            child: ClipOval(
              child: provider.photo != null
                  ? Image.file(
                provider.photo,
                fit: BoxFit.cover,
              )
                  : Container(color: AppColors.greyButtom.withOpacity(0.5),),
            ),
          ),
          FloatingActionButton(
            mini: true,
            backgroundColor: AppColors.greyButtom,
            child: Icon(Icons.add),
              onPressed: () => ImageUtil.showPhotoDialog(
                context, (image) {
                  if (image != null) provider.photo = image;
                  provider.state = Loaded();
                },
                loadingBuilder: () => provider.state = Loading(),
              )
          ),
        ],
      ),
    );
  }




  Widget _buildContentSection(BuildContext context, RegisterProvider provider) {
    return RegisterForm(
      provider: provider,
    );
  }
}
