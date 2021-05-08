import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import 'package:smart_cities/src/shared/app_colors.dart';

import '../../../../../../generated/i18n.dart';

class CrudSurveySettings extends StatefulWidget {
  const CrudSurveySettings({Key key}) : super(key: key);

  @override
  _CrudSurveySettingsState createState() => _CrudSurveySettingsState();
}

class _CrudSurveySettingsState extends State<CrudSurveySettings> {
  double _lowerValue = 50;
  double _upperValue = 180;



  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.of(context).settingsSurveys,
            textAlign: TextAlign.start,
            style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.bold)),

        Spaces.verticalSmall(),

        Text(S.of(context).surveysTime,
            textAlign: TextAlign.start,
            style: kTitleStyle.copyWith(
                color: AppColors.blueBtnRegister, fontWeight: FontWeight.bold)),


        Spaces.verticalSmall(),

        FlutterSlider(
          values: [300],
          max: 500,
          min: 0,
          onDragging: (handlerIndex, lowerValue, upperValue) {
            _lowerValue = lowerValue;
            _upperValue = upperValue;
            setState(() {});
          },
        )





      ],
    );
  }
}
