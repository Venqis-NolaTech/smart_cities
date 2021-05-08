import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/survey.dart';
import '../repositories/surveys_repository.dart';

class CreateSurveyUseCase extends UseCase<Survey, Survey> {
  final SurveysRepository surveysRepository;

  CreateSurveyUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, Survey>> call(Survey survey, {Callback callback}) {
    return surveysRepository.createSurvey(survey);
  }
}
