import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/payments/presentation/add_account/provider/add_account_provider.dart';
import 'package:smart_cities/src/features/payments/presentation/linked_accounts/provider/payments_provider.dart';

initProvider(GetIt sl){
  sl.registerFactory(() => PaymentsProvider(
    loggedUserUseCase: sl(),
  )) ;

  sl.registerFactory(() => AddAccountBankProvider(
    getListBankUseCase: sl(),
  )) ;
}