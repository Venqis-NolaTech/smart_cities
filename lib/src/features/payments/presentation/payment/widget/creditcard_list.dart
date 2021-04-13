import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/widget/item_card.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../../../../../../app.dart';

class CreditCardList extends StatelessWidget {
  final List<dynamic> creditCardList;
  final AddAccountBankProvider provider;

  final Function addCard;
  final Function payment;

  const CreditCardList({Key key, this.creditCardList, this.provider, this.addCard, this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    return SingleChildScrollView(
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Text(S.of(context).linkedCards.toUpperCase(), style: kTitleStyle),
            Spaces.verticalMedium(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: getList(creditCardList),
            ),
            Spaces.verticalMedium(),
            _buildButtomAddCard(context),
            Spaces.verticalMedium(),
            _buildButtomPayment(context)
          ]
      ),
    );;



  }

  Widget _buildButtomAddCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: RoundedButton(
          color: AppColors.white,
          borderColor: AppColors.blueBtnRegister,
          elevation: 0,
          title: S.of(context).addCard.toUpperCase(),
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.blueBtnRegister),
          onPressed: addCard
      ),
    );

  }

  Widget _buildButtomPayment(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: RoundedButton(
          color: AppColors.blueBtnRegister,
          borderColor: AppColors.white,
          elevation: 0,
          title: S.of(context).payment.toUpperCase(),
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white),
          onPressed: payment
      ),
    );


  }


  Widget _buildHeader(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currentUser.nickName, style: kMediumTitleStyle.copyWith(color: AppColors.black, fontWeight:FontWeight.bold )),
            Spaces.verticalSmall(),
            Text('ID 12143124234', style: kNormalStyle),
          ],
        ),
      ),
    );
  }

  List<Widget> getList(List<dynamic> list){
    return List<Widget>.generate(list.length, (index) {
      return ItemCreditCard(
        background: (index%2) != 0 ? Colors.white : AppColors.greyButtom.withOpacity(0.2),
        onTap: () => {} ,
      );
    });

  }
}
