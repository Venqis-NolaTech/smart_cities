import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';





class PaymentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          children: [

            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.blueLight
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: AppImages.iconPayFact,
              ),
            ),
            Spaces.horizontalSmall(),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Paga tu factura',
                        textAlign: TextAlign.justify,
                        style: kMediumTitleStyle.copyWith(
                          color: AppColors.primaryTextLight,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Colabora con tu municipio',
                        style: kNormalStyle.copyWith(
                          color: AppColors.primaryTextLight,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () {},
              color: AppColors.blueBtnRegister,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: AppColors.blueBtnRegister)),
              child: Text(
                S.of(context).connect,
                style: kNormalStyle.copyWith(
                  color: AppColors.white,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
