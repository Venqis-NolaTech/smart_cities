import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class BottomNavigationReport extends StatelessWidget {
  final String textOnBack;
  final String textOnNext;
  final Function onNext;
  final Function onBack;

  const BottomNavigationReport({Key key, this.textOnBack, this.textOnNext, this.onNext, this.onBack}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final screenHeight= MediaQuery.of(context).size.height;

    return Container(
      color: AppColors.blueBtnRegister,
//      height: screenHeight*0.06,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spaces.horizontalSmall(),
          InkWell(
            onTap: onBack,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(textOnBack ?? S.of(context).back.toUpperCase(), style: kNormalStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
            ),
          ),
          Expanded(child: Spaces.horizontalSmall(),),
          InkWell(
            onTap: onNext,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(textOnNext ?? S.of(context).nextPage.toUpperCase(), style: kNormalStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.w500)),
            ),
          ),
          Spaces.horizontalSmall()
        ],
      ),);
  }
}
