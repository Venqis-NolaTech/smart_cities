import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class HeaderReport extends StatelessWidget {
  final String numberStep;
  final String tittle;

  const HeaderReport({
    Key key,
    @required this.numberStep,
    @required this.tittle,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight*0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Spaces.horizontalMedium(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(numberStep, style: kMediumTitleStyle.copyWith(color: AppColors.blueLight, fontWeight: FontWeight.bold),),
          ),
          Spaces.horizontalSmall(),
          Flexible(child: Text(tittle, style: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
