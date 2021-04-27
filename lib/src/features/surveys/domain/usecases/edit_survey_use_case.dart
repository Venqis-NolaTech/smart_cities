import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/survey.dart';
import '../repositories/surveys_repository.dart';

class EditSurveyUseCase extends UseCase<Survey, EditSurveyParams> {
  final SurveysRepository surveysRepository;

  EditSurveyUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, Survey>> call(EditSurveyParams params,
      {Callback callback}) {
    return surveysRepository.updateSurvey(
      params.surveyId,
      params.survey,
    );
  }
}

class EditSurveyParams extends Equatable {
  final String surveyId;
  final Survey survey;

  EditSurveyParams({
    this.surveyId,
    this.survey,
  });

  @override
  List<Object> get props => [
        surveyId,
        survey,
      ];
}
