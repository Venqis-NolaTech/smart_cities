import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';





class PaymentWidget extends StatelessWidget {
  final Function moveToPayment;

  const PaymentWidget({Key key, this.moveToPayment}) : super(key: key);


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
                      Flexible(
                        child: Text(
                          'Paga tu factura',
                          textAlign: TextAlign.justify,
                          style: kTitleStyle.copyWith(
                            color: AppColors.primaryTextLight,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Colabora con tu municipio',
                          style: kSmallTextStyle.copyWith(
                            color: AppColors.primaryTextLight,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: moveToPayment,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: AppColors.blueBtnRegister,
                    //color: report.follow ? AppColors.colorFollow : Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  child: Text(
                    S.of(context).connect,
                    textAlign: TextAlign.center,
                    style: kSmallTextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            )
            /*FlatButton(
              onPressed: () {},
              color: AppColors.blueBtnRegister,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: AppColors.blueBtnRegister)),
              child: Text(
                S.of(context).connect,
                style: kSmallTextStyle.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
