import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/survey.dart';
import '../repositories/surveys_repository.dart';

class PublishSurveyUseCase extends UseCase<Survey, String> {
  final SurveysRepository surveysRepository;

  PublishSurveyUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, Survey>> call(String surveyId, {Callback callback}) {
    return surveysRepository.publishSurvey(surveyId);
  }
}
