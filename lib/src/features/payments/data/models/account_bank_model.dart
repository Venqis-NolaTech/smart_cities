
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';

class AccountBankModel {
  AccountBankModel(
      {this.accountNumber, this.accountHolderName, this.typeAccount, this.bank});

  String accountNumber = '';
  String accountHolderName = '';
  CatalogItem bank;
  CatalogItem typeAccount;
}