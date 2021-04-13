import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/app.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/widget/credit_card_form.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class AddCreditCard extends StatelessWidget {
  final AddAccountBankProvider provider;
  final Function payment;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  const AddCreditCard({Key key, this.provider, this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(context),
          _buildCardAccunt(context),
          Spaces.verticalSmall(),
          buildCreditCardForm(provider, context),
          Spaces.verticalSmall(),
          _buildBottom(context),
          Spaces.verticalMedium(),
          _buildButtomPayment(context)


        ],
      ),
    );
  }


  Widget _buildHeader(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Row(
          children: [

            Icon(MdiIcons.informationOutline, color: AppColors.blueFacebook),
            Spaces.horizontalMedium(),
            Expanded(
              child: Text(
                S.of(context).messageAddCreditCard,
                textAlign: TextAlign.start,
                style: kNormalStyle.copyWith(color: AppColors.primaryText),
              ),
            ),

          ],
        ),
      ),
    );

  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, right: 20),
      child: Row(
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).saveCard,
                  style: kMediumTitleStyle.copyWith(color: AppColors.primaryText),
                ),

                Spaces.verticalSmall(),

                Text(
                  S.of(context).noteSaveCard,
                  textAlign: TextAlign.start,
                  style: kNormalStyle.copyWith(color: AppColors.primaryText),
                )
              ],
            ),
          ),
          Spaces.horizontalMedium(),
          Switch(
            onChanged: (bool value) {

            },
            value: true,
          )




        ],
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



  Widget _buildCardAccunt(BuildContext context) {
    return Container(
      color: AppColors.greyButtom.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Row(
          children: [

            Expanded(
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

            Text('\$ 1,314', style: kBigTitleStyle.copyWith(color: AppColors.black),),



          ],
        ),
      ),
    );

  }



  Widget buildCreditCardForm(AddAccountBankProvider provider, BuildContext context) {
    return CreditCardForm(
      formKey: _formKey,
      obscureCvv: true,
      obscureNumber: false,
      cardNumber: provider.cardNumber,
      cvvCode: provider.cvvCode,
      cardHolderName: provider.cardHolderName,
      expiryDate: provider.expiryDate,
      themeColor: Colors.blue,
      cardNumberDecoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintText: S.of(context).numberCard,
      ),
      expiryDateDecoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintText: S.of(context).expirationDate,
      ),
      cvvCodeDecoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintText: S.of(context).cvv,
      ),
      cardHolderDecoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onCreditCardModelChange: (creditCardModel) => {},
    );

  }

}
