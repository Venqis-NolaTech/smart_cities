import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/payments/di/data_source_module.dart';
import 'package:smart_cities/src/features/payments/di/provider_module.dart';
import 'package:smart_cities/src/features/payments/di/repository_module.dart';
import 'package:smart_cities/src/features/payments/di/use_case_module.dart';

initPaymentsModule(GetIt sl) async {
  initProvider(sl);
  initUseCase(sl);
  initRepository(sl);
  initDataSource(sl);
}
