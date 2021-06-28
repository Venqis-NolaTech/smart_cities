


import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/help_line/domain/usescase/get_data_streaming_use_case.dart';

initUseCase(GetIt sl) {
  sl.registerLazySingleton(
        () => GetDataStreamingUseCase(
          streamingRepository: sl(),
        ),
  );
}