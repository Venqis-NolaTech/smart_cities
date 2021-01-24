import 'package:get_it/get_it.dart';

import '../data/datasources/local/user_data_source.dart';
import '../data/datasources/remote/auth_data_source.dart';
import '../data/datasources/remote/user_data_source.dart';

initDataSource(GetIt sl) {
  sl.registerLazySingleton<UserDataSource>(
    () => UserDataSourceImpl(
      authHttpClient: sl(),
      publicHttpClient: sl(),
    ),
  );

  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      publicHttpClient: sl(),
      userLocalDataSource: sl(),
    ),
  );
}
