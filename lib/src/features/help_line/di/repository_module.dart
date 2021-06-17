

import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/help_line/data/repositories/streaming_repository_impl.dart';
import 'package:smart_cities/src/features/help_line/domain/repositories/streaming_repository.dart';

initRepository(GetIt sl) {
  sl.registerLazySingleton<StreamingRepository>(
    () => StreamingRepositoryImpl(streamingDataSource: sl()),
  );
}