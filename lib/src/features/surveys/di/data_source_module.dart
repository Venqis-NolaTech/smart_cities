import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/surveys/data/datasources/remote/surveys_data_source.dart';

initDataSource(GetIt sl) {

  sl.registerLazySingleton<SurveysDataSource>(
        () => SurveysDataSourceImpl(
      authHttpClient: sl(),
      publicHttpClient: sl(),
    ),
  );
}
