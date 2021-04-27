import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/survey.dart';

abstract class SurveysRepository {
  Future<Either<Failure, Survey>> createSurvey(Survey survey);

  Future<Either<Failure, Survey>> publishSurvey(String surveyId);

  Future<Either<Failure, Survey>> disableSurvey(String surveyId);

  Future<Either<Failure, Survey>> updateSurvey(String surveyId, Survey survey);

  Future<Either<Failure, bool>> deleteSurvey(String surveyId);

  Future<Either<Failure, SurveyListings>> getAllSurveys({
        int page,
        int count,
      });

}
