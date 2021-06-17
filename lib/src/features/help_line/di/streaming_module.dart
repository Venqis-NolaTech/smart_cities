import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/help_line/di/data_source_module.dart';
import 'package:smart_cities/src/features/help_line/di/provider_module.dart';
import 'package:smart_cities/src/features/help_line/di/repository_module.dart';
import 'package:smart_cities/src/features/help_line/di/use_case_module.dart';

initStreamingModule(GetIt sl) async {
  initProvider(sl);
  initUseCase(sl);
  initRepository(sl);
  initDataSource(sl);
}
