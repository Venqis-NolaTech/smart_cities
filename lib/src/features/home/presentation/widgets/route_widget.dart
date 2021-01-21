import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class RouteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Image.asset(AppImagePaths.iconRoute),
                  Spaces.horizontalSmall(),
                  Text(
                    'Recogida',
                    textAlign: TextAlign.center,
                    style: kMediumTitleStyle.copyWith(
                      color: AppColors.blueBtnRegister,
                      fontFamily: 'Roboto',
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
                      'Completa el perfil con sector y conoce cuando sacar la basura',
                      textAlign: TextAlign.center,
                      style: kNormalStyle.copyWith(
                        color: AppColors.blueBtnRegister,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),


              Spaces.verticalMedium(),

              Visibility(
                visible: false,
                child: Row(
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
              ),

              Spaces.verticalMedium(),

              FlatButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColors.blueLight)),
                child: Text(
                  'Agregar Sector',
                  maxLines: 1,
                  style: kSmallestTextStyle.copyWith(
                    color: AppColors.blueLight,
                    fontFamily: 'Roboto',
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
