import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/use_case.dart';
import '../entities/survey.dart';
import '../repositories/surveys_repository.dart';

class GetAllSurveysByChannelUseCase
    extends UseCase<SurveyListings, AllSurveysParams> {
  final SurveysRepository surveysRepository;

  GetAllSurveysByChannelUseCase({@required this.surveysRepository});

  @override
  Future<Either<Failure, SurveyListings>> call(AllSurveysParams params,
      {Callback callback}) {
    return surveysRepository.getAllSurveys(
      page: params.page,
      count: params.count,
    );
  }
}

class AllSurveysParams extends ListingsParams {

  AllSurveysParams({
    int page,
    int count,
  }) : super(
          page: page,
          count: count,
        );

  @override
  List<Object> get props => [
        ...super.props,
      ];
}
