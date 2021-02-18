import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/reports/data/datasources/local/report_filter_data_source.dart';

import '../data/datasources/remote/report_data_source.dart';

initDataSource(GetIt sl) {
  sl.registerLazySingleton<ReportDataSource>(
    () => ReportDataSourceImpl(
      authHttpClient: sl(),
      publicHttpClient: sl(),
    ),
  );

  sl.registerLazySingleton<ReportFilterDataSource>(
    () => ReportFilterDataSourceImpl(sharedPreferences: sl()),
  );
}
