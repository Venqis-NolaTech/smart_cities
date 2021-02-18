

import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/places/data/datasource/remote/places_data_source.dart';

initDataSource(GetIt sl) async {
  sl.registerLazySingleton<PlacesDataSource>(
    () => PlacesDataSourceImpl(
      publicHttpClient: sl(),
      authHttpClient: sl(),
    ),
  );
}
