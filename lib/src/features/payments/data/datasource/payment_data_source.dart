

import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/api/auth_client.dart';
import 'package:smart_cities/src/core/api/public_http_client.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/entities/response_model.dart';
import 'package:smart_cities/src/core/models/catalog_item_model.dart';
import 'package:smart_cities/src/features/payments/data/models/account_model.dart';
import 'package:smart_cities/src/features/payments/domain/entities/account.dart';

abstract class PaymentDataSource{
  Future<List<CatalogItem>> bankList();
  Future<List<CatalogItem>> listPaymentMethod();
  Future<Account> createAccount({Map<String, dynamic> request});
  Future<List<Account>> listAccounts();
  Future<Account> detailAccount(String id);
}


class PaymentDataSourceImpl implements PaymentDataSource{
  final AuthHttpClient authHttpClient;
  final PublicHttpClient publicHttpClient;


  PaymentDataSourceImpl({
      @required this.authHttpClient,
      @required this.publicHttpClient});


  @override
  Future<List<CatalogItem>> bankList() async {
    final response = await publicHttpClient.get('/api/user/bank');
    print('listado de bancos'+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return List<CatalogItem>.from(body.data['bank'].map((x) => CatalogItemModel.fromJson(x)));
  }

  @override
  Future<List<CatalogItem>> listPaymentMethod() async  {  // listado de cuentas en home de payments
    final response = await authHttpClient.get('/api/paymentmethod');
    print('listado de metodos de pagos'+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return List<CatalogItem>.from(body.data['municipality'].map((x) => CatalogItemModel.fromJson(x)));
  }

  @override
  Future<Account> createAccount({Map<String, dynamic> request}) async {
    print('agregando cuenta cuenta '+request.toString());


    final response = await authHttpClient.post(
        '/api/account',
        body: request);


    print('nueva cuenta '+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return AccountModel.fromJson(body.data);
  }

  @override
  Future<List<Account>> listAccounts() async {
    var response= await authHttpClient.get('/api/account');
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return List<Account>.from(body.data['data'].map((x) => AccountModel.fromJson(x)));
    //return PostListingsModel.fromJson(body.data);
  }

  @override
  Future<Account> detailAccount(String id) async  {
    final response = await authHttpClient.get('/api/account/$id');
    print('detalle de cuenta '+response.toString());
    final body = ResponseModel<Map<String, dynamic>>.fromJson(response.data);
    return AccountModel.fromJson(body.data);
  }
  

  




}