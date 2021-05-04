import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/constant.dart';
import '../../../domain/entities/survey.dart';
import '../../../domain/entities/user_display.dart';


enum SurveyMenuOption {
  publish,
  edit,
  share,
  disable,
  delete,
}

class SurveyItem extends StatelessWidget {
  const SurveyItem({
    Key key,
    @required this.survey,
    this.onPressed,
    this.onOptionMenuSelected,
    this.isFirst = false,
  }) : super(key: key);

  final Survey survey;
  final bool isFirst;

  final Function onPressed;
  final Function(SurveyMenuOption) onOptionMenuSelected;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Material(
        color: survey.public ? Colors.white : AppColors.backgroundLight,
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: _buildContent(context)),
              //allowActions ? _buildPopupMenuButton(context) : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserDisplay(context),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              survey?.name ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: kMediumTitleStyle.copyWith(
                color: AppColors.blueBtnRegister,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              survey?.description ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: kTitleStyle.copyWith(
                color: AppColors.blueBtnRegister,
              ),
            ),
          ),


          //_buildButtomSee(context)

        ],
      ),
      /*subtitle: Text(
        survey?.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: kSmallestTextStyle.copyWith(
          color: AppColors.primaryTextLight,
        ),
      ),*/
    );
  }

  Widget _buildButtomSee(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: RoundedButton(
          color: AppColors.greyButtom.withOpacity(0.2),
          borderColor: AppColors.white,
          elevation: 0,
          title: S.of(context).seeSurvey.toUpperCase(),
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white),
          onPressed: onPressed
      ),
    );


  }

  Widget _buildPopupMenuButton(BuildContext context) {
    final entry = List<PopupMenuEntry<SurveyMenuOption>>();

    final publishOption = PopupMenuItem(
      value: SurveyMenuOption.publish,
      child: Text(S.of(context).publish),
    );

    final editOption = PopupMenuItem(
      value: SurveyMenuOption.edit,
      child: Text(S.of(context).edit),
    );

    final shareOption = PopupMenuItem(
      value: SurveyMenuOption.share,
      child: Text(S.of(context).share),
    );

    final disableOption = PopupMenuItem(
      value: SurveyMenuOption.disable,
      child: Text(S.of(context).disable),
    );

    final deleteOption = PopupMenuItem(
      value: SurveyMenuOption.delete,
      child: Text(S.of(context).delete),
    );

    if (survey.public) {
      entry.addAll([
        publishOption,
        shareOption,
        disableOption,
      ]);
    } else {
      entry.addAll([
        publishOption,
        editOption,
        deleteOption,
      ]);
    }

    return PopupMenuButton(
      icon: Icon(
        MdiIcons.dotsHorizontal,
        color: Colors.black,
      ),
      onSelected: onOptionMenuSelected,
      itemBuilder: (context) {
        return entry;
      },
    );
  }

  Widget _buildUserDisplay(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildProfile(survey.createdBy),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${survey.createdBy?.displayName ?? ''}',
              style: kSmallTextStyle.copyWith(
                color: AppColors.blueBtnRegister,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Termina en 2h',
                style: kSmallTextStyle.copyWith(
                  color: AppColors.blueFacebook,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildProfile(UserDisplay user) {

    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(8.0),
      child: ClipOval(
        child: Visibility(
          visible: true,
          child: FirebaseStorageImage(
            referenceUrl: user?.photoUrl,
            fallbackWidget: CircularProgressIndicator(),
            errorWidget: AppImages.defaultImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

  }

}
