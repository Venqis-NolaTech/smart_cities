import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/string_util.dart';
import '../../../../../core/util/validator.dart';
import '../../../../../di/injection_container.dart' as di;
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/circular_button.dart';
import '../../../../../shared/components/custom_card.dart';
import '../../../../../shared/components/firebase_storage_image.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/components/rounded_button.dart';
import '../../../../../shared/constant.dart';
import '../../../../../shared/image_utils.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/spaces.dart';
import '../../../domain/entities/user.dart';
import '../providers/profile_provider.dart';

class ProfileContent extends StatefulWidget {
  ProfileContent({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final ProfileProvider provider;

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  static const _photoSize = 90.0;
  static const _changePhotoBtnSize = 48.0;

  final _fullNameTextController = TextEditingController();
  final _nickNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  final _addressTextController = TextEditingController();

  final _validator = di.sl<Validator>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _initUserData(widget.provider.user);

    super.initState();
  }

  void dispose() {
    _fullNameTextController.dispose();
    _nickNameTextController.dispose();
    _emailTextController.dispose();
    _phoneNumberTextController.dispose();
    _locationTextController.dispose();
    _addressTextController.dispose();

    super.dispose();
  }

  void _initUserData(User user) {
    if (user != null) {
      _fullNameTextController.text = user.fullName ?? "";
      _fullNameTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _fullNameTextController.text.length),
      );

      _nickNameTextController.text = user.nickName;
      _nickNameTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _nickNameTextController.text.length),
      );

      _emailTextController.text = user.email;
      _emailTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _emailTextController.text.length),
      );

      _phoneNumberTextController.text = user.phoneNumber;

      _phoneNumberTextController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneNumberTextController.text.length),
      );


    }
  }


  void _sendData(BuildContext context, ProfileProvider provider) async {
    if (provider.editMode) {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();

        await provider.editProfile();

        _proccess(context, provider);
      }
    } else {
      provider.editMode = true;
    }
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

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: Colors.white,
        hintColor: Colors.white,
        disabledColor: Colors.white.withOpacity(0.5),
        inputDecorationTheme: InputDecorationTheme(
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Container(
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildHeader(),
                        _buildContent(),
                        _buildEditButton(),
                      ],
                    ),
                    _buildPhotoWidget(),
                    _buildChangePhotoButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final List<Widget> widgets = [
      Spaces.verticalLarge(),
      Spaces.verticalMedium(),
    ];

    if (widget.provider.editMode) {
      widgets.addAll([
        TextFormField(
          controller: _fullNameTextController,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            //widget.provider.fullName = value;
          },
          decoration: new InputDecoration(
            hintText: '${S.of(context).nameAndLastNames}*',
          ),
          style: kMediumTitleStyle.copyWith(
            color: Colors.white,
          ),
        ),


      ]);
    } else {
      widgets.addAll([
        Text(
          _fullNameTextController.text,
          style: kMediumTitleStyle.copyWith(color: Colors.white),
        ),
        Spaces.verticalMedium(),
      ]);

      widgets.add(
        Text(
          _locationTextController.text.isNotNullOrNotEmpty
              ? _locationTextController.text
              : S.of(context).nationality,
          style: kTitleStyle.copyWith(color: Colors.white),
        ),
      );

      widgets.add(Text(
        _addressTextController.text.isNotNullOrNotEmpty
            ? _addressTextController.text
            : S.of(context).address,
        style: kNormalStyle.copyWith(color: Colors.white),
      ));
    }

    return CustomCard(
      backgroundColor: AppColors.bermudaGray,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      margin: const EdgeInsets.only(top: _photoSize, left: 16.0, right: 16.0),
      child: Column(
        children: widgets,
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      child: Column(
        children: <Widget>[
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
              labelText: '${S.of(context).email}*',
            ),
            enabled: widget.provider.editMode,
            style: kNormalStyle.copyWith(
              color: Colors.white,
            ),
          ),
          Spaces.verticalSmall(),
          TextFormField(
            controller: _phoneNumberTextController,
            decoration: new InputDecoration(
              labelText: S.of(context).phoneNumber,
            ),
            enabled: false,
            style: kNormalStyle.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoWidget() {
    final visible = widget.provider.profileState is Loaded ||
        widget.provider.profileState is Idle;

    return Positioned(
      top: _photoSize / 2,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: CustomCard(
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(width: 1.5, color: Colors.white),
          backgroundColor: AppColors.backgroundLight,
          child: SizedBox(
            height: _photoSize,
            width: _photoSize,
            child: Visibility(
              visible: visible,
              child: FirebaseStorageImage(
                referenceUrl: widget.provider?.user?.photoURL,
                fallbackWidget: CircularProgressIndicator(),
                errorWidget: AppImages.defaultImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePhotoButton() {
    return Positioned(
      top: _photoSize / 2 + _photoSize - _changePhotoBtnSize / 2,
      left: 0.0,
      right: 0.0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CircularButton(
          size: _changePhotoBtnSize,
          color: Colors.red,
          child: Icon(
            MdiIcons.camera,
            size: 24,
            color: Colors.white,
          ),
          onPressed: () => ImageUtil.showPhotoDialog(
            context,
            (image) {
              if (image != null) widget.provider.photo = image;
            },
            loadingBuilder: () => widget.provider.profileState = Loading(),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    final provider = widget.provider;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: RoundedButton(
        color: AppColors.blueButton,
        style: kNormalStyle.copyWith(color: Colors.white),
        title: (provider.editMode ? S.of(context).confirm : S.of(context).edit)
            .toUpperCase(),
        onPressed: () => _sendData(context, provider),
      ),
    );
  }
}
