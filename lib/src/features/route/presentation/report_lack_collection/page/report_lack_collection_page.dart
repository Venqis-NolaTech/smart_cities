import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/select_sector/presentation/page/select_sector_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/header_route.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/bottom_navigation.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';

class ReportLackCollectionPage extends StatefulWidget {
  static const id = "report_lack_collection_page";

  ReportLackCollectionPage({Key key}) : super(key: key);

  @override
  _ReportLackCollectionPageState createState() => _ReportLackCollectionPageState();
}

class _ReportLackCollectionPageState extends State<ReportLackCollectionPage> {
  DateTime  selectedDate;
  CatalogItem  selectedSector;
  int _stepIndex = 0;


  String _dateTimeFormatted(BuildContext context, DateTime time) =>
      DateFormat('d MMMM y')
          .format(time.toLocal());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(S.of(context).notTakeOutTrash),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: HeaderRoute(tittle: S.of(context).reportSingle, widget: buildHeader(context),),
                  ),
                  Spaces.verticalLarge(),
                  _buildSelectSector(context),
                  Spaces.verticalMedium(),
                  Divider(),
                  Spaces.verticalLarge(),
                  _buildSelectDay(context),
                  Spaces.verticalMedium(),
                  Divider(),
                  //Spaces.verticalLarge(),
                  //btnSeeRoute(context)
                ],
              ),
            ),
          ),


          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomNavigationReport(
                textOnBack: S.of(context).cancel,
                textOnNext: (selectedDate!= null && selectedDate != null) ? S.of(context).send : '',
                onBack: ()=> Navigator.of(context).pop(), //boton cancelar
                onNext: ()=>onNext(),
              ),
            ],
          ),




        ],
      ),
    );
  }

  Widget _buildOptionSelect(){
    return Column(
      children: [
        _buildSelectSector(context),
        Spaces.verticalMedium(),
        Divider(),
        Spaces.verticalLarge(),
        _buildSelectDay(context),
        Spaces.verticalMedium(),
        Divider(),
      ],
    );
  }

  Widget buildHeader(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      Flexible(child: Text(S.of(context).reportDone, style: kNormalStyle.copyWith(color: AppColors.white),)),
      Spaces.verticalMedium(),
      Text(S.of(context).thankInfo, style: kTitleStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.bold))
    ],);

  }

  Widget _buildSelectSector(BuildContext context){
    return InkWell(
      onTap: ()async {

        setState(() {
          _stepIndex=1;
        });
        /*var result= await Navigator.pushNamed(context, SelectSectorPage.id);
        print('sector seleccionado $result');
        if(result!=null) {
          selectedSector = result;
          setState(() {

          });
        }*/
      },
      child: Row(
        children: [
          Icon(MdiIcons.mapMarkerOutline, color: AppColors.blueBtnRegister),
          Spaces.horizontalLarge(),
          Expanded(child: Text(selectedSector != null ?  selectedSector.value : S.of(context).selectSector, style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister))),
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
          Expanded(child: Text(selectedDate!= null ? _dateTimeFormatted(context, selectedDate) : S.of(context).selectDay, style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),)),
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
    if (picked != null && picked != selectedDate){
      setState(() {
        selectedDate= picked;
      });
    }

  }

  Widget btnSeeRoute(BuildContext context){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).send.toUpperCase(),
            style: kTitleStyle.copyWith(fontWeight: FontWeight.bold,  color: AppColors.white),
            onPressed: (){

            }
        )
    );
  }

  void showInfoDialog(
      String message, {
        String title,
        String confirmTitle,
        String cancelTitle,
        bool cancelAction = false,
        Function onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (context) => InfoAlertDialog(
        title: title ?? '',
        message: message,
        confirmTitle: confirmTitle,
        cancelTitle: cancelTitle,
        cancelAction: cancelAction,
        buttomStyle: TextStyle(color: AppColors.primaryTextLight),
        onConfirm: () {
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }

  void onNext() {
    print('on next');
    if(selectedDate!= null && selectedDate != null)
      showInfoDialog(
        S.of(context).reportSendMessage,
        title:  S.of(context).reportSend,
        confirmTitle: S.of(context).ok,
        cancelAction: false,
        onConfirm: () => Navigator.of(context).pop(),
      );
    else
      showInfoDialog(S.of(context).completeData);
  }
}
