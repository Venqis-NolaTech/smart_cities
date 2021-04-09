

import 'package:meta/meta.dart';
import 'package:smart_cities/src/core/api/auth_client.dart';
import 'package:smart_cities/src/core/api/public_http_client.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/entities/response_model.dart';
import 'package:smart_cities/src/core/models/catalog_item_model.dart';

abstract class PaymentDataSource{
  Future<List<CatalogItem>> bankList();
  Future<List<CatalogItem>> listPaymentMethod();
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


  




}