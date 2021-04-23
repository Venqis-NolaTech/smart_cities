import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/payment/widget/item_card.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import '../../../../../../app.dart';

class CreditCardList extends StatefulWidget {
  final List<dynamic> creditCardList;
  final AddAccountBankProvider provider;

  final Function addCard;
  final Function payment;


  CreditCardList({Key key, this.creditCardList, this.provider, this.addCard, this.payment}) : super(key: key);

  @override
  _CreditCardListState createState() => _CreditCardListState();
}

class _CreditCardListState extends State<CreditCardList> {
  int indexSlected=1;
  @override
  Widget build(BuildContext context) {



    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                _buildHeaderUser(),
                Container(
                  width: double.infinity,
                  color: AppColors.greyButtom.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(S.of(context).linkedCards.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: kTitleStyle),
                    )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: getList(widget.creditCardList),
                ),
                Spaces.verticalLarge(),

              ]
          ),
        ),


        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spaces.verticalSmall(),
            _buildButtomAddCard(context),
            Spaces.verticalMedium(),
            _buildButtomPayment(context)
          ],
        )
      ],
    );



  }

  Widget _buildButtomAddCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: RoundedButton(
          color: AppColors.white,
          borderColor: AppColors.blueButton,
          elevation: 0,
          title: S.of(context).addCard.toUpperCase(),
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.blueButton),
          onPressed: widget.addCard,
      ),
    );

  }

  Widget _buildButtomPayment(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: RoundedButton(
          color: AppColors.blueBtnRegister,
          //borderColor: AppColors.white,
          elevation: 0,
          title: S.of(context).toPay.toUpperCase(),
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white),
          onPressed: widget.payment
      ),
    );


  }


  Widget _buildHeader(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Row(
          children: [

            Icon(MdiIcons.informationOutline, color: AppColors.blueFacebook),
            Spaces.horizontalMedium(),
            Expanded(
              child: Text(
                S.of(context).messagePayment,
                textAlign: TextAlign.start,
                style: kNormalStyle.copyWith(color: AppColors.primaryText),
              ),
            ),

          ],
        ),
      ),
    );

  }

  Widget _buildHeaderUser(){
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
        isSelected: index== indexSlected,
        background: (index%2) != 0 ? AppColors.greyButtom.withOpacity(0.2) : Colors.white ,
        onTap: () => {} ,
      );
    });

  }
}
