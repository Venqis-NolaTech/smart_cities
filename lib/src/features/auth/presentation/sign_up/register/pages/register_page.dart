import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/auth/presentation/phone_number/widgets/tittle_app_bar_login.dart';
import 'package:smart_cities/src/features/auth/presentation/pre_login/page/pre_login.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_in/pages/sign_in_page.dart';
import 'package:smart_cities/src/features/auth/presentation/selected_municipality/page/selected_municipality_page.dart';
import 'package:smart_cities/src/shared/image_utils.dart';

import '../../../../../../../generated/i18n.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../shared/app_colors.dart';
import '../../../../../../shared/components/base_view.dart';
import '../../../../../../shared/components/rounded_button.dart';
import '../../../../../../shared/provider/view_state.dart';
import '../../../../../../shared/spaces.dart';
import '../providers/register_provider.dart';
import '../widgets/register_form.dart';

class RegisterPage extends StatefulWidget {
  static const id = "register_page";

  static pushNavigate(BuildContext context, {replace = false}) {
    replace
        ? Navigator.pushReplacementNamed(context, id)
        : Navigator.pushNamed(context, id);
  }

  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  RegisterProvider _provider;

  @override
  void initState() {
    super.initState();
  }

  void _register() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await _provider.register();

      _processRegister();
    }
  }

  void _processRegister() async {
    final currentState = _provider.currentState;

    if (currentState is Loaded) {
      SelectedMunicipalityPage.pushNavigate(context, replace: true);
    } else if (currentState is Error) {
      final failureType = currentState.failure.runtimeType;

      var errorMessage = '';

      switch (failureType) {
        case InvalidCredentialFailure:
          errorMessage = S.of(context).wrongEmailOrPasswordMessage;
          break;
        case UserDisabledFailure:
          errorMessage = S.of(context).emailInvalidFormatMessage;
          break;

        case AccountExistWithDiferentCredentialFailure:
          errorMessage = S.of(context).emailAlreadyInUseMessage;
          break;
        default:
          errorMessage = S.of(context).unexpectedErrorMessage;
      }

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterProvider>(
      builder: (context, provider, child) {
        _provider = provider;

        return ModalProgressHUD(
          inAsyncCall: provider.currentState is Loading,
          child: Scaffold(
              appBar: AppBar(
                  backgroundColor: AppColors.red,
                  title: tittleAppBarLogin(onRegister: null, onLogin: ()=> Navigator.pushReplacementNamed(context, SignInPage.id)),
                  leading: IconButton(
                    icon: Icon(MdiIcons.close),
                    color: AppColors.white,
                    onPressed: () => Navigator.pushReplacementNamed(context, PreLogin.id),
                  )),
            body: _buildBody(),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Scrollbar(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraint.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _buildUserPhoto(context, _provider),
                    Spaces.verticalMedium(),
                    RegisterForm(
                      formKey: _formKey,
                      provider: _provider,
                    ),
                    Spaces.verticalLargest(),
                    _buildSignUpButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpButton() {
    return RoundedButton(
      title: S.of(context).register,
      color: AppColors.blueBtnRegister,
      style: TextStyle(
          color: AppColors.white,
          fontWeight: FontWeight.bold),
      onPressed: _register,
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
}
