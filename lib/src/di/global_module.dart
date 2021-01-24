import 'package:get_it/get_it.dart';

import '../features/splash/presentation/providers/splash_provider.dart';

initGlobal(GetIt sl) {
  sl.registerFactory(
    () => SplashProvider(
      loggedUserUseCase: sl(),
      deviceInfo: sl(),
      getParamsUseCase: sl(),
      getTokenUseCase: sl(),
      refreshProfileUseCase: sl(),
      getMunicipalityUseCase: sl(),
      //getAllInstitutionUseCase: sl(),
      //getAllProvinceUseCase: sl(),
      //getAllRightsVioledUseCase: sl(),
      //getAllNationalityUseCase: sl(),
    ),
  );
}
