import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/survey.dart';
import '../repositories/surveys_repository.dart';

class DisableSurveyUseCase extends UseCase<Survey, String> {
  final SurveysRepository surveysRepository;

  DisableSurveyUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, Survey>> call(String surveyId, {Callback callback}) {
    return surveysRepository.disableSurvey(surveyId);
  }
}
