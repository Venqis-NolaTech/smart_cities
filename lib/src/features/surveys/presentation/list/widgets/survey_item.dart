import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../../app.dart';
import '../../../../../../generated/i18n.dart';
import '../../../../../shared/app_colors.dart';
import '../../../../../shared/constant.dart';
import '../../../../channels/domain/entities/channel.dart';
import '../../../domain/entities/survey.dart';

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
    @required this.permission,
    @required this.survey,
    this.onPressed,
    this.onOptionMenuSelected,
    this.isFirst = false,
  }) : super(key: key);

  final ChannelPermission permission;
  final Survey survey;
  final bool isFirst;

  final Function onPressed;
  final Function(SurveyMenuOption) onOptionMenuSelected;

  @override
  Widget build(BuildContext context) {
    final allowActions = (permission?.createPoll ?? false) &&
        survey.createdBy.id == currentUser.id;

    return Material(
      color: survey.public ? Colors.white : AppColors.backgroundLight,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: _buildContent(context)),
            allowActions ? _buildPopupMenuButton(context) : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      title: Text(
        survey?.name ?? "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: kTitleStyle.copyWith(
          color: AppColors.primaryTextDark,
        ),
      ),
      subtitle: Text(
        survey?.description,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: kSmallestTextStyle.copyWith(
          color: AppColors.primaryTextLight,
        ),
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
}
