import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';


import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/auth/domain/usecases/logged_user_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/entities/survey.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/delete_survey_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/disable_survey_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/get_all_surveys_use_case.dart';
import 'package:smart_cities/src/features/surveys/domain/usecases/get_my_surveys_use_case.dart';
import 'package:smart_cities/src/shared/provider/paginated_provider.dart';

class MySurveysProvider extends PaginatedProvider<Survey> {

  MySurveysProvider({
    @required LoggedUserUseCase loggedUserUseCase,
    @required this.getMySurveys,
    @required this.disableSurveyUseCase,
    @required this.deleteSurveyUseCase,
  }) : super(loggedUserUseCase: loggedUserUseCase);

  final GetMySurveysUseCase getMySurveys;
  final DisableSurveyUseCase disableSurveyUseCase;
  final DeleteSurveyUseCase deleteSurveyUseCase;

  void loadData() async {
    await super.getUser(notify: false);

    super.fetchData();
  }



  @override
  Future<Either<Failure, PageData<Survey>>> processRequest() async {
    final params = AllSurveysParams(
      page: page,
      count: count,
    );

    final failureOrListings = await getMySurveys(params);

    return failureOrListings.fold((failure) => Left(failure), (listings) {
      final surveys = listings?.surveys ?? [];

      return Right(
        PageData(
          totalCount: listings.totalCount,
          items: surveys,
        ),
      );
    });
  }




}