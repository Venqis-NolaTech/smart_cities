import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/payments/presentation/multiple_payments/page/multiple_payments_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class ItemPayment extends StatelessWidget {
  final Payment payment;
  final Function onTap;

  const ItemPayment({Key key, this.payment, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16, left: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(payment.id, style: kMediumTitleStyle.copyWith(color: AppColors.primaryTextLight)),
                    Spaces.verticalSmall(),
                    Text(payment.card, style: kNormalStyle),
                  ],
                ),
              ),

              Text('\$${payment.total}', style: kBigTitleStyle.copyWith(color: AppColors.primaryTextLight),),
              Spaces.horizontalSmall(),
              Checkbox(
                value: payment.selected,
                onChanged: (value){},
              )


            ],
          ),
        ),
      ),
    );
  }
}
