import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:smart_cities/src/features/surveys/presentation/crud/providers/crud_survey_provider.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import 'package:smart_cities/src/shared/app_colors.dart';

import '../../../../../../generated/i18n.dart';

class CrudSurveySettings extends StatefulWidget {
  final CrudSurveyProvider provider;

  CrudSurveySettings({Key key, this.provider}) : super(key: key);

  @override
  _CrudSurveySettingsState createState() => _CrudSurveySettingsState();
}

class _CrudSurveySettingsState extends State<CrudSurveySettings> {
  double _lowerValue = 3;

  bool isHideParticipantData = false;
  bool isOtherShare = false;
  @override
  void initState() {
    isHideParticipantData = widget.provider.survey.isHideParticipantData;
    isOtherShare = widget.provider.survey.isOtherShare;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildContentDialog(),
              ),
            ),
            Divider(
              height: 0.5,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: _buildBottomDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.background),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          )),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(Icons.tune, color: AppColors.blueBtnRegister),
          Spaces.horizontalSmall(),
          Expanded(
            child: Text(S.of(context).settingsSurveys,
                textAlign: TextAlign.start,
                style: kTitleStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String getTextSlider(String value) {
    switch (value) {
      case '1.0':
        return '3 h';
      case '2.0':
        return '6 h';
      case '3.0':
        return '1 d';
      case '5.0':
        return '2 d';
      default:
        return value;
    }
  }

  List<Widget> _buildContentDialog() {
    final widgets = <Widget>[];

    widgets.add(Text(S.of(context).surveysTime,
        textAlign: TextAlign.start,
        style: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister)));

    widgets.add(FlutterSlider(
      values: [_lowerValue],
      max: 4,
      min: 1,
      handler: FlutterSliderHandler(
        decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.background),
            borderRadius: BorderRadius.circular(8.0)),
        child: Container(
            padding: EdgeInsets.all(5),
            child: Text(
              getTextSlider(_lowerValue.toString()),
              style:
                  kSmallestTextStyle.copyWith(color: AppColors.blueBtnRegister),
            )),
      ),
      tooltip: FlutterSliderTooltip(format: (String value) => getTextSlider(value)),
      step: FlutterSliderStep(step: 1, // default
          rangeList: [
            FlutterSliderRangeStep(from: 1, to: 2, step: 1),
            FlutterSliderRangeStep(from: 2, to: 3, step: 2),
            FlutterSliderRangeStep(from: 3, to: 4, step: 3),
          ]),
      onDragging: (handlerIndex, lowerValue, upperValue) {
        _lowerValue = lowerValue;
        //_upperValue = upperValue;
        setState(() {});
      },
    ));

    widgets.addAll([
      Divider(),
      Row(
        children: [
          Expanded(
            child: Text(S.of(context).hideMainData,
                textAlign: TextAlign.start,
                style:
                    kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister)),
          ),
          Switch(
              onChanged: (bool value) {
                isHideParticipantData = value;
                setState(() {});
              },
              value: isHideParticipantData)
        ],
      )
    ]);

    widgets.addAll([
      Divider(),
      Row(
        children: [
          Expanded(
            child: Text(S.of(context).shareSurveys,
                textAlign: TextAlign.start,
                style:
                    kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister)),
          ),
          Switch(
            onChanged: (bool value) {
              isOtherShare = value;
              setState(() {});
            },
            value: isOtherShare,
          )
        ],
      )
    ]);

    return widgets;
  }

  Widget _buildBottomDialog(BuildContext context) {
    final actions = <Widget>[];

    actions.add(
      FlatButton(
        child: Text(S.of(context).cancel),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    actions.add(
      FlatButton(
        child: Text(S.of(context).done,
            style: TextStyle(color: AppColors.blueLight)),
        onPressed: () {
          widget.provider.survey.isHideParticipantData = isHideParticipantData;
          widget.provider.survey.isOtherShare = isOtherShare;
          Navigator.pop(context);
        },
      ),
    );

    return Row(
      mainAxisAlignment: actions.length > 1
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceAround,
      children: actions,
    );
  }
}
