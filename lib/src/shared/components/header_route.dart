import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/app_images.dart';


class HeaderRoute extends StatelessWidget {
  final Widget widget;
  final String tittle;

  HeaderRoute({Key key, this.widget, this.tittle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.blueBtnRegister,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 25.00, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tittle, style: kMediumTitleStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  Spaces.verticalLarge(),
                  widget,
                ],
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              child: AppImages.iconTrash,
            )


          ],
        ),
      ),
    );
  }
}
