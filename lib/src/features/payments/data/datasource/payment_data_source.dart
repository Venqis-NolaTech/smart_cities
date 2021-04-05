


import 'package:smart_cities/src/core/entities/catalog_item.dart';

abstract class PaymentDataSource{
  Future<List<CatalogItem>> bankList();

  Future<CatalogItem> saveAccount();
  Future<CatalogItem> updateAccount();
  Future<CatalogItem> deleteAccount();
  Future<List<CatalogItem>> accountList();
  Future<CatalogItem> getDetailAccount(String id);

  Future<CatalogItem> savePaymentMethod();
  Future<CatalogItem> detailPaymentMethod(String id);
  Future<CatalogItem> updatePaymentMethod();
  Future<CatalogItem> deletePaymentMethod(String id);
  Future<CatalogItem> listingPaymentMethod();

}