import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class AccountItem extends StatelessWidget {
  final Account account;
  final Function onTap;
  final bool topAndBottomPaddingEnabled;
  final bool isFirst;
  final bool isLast;




  AccountItem({Key key, this.account, this.onTap, this.topAndBottomPaddingEnabled, this.isFirst, this.isLast}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderRadius: BorderRadius.circular(4.0),
      margin: EdgeInsets.only(
        top: isFirst && topAndBottomPaddingEnabled
            ? 70.0
            : isFirst && !topAndBottomPaddingEnabled
            ? 16.0
            : 0.0,
        bottom: isLast && topAndBottomPaddingEnabled ? 86.0 : 16.0,
        left: 16.0,
        right: 16.0,
      ),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(account.accountOwner, style: kTitleStyle.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.bold),
                textAlign: TextAlign.left),
            Spaces.verticalMedium(),
            Row(
              children: [
                Expanded(
                    child: Text(S.of(context).codeOfSystem,
                        style: kNormalStyle)),
                Text(account.systemCode, style: kNormalStyle)
              ],
            ),
            Spaces.verticalSmall(),
            Row(
              children: [
                Expanded(
                    child: Text(S.of(context).typeAccount, style: kNormalStyle)),
                Text(account.accountType, style: kNormalStyle)
              ],
            ),

            Spaces.verticalSmall(),
          ],
        ),
      ),



    );
  }
}
