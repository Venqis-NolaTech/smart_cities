
import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/help_line/provider/streaming_provider.dart';

initProvider(GetIt sl) {
  sl.registerFactory(
    () => StreamingProvider(getDataStreamingUseCase: sl(), loggedUserUseCase: sl()),
  );
}
