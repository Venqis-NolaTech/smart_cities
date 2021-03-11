import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/route/presentation/see_route/provider/route_provider.dart';
import 'package:smart_cities/src/features/select_sector/presentation/page/select_sector_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';


class LocationSeeRoute extends StatelessWidget {
  final RouteProvider provider;
  final Function onSeeRoute;
  const LocationSeeRoute({Key key, @required this.provider, @required this.onSeeRoute}) : super(key: key);


  String _dateTimeFormatted(BuildContext context, DateTime time) =>
      DateFormat('d MMMM y')
          .format(time.toLocal());


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spaces.verticalLarge(),
            AppImages.camionIcon,
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
            Spaces.verticalMedium(),
            btnSeeRoute(context)

          ],
        ),
      ),
    );
  }

  Widget _buildSelectSector(BuildContext context){
    return InkWell(
      onTap: ()async {
        var result= await Navigator.pushNamed(context, SelectSectorPage.id);
        print('sector seleccionado $result');
        if(result!=null)
          provider.selectedSector= result;
      },
      child: Row(
        children: [
          Icon(MdiIcons.mapMarkerOutline, color: AppColors.blueBtnRegister),
          Spaces.horizontalLarge(),
          Expanded(child: Text(provider.selectedSector != null ?  provider.selectedSector.value : S.of(context).selectSector, style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister))),
          Icon(MdiIcons.chevronRight, color: AppColors.blueBtnRegister)
        ],
      ),
    );
  }

  Widget _buildSelectDay(BuildContext context){
    return InkWell(
      onTap: ()=> _selectDate(context),
      child: Row(
        children: [
          Icon(MdiIcons.cameraEnhanceOutline, color: AppColors.blueBtnRegister),
          Spaces.horizontalLarge(),
          Expanded(child: Text(provider.selectedDate!= null ? _dateTimeFormatted(context, provider.selectedDate) : S.of(context).selectDay, style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),)),
          Icon(MdiIcons.chevronRight, color: AppColors.blueBtnRegister)
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != provider.selectedDate)
      provider.selectedDate= picked;

  }

  Widget btnSeeRoute(BuildContext context){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).routeSee.toUpperCase(),
            style: kTitleStyle.copyWith(fontWeight: FontWeight.bold,  color: AppColors.white),
            onPressed: (){
              if(provider.validate())
                onSeeRoute();
              else
                showInfoDialog(S.of(context).completeData, context);
            }
        )
    );
  }

}
