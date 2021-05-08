import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/surveys/di/use_case_module.dart';
import 'package:smart_cities/src/features/surveys/di/provider_module.dart';
import 'package:smart_cities/src/features/surveys/di/repository_module.dart';
import 'package:smart_cities/src/features/surveys/di/data_source_module.dart';



initSurveysModule(GetIt sl) async {
  initProvider(sl);
  initUseCase(sl);
  initRepository(sl);
  initDataSource(sl);
}
