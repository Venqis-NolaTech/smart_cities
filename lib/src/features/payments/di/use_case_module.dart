

import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/payments/domain/usescase/get_list_bank_use_case.dart';

initUseCase(GetIt sl) {
  sl.registerLazySingleton(
    () => GetListBankUseCase(
      paymentsRepository: sl(),
    ),
  );



}