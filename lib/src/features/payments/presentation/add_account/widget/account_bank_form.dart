import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/payments/data/models/account_bank_model.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/shared/components/drop_down_list.dart';
import 'package:smart_cities/src/shared/components/masked_text_controller.dart';
import 'package:smart_cities/src/shared/constant.dart';

class BankAccountForm extends StatefulWidget {
  const BankAccountForm(
      {Key key,
      @required this.accountNumber,
      @required this.bank,
      @required this.typeAccount,
      @required this.accountHolderName,
      this.obscureNumber = false,
      @required this.onAccountModelChange,
      @required this.themeColor,
      this.textColor = Colors.black,
      this.cursorColor,
      this.accountNumberDecoration = const InputDecoration(
        labelText: 'Account Number',
        hintText: 'XXXX XXXX XXXX XXXX',
      ),
      this.accountHolderNameDecoration = const InputDecoration(
        hintText: 'Account Holder',
      ),
      @required this.formKey,
      this.accountNumberValidationMessage =
          'Please input a valid account number',
      this.provider})
      : super(key: key);

  final String accountNumber;
  final CatalogItem bank;
  final CatalogItem typeAccount;
  final String accountHolderName;

  final String accountNumberValidationMessage;
  final void Function(AccountBankModel) onAccountModelChange;
  final Color themeColor;
  final Color textColor;
  final Color cursorColor;

  final bool obscureNumber;
  final GlobalKey<FormState> formKey;

  final InputDecoration accountNumberDecoration;
  final InputDecoration accountHolderNameDecoration;

  final AddAccountBankProvider provider;

  @override
  _BankAccountFormState createState() => _BankAccountFormState();
}

class _BankAccountFormState extends State<BankAccountForm> {
  String accountNumber;
  CatalogItem bank;
  CatalogItem typeAccount;
  String accountHolderName;
  Color themeColor;

  void Function(AccountBankModel) onAccountModelChange;

  AccountBankModel accountBankModel;
  final MaskedTextController _accountNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _accountHolderNameController =
      TextEditingController();

  FocusNode accountNumberNode = FocusNode();
  FocusNode accountHolderNode = FocusNode();

  void createAccountModel() {
    accountNumber = widget.accountNumber;
    bank = widget.bank;
    typeAccount = widget.typeAccount;
    accountHolderName = widget.accountHolderName;
    onAccountModelChange = widget.onAccountModelChange;

    accountBankModel = AccountBankModel(
      accountNumber: accountNumber,
      typeAccount: typeAccount,
      bank: bank,
      accountHolderName: accountHolderName,
    );
  }

  @override
  void didChangeDependencies() {
    themeColor = widget.themeColor;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createAccountModel();
    _accountHolderNameController.addListener(() {
      setState(() {
        accountHolderName = _accountHolderNameController.text;
        accountBankModel.accountHolderName = accountHolderName;
        onAccountModelChange(accountBankModel);
      });
    });

    _accountNumberController.addListener(() {
      setState(() {
        accountNumber = _accountNumberController.text;
        accountBankModel.accountNumber = accountNumber;
        onAccountModelChange(accountBankModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: themeColor.withOpacity(0.8),
        primaryColorDark: themeColor,
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Text(S.of(context).ownerName, style: kNormalStyle)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                controller: _accountHolderNameController,
                cursorColor: widget.cursorColor ?? themeColor,
                focusNode: accountHolderNode,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: widget.accountHolderNameDecoration,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  accountHolderNode.unfocus();
                },
                onEditingComplete: () {
                  onAccountModelChange(accountBankModel);
                },
                validator: (value){
                  if (value.isEmpty) {
                    return S.of(context).requiredField;
                  } else
                    return null;
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Text(S.of(context).bank, style: kNormalStyle)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: DropDownList<CatalogItem>(
                title: '',
                hintTitle: S.of(context).bank,
                items: widget.provider.listBanks,
                itemSelected: bank,
                onSelected: (item) {
                  bank = item;
                  accountBankModel.bank = bank;
                  onAccountModelChange(accountBankModel);
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child: Text(S.of(context).typeAccount, style: kNormalStyle)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
              child: DropDownList<CatalogItem>(
                title: '',
                hintTitle: S.of(context).typeAccount,
                items: AddAccountBankProvider.typeAccountBank,
                itemSelected: typeAccount,
                onSelected: (item) {
                  typeAccount = item;
                  accountBankModel.typeAccount = typeAccount;
                  onAccountModelChange(accountBankModel);
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                child:
                    Text(S.of(context).numberOfAcccount, style: kNormalStyle)),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: TextFormField(
                controller: _accountNumberController,
                cursorColor: widget.cursorColor ?? themeColor,
                focusNode: accountNumberNode,
                style: TextStyle(
                  color: widget.textColor,
                ),
                decoration: widget.accountNumberDecoration,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  accountNumberNode.unfocus();
                },
                onEditingComplete: () {
                  onAccountModelChange(accountBankModel);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return S.of(context).requiredField;
                  } else if (value.length < 16) {
                    return S.of(context).numberAccountFailed;
                  } else
                    return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
