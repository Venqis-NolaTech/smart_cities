import 'package:get_it/get_it.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/user_local_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/user_local_repository.dart';
import '../domain/repositories/user_repository.dart';

initRepository(GetIt sl) {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authDataSource: sl(),
      firebaseAuth: sl(),
      userLocalRepository: sl(),
      firebaseStorage: sl(),
      userDataSource: sl(),
      facebookAuth: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userDataSource: sl(),
      userLocalDataSource: sl(),
      firebaseStorage: sl(),
    ),
  );

  sl.registerLazySingleton<UserLocalRepository>(
    () => UserLocalRepositoryImpl(
      userLocalDataSource: sl(),
    ),
  );
}
