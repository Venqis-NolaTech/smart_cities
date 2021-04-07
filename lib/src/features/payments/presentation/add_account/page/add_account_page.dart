import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/widget/credit_card_form.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/widget/credit_card_model.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/drop_down_list.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class AddAccountPage extends StatefulWidget {
  static const id = "add_account_page";

  static pushNavigate(BuildContext context, {replace = false}) {
    replace
        ? Navigator.pushReplacementNamed(context, id)
        : Navigator.pushNamed(context, id);
  }


  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';

  bool isCvvFocused = false;

  final _nameOwner = FocusNode();

  List<CatalogItem> accountTypes=[];
  CatalogItem typeSelected;

  List<CatalogItem> paymentMethod=[];
  CatalogItem paymentMethodSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        title: Text(S.of(context).myAccounts),
        centerTitle: true,
          actions: [
            FlatButton(
                onPressed: _onBackPressed,
                child: Text(
                  S.of(context).cancel,
                  style: kSmallTextStyle.copyWith(color: AppColors.white),
                ))
          ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).addAccount,
                      style: kMediumTitleStyle.copyWith(color: AppColors.primaryText),
                    ),

                    Spaces.verticalSmall(),

                    Text(
                      S.of(context).addAccountMessage('Nahomi'),
                      style: kNormalStyle.copyWith(color: AppColors.primaryText),
                    ),

                    Spaces.verticalSmall(),
                  ],
                ),
              ),
            ),

            Spaces.verticalSmall(),
            _buildFormAccount(context),
            Spaces.verticalSmall(),
            /*Padding(
              padding: const EdgeInsets.symmetric( horizontal: 20),
              child: AddCreditCard(),
            )*/

            CreditCardForm(
              formKey: _formKey,
              obscureCvv: true,
              obscureNumber: true,
              cardNumber: cardNumber,
              cvvCode: cvvCode,
              cardHolderName: cardHolderName,
              expiryDate: expiryDate,
              themeColor: Colors.blue,
              cardNumberDecoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                //labelText: S.of(context).numberCard,
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                //labelText:  S.of(context).expirationDate,
                hintText: 'XX/XX',
              ),
              cvvCodeDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                //labelText:  S.of(context).cvv,
                hintText: 'XXX',
              ),
              cardHolderDecoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
                //labelText:  S.of(context).ownerName,
              ),
              onCreditCardModelChange: onCreditCardModelChange,
            )



          ],


        ),
      ) ,



    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void _onBackPressed() {
  }

  Widget _buildFormAccount(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Form(
        //key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).ownerName, style: kNormalStyle),
            Spaces.verticalSmall(),
            TextFormField(
              onChanged: (value){
                //widget.provider.nameStreet= value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)
                  ),
                  hintText: S.of(context).ownerName,
                  hintStyle: TextStyle(color: AppColors.greyButtom.withOpacity(0.7))
              ),
              focusNode: _nameOwner,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value){
                //FocusScope.of(context).requestFocus(new FocusNode());
              },
              onSaved: (value) {

              },
              style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
            ),
            Spaces.verticalSmall(),
            Text(S.of(context).typeOfAccount, style: kNormalStyle),
            Spaces.verticalSmall(),

            DropDownList<CatalogItem>(
              title:'',
              items: accountTypes,
              itemSelected: typeSelected,
              onSelected: onSelected,
            ),
            Spaces.verticalSmall(),
            Text(S.of(context).paymentMethod, style: kNormalStyle),
            Spaces.verticalSmall(),

            DropDownList<CatalogItem>(
              title:'',
              items: paymentMethod,
              itemSelected: paymentMethodSelected,
              onSelected: onSelected,
            ),



          ],
        ),
      ),
    );


  }

  void onSelected(CatalogItem p1) {

  }
}
