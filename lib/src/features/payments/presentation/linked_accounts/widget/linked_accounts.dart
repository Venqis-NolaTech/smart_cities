import 'package:flutter/material.dart';

import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class LinkedAccount extends StatelessWidget {
  final bool linkedAccount;

  const LinkedAccount({Key key, this.linkedAccount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.greyButtom,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Spaces.verticalLarge(),
            Text('0', style: kMenuBigTitleStyle.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),),
            Spaces.verticalMedium(),
            Text(S.of(context).linkedAccounts, style: kNormalStyle.copyWith(color: AppColors.white),),
            Spaces.verticalMedium(),

            !linkedAccount ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).nextPayment, style: kNormalStyle.copyWith(color: AppColors.white),),
                Spaces.horizontalLarge(),
                Text('00.00.0000', style: kNormalStyle.copyWith(color: AppColors.white),),
              ],
            ) : _buildButtomStart(context),

            Spaces.verticalLarge(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtomStart(BuildContext context) {
    return RoundedButton(
        color: Colors.transparent,
        borderColor: AppColors.white,
        title: S.of(context).multiplePayments.toUpperCase(),
        style: kNormalStyle.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.white),
        onPressed: null
    ) ;
  }

}


