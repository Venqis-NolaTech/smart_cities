import 'package:dartz/dartz.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/src/features/surveys/data/models/survey_model.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/survey.dart';
import '../../domain/repositories/surveys_repository.dart';
import '../datasources/remote/surveys_data_source.dart';

class SurveysRepositoryImpl implements SurveysRepository {
  SurveysRepositoryImpl({@required this.surveysDataSource});

  final SurveysDataSource surveysDataSource;

  @override
  Future<Either<Failure, Survey>> createSurvey(Survey survey) {
    return _process<Survey>(
      () => surveysDataSource.createSurvey(SurveyModel.fromEntity(survey)),
    );
  }

  @override
  Future<Either<Failure, Survey>> publishSurvey(String surveyId) {
    return _process<Survey>(
      () => surveysDataSource.publishSurvey(surveyId),
    );
  }

  @override
  Future<Either<Failure, Survey>> disableSurvey(String surveyId) {
    return _process<Survey>(
      () => surveysDataSource.disableSurvey(surveyId),
    );
  }

  @override
  Future<Either<Failure, Survey>> updateSurvey(String surveyId, Survey survey) {
    return _process<Survey>(
      () => surveysDataSource.updateSurvey(
          surveyId, SurveyModel.fromEntity(survey)),
    );
  }

  @override
  Future<Either<Failure, Survey>> detailsSurvey(String surveyId) {
    return _process<Survey>(
      () => surveysDataSource.detailsSurvey(surveyId),
    );
  }


  @override
  Future<Either<Failure, bool>> deleteSurvey(String surveyId) {
    return _process<bool>(
      () => surveysDataSource.deleteSurvey(surveyId),
    );
  }

  @override
  Future<Either<Failure, SurveyListings>> getAllSurveys({int page, int count}) {
    return _process<SurveyListings>(
          () => surveysDataSource.getAllSurveys(
        page: page,
        count: count,
      ),
    );
  }

  @override
  Future<Either<Failure, SurveyListings>> getMySurveys({int page, int count}) {
    return _process<SurveyListings>(
          () => surveysDataSource.getMySurveys(
        page: page,
        count: count,
      ),
    );
  }



  // private methods --
  Future<Either<Failure, T>> _process<T>(Future<T> Function() action) async {
    try {
      final result = await action();

      if (result == null) {
        return Left(UnexpectedFailure());
      }

      return Right(result);
    } catch (e, s) {
      switch (e.runtimeType) {
        case NotConnectionException:
          return Left(NotConnectionFailure());

        default:
          FirebaseCrashlytics.instance.recordError(e, s);

          return Left(UnexpectedFailure());
      }
    }
  }

  // -- private methods
}
