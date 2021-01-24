import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/util/validator.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
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
  final _addressTextController = TextEditingController();
  final _sectorTextController = TextEditingController();

  final _validator = di.sl<Validator>();
  final _formKey = GlobalKey<FormState>();


  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _phoneNumberTextController.dispose();
    _sectorTextController.dispose();
    _addressTextController.dispose();

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


    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: kToolbarHeight),
              child: Stack(
                children: [

                  _buildContent(),

                ],
              ),
            ),
          ),
        ),
      ),


    );
  }


  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _fullNameTextController,
            textInputAction: TextInputAction.next,
            enabled: false,
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
            enabled: false,
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
              //widget.provider.email = value;
            },
            decoration: new InputDecoration(
              labelText: S.of(context).email,
            ),
            enabled: false,
            style: kNormalStyle,
          ),

          Container(alignment: Alignment.bottomLeft, child: Text('* tu cuenta no esta validad', style: kSmallestTextStyle.copyWith(color: AppColors.red), textAlign: TextAlign.start)),

          TextFormField(
            controller: _sectorTextController,
            textInputAction: TextInputAction.next,
            enabled: false,
            validator: (value) {
              if (!_validator.isEmail(value)) {
                return S.of(context).invaliEmailMessage;
              }
              return null;
            },
            onSaved: (value) {
              //widget.provider.email = value;
            },
            decoration: new InputDecoration(
              labelText: '${S.of(context).sector}*',
            ),
            style: kNormalStyle.copyWith(
              color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }
}
