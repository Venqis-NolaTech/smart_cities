import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/pages/selected_neighborhood_page.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/pages/selected_sector_page.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/header_report.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class LocationReport extends StatelessWidget {
  final CreateReportProvider provider;

  LocationReport({Key key, this.provider}) : super(key: key);

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderReport( numberStep: '', tittle: S.of(context).completeData),

        _buildForm(context)

      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Form(
        key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Text(S.of(context).nameStreet, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister)),
                ],
              ),
              TextFormField(
                onChanged: (value){
                  provider.nameStreet= value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: S.of(context).nameStreet,
                  hintStyle: TextStyle(color: AppColors.greyButtom.withOpacity(0.7))
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value) {

                },
                style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
              ),
              Divider(),
              //Spaces.verticalMedium(),
              Row(
                children: [
                  Text(S.of(context).numberStreet, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister)),
                ],
              ),
              TextFormField(
                onChanged: (value){
                  provider.numberStreet= value;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: S.of(context).numberStreet,
                  hintStyle: TextStyle(color: AppColors.greyButtom.withOpacity(0.7))
                ),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                },
                style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
              ),
              Divider(),
              //Spaces.verticalMedium(),

              InkWell(
                onTap: ()=> Navigator.pushNamed(
                  context,
                  SelectedSectorPage.id,
                  arguments: provider,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      provider.selectedSector != null
                          ? provider.selectedSector.value
                          : S.of(context).sector,
                      style: kTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister),
                    )),
                    Icon(Icons.keyboard_arrow_right)
                  ]),
                ),
              ),
              Divider(),
              Spaces.verticalMedium(),
              InkWell(
                onTap: () async {

                  if(provider.selectedSector==null){
                    showInfo(context);
                    return;
                  }

                  await provider.getNeighborhood();

                  if(provider.allNeighborhood.isNotEmpty){
                    Navigator.pushNamed(
                      context,
                      SelectedNeighborhoodPage.id,
                      arguments: provider,
                    );
                  }

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      provider.selectedNeighborhood != null
                          ? provider.selectedNeighborhood.value
                          : S.of(context).neighborhood,
                      style: kTitleStyle.copyWith(
                          color: AppColors.blueBtnRegister),
                    )),
                    Icon(Icons.keyboard_arrow_right)
                  ]),
                ),
              ),
              Divider(),




            ],
          )
      ),
    );
  }


  void showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => InfoAlertDialog(
        message: S.of(context).sectorValid,
        cancelAction: false,
        onConfirm: () => {}//Navigator.of(context).pop(),
      ),
    );
  }
}
