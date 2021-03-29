import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/route/presentation/rate_service/widget/item_rate.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/bottom_navigation.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';

import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/constant.dart';

class RateServicePage extends StatefulWidget {
  static const id = "rate_service_page";

  @override
  _RateServicePageState createState() => _RateServicePageState();
}

class _RateServicePageState extends State<RateServicePage> {
  int ranting=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(S.of(context).rateService),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                children: [
                  Spaces.verticalMedium(),
                  AppImages.iconStar,
                  Spaces.verticalMedium(),
                  Text(
                    S.of(context).rateServiceSector,
                    style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
                  ),
                  Spaces.verticalMedium(),
                  Text(
                    S.of(context).rateServiceMessage,
                    style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
                  ),
                  Spaces.verticalMedium(),
                  ItemRate(title: S.of(context).veryGood, selected: ranting==5, onSelect: (){
                    setState(() {
                      ranting=5;
                    });
                  },),
                  Spaces.verticalMedium(),
                  ItemRate(title: S.of(context).good, selected: ranting==4, onSelect: (){
                    setState(() {
                      ranting=4;
                    });
                  },),

                  Spaces.verticalMedium(),
                  ItemRate(title: S.of(context).regular, selected: ranting==3, onSelect: (){
                    setState(() {
                      ranting=3;
                    });
                  },),


                  Spaces.verticalMedium(),
                  ItemRate(title: S.of(context).bad, selected: ranting==2, onSelect: (){
                    setState(() {
                      ranting=2;
                    });
                  },),

                  Spaces.verticalMedium(),
                  ItemRate(title: S.of(context).veryBad, selected: ranting==1, onSelect: (){
                    setState(() {
                      ranting=1;
                    });
                  },),
                ],
              ),
            ),
          ),



          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomNavigationReport(
                textOnBack: S.of(context).cancel,
                textOnNext: S.of(context).send,
                onBack: ()=> Navigator.of(context).pop(), //boton cancelar
                onNext: ()=> onNext(),
              ),
            ],
          ),




        ],
      ),
    );
  }

  void onNext() {
    var title=S.of(context).titleOkRate;
    var message=  S.of(context).reportSendMessage;
    var isError= false;

    if( ranting==0){
      title= S.of(context).error;
      message= S.of(context).selectRateInvalid;
      isError= true;
    }

    showInfoDialog(
      message,
      title:  title,
      confirmTitle: S.of(context).ok,
      cancelAction: false,
      onConfirm: (){
        if(!isError)
          Navigator.of(context).pop();
      },
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

}
