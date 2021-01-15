import 'package:get_it/get_it.dart';

import '../data/datasources/remote/blog_data_source.dart';

initDataSource(GetIt sl) {
  sl.registerLazySingleton<BlogDataSource>(
    () => BlogDataSourceImpl(
      publicHttpClient: sl(),
      authHttpClient: sl(),
    ),
  );
}
