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
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';


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
                                  textAlign: TextAlign.center,
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

                        provider.paymentMethodSelected==null ? Container() :
                        provider.paymentMethodSelected.key == DataKey.CREDITCARD ?
                        buildCreditCardForm(provider) :
                        buildBankAccountForm(context, provider),
                        Spaces.verticalSmall(),
                        provider.paymentMethodSelected==null ? Container() :
                        _btnStart(context, provider),
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

  Widget buildCreditCardForm(AddAccountBankProvider provider) {
    return CreditCardForm(
      formKey: _formKey,
      obscureCvv: true,
      obscureNumber: false,
      cardNumber: provider.cardNumber,
      cvvCode: provider.cvvCode,
      cardHolderName: provider.cardHolderName,
      expiryDate: provider.expiryDate,
      themeColor: Colors.blue,
      cardHolderDecoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintText: S.of(context).ownerName,
      ),
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
      onCreditCardModelChange: (creditCardModel) => onCreditCardModelChange(creditCardModel, provider),
    );
  }

  Widget buildBankAccountForm(BuildContext context, AddAccountBankProvider provider) {
    return BankAccountForm(
      formKey: _formKeyAccount,
      accountNumber: provider.accountNumber,
      bank: provider.bankSelected,
      typeAccount: provider.typeAccountBankSelected,
      accountHolderName: provider.accountNumber,
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
      onAccountModelChange: (creditCardModel)=>onAccountModelChange(creditCardModel, provider),
      provider: provider,
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel, AddAccountBankProvider provider) {
    setState(() {
      provider.cardNumber = creditCardModel.cardNumber;
      provider.expiryDate = creditCardModel.expiryDate;
      provider.cardHolderName = creditCardModel.cardHolderName;
      provider.cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }


  void onAccountModelChange(AccountBankModel accountBankModel, AddAccountBankProvider provider) {
    setState(() {
      provider.accountNumber = accountBankModel.accountNumber;
      provider.accountHolderName = accountBankModel.accountHolderName;
      provider.bankSelected = accountBankModel.bank;
      provider.typeAccountBankSelected = accountBankModel.typeAccount;
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
                provider.holderName= value;
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
              itemSelected: provider.typeAccountSelected,
              onSelected: (paymentMethod){
                provider.typeAccountSelected= paymentMethod;
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

  Widget _btnStart(BuildContext context, AddAccountBankProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: RoundedButton(
          color: AppColors.blueBtnRegister,
          borderColor: AppColors.white,
          elevation: 0,
          title: S.of(context).createAccount,
          style: kTitleStyle.copyWith( fontWeight: FontWeight.bold, color: AppColors.white),
          onPressed: () async {
            await provider.sendAccount();
            _process(provider, context);
            /*Navigator.pushNamedAndRemoveUntil(
              context,
              MainPage.id,
              ModalRoute.withName(MainPage.id),
            );*/
          }
      ),
    );
  }


  void _process(AddAccountBankProvider provider, BuildContext context) {

    final currentState = provider.currentState;

    Widget image =  Image.asset(AppImagePaths.createComment, height: 120);
    String title = S.of(context).accountCreatedSuccessMessage;
    bool sucesss = true;

    if (currentState is Error) {
      title = S.of(context).unexpectedErrorMessage;
      sucesss = false;
      image =  Image.asset(AppImagePaths.iconFailed, height: 150);
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return InfoAlertDialog(
            image: sucesss ? image : Container(height: 120),
            title: title,
            message: '',
            onConfirm: sucesss
                ? () {
              Navigator.pop(context, true);
            }
                : null,

          );
        });
  }


}
