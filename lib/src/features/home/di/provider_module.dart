import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/home/presentation/provider/home_provider.dart';

initProvider(GetIt sl) {
  sl.registerFactory(
    () => HomeProvider(
        loggedUserUseCase: sl()
    ),
  );


}
