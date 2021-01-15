import 'package:get_it/get_it.dart';

import '../data/repositories/report_repository_impl.dart';
import '../domain/repositories/report_repository.dart';

initRepository(GetIt sl) {
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      reportDataSource: sl(),
      userLocalDataSource: sl(),
    ),
  );
}
