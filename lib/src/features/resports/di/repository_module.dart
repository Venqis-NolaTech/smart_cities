import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/resports/data/repositories/report_filter_repository_impl.dart';
import 'package:smart_cities/src/features/resports/domain/repositories/report_filter_repository.dart';

import '../data/repositories/report_repository_impl.dart';
import '../domain/repositories/report_repository.dart';

initRepository(GetIt sl) {
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(
      reportDataSource: sl(),
      userLocalDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ReportFilterRepository>(
        () => ReportFilterRepositoryImpl(
          reportFilterDataSource: sl(),
    ),
  );


}
