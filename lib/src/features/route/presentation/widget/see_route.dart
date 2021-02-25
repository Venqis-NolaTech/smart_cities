import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import '../../../../shared/app_colors.dart';



class SeeRoute extends StatelessWidget {
  const SeeRoute({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spaces.verticalLarge(),
            //AppImages.iconCamion,
            Spaces.verticalLarge(),
            Text(S.of(context).seeRoutes, style: kTitleStyle.copyWith(fontWeight: FontWeight.bold, color: AppColors.blueBtnRegister)), 
            Spaces.verticalLarge(),
            Text(S.of(context).selectSectorMessage, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister)), 
            Spaces.verticalLarge(),
            _buildSelectSector(context),
            Spaces.verticalMedium(),
            Divider(),
            Spaces.verticalMedium(),
            _buildSelectDay(context),
            Spaces.verticalMedium(),
            Divider(),
            


          ],
        ),
      ),
    );
  }

  Widget _buildSelectSector(BuildContext context){
    return InkWell(
      onTap: null,
      child: Row(
        children: [
          Icon(MdiIcons.mapMarkerOutline, color: AppColors.blueBtnRegister),
          Spaces.horizontalLarge(),
          Expanded(child: Text(S.of(context).selectSector, style: kMediumTitleStyle.copyWith(color: AppColors.blueBtnRegister))),
          Icon(MdiIcons.chevronRight, color: AppColors.blueBtnRegister)
        ],
      ),
    );
  }

  Widget _buildSelectDay(BuildContext context){
    return InkWell(
      onTap: null,
      child: Row(
        children: [
          Icon(MdiIcons.cameraEnhanceOutline, color: AppColors.blueBtnRegister),
          Spaces.horizontalLarge(),
          Expanded(child: Text(S.of(context).selectDay, style: kMediumTitleStyle.copyWith(color: AppColors.blueBtnRegister),)),
          Icon(MdiIcons.chevronRight, color: AppColors.blueBtnRegister)
        ],
      ),
    );
  }


}