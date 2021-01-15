import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../shared/app_colors.dart';
import '../../../../shared/constant.dart';
import '../../../../shared/spaces.dart';

class StepView extends StatelessWidget {
  final Image image;
  final Image icon;
  final String text;
  final String tittle;

  const StepView(
      {Key key,
      @required this.image,
      this.icon,
      @required this.text,
      this.tittle})
      : assert(image != null),
        assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      child: Stack(
        children: [
          /*Positioned(
            right: -size.width*0.2,
            top: -size.width*0.4,

            child: AppImages.step1,
          ),

          Positioned(
            right: -size.width*0.7,
            top: -size.width*0.7,
            child: Circle(
                radius: size.width*0.9,
                color: AppColors.blueDark.withOpacity(0.82)
            ),
          ),
          */

          /*Positioned(
            right: -size.width*0.45,
            top: -size.height*0.2,
            child: AppImages.ellipseOpacity,
          ),*/
          Container(width: double.infinity, child: image),
          icon != null
              ? Positioned(
                  right: 0,
                  left: 0,
                  top: size.height * 0.20,
                  child: icon,
                )
              : Container(),
          Positioned(
            right: 0,
            left: 0,
            top: size.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  tittle != null
                      ? Text(
                          tittle,
                          style: kMediumTitleStyle.copyWith(
                              color: AppColors.testTittleIntro,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold),
                        )
                      : Container(),
                  Spaces.verticalLarge(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      text,
                      style: kTitleStyle.copyWith(
                          color: AppColors.testIntro,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
