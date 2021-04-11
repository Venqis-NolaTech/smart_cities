import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/widget/credit_card_form.dart';
import 'package:smart_cities/src/features/payments/presentation/add_creditcard/widget/item_card.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/spaces.dart';



class AddCreditCardPage extends StatelessWidget {
  static const id = "add_creditcard_page";
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static dynamic pushNavigate(
      BuildContext context, {
        bool replace = false,
      }) {
    if (replace) {
      return Navigator.pushNamedAndRemoveUntil(
        context,
        id,
            (route) => false,
        //arguments: args,
      );
    } else {
      return Navigator.pushNamed(context, id); //arguments: args);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AddAccountBankProvider>(
        onProviderReady: (provider) => provider.loadData(),
        builder: (context, provider, child) {

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.red,
              title: Text(S.of(context).card),
              centerTitle: true,
            ),

            body: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context),
                    _buildCardAccunt(context),
                    Spaces.verticalSmall(),
                    buildCreditCardForm(provider, context),
                    _buildBottom(context),
                    _buildButtomPayment(context)
                  ],
                ),
              ),
            ),
          );


        });

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
                  Text('Nahomi Sanchez', style: kMediumTitleStyle.copyWith(color: AppColors.black, fontWeight:FontWeight.bold )),
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

  Widget _buildHeader(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        child: Row(
          children: [

            Icon(MdiIcons.informationOutline, color: AppColors.blueFacebook),
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
          onPressed: () async {
            AddCreditCardPage.pushNavigate(context, replace: false);
          }
      ),
    );


  }


  List<Widget> getList(List<dynamic> cards){
    return List<Widget>.generate(cards.length, (index) {
      return ItemCreditCard(
        background: (index%2) != 0 ? Colors.white : AppColors.greyButtom.withOpacity(0.2),
        onTap: (){

        },
      );
    });

  }



}
