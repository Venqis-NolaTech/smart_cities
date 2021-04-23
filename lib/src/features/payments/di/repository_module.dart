import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/payments/data/repositories/payments_repository_impl.dart';
import 'package:smart_cities/src/features/payments/domain/repositories/payment_repository.dart';

initRepository(GetIt sl) {

  sl.registerLazySingleton<PaymentsRepository>(
    () => PaymentsRepositoryImpl(paymentDataSource: sl()),
  );


}