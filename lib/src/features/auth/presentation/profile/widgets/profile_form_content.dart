import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/util/validator.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/select_sector/presentation/page/select_sector_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../di/injection_container.dart' as di;



class ProfileFormContent extends StatefulWidget {
  ProfileFormContent({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final ProfileProvider provider;

  @override
  _ProfileFormContentState createState() => _ProfileFormContentState();
}

class _ProfileFormContentState extends State<ProfileFormContent> {
  final _fullNameTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _streetTextController = TextEditingController();
  final _numberTextController = TextEditingController();
  final _validator = di.sl<Validator>();
  final _formKey = GlobalKey<FormState>();


  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _phoneNumberTextController.dispose();

    _streetTextController.dispose();
    _numberTextController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _initUserData(widget.provider.user);

    super.initState();
  }



  void _initUserData(User user) {
    if (user != null) {
      _fullNameTextController.text = user.fullName ?? "";

      _emailTextController.text = user.email;

      _phoneNumberTextController.text = user.phoneNumber;
      
      _streetTextController.text = user.street;
      
      _numberTextController.text = user.number;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Spaces.verticalSmallest(),
          _buildContent(widget.provider),
          //Spaces.verticalSmallest(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.of(context).report, style: kSmallestTextStyle.copyWith(
                  color: AppColors.blueBtnRegister.withOpacity(0.2)), textAlign: TextAlign.left),
                Spaces.verticalSmall(),

                widget.provider.user.reportNumber!= null ? Text('${widget.provider.user.reportNumber} ${S.of(context).reportCreated}',
                    style: kNormalStyle.copyWith(color: AppColors.red), textAlign: TextAlign.left,)
                : Container(),
              ],
            ),
          ),
          Spaces.verticalSmall(),
          btnIniciar(context, widget.provider)
        ],
      ),
    );
  }


  Widget _buildContent(ProfileProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _fullNameTextController,
            textInputAction: TextInputAction.next,
            enabled: provider.editMode,
            onSaved: (value) {
              provider.fullName = value;
            },
            decoration: new InputDecoration(
              labelText: S.of(context).nameAndLastNames,
              focusColor: AppColors.blueBtnRegister,
              hoverColor: AppColors.blueBtnRegister,
              labelStyle: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.2))
            ),
            style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
          ),
          Spaces.verticalSmall(),

          TextFormField(
            controller: _phoneNumberTextController,
            enabled: false,
            decoration: new InputDecoration(
                labelText: S.of(context).phoneNumber,
                focusColor: AppColors.blueBtnRegister,
                hoverColor: AppColors.blueBtnRegister,
                labelStyle: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.2))
            ),
            style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
          ),


          TextFormField(
            controller: _emailTextController,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (!_validator.isEmail(value)) {
                return S.of(context).invaliEmailMessage;
              }
              return null;
            },
            onSaved: (value) {
              widget.provider.email = value;
            },
            decoration: new InputDecoration(
                labelText: S.of(context).email,
                focusColor: AppColors.blueBtnRegister,
                hoverColor: AppColors.blueBtnRegister,
                labelStyle: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.2))
            ),
            style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
            enabled: provider.editMode,
          ),

          InkWell(      
            onTap: provider.editMode ? () async {
              //SelectedSectorPage
              var result= await Navigator.pushNamed(context, SelectSectorPage.id);
              print('sector seleccionado $result');
              if(result!=null)
                provider.sector= result;


            } : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spaces.verticalSmall(),
                Text(S.of(context).sector, style: kSmallestTextStyle.copyWith(
                  color: AppColors.blueBtnRegister.withOpacity(0.2)), textAlign: TextAlign.left),
                Spaces.verticalSmall(),

                Text(
                  provider.sector!= null ? provider.sector.value : '',
                  style: kNormalStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    //fontWeight: FontWeight.bold
                  ),
                ),
                Spaces.verticalSmall(),
                Container(height: 0.7, color: AppColors.blueBtnRegister,)
              ],
            ),
          ),

          TextFormField(
            controller: _streetTextController, //calle
            textInputAction: TextInputAction.next,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              widget.provider.street = value;
            },
            enabled: provider.editMode,
            decoration: new InputDecoration(
                labelText: S.of(context).street,
                focusColor: AppColors.blueBtnRegister,
                hoverColor: AppColors.blueBtnRegister,
                labelStyle: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.2))
            ),
            style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
          ),


          TextFormField(
            controller: _numberTextController, //calle
            textInputAction: TextInputAction.next,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              widget.provider.number = value;
            },
            enabled: provider.editMode,
            decoration: new InputDecoration(
                labelText: S.of(context).numberStreet,
                focusColor: AppColors.blueBtnRegister,
                hoverColor: AppColors.blueBtnRegister,
                labelStyle: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister.withOpacity(0.2))
            ),
            style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
          ),



        ],
      ),
    );
  }



   Widget btnIniciar(BuildContext context, ProfileProvider provider){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: !provider.editMode ? S.of(context).edit.toUpperCase() : S.of(context).save.toUpperCase(),
            style: kTitleStyle.copyWith(fontWeight: FontWeight.bold,  color: AppColors.white),
            onPressed: () async {
    
              if(provider.editMode){
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  await provider.editProfile();

                  _proccess(context, provider);
                }


              }else
                provider.editMode = true;


            }
        )
    );
  }

  
  void _proccess(BuildContext context, ProfileProvider provider) {
    final currentState = provider.currentState;

    if (currentState is NoChanged) {
      provider.editMode = false;

      return;
    }

    String message = S.of(context).saveDataMessage;

    if (currentState is Error) {
      message = S.of(context).unexpectedErrorMessage;
    } else {
      provider.editMode = false;
    }

    showDialog(
        context: context,
        builder: (context) {
          return InfoAlertDialog(
            message: message,
            onConfirm: () {
              if (!provider.editMode)
                Navigator.pop(context);
            },
          );
        });
  }

}
