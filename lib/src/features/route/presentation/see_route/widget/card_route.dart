import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';



class CardOptionRoute extends StatelessWidget {
  final Function onChange;
  final DateTime selectedDate;
  final CatalogItem selectedSector;
  final String textButtom;
  bool isMunicipality;

  CardOptionRoute({Key key, this.isMunicipality, @required this.selectedSector,  @required this.selectedDate, @required this.onChange, this.textButtom}) : super(key: key);

  String _dateTimeFormatted(DateTime time) =>
      DateFormat('d MMMM y')
          .format(time.toLocal());


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 15, bottom: 15),
          child: isMunicipality ? _buildMunicipality(context)
          : _buildSector(context)
        ),
      ),
    );
  }
  Widget _buildSector(BuildContext context){

    print('ancho  '+MediaQuery.of(context).size.width.toString());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(MdiIcons.mapMarker, color: AppColors.blueBtnRegister.withOpacity(0.7),),
        Spaces.horizontalSmall(),
        Expanded(
          child: Wrap(
            direction: MediaQuery.of(context).size.width > 320 ? Axis.horizontal : Axis.vertical,
            spacing: 10.0,
            alignment: WrapAlignment.center,
            //runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(selectedSector!=null ? selectedSector.value : '',
                      style: kTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister)),
                  Spaces.verticalSmall(),

                  buildSchedule(context)


                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: btnIniciar(context),
              )

            ] ,
          ),
        ),


      ],
    );
  }
  Widget _buildMunicipality(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildSector(),
        Spaces.verticalSmall(),
        Row(
          children: [
            Expanded(child: btnIniciar(context)),
          ],
        )
      ],
    );
  }


  Widget btnIniciar(BuildContext context){
    return InkWell(
      onTap: onChange,
      child: Container(
        width: MediaQuery.of(context).size.width*0.5,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.blueBtnRegister),
            borderRadius: BorderRadius.circular(25),
            color: AppColors.blueBtnRegister
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          child: Text(
            isMunicipality ? S.of(context).selectSector : textButtom,//
            textAlign: TextAlign.center,
            style: kNormalStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildSchedule(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).dayRoute,
          style: kNormalStyle.copyWith(
              color: AppColors.blueBtnRegister.withOpacity(0.5)),
        ),
        Spaces.verticalSmallest(),
        Text(_dateTimeFormatted(selectedDate ?? DateTime.now()),
          style: kNormalStyle.copyWith(
            color: AppColors.blueBtnRegister),)
      ],
    );
  }

  Widget buildSector() {
    return Row(
      children: [
        Icon(MdiIcons.mapMarker, color: AppColors.blueBtnRegister.withOpacity(0.7),),
        Spaces.horizontalSmall(),
        Expanded(
            child: Text(selectedSector!=null ? selectedSector.value : '',
                style: kTitleStyle.copyWith(
                    color: AppColors.blueBtnRegister))),
        //IconButton(icon: Icon(MdiIcons.dotsHorizontal), onPressed: null)
      ],
    );
  }
}
