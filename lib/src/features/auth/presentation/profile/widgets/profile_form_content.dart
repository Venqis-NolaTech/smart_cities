import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/util/validator.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../di/injection_container.dart' as di;



class ProfileFormContent extends StatefulWidget {
  ProfileFormContent({
    Key key,
    @required this.provider, 
    @required this.onSend,
  }) : super(key: key);

  final ProfileProvider provider;
  final Function onSend;

  @override
  _ProfileFormContentState createState() => _ProfileFormContentState();
}

class _ProfileFormContentState extends State<ProfileFormContent> {
  final _fullNameTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _streetTextController = TextEditingController();
  final _numberTextController = TextEditingController();

  final _sectorTextController = TextEditingController();

  final _validator = di.sl<Validator>();
  final _formKey = GlobalKey<FormState>();


  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _phoneNumberTextController.dispose();
    _sectorTextController.dispose();
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
        children: [
          _buildContent(widget.provider),
          btnIniciar(context, widget.provider)
        ],
      ),
    );
  }


  Widget _buildContent(ProfileProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _fullNameTextController,
            textInputAction: TextInputAction.next,
            enabled: provider.editMode,
            onSaved: (value) {
              //widget.provider.fullName = value;
            },
            decoration: new InputDecoration(
              hintText: '${S.of(context).nameAndLastNames}*',
            ),
            style: kNormalStyle,
          ),
          Spaces.verticalSmall(),

          TextFormField(
            controller: _phoneNumberTextController,
            decoration: new InputDecoration(
              labelText: S.of(context).phoneNumber,
            ),
            enabled: provider.editMode,
            style: kNormalStyle,
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
            ),
            enabled: provider.editMode,
            style: kNormalStyle,
          ),

          InkWell(
            onTap: () async {
              
            },
            child: TextFormField(
              controller: _sectorTextController,
              textInputAction: TextInputAction.next,
              enabled: provider.editMode,
              validator: (value) {
                return null;
              },
              onSaved: (value) {
            
            
              },
              decoration: new InputDecoration(
                labelText: '${S.of(context).sector}*',
              ),
              style: kNormalStyle.copyWith(
                color: Colors.white,
              ),
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
            decoration: new InputDecoration(
              labelText: S.of(context).street,
            ),
            enabled: provider.editMode,
            style: kNormalStyle,
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
            decoration: new InputDecoration(
              labelText: S.of(context).numberStreet,
            ),
            enabled: provider.editMode,
            style: kNormalStyle,
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
          );
        });
  }

}
