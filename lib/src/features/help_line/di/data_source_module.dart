
import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/help_line/data/datasource/streaming_data_source.dart';

initDataSource(GetIt sl) {
  sl.registerLazySingleton<StreamingDataSource>(
    () => StreamingDataSourceImpl(
      authHttpClient: sl(),
    ),
  );
}