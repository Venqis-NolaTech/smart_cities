import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';

import '../../../../../../app.dart';
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
    this.isLast = false,
    this.allowActions = false,
    this.topAndBottomPaddingEnabled = false,
  }) : super(key: key);

  final Survey survey;
  final bool isFirst;
  final bool topAndBottomPaddingEnabled;
  final bool isLast;
  final bool allowActions;
  final Function onPressed;
  final Function(SurveyMenuOption) onOptionMenuSelected;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      margin: EdgeInsets.only(
        top: 16.0,
        bottom: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _buildContent(context)),
                _buildPopupMenuButton(context),
              ],
            )),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserDisplay(context),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: Text(
              survey?.name ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: kMediumTitleStyle.copyWith(
                color: AppColors.blueButton,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
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

          //Spaces.verticalSmall(),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildButtomSee(context),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtomSee(BuildContext context) {
    return FlatButton(
        onPressed: onPressed,
        child: Text(
          S.of(context).seeSurvey.toUpperCase(),
          style: kNormalStyle.copyWith(
            color: AppColors.blueBtnRegister,
            fontWeight: FontWeight.bold,
          ),
        ));
    /*return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: RoundedButton(
          color: AppColors.blueBtnRegister,
          borderColor: AppColors.white,
          elevation: 0,
          title: S.of(context).seeSurvey.toUpperCase(),
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white),
          onPressed: onPressed
      ),
    );*/
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

    if (survey.isOtherShare){
      if(survey.createdBy.id==currentUser.id)
        entry.addAll([
          shareOption,
          //disableOption,
          deleteOption
        ]);
      else
        entry.addAll([shareOption]);
    }else
        if (survey.createdBy.id==currentUser.id)
          entry.addAll([deleteOption]);
         

    /*if (survey.public) {
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
    }*/

    if(entry.isEmpty)
      return Container();


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
    print('fecha de expiracion ${survey.name}  ${survey.expirationDate}');
    //var diferencia= DateTime.now().difference(DateTime.parse(survey.expirationDate)).inHours;
    var diferencia = DateTime.parse(survey.expirationDate)
        .difference(DateTime.now())
        .inHours;
    print('diferencia en horas ${survey.name}  ${diferencia}');

    return Container(
      //padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          survey.isHideParticipantData
              ? Container(
                  width: 20,
                  height: 40,
                )
              : _buildProfile(survey.createdBy),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  survey.isHideParticipantData
                      ? S.of(context).anonymous
                      : '${survey.createdBy?.displayName ?? ''}',
                  style: kSmallTextStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  diferencia < 0
                      ? S.of(context).finished
                      : S.of(context).finishedIn(diferencia.toInt()),
                  style: kSmallTextStyle.copyWith(
                    color:
                        diferencia < 0 ? AppColors.red : AppColors.blueButton,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
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
