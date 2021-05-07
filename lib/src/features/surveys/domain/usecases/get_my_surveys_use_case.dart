import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/survey.dart';
import '../repositories/surveys_repository.dart';
import 'get_all_surveys_use_case.dart';

class GetMySurveysUseCase extends UseCase<SurveyListings, AllSurveysParams> {
  final SurveysRepository surveysRepository;

  GetMySurveysUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, SurveyListings>> call(AllSurveysParams params,
      {Callback callback}) {
    return surveysRepository.getMySurveys(
      page: params.page,
      count: params.count,
    );
  }
}
