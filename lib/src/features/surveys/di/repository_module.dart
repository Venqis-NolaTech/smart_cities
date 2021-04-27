




import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/surveys/data/repositories/surveys_repository_impl.dart';
import 'package:smart_cities/src/features/surveys/domain/repositories/surveys_repository.dart';

initRepository(GetIt sl) {
  sl.registerLazySingleton<SurveysRepository>(
        () => SurveysRepositoryImpl(
      surveysDataSource: sl(),
    ),
  );

}