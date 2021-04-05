import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/provider/payments_provider.dart';

initProvider(GetIt sl){
  sl.registerFactory(() => PaymentsProvider(
    loggedUserUseCase: sl(),
  )) ;


}