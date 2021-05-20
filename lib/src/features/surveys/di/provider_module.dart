import 'package:get_it/get_it.dart';
import 'package:smart_cities/src/features/surveys/presentation/crud/providers/crud_survey_provider.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/providers/my_surveys_provider.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/providers/surveys_provider.dart';

initProvider(GetIt sl) {


  sl.registerFactory(
        () => SurveysProvider(
      getAllSurveysByChannelUseCase: sl(),
      loggedUserUseCase: sl(),
      deleteSurveyUseCase: sl(),
      disableSurveyUseCase: sl(),
      publishSurveyUseCase: sl(),
    ),
  );


  sl.registerFactory(
        () => MySurveysProvider(
      loggedUserUseCase: sl(),
      getMySurveys: sl(),
      deleteSurveyUseCase: sl(),
      disableSurveyUseCase: sl(),
    ),
  );

  sl.registerFactory(
        () => CrudSurveyProvider(
      createSurveyUseCase: sl(),
      editSurveyUseCase: sl(), 
      detailsSurveyUseCase: sl(),
    ),
  );

}