import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/places/di/data_source_module.dart';
import 'package:smart_cities/src/features/places/di/provider_module.dart';
import 'package:smart_cities/src/features/places/di/repository_module.dart';
import 'package:smart_cities/src/features/places/di/use_case_module.dart';

initPlacesModule(GetIt sl) async {
  initProvider(sl);
  initUseCase(sl);
  initRepository(sl);
  initDataSource(sl);
}