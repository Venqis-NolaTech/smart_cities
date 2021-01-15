import 'package:get_it/get_it.dart';

import 'data_source_module.dart';
import 'provider_module.dart';
import 'repository_module.dart';
import 'use_case_module.dart';

initAuthModule(GetIt sl) async {
  initProvider(sl);
  initUseCase(sl);
  initRepository(sl);
  initDataSource(sl);
}
