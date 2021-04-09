import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/payments/data/models/account_bank_model.dart';
import 'package:smart_cities/src/features/payments/data/models/credit_card_model.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/widget/account_bank_form.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/widget/credit_card_form.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/drop_down_list.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
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
  static GlobalKey<FormState> _formKeyAccount = GlobalKey<FormState>();

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';


  String accountNumber= '';
  CatalogItem bank;
  CatalogItem typeAccountBank;
  String accountHolderName= '';


  bool isCvvFocused = false;

  final _nameOwner = FocusNode();

  List<CatalogItem> paymentMethod=[];
  CatalogItem paymentMethodSelected;

  @override
  Widget build(BuildContext context) {
    return BaseView<AddAccountBankProvider>(
        onProviderReady: (provider)=> provider.loadData(),
        builder: (context, provider, child ){
          return ModalProgressHUD(
              inAsyncCall: provider.currentState is Loading,
              child: Theme(
                data: ThemeData(
                  primaryColor:  Colors.blue.withOpacity(0.8),
                  primaryColorDark: Colors.blue,
                ),
                child: Scaffold(
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
                        _buildFormAccount(context, provider),
                        Spaces.verticalSmall(),

                        provider.paymentMethodSelected.key == "CREDITCARD" ?
                        buildCreditCardForm() :
                        buildBankAccountForm(context, provider),

                        Spaces.verticalMedium(),

                      ],


                    ),
                  ) ,



                ),
              )

          );
        }
    );


  }

  Widget buildCreditCardForm() {
    return CreditCardForm(
      formKey: _formKey,
      obscureCvv: true,
      obscureNumber: true,
      cardNumber: cardNumber,
      cvvCode: cvvCode,
      cardHolderName: cardHolderName,
      expiryDate: expiryDate,
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
      onCreditCardModelChange: onCreditCardModelChange,
    );
  }

  Widget buildBankAccountForm(BuildContext context, AddAccountBankProvider provider) {
    return BankAccountForm(
      formKey: _formKeyAccount,
      accountNumber: accountNumber,
      bank: bank,
      typeAccount: typeAccountBank,
      accountHolderName: accountNumber,
      themeColor: Colors.blue,
      accountHolderNameDecoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        //labelText: S.of(context).numberCard,
        hintText: S.of(context).hintAccountHolderName,
      ),
      accountNumberDecoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        //labelText: S.of(context).numberCard,
        hintText: S.of(context).hintNumberOfAcccount,
      ),
      onAccountModelChange: onAccountModelChange,
      provider: provider,
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


  void onAccountModelChange(AccountBankModel accountBankModel) {
    setState(() {
      accountNumber = accountBankModel.accountNumber;
      accountHolderName = accountBankModel.accountHolderName;
      bank = accountBankModel.bank;
      typeAccountBank = accountBankModel.typeAccount;
    });
  }

  void _onBackPressed() {
  }

  Widget _buildFormAccount(BuildContext context, AddAccountBankProvider provider) {
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
              //style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister),
            ),
            Spaces.verticalSmall(),


            Text(S.of(context).typeOfAccount, style: kNormalStyle),
            Spaces.verticalSmall(),

            DropDownList<CatalogItem>(
              title:'',
              hintTitle: S.of(context).selectTypeAccount,
              items: AddAccountBankProvider.typeAccount,
              itemSelected: provider.typeAccountBankSelected,
              onSelected: (paymentMethod){
                provider.typeAccountBankSelected= paymentMethod;
              },
            ),


            Spaces.verticalSmall(),
            Text(S.of(context).paymentMethod, style: kNormalStyle),
            Spaces.verticalSmall(),

            DropDownList<CatalogItem>(
              title:'',
              hintTitle: S.of(context).paymentMethod,
              items: AddAccountBankProvider.paymentMethod,
              itemSelected: provider.paymentMethodSelected,
              onSelected: (paymentMethod){
                provider.paymentMethodSelected= paymentMethod;
              },
            ),



          ],
        ),
      ),
    );


  }

}
