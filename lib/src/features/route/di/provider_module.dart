

import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/route/presentation/provider/route_provider.dart';

initProvider(GetIt sl) {

  sl.registerFactory(
        () => RouteProvider(),
  );


}

