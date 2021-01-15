import 'package:get_it/get_it.dart';

import '../data/datasources/remote/report_data_source.dart';

initDataSource(GetIt sl) {
  sl.registerLazySingleton<ReportDataSource>(
    () => ReportDataSourceImpl(
      authHttpClient: sl(),
      publicHttpClient: sl(),
    ),
  );
}
