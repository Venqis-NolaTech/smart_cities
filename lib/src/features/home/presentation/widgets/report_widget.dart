import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';



class ReportWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //width: screenWidth*0.40,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Image.asset(AppImagePaths.iconReport),
                  Spaces.horizontalSmall(),
                  Text(
                    S.of(context).report,
                    textAlign: TextAlign.center,
                    style: kMediumTitleStyle.copyWith(
                      color: AppColors.blueBtnRegister,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Spaces.verticalMedium(),

              Row(
                children: [
                  Flexible(
                    child: Text(
                      '¿Has notado incidencia en tu sector?',
                      textAlign: TextAlign.center,
                      style: kNormalStyle.copyWith(
                        color: AppColors.blueBtnRegister,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),


              Spaces.verticalMedium(),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '¡Déjanos saber!',
                    textAlign: TextAlign.center,
                    style: kNormalStyle.copyWith(
                      color: AppColors.blueBtnRegister,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              Spaces.verticalMedium(),

              FlatButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColors.blueLight)),
                child: Text(
                  S.of(context).newReport,
                  maxLines: 1,
                  style: kSmallestTextStyle.copyWith(
                    color: AppColors.blueLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );


  }
}
