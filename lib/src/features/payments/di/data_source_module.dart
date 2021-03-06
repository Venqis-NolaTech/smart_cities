

import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/payments/data/datasource/payment_data_source.dart';

initDataSource(GetIt sl) {

  sl.registerLazySingleton<PaymentDataSource>(
        () => PaymentDataSourceImpl(
      authHttpClient: sl(),
      publicHttpClient: sl(),
    ),
  );


}