import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../repositories/surveys_repository.dart';

class DeleteSurveyUseCase extends UseCase<bool, String> {
  final SurveysRepository surveysRepository;

  DeleteSurveyUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, bool>> call(String surveyId, {Callback callback}) {
    return surveysRepository.deleteSurvey(surveyId);
  }
}
