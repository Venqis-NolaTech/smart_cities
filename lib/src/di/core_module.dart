import 'package:get_it/get_it.dart';

import '../core/api/auth_client.dart';
import '../core/api/firebase_auth_client.dart';
import '../core/api/public_http_client.dart';
import '../core/util/device_info.dart';
import '../core/util/validator.dart';

initCore(GetIt sl) {
  sl.registerLazySingleton(() => Validator());
  sl.registerLazySingleton(() => DeviceInfo());

  sl.registerLazySingleton(
    () => AuthHttpClient(
      dataConnectionChecker: sl(),
      userLocalDataSource: sl(),
      publicHttpClient: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => FirebaseAuthHttpClient(
      firebaseAuth: sl(),
      dataConnectionChecker: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => PublicHttpClient(
      dataConnectionChecker: sl(),
    ),
  );
}
