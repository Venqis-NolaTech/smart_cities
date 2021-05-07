


import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/create_survey_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/delete_survey_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/disable_survey_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/edit_survey_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/get_all_surveys_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/get_my_surveys_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/publish_survey_use_case.dart';

initUseCase(GetIt sl){

  sl.registerLazySingleton(
        () => CreateSurveyUseCase(
      surveysRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => EditSurveyUseCase(
      surveysRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => PublishSurveyUseCase(
      surveysRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => DisableSurveyUseCase(
      surveysRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => DeleteSurveyUseCase(
      surveysRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => GetAllSurveysUseCase(
      surveysRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
        () => GetMySurveysUseCase(
      surveysRepository: sl(),
    ),
  );



}