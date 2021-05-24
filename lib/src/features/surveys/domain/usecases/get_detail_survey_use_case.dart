import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/survey.dart';
import '../repositories/surveys_repository.dart';

class DetailsSurveyUseCase extends UseCase<Survey, DetailsSurveyParams> {
  final SurveysRepository surveysRepository;

  DetailsSurveyUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, Survey>> call(DetailsSurveyParams params,
      {Callback callback}) {
    return surveysRepository.detailsSurvey(
      params.surveyId
    );
  }
}

class DetailsSurveyParams extends Equatable {
  final String surveyId;

  DetailsSurveyParams({
    this.surveyId
  });

  @override
  List<Object> get props => [
        surveyId,
      ];
}
