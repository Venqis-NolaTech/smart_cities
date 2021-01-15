import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class HeaderSearch extends StatelessWidget {


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
          Flexible(child: Text(S.of(context).search, style: kSmallTextStyle.copyWith(color: AppColors.blueBtnRegister, fontWeight: FontWeight.w500))),

        ],
      ),
    );
  }
}
